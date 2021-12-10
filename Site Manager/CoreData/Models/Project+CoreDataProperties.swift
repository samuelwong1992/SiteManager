//
//  Project+CoreDataProperties.swift
//  Site Manager
//
//  Created by Samuel Wong on 10/12/21.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var color: String?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var drawings: NSSet?
    @NSManaged public var siteInspections: NSSet?
    @NSManaged public var attachments: NSSet?

}

// MARK: Generated accessors for drawings
extension Project {

    @objc(addDrawingsObject:)
    @NSManaged public func addToDrawings(_ value: Drawings)

    @objc(removeDrawingsObject:)
    @NSManaged public func removeFromDrawings(_ value: Drawings)

    @objc(addDrawings:)
    @NSManaged public func addToDrawings(_ values: NSSet)

    @objc(removeDrawings:)
    @NSManaged public func removeFromDrawings(_ values: NSSet)

}

// MARK: Generated accessors for siteInspections
extension Project {

    @objc(addSiteInspectionsObject:)
    @NSManaged public func addToSiteInspections(_ value: SiteInspection)

    @objc(removeSiteInspectionsObject:)
    @NSManaged public func removeFromSiteInspections(_ value: SiteInspection)

    @objc(addSiteInspections:)
    @NSManaged public func addToSiteInspections(_ values: NSSet)

    @objc(removeSiteInspections:)
    @NSManaged public func removeFromSiteInspections(_ values: NSSet)

}

// MARK: Generated accessors for attachments
extension Project {

    @objc(addAttachmentsObject:)
    @NSManaged public func addToAttachments(_ value: Attachment)

    @objc(removeAttachmentsObject:)
    @NSManaged public func removeFromAttachments(_ value: Attachment)

    @objc(addAttachments:)
    @NSManaged public func addToAttachments(_ values: NSSet)

    @objc(removeAttachments:)
    @NSManaged public func removeFromAttachments(_ values: NSSet)

}

extension Project : Identifiable {

}
