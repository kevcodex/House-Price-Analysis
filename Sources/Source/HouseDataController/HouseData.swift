//  Created by Kevin Chen on 2/29/20.
//

import Foundation

struct HouseData: Decodable {
    let data: Data
}

extension HouseData {
    struct Data: Decodable {
        let homeDetailsByUrl: HomeDetails
    }
}

extension HouseData.Data {
    struct HomeDetails: Decodable {
        let __typename: String
    }
}
