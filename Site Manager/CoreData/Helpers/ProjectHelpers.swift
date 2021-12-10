//
//  ProjectHelpers.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/12/21.
//

import Foundation
import UIKit

class ProjectHelpers {
    static var projects: [Project] {
        get {
            do {
                return try CoreDataHelper.container.viewContext.fetch(Project.fetchRequest())
            } catch {
                print(error)
                return []
            }
        }
    }
    
    @discardableResult
    static func createProject(withName name: String, location: String, color: String) -> (project: Project?, error: Error?) {
        let project = Project(context: CoreDataHelper.context)
        project.name = name
        project.location = location
        project.color = color
        do {
            try CoreDataHelper.context.save()
            return (project, nil)
        } catch {
            print(error)
            return (nil, error)
        }
    }
}

extension Project {
    var drawingsArray: [Drawings] {
        if let drawings = self.drawings {
            return drawings.map({$0 as! Drawings})
        }
        
        return []
    }
    
    var photoArray: [Attachment] {
        if let attachments = self.attachments {
            return attachments.map({ $0 as! Attachment }).filter({ $0.isPhoto })
        }
        
        return []
    }
    
    var shopDrawingArray: [Attachment] {
        if let attachments = self.attachments {
            return attachments.map({ $0 as! Attachment }).filter({ !$0.isPhoto })
        }
        
        return []
    }
    
    var siteInspectionsArray: [SiteInspection] {
        if let siteInspections = self.siteInspections {
            return siteInspections.map({$0 as! SiteInspection})
        }
        
        return []
    }
}
