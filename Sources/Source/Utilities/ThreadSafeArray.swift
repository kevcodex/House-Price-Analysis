//  Created by Kevin Chen on 2/29/20.
//

import Foundation

class ThreadSafeArray<Element> {
    private var array: Array<Element> = []
    
    let queue = DispatchQueue(label: "ThreadSafeArray", attributes: .concurrent)
    
    func append(_ value: Element, completion: (() -> Void)? = nil) {
        queue.async(flags: .barrier) {
            self.array.append(value)
            completion?()
        }
    }
    
    func remove(_ value: Element, predicate: @escaping (Element) -> Bool, completion: (() -> Void)? = nil) {
        queue.async(flags: .barrier) {
            
            if let index = self.array.firstIndex(where: predicate) {
                self.array.remove(at: index)
            }
            
            completion?()
        }
    }
    
    func elements() -> Array<Element> {
        var array: Array<Element> = []
        
        queue.sync {
            array = self.array
        }

        return array
    }
}

extension ThreadSafeArray where Element: Equatable {
    func remove(_ value: Element, completion: (() -> Void)? = nil) {
        queue.async(flags: .barrier) {
            
            if let index = self.array.firstIndex(of: value) {
                self.array.remove(at: index)
            }
            
            completion?()
        }
    }
}
