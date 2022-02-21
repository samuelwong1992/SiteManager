//
//  StoryboardConstants.swift
//  Site Manager
//
//  Created by Samuel Wong on 4/2/21.
//

import UIKit

struct StoryboardConstants {
    enum Nib: String {
        case MainTabBar = "MainTabBar"
        case MainNavBar = "MainNavBar"
        case ProjectTabBar = "ProjectTabBar"
        
        case CalendarCollectionViewCell = "CalendarCollectionViewCell"
        case ImageCollectionViewCell = "ImageCollectionViewCell"
        
        case SiteInspectionTableViewCell = "SiteInspectionTableViewCell"
        case SiteInspectionNoteTableViewCell = "SiteInspectionNoteTableViewCell"
        case ProjectTableViewCell = "ProjectTableViewCell"
        case NewSiteInspectionTableViewCell = "NewSiteInspectionTableViewCell"
        
        var identifier: String {
            return self.rawValue
        }
    }
    
    enum Storyboard: String {
        case Calendar = "Calendar"
        case Projects = "Projects"
        case Settings = "Settings"
        case Project = "Project"
        case Profile = "Profile"
        case SiteInspectionStoryboard = "SiteInspection"
        
        var storyboard: UIStoryboard {
            return UIStoryboard(name: self.rawValue, bundle: nil)
        }
    }
    
    enum ViewController: String {
        case ProjectDrawings = "ProjectDrawings"
        case InspectionReports = "InspectionReports"
        
        case SiteInspectionInitializationViewController = "SiteInspectionInitializationViewController"
        case SiteInspectionNotesViewController = "SiteInspectionNotesViewController"
        case SiteInspectionFinalizationViewController = "SiteInspectionFinalizationViewController"
        
        case NewProjectViewController = "NewProjectViewController"
        
        var identifier: String {
            return self.rawValue
        }
    }
}

