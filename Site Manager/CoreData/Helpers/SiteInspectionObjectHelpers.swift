//
//  SiteInspectionObjectHelpers.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/12/21.
//

import UIKit

class SiteInspectionObjectHelpers {
    @discardableResult
    static func createSiteInspectionObject(forSiteInspection siteInspection: SiteInspection, siObjectType: SiteInspectionObject.SiteInspectionObjectType, colour: String, coords: [CGPoint], text: String?, information: String?, notes: String?, actionBy: String?, textXCoord: Double, textYCoord: Double, textHeight: Double, textWidth: Double, attachments: [Attachment]) -> (siteInspectionObject: SiteInspectionObject?, error: Error?) {
        let siteInspectionObject = SiteInspectionObject(context: CoreDataHelper.context)
        
        siteInspectionObject.siteInspection = siteInspection
        siteInspectionObject.siObjectType = Int16(siObjectType.rawValue)
        siteInspectionObject.colour = colour
        siteInspectionObject.text = text
        siteInspectionObject.information = information
        siteInspectionObject.notes = notes
        siteInspectionObject.actionBy = actionBy
        siteInspectionObject.textXCoord = textXCoord
        siteInspectionObject.textYCoord = textYCoord
        siteInspectionObject.textHeight = textHeight
        siteInspectionObject.textWidth = textWidth
        
        for attachment in attachments {
            siteInspectionObject.addToAttachments(attachment)
        }
        
        for (i, coord) in coords.enumerated() {
            let coordObject = SiteInspectionObjectCoordinate(context: CoreDataHelper.context)
            coordObject.index = Int16(i)
            coordObject.x = coord.x
            coordObject.y = coord.y
            siteInspectionObject.addToCoords(coordObject)
        }

        do {
            try CoreDataHelper.context.save()
            return (siteInspectionObject, nil)
        } catch {
            print(error)
            return (nil, error)
        }
    }
    
    @discardableResult
    static func createSiteInspectionObject(forSiteInspection siteInspection: SiteInspection, siObjectType: SiteInspectionObject.SiteInspectionObjectType, colour: String, coords: [CGPoint]) -> (siteInspectionObject: SiteInspectionObject?, error: Error?) {
        let siteInspectionObject = SiteInspectionObject(context: CoreDataHelper.context)
        
        siteInspectionObject.siteInspection = siteInspection
        siteInspectionObject.siObjectType = Int16(siObjectType.rawValue)
        siteInspectionObject.colour = colour
        
        for (i, coord) in coords.enumerated() {
            let coordObject = SiteInspectionObjectCoordinate(context: CoreDataHelper.context)
            coordObject.index = Int16(i)
            coordObject.x = coord.x
            coordObject.y = coord.y
            siteInspectionObject.addToCoords(coordObject)
        }
        
        do {
            try CoreDataHelper.context.save()
            return (siteInspectionObject, nil)
        } catch {
            print(error)
            return (nil, error)
        }
    }
    
    @discardableResult
    static func createSiteInspectionObject(forSiteInspection siteInspection: SiteInspection, withLinkToSiteInspecionObject link: SiteInspectionObject, siObjectType: SiteInspectionObject.SiteInspectionObjectType, colour: String, coords: [CGPoint]) -> (siteInspectionObject: SiteInspectionObject?, error: Error?) {
        let siteInspectionObject = SiteInspectionObject(context: CoreDataHelper.context)
        
        siteInspectionObject.siteInspection = siteInspection
        siteInspectionObject.siObjectType = Int16(siObjectType.rawValue)
        siteInspectionObject.link = link
        siteInspectionObject.colour = colour
        
        for (i, coord) in coords.enumerated() {
            let coordObject = SiteInspectionObjectCoordinate(context: CoreDataHelper.context)
            coordObject.index = Int16(i)
            coordObject.x = coord.x
            coordObject.y = coord.y
            siteInspectionObject.addToCoords(coordObject)
        }

        do {
            try CoreDataHelper.context.save()
            return (siteInspectionObject, nil)
        } catch {
            print(error)
            return (nil, error)
        }
    }
    
    @discardableResult
    static func updateSiteInspectionObject(siteInspectionObject: SiteInspectionObject, textLocation location: CGRect) -> (siteInspectionObject: SiteInspectionObject?, error: Error?) {
        siteInspectionObject.textXCoord = location.origin.x
        siteInspectionObject.textYCoord = location.origin.y
        siteInspectionObject.textHeight = location.size.height
        
        do {
            try CoreDataHelper.context.save()
            return (siteInspectionObject, nil)
        } catch {
            print(error)
            return (nil, error)
        }
    }
}

extension SiteInspectionObject {
    enum SiteInspectionObjectType: Int {
        case Line = 0
        case Square
        case FreeForm
    }
    
    var siteInspectionObjectType: SiteInspectionObjectType {
        return SiteInspectionObjectType(rawValue: Int(self.siObjectType))!
    }
    
    var linkedSiteInspectionObjectsArray: [SiteInspectionObject] {
        if let siteInspectionObjects = self.linkedObjects {
            return siteInspectionObjects.map({ $0 as! SiteInspectionObject })
        }
        
        return []
    }
    
    var attachmentsArray: [Attachment] {
        if let attachments = self.attachments {
            return attachments.map({ $0 as! Attachment })
        }
        
        return []
    }
    
    var coordinates: [CGPoint] {
        var toReturn: [CGPoint] = []
        if let coords = self.coords {
            for coord in coords.map({ $0 as! SiteInspectionObjectCoordinate }).sorted(by:{ $0.index > $1.index }) {
                toReturn.append(CGPoint(x: coord.x, y: coord.y))
            }
        }
        return toReturn
    }
    
    var uiColor: UIColor {
        return UIColor.colourWithHexString(self.colour ?? "#0000FF")
    }
    
    func delete() {
        CoreDataHelper.context.delete(self)
        
        do {
            try CoreDataHelper.context.save()
        } catch {
            print(error)
        }
    }
}
