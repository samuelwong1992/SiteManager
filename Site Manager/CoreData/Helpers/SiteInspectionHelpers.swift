//
//  SiteInspectionHelpers.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/12/21.
//

import UIKit

struct SiteInspectionHelpers {
    static var siteInspections: [SiteInspection] {
        get {
            do {
                return try CoreDataHelper.container.viewContext.fetch(SiteInspection.fetchRequest())
            } catch {
                print(error)
                return []
            }
        }
    }
    
    @discardableResult
    static func createSiteInspection(withName name: String, withDrawing drawing: Drawings, forProject project: Project, introduction: String, presentOnSite: String, weatherConditions: String, workInProgress: String, attention: String, subject: String) -> (siteInspection: SiteInspection?, error: Error?) {
        let siteInspection = SiteInspection(context: CoreDataHelper.context)
        siteInspection.name = name
        siteInspection.drawing = drawing
        siteInspection.introduction = introduction
        siteInspection.presentOnSite = presentOnSite
        siteInspection.weatherConditions = weatherConditions
        siteInspection.workInProgress = workInProgress
        siteInspection.attention = attention
        siteInspection.subject = subject
        siteInspection.project = project
        siteInspection.date = Date()

        do {
            try CoreDataHelper.context.save()
            return (siteInspection, nil)
        } catch {
            print(error)
            return (nil, error)
        }
    }
}

extension SiteInspection {
    var siteInspectionObjectsArray: [SiteInspectionObject] {
        if let siteInspectionObjects = self.siteInspectionObjects {
            return siteInspectionObjects.map({ $0 as! SiteInspectionObject })
        }
        
        return []
    }
}
