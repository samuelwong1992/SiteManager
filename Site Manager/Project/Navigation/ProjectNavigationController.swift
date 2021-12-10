//
//  ProjectNavigationController.swift
//  Site Manager
//
//  Created by Samuel Wong on 16/2/21.
//

import UIKit

class ProjectNavigationController: MainNavigationController {
    static var navigationController: ProjectNavigationController? {
        return StoryboardConstants.Storyboard.Project.storyboard.instantiateInitialViewController() as? ProjectNavigationController
    }
    
    var project: Project!
    
    override func initialize() {
        super.initialize()
        
        self.setTitle(title: project.name ?? "")
    }
}
