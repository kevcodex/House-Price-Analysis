//  Created by Kevin Chen on 2/29/20.
//

import ScriptHelpers
import MiniNe
import Foundation
import Kanna

// Gets all the URLs to houses from the street path
class HouseURLsOperation: AsyncOperation, IPAddressGenerator {
    let path: String
    
    let client = MiniNeClient()
    
    var result: (Result<[URL], Error>)? {
        didSet {
            finish()
        }
    }
    
    init(path: String) {
        self.path = path
    }
    
    override func execute() {
        guard canExecute() else {
            finish()
            return
        }
        let ip = generateIPAddress()
        let request = TruliaSearchRequest(path: path, headers: ["X-Forwarded-For": ip])
        
        client.send(request: request, callBackQueue: .global()) { [weak self] (result) in
            switch result {
            case .success(let response):
                do {
                    let doc = try HTML(html: response.data, encoding: .utf8)
                    let allLinks = doc.xpath("//a[@class='clickable h7 ']")
                    
                    let allURLLinks: [URL] = allLinks.compactMap {
                        if let urlString = $0["href"],
                            let url = URL(string: urlString) {
                            return url
                        } else {
                            return nil
                        }
                    }
                    
                    self?.result = .success(allURLLinks)
                } catch {
                    self?.result = .failure(error)
                }
            case .failure(let error):
                self?.result = .failure(error)
            }
        }
    }
}
