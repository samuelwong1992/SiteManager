//
//  Attachment+CoreDataProperties.swift
//  Site Manager
//
//  Created by Samuel Wong on 10/12/21.
//
//

import Foundation
import CoreData


extension Attachment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attachment> {
        return NSFetchRequest<Attachment>(entityName: "Attachment")
    }

    @NSManaged public var data: Data?
    @NSManaged public var isPhoto: Bool
    @NSManaged public var project: Project?
    @NSManaged public var siteInspectionObject: SiteInspectionObject?

}

extension Attachment : Identifiable {

}
