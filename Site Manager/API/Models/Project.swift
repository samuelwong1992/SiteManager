//
//  Project.swift
//  Site Manager
//
//  Created by Samuel Wong on 5/2/21.
//

import UIKit

class Project {
    var id: Int!
    var name: String!
    var location: String!
    var color: ProjectColor!
    
    var drawings: [UIImage] {
        return [UIImage(named: "test_plan.jpg")!, UIImage(named: "test_plan.jpg")!, UIImage(named: "test_plan.jpg")!]
    }
    
    enum ProjectColor: Int {
        case Red = 0
        case Orange
        case Green
        
        var uiColor: UIColor {
            switch self {
            case .Red : return .red
            case .Orange : return .orange
            case .Green : return .green
            }
        }
    }
}
