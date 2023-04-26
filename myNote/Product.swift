//
//  Product.swift
//  myNote
//
//  Created by Mohan K on 20/03/23.
//

import Foundation
import CoreData
import UIKit

@objc(Product)
public class Product: NSManagedObject {


    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var content: String?
    @NSManaged public var colorValue: String?
    @NSManaged public var creationDate: String?
    @NSManaged public var dateString  : String?
    @NSManaged public var id: Int64
    @NSManaged public var isEdited: Bool
    @NSManaged public var isPinned: Bool
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
}

extension Product : Identifiable {

}
