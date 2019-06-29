//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//
//

import Foundation
import CoreData

extension Company {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var companyDescription: String

}
