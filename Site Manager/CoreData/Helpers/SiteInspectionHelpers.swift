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
    static func createSiteInspection(withName name: String, withDrawing drawing: Drawings, forProject project: Project, company: String, introduction: String, introductionPhoto: UIImage?, workInProgress: String, attention: String, subject: String) -> (siteInspection: SiteInspection?, error: Error?) {
        let siteInspection = SiteInspection(context: CoreDataHelper.context)
        siteInspection.name = name
        siteInspection.drawing = drawing
        siteInspection.company = company
        siteInspection.introduction = introduction
        siteInspection.workInProgress = workInProgress
        siteInspection.attention = attention
        siteInspection.subject = subject
        siteInspection.project = project
        siteInspection.date = Date()
        
        if let introductionPhoto = introductionPhoto {
            siteInspection.introductionPhotoPath = introductionPhoto.saveImageToFileManager()
        }

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
    
    var introductionPhoto: UIImage? {
        if let path = self.introductionPhotoPath {
            return UIImage.loadImageFromDiskWith(fileName: path)
        }
        return nil
    }
}
