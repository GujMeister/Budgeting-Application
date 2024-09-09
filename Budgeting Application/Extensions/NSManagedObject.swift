//
//  NSManagedObject.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 04.09.24.
//

import CoreData

public extension NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let entityName = String(describing: type(of: self))
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            fatalError("Failed to find entity \(entityName) in Core Data model")
        }
        self.init(entity: entity, insertInto: context)
    }
}
