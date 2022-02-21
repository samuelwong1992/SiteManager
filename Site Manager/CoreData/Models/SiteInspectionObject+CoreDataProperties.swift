//
//  SiteInspectionObject+CoreDataProperties.swift
//  Site Manager
//
//  Created by Samuel Wong on 10/2/2022.
//
//

import Foundation
import CoreData


extension SiteInspectionObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SiteInspectionObject> {
        return NSFetchRequest<SiteInspectionObject>(entityName: "SiteInspectionObject")
    }

    @NSManaged public var actionBy: String?
    @NSManaged public var colour: String?
    @NSManaged public var information: String?
    @NSManaged public var notes: String?
    @NSManaged public var siObjectType: Int16
    @NSManaged public var text: String?
    @NSManaged public var textHeight: Double
    @NSManaged public var textWidth: Double
    @NSManaged public var textXCoord: Double
    @NSManaged public var textYCoord: Double
    @NSManaged public var attachments: NSSet?
    @NSManaged public var coords: NSSet?
    @NSManaged public var link: SiteInspectionObject?
    @NSManaged public var linkedObjects: NSSet?
    @NSManaged public var siteInspection: SiteInspection?

}

// MARK: Generated accessors for attachments
extension SiteInspectionObject {

    @objc(addAttachmentsObject:)
    @NSManaged public func addToAttachments(_ value: Attachment)

    @objc(removeAttachmentsObject:)
    @NSManaged public func removeFromAttachments(_ value: Attachment)

    @objc(addAttachments:)
    @NSManaged public func addToAttachments(_ values: NSSet)

    @objc(removeAttachments:)
    @NSManaged public func removeFromAttachments(_ values: NSSet)

}

// MARK: Generated accessors for coords
extension SiteInspectionObject {

    @objc(addCoordsObject:)
    @NSManaged public func addToCoords(_ value: SiteInspectionObjectCoordinate)

    @objc(removeCoordsObject:)
    @NSManaged public func removeFromCoords(_ value: SiteInspectionObjectCoordinate)

    @objc(addCoords:)
    @NSManaged public func addToCoords(_ values: NSSet)

    @objc(removeCoords:)
    @NSManaged public func removeFromCoords(_ values: NSSet)

}

// MARK: Generated accessors for linkedObjects
extension SiteInspectionObject {

    @objc(addLinkedObjectsObject:)
    @NSManaged public func addToLinkedObjects(_ value: SiteInspectionObject)

    @objc(removeLinkedObjectsObject:)
    @NSManaged public func removeFromLinkedObjects(_ value: SiteInspectionObject)

    @objc(addLinkedObjects:)
    @NSManaged public func addToLinkedObjects(_ values: NSSet)

    @objc(removeLinkedObjects:)
    @NSManaged public func removeFromLinkedObjects(_ values: NSSet)

}

extension SiteInspectionObject : Identifiable {

}
