//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Company)
public class Company: NSManagedObject {
    func update(with jsonDictionary: [String: Any]) throws {
        guard let id = jsonDictionary["id"] as? String,
            let name = jsonDictionary["name"] as? String
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }
        
        self.id = id
        self.name = name
    }
    
    func updateDescription(with jsonDictionary:[String: Any]) throws {
        guard let id = jsonDictionary["id"] as? String, self.id == id,
            let decription = jsonDictionary["decription"] as? String
        else {
            throw NSError(domain: "", code: 100, userInfo: nil)
        }
        self.companyDescription = decription
    }
}
