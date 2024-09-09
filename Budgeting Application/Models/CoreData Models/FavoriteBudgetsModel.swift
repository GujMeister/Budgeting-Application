//
//  FavoriteBudgetsModel.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 04.07.24.
//

import CoreData

//@objc(FavoriteBudgetsModel)
class FavoriteBudgetsModel: NSManagedObject, Identifiable {
    @NSManaged public var category: String?
}
