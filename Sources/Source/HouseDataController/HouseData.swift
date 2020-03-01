//  Created by Kevin Chen on 2/29/20.
//

import Foundation

struct HouseData: Decodable {
    let data: Data
}

extension HouseData {
    struct Data: Decodable {
        let homeDetailsByUrl: HomeDetails?
    }
}

extension HouseData.Data {
    struct HomeDetails: Decodable {
        let url: String?
        let sharableUrl: String?
        let location: Location?
        let bedrooms: Bedrooms?
        let bathrooms: Bathrooms?
        let floorSpace: FloorSpace?
        let tracking: [Tracking]?
        let features: Features?
        let priceHistory: [PriceHistory]?
        let hoaFee: HoaFee?
    }
}

struct Location: Decodable {
    let city: String?
    let stateCode: String?
    let zipCode: String?
    let streetAddress: String?
    let formattedLocation: String?
    let neighborhoodName: String?
    let coordinates: Coordinates?
}

extension Location {
    struct Coordinates: Decodable {
        let latitude: Double?
        let longitude: Double?
    }
}

struct Bedrooms: Decodable {
    let shareBedrooms: String?
    let raw: String?
}

struct Bathrooms: Decodable {
    let shareBathrooms: String?
    let raw: String?
}

struct FloorSpace: Decodable {
    let formattedDimension: String?
    let shareFloorSpace: String?
    let raw: String?
}

struct Tracking: Decodable {
    let key: String?
    let value: String?
}

struct Features: Decodable {
    let attributes: [Attributes]?
}

extension Features {
    struct Attributes: Decodable {
        let formattedName: String?
        let formattedValue: String?
    }
}

struct PriceHistory: Decodable {
    let formattedDate: String?
    let source: String?
    let event: String?
    let attributes: [Attributes]?
    let price: Price?
}

extension PriceHistory {
    struct Attributes: Decodable {
        let formattedAttribute: String?
        let key: String?
    }
    
    struct Price: Decodable {
        let formattedPrice: String?
    }
}

struct HoaFee: Decodable {
    let totalAmount: TotalAmount?
    let period: String?
}

extension HoaFee {
    struct TotalAmount: Decodable {
        let price: Double?
        let currencyCode: String?
        let formattedPrice: String?
    }
}

extension HouseData {
    // TODO: - Use decodable to auto convert to array
    // Maps all values to array based on price history events
    func mapForCSV() -> [[CustomStringConvertible]] {
        
        guard let priceHistory = data.homeDetailsByUrl?.priceHistory?.nonEmpty else {
            return []
        }
        
        var allItems: [[CustomStringConvertible]] = []
        
        for price in priceHistory {
            
            guard price.event?.lowercased() == "sold" else {
                continue
            }
            
            let propertyType = data.homeDetailsByUrl?.tracking?.first { $0.key == "propertyType" }?.value
            let lotSize = data.homeDetailsByUrl?.features?.attributes?.first { $0.formattedName == "Lot Size" }?.formattedValue
            let yearBuilt = data.homeDetailsByUrl?.features?.attributes?.first { ($0.formattedValue?.contains("Built") ?? false) }?.formattedValue
            let stories = data.homeDetailsByUrl?.features?.attributes?.first { $0.formattedName == "Stories" }?.formattedValue
            
            let latitudeString: String
            if let latitude = data.homeDetailsByUrl?.location?.coordinates?.latitude {
                latitudeString = String(latitude)
            } else {
                latitudeString = ""
            }
            
            let longitudeString: String
            if let latitude = data.homeDetailsByUrl?.location?.coordinates?.longitude {
                longitudeString = String(latitude)
            } else {
                longitudeString = ""
            }
            
            let priceString: String
            if let price = data.homeDetailsByUrl?.hoaFee?.totalAmount?.price {
                priceString = String(price)
            } else {
                priceString = ""
            }
            
            let possibleItems: [String?] =
                [data.homeDetailsByUrl?.sharableUrl,
                 data.homeDetailsByUrl?.location?.streetAddress,
                 data.homeDetailsByUrl?.location?.city,
                 data.homeDetailsByUrl?.location?.stateCode,
                 data.homeDetailsByUrl?.location?.zipCode,
                 data.homeDetailsByUrl?.location?.neighborhoodName,
                 latitudeString,
                 longitudeString,
                 data.homeDetailsByUrl?.bedrooms?.shareBedrooms,
                 data.homeDetailsByUrl?.bathrooms?.shareBathrooms,
                 data.homeDetailsByUrl?.floorSpace?.raw,
                 propertyType,
                 lotSize,
                 yearBuilt,
                 price.formattedDate,
                 price.event,
                 price.price?.formattedPrice,
                 priceString,
                 data.homeDetailsByUrl?.hoaFee?.totalAmount?.currencyCode,
                 data.homeDetailsByUrl?.hoaFee?.period,
                 stories
            ]
            
            let compactedItems = possibleItems.map { $0?.replacingOccurrences(of: ",", with: "") ?? "" }
            
            allItems.append(compactedItems)
        }
                
        return allItems
    }
}
