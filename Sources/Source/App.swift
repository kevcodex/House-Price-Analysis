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
        let zipCode = "92011"
        
        Console.writeMessage("Fetching all street urls for zip code: \(zipCode)")
        guard let allStreetURLs = searchController.fetchAllStreetURLs(for: zipCode) else {
            exit(1)
        }
        
        Console.writeMessage("Fetching all house urls!")
        guard let allHouseURLs = searchController.fetchHouses(limit: 100, allStreetURLs: allStreetURLs).elements().nonEmpty else {
            exit(1)
        }
        
        let houseDataController = HouseDataController()
        
        Console.writeMessage("Fetching all house data!")
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
