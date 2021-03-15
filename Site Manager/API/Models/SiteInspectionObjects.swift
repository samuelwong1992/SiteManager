//
//  SiteInspectionObjects.swift
//  Site Manager
//
//  Created by Samuel Wong on 10/2/21.
//

import UIKit

class SiteInspectionObject {
    var id: Int!
    
    enum SiteInspectionObjectType {
        case Line
        case Square
    }
    
    var siteInspectionObjectType: SiteInspectionObjectType!
    var coordinates: [CGPoint] = []
    var text: String!
    var description: String!
    var notes: String!
    var textCoordinates: [CGPoint] = []
}
