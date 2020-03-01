//  Created by Kevin Chen on 2/29/20.
//

import Foundation
import MiniNe
import ScriptHelpers
import Kanna

/// Responsible for getting the house urls to search with.
struct HouseURLController {
    
    let operationQueue = OperationQueue()
    
    init() {
        operationQueue.maxConcurrentOperationCount = 1
    }
    
    func fetchAllStreetURLs(for zipCode: String) -> [String]? {
        let request = TruliaSearchRequest(path: "/property-sitemap/CA/San-Diego-County-06073/\(zipCode)")
        
        var urlStringPaths: [String] = []
        
        let client = MiniNeClient()
        let runner = SwiftScriptRunner()
        
        runner.lock()
        client.send(request: request) { (result) in
            switch result {
            case .success(let response):
                if let doc = try? HTML(html: response.data, encoding: .utf8) {
                    let allLinks = doc.xpath("//a[@class='clickable h7 ']")
                    for link in allLinks {
                        if let urlString = link["href"],
                            let url = URL(string: urlString) {
                            urlStringPaths.append(url.path)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
            
            runner.unlock()
        }
            
        runner.wait()
        return urlStringPaths.nonEmpty
    }
    
    func fetchHouses(limit: Int, allStreetURLs: [String]) -> ThreadSafeArray<URL> {
        
        let allHouseURLs = ThreadSafeArray<URL>()
        
        // Keep adding until limit is reached
        while allHouseURLs.elements().count < limit {
            
            // Only add operations group up to max allowed
            for _ in 1...operationQueue.maxConcurrentOperationCount {
                guard let randomPath = allStreetURLs.randomElement() else {
                    continue
                }
                
                let houseOperation = HouseURLsOperation(path: randomPath)
                
                let arrayOperation = ThreadSafeArrayOperation(array: allHouseURLs)
                
                let houseCompletion = BlockOperation { [weak houseOperation, weak arrayOperation] in
                    guard let result = houseOperation?.result else {
                        return
                    }
                    
                    switch result {
                    case .success(let urls):
                        
                        guard let randomURL = urls.randomElement(),
                            !allHouseURLs.elements().contains(randomURL) else {
                            return
                        }
                        
                        arrayOperation?.element = randomURL
                    case .failure(let error):
                        print(error)
                    }
                }
                
                houseCompletion.addDependency(houseOperation)
                arrayOperation.addDependency(houseCompletion)
                
                operationQueue.addOperations([houseOperation, houseCompletion, arrayOperation], waitUntilFinished: false)
                
            }
            operationQueue.waitUntilAllOperationsAreFinished()
        }
        
        
        return allHouseURLs
    }
}
