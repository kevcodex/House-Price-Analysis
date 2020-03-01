//  Created by Kevin Chen on 2/29/20.
//

import Foundation
import ScriptHelpers

/// Responsible for getting all the data for a specific house.
struct HouseDataController {
    let operationQueue = OperationQueue()
    
    init() {
        operationQueue.maxConcurrentOperationCount = 1
    }
    
    func fetchAllHouseData(urls: [URL]) -> ThreadSafeArray<HouseData> {
        
        let allHouseData = ThreadSafeArray<HouseData>()
        
        let fetchHouseDataOperations = urls.reduce([Operation]()) { (result, url) in
            let houseDataOperation = HouseDataOperation(url: url)
            
            let threadSafeArrayOperation = ThreadSafeArrayOperation(array: allHouseData)
            
            let houseDataCompletionOperation = BlockOperation { [weak houseDataOperation, weak threadSafeArrayOperation] in
                guard let result = houseDataOperation?.result else {
                    return
                }
                
                switch result {
                case .success(let houseData):
                    threadSafeArrayOperation?.element = houseData
                case .failure(let error):
                    print(error)
                }
            }
            
            houseDataCompletionOperation.addDependency(houseDataOperation)
            threadSafeArrayOperation.addDependency(houseDataCompletionOperation)
            
            return result + [houseDataOperation, houseDataCompletionOperation, threadSafeArrayOperation]
        }
        
        operationQueue.addOperations(fetchHouseDataOperations, waitUntilFinished: false)
        
        operationQueue.waitUntilAllOperationsAreFinished()
        
        return allHouseData
    }
    
    func writeHouseDataIntoCSV(_ allHouseData: [HouseData]) throws {
        Console.writeMessage("**Writing data to CSV")
        let workingDirectory = FileManager.default.currentDirectoryPath
        let csvFilePath = workingDirectory + "/data.csv"
        let csvFileURL = URL(fileURLWithPath: csvFilePath)
        
        for houseData in allHouseData {
            
            let items = [houseData.data.homeDetailsByUrl.__typename]
            
            try CSVWriter.addNewRowWithItems(items, to: csvFileURL)
        }
    }
}
