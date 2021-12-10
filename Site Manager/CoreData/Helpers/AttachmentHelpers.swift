//
//  AttachmentHelpers.swift
//  Site Manager
//
//  Created by Samuel Wong on 8/12/21.
//

import Foundation
import UIKit

class AttachmentHelpers {
    static func createAttachment(forProject project: Project, fromImage image: UIImage, isPhoto: Bool) {
        let attachment = Attachment(context: CoreDataHelper.context)
        attachment.data = image.pngData()
        attachment.isPhoto = isPhoto
        
        do {
            project.addToAttachments(attachment)
            try CoreDataHelper.context.save()
        } catch {
            print(error)
        }
    }
}

extension Attachment {
    var image: UIImage {
        return UIImage(data: self.data! )!
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
