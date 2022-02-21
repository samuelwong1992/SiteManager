//
//  Profile+CoreDataProperties.swift
//  Site Manager
//
//  Created by Samuel Wong on 11/2/2022.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var companyName: String?
    @NSManaged public var address1: String?
    @NSManaged public var suburb: String?
    @NSManaged public var state: String?
    @NSManaged public var postcode: String?
    @NSManaged public var phone: String?
    @NSManaged public var abn: String?
    @NSManaged public var logoPath: String?

}

extension Profile : Identifiable {

}
