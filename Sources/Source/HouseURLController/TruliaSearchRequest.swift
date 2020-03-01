//  Created by Kevin Chen on 2/29/20.
//

import MiniNe
import Foundation

struct TruliaSearchRequest: NetworkRequest {
        
    var baseURL: URL? {
        return URL(string: "https://www.trulia.com")
    }
    
    let path: String
    
    let method: HTTPMethod
    
    let parameters: [String: Any]? = nil
    
    let headers: [String: Any]?
    
    let body: NetworkBody? = nil
    
    init(path: String,
         method: HTTPMethod = .get,
         headers: [String: Any]? = nil) {
        
        self.path = path
        self.method = method
        self.headers = headers
    }
}
