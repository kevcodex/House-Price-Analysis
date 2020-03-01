//  Created by Kevin Chen on 2/29/20.
//

import Foundation
import ScriptHelpers
import MiniNe

class HouseDataOperation: AsyncOperation, IPAddressGenerator {
    
    let url: URL
    
    var result: (Result<HouseData, Error>)? {
        didSet {
            finish()
        }
    }
    
    init(url: URL) {
        self.url = url
    }
    
    override func execute() {
        guard canExecute() else {
            finish()
            return
        }
                
        guard let path = url.path.nonEmpty else {
            finish()
            return
        }
        
        let client = MiniNeClient()
        
        let query = TruliaGraphQLQuery(variables: TruliaGraphQLQuery.Variables(url: path))
        
        do {
            let data = try JSONEncoder().encode(query)
            let ip = generateIPAddress()
            let request = TruliaGraphQL(headers: ["X-Forwarded-For": ip], body: NetworkBody(data: data, encoding: .json))
            
            client.send(request: request, callBackQueue: .global()) { [weak self] (result) in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    do {
                        let houseData = try decoder.decode(HouseData.self, from: response.data)
                        self?.result = .success(houseData)
                    } catch {
                        self?.result = .failure(error)
                    }
                case .failure(let error):
                    self?.result = .failure(error)
                }
            }
        } catch {
            result = .failure(error)
        }
    }
}
