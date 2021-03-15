//
//  User.swift
//  Site Manager
//
//  Created by Samuel Wong on 5/2/21.
//

import UIKit

private var _currentUser: User = User(test: true)

class User {
    var projects: [Project] = []
    var siteInspections: [SiteInspection] = []
    
    static var currentUser: User {
        get {
            return _currentUser
        }
        set {
            _currentUser = newValue
        }
    }
    
    convenience init(test: Bool) {
        self.init()
        
        let testProject = Project()
        testProject.id = 0
        testProject.name = "Sam's House"
        testProject.location = "4 Grandview Grove, Toorak Gardens"
        testProject.color = .Red
        
        let testProject1 = Project()
        testProject1.id = 1
        testProject1.name = "Sherman Residence"
        testProject1.location = "Near Fancy Burger"
        testProject1.color = .Green
        
        let testProject2 = Project()
        testProject2.id = 2
        testProject2.name = "Burton Residence"
        testProject2.location = "Near The Freeway"
        testProject2.color = .Orange
        
        projects.append(testProject)
        projects.append(testProject1)
        projects.append(testProject2)
        
        let siteInspection = SiteInspection()
        siteInspection.date = Date().dateInDaysFromNow(numberOfDays: 3)
        siteInspection.project = testProject
        
        let siteInspection1 = SiteInspection()
        siteInspection1.date = Date().standardizedDate().dateInDaysFromNow(numberOfDays: 3)
        siteInspection1.project = testProject1
        
        let siteInspection2 = SiteInspection()
        siteInspection2.date = Date().dateInDaysFromNow(numberOfDays: 1)
        siteInspection2.project = testProject
        
        let siteInspection3 = SiteInspection()
        siteInspection3.date = Date().dateInDaysFromNow(numberOfDays: 4)
        siteInspection3.project = testProject1
        
        let siteInspection4 = SiteInspection()
        siteInspection4.date = Date().dateInDaysFromNow(numberOfDays: 6)
        siteInspection4.project = testProject1
        
        let siteInspection5 = SiteInspection()
        siteInspection5.date = Date().dateInDaysFromNow(numberOfDays: 6)
        siteInspection5.project = testProject
        
        let siteInspection6 = SiteInspection()
        siteInspection6.date = Date().dateInDaysFromNow(numberOfDays: 6)
        siteInspection6.project = testProject2
        
        siteInspections.append(siteInspection)
        siteInspections.append(siteInspection1)
        siteInspections.append(siteInspection2)
        siteInspections.append(siteInspection3)
        siteInspections.append(siteInspection4)
        siteInspections.append(siteInspection5)
        siteInspections.append(siteInspection6)
        
        for _ in 0..<6 {
            let si = SiteInspection()
            si.date = Date().dateInDaysFromNow(numberOfDays: 7)
            si.project = [testProject, testProject1, testProject2][Int.random(in: 0...2)]
            siteInspections.append(si)
        }
        
        for _ in 0..<8 {
            let si = SiteInspection()
            si.date = Date().dateInDaysFromNow(numberOfDays: 8)
            si.project = [testProject, testProject1, testProject2][Int.random(in: 0...2)]
            siteInspections.append(si)
        }
        
        for _ in 0..<10 {
            let si = SiteInspection()
            si.date = Date().dateInDaysFromNow(numberOfDays: 9).addingTimeInterval(TimeInterval(Int.random(in: 0...120)*60))
            si.project = [testProject, testProject1, testProject2][Int.random(in: 0...2)]
            siteInspections.append(si)
        }
    }
}
