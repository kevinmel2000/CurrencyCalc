//
//  Currency+CoreDataProperties.swift
//  
//
//  Created by Luthfi Fathur Rahman on 16/02/20.
//
//

import Foundation
import CoreData

extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var responseJSON: String?

}
