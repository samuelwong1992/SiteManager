//
//  DrawingsHelpers.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/12/21.
//

import Foundation
import UIKit

class DrawingsHelpers {
    static func createDrawing(forProject project: Project, fromImage image: UIImage) {
        let drawing = Drawings(context: CoreDataHelper.context)
        drawing.data = image.pngData()
        
        do {
            project.addToDrawings(drawing)
            try CoreDataHelper.context.save()
        } catch {
            print(error)
        }
    }
}

extension Drawings {
    var image: UIImage {
        return UIImage(data: self.data! )!
    }
}
