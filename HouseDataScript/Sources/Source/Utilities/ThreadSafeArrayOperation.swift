//  Created by Kevin Chen on 2/29/20.
//

import Foundation
import ScriptHelpers

/// Operation for thread safe set that requires a dependency
final class ThreadSafeArrayOperation<Element>: AsyncOperation {
    
    // Input
    var element: Element?
    let array: ThreadSafeArray<Element>
    
    init(array: ThreadSafeArray<Element>) {
        self.array = array
    }
    
    override func execute() {
        guard canExecute(), let element = element else {
            finish()
            return
        }
        
        array.append(element) {
            self.finish()
        }
    }
}
