//
//  Drawings+CoreDataProperties.swift
//  Site Manager
//
//  Created by Samuel Wong on 10/2/2022.
//
//

import Foundation
import CoreData


extension Drawings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drawings> {
        return NSFetchRequest<Drawings>(entityName: "Drawings")
    }

    @NSManaged public var path: String?
    @NSManaged public var project: Project?
    @NSManaged public var siteInspection: NSSet?

}

// MARK: Generated accessors for siteInspection
extension Drawings {

    @objc(addSiteInspectionObject:)
    @NSManaged public func addToSiteInspection(_ value: SiteInspection)

    @objc(removeSiteInspectionObject:)
    @NSManaged public func removeFromSiteInspection(_ value: SiteInspection)

    @objc(addSiteInspection:)
    @NSManaged public func addToSiteInspection(_ values: NSSet)

    @objc(removeSiteInspection:)
    @NSManaged public func removeFromSiteInspection(_ values: NSSet)

}

extension Drawings : Identifiable {

}
