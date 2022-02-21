//
//  Attachment+CoreDataProperties.swift
//  Site Manager
//
//  Created by Samuel Wong on 10/2/2022.
//
//

import Foundation
import CoreData


extension Attachment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attachment> {
        return NSFetchRequest<Attachment>(entityName: "Attachment")
    }

    @NSManaged public var path: String?
    @NSManaged public var isPhoto: Bool
    @NSManaged public var project: Project?
    @NSManaged public var siteInspectionObject: SiteInspectionObject?

}

extension Attachment : Identifiable {

}
