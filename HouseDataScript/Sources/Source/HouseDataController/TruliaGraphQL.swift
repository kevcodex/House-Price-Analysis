//  Created by Kevin Chen on 2/29/20.
//

import MiniNe
import Foundation

struct TruliaGraphQL: NetworkRequest {
    var baseURL: URL? {
        return URL(string: "https://graphql.trulia.com/graphql")
    }
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var headers: [String: Any]?
    
    var body: NetworkBody?
}
