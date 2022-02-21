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
        if let path = image.saveImageToFileManager() {
            drawing.path = path
            
            do {
                project.addToDrawings(drawing)
                try CoreDataHelper.context.save()
            } catch {
                print(error)
            }
        }
    }
}

extension Drawings {
    var image: UIImage? {
        if let path = self.path {
            return UIImage.loadImageFromDiskWith(fileName: path)
        }
        return nil
    }
}
