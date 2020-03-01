//  Created by Kevin Chen on 2/29/20.
//

import Foundation

protocol IPAddressGenerator {
    func generateIPAddress() -> String
}

extension IPAddressGenerator {
    func generateIPAddress() -> String {
        var values: [String] = []
        
        while values.count != 4 {
            
            guard let randomNumber = (0...255).randomElement() else {
                continue
            }
            
            values.append(String(randomNumber))
        }
        
        let ip = values.joined(separator: ".")
        
        return ip
    }
}
