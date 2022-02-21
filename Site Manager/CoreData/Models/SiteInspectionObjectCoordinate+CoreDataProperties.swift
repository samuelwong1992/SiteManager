//
//  SiteInspectionObjectCoordinate+CoreDataProperties.swift
//  Site Manager
//
//  Created by Samuel Wong on 10/2/2022.
//
//

import Foundation
import CoreData


extension SiteInspectionObjectCoordinate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SiteInspectionObjectCoordinate> {
        return NSFetchRequest<SiteInspectionObjectCoordinate>(entityName: "SiteInspectionObjectCoordinate")
    }

    @NSManaged public var index: Int16
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var siteInspectionObject: SiteInspectionObject?

}

extension SiteInspectionObjectCoordinate : Identifiable {

}
