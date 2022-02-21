//
//  SiteInspection+CoreDataProperties.swift
//  Site Manager
//
//  Created by Samuel Wong on 10/2/2022.
//
//

import Foundation
import CoreData


extension SiteInspection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SiteInspection> {
        return NSFetchRequest<SiteInspection>(entityName: "SiteInspection")
    }

    @NSManaged public var attention: String?
    @NSManaged public var company: String?
    @NSManaged public var date: Date?
    @NSManaged public var introduction: String?
    @NSManaged public var name: String?
    @NSManaged public var subject: String?
    @NSManaged public var workInProgress: String?
    @NSManaged public var introductionPhotoPath: String?
    @NSManaged public var issuedBy: String?
    @NSManaged public var drawing: Drawings?
    @NSManaged public var project: Project?
    @NSManaged public var siteInspectionObjects: NSSet?

}

// MARK: Generated accessors for siteInspectionObjects
extension SiteInspection {

    @objc(addSiteInspectionObjectsObject:)
    @NSManaged public func addToSiteInspectionObjects(_ value: SiteInspectionObject)

    @objc(removeSiteInspectionObjectsObject:)
    @NSManaged public func removeFromSiteInspectionObjects(_ value: SiteInspectionObject)

    @objc(addSiteInspectionObjects:)
    @NSManaged public func addToSiteInspectionObjects(_ values: NSSet)

    @objc(removeSiteInspectionObjects:)
    @NSManaged public func removeFromSiteInspectionObjects(_ values: NSSet)

}

extension SiteInspection : Identifiable {

}
