//  Created by Kevin Chen on 2/29/20.
//

import ScriptHelpers
import Foundation
import MiniNe

public struct App {
    
    let environment = ProcessInfo.processInfo.environment
    
    public init() {}
    
    public func start() {
        
        let searchController = HouseURLController()
        
        guard let allStreetURLs = searchController.fetchAllStreetURLs(for: "92130") else {
            exit(1)
        }
        
        guard let allHouseURLs = searchController.fetchHouses(limit: 1, allStreetURLs: allStreetURLs).elements().nonEmpty else {
            exit(1)
        }
        
        let houseDataController = HouseDataController()
        
        guard let allHouseData = houseDataController.fetchAllHouseData(urls: allHouseURLs).elements().nonEmpty else {
            exit(1)
        }
        
        do {
            try houseDataController.writeHouseDataIntoCSV(allHouseData)
        } catch {
            exit(1)
        }
        
        Console.writeMessage("Completed!")
    }
}
