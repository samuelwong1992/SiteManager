//
//  SiteInspectionPDFGenerator.swift
//  Site Manager
//
//  Created by Samuel Wong on 10/2/2022.
//

import Foundation
import PDFKit

class SiteInspectionPDFGenerator {
    fileprivate enum TextSize {
        case large
        case medium
        case small
        case verySmall
        
        var cgFloat: CGFloat {
            switch self {
            case .large : return 16
            case .medium : return 14
            case .small : return 12
            case .verySmall : return 10
            }
        }
    }
    
    static let pageWidth = 8.25 * 72.0
    static let pageHeight = 11.75 * 72.0
    static let margin: CGFloat = 0.5 * 72
    static let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    
    static func createPDF(siteInspection: SiteInspection, withSiteInspectionDrawings drawings: [UIImage?]) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: siteInspection.name,
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            self.drawFrontPage(withContext: context, siteInspection: siteInspection)
            self.drawSiteInspectionObjectsPage(withContext: context, siteInspection: siteInspection)
            self.drawSiteInspectionMapPage(withContext: context, images: drawings)
        }
        
        return data
    }
}

extension SiteInspectionPDFGenerator {
    static func drawFrontPage(withContext context: UIGraphicsPDFRendererContext, siteInspection: SiteInspection) {
        context.beginPage()
        
        let introText = NSMutableAttributedString()
        if let project = siteInspection.project {
            introText.append(NSMutableAttributedString(string: (project.name ?? "") + " / " + (project.location ?? ""), attributes: paragraphAttributes(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: TextSize.large.cgFloat)])))
            introText.addNewLine()
        }
        introText.append(NSMutableAttributedString(string: siteInspection.name ?? "", attributes: paragraphAttributes(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: TextSize.medium.cgFloat)])))
        introText.addNewLine()
        if let date = siteInspection.date {
            introText.append(NSMutableAttributedString(string: date.dayMonthYearReadableString, attributes: paragraphAttributes(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: TextSize.medium.cgFloat)])))
            introText.addNewLine()
        }
        
        introText.append(attributedTitleAndInput(title: "Project Number", input: siteInspection.project?.number))
        introText.append(attributedTitleAndInput(title: "Attention", input: siteInspection.attention))
        introText.append(attributedTitleAndInput(title: "Company", input: siteInspection.company))
        introText.append(attributedTitleAndInput(title: "Issued By", input: siteInspection.issuedBy))
        introText.append(attributedTitleAndInput(title: "Subject", input: siteInspection.subject))
        
        var textCanvas = pageRect.insetBy(dx: margin, dy:margin).size
        textCanvas.width = textCanvas.width/2
        let textSize = introText.boundingRect(with: textCanvas,
                                                 options: [.usesFontLeading, .usesLineFragmentOrigin],
                                                 context: nil).size
        let textRect = CGRect(origin: .init(x: margin, y: margin), size: textSize)
        introText.draw(in: textRect)
        
        let wipText = NSMutableAttributedString()
        wipText.append(NSMutableAttributedString(string: siteInspection.introduction ?? "", attributes: paragraphAttributes(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: TextSize.small.cgFloat)])))
        wipText.addNewLine()
        wipText.append(NSMutableAttributedString(string: siteInspection.workInProgress ?? "", attributes: paragraphAttributes(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: TextSize.medium.cgFloat)])))
        
        let wipCanvas = pageRect.insetBy(dx: margin, dy: margin).size
        let wipSize = wipText.boundingRect(with: wipCanvas,
                                                 options: [.usesFontLeading, .usesLineFragmentOrigin],
                                                 context: nil).size
        let wipRect = CGRect(origin: .init(x: margin, y: textRect.origin.y + textRect.height), size: wipSize)
        wipText.draw(in: wipRect)
        
        if let profile = ProfileHelpers.profile {
            let companyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: TextSize.verySmall.cgFloat), NSAttributedString.Key.strokeColor: UIColor.black.withAlphaComponent(0.7)]
            
            let companyText = NSMutableAttributedString()
            companyText.append(NSMutableAttributedString(string: profile.address1 ?? "", attributes: paragraphAttributes(withAttributes: companyAttributes, rightAlign: true)))
            companyText.addNewLine()
            companyText.append(NSMutableAttributedString(string: "\(profile.suburb ?? "") \(profile.state ?? "") \(profile.postcode ?? "") ", attributes: paragraphAttributes(withAttributes: companyAttributes, rightAlign: true)))
            companyText.addNewLine()
            companyText.append(NSMutableAttributedString(string: "T: \(profile.address1 ?? "")", attributes: paragraphAttributes(withAttributes: companyAttributes, rightAlign: true)))
            companyText.addNewLine()
            companyText.append(NSMutableAttributedString(string: profile.companyName ?? "", attributes: paragraphAttributes(withAttributes: companyAttributes, rightAlign: true)))
            companyText.addNewLine()
            companyText.append(NSMutableAttributedString(string: "ABN: \(profile.abn ?? "")", attributes: paragraphAttributes(withAttributes: companyAttributes, rightAlign: true)))
            
            var textCanvas = pageRect.insetBy(dx: margin, dy: (pageWidth - margin*2)/2).size
            textCanvas.width = textCanvas.width/2
            let textSize = companyText.boundingRect(with: textCanvas,
                                                     options: [.usesFontLeading, .usesLineFragmentOrigin],
                                                     context: nil).size
            
            if let image = profile.logo {
                let space = textRect.origin.y + textRect.size.height - 8 - (margin*2)
                let imageHeight = space - textSize.height
                
                let aspectWidth = ((pageWidth - margin*2)/2 - margin) / image.size.width
                let aspectHeight = imageHeight / image.size.height
                let aspectRatio = min(aspectWidth, aspectHeight)
                
                let scaledWidth = image.size.width * aspectRatio
                let scaledHeight = image.size.height * aspectRatio
                
                let imageRect = CGRect(x: (pageWidth - margin - scaledWidth), y: margin,
                                         width: scaledWidth, height: scaledHeight)
                image.draw(in: imageRect)
                
                let companyRect = CGRect(origin: .init(x: (pageWidth - margin - textSize.width), y: imageRect.origin.y + imageRect.height + 8), size: textSize)
                companyText.draw(in: companyRect)
            } else {
                let companyRect = CGRect(origin: .init(x: (pageWidth - margin - textSize.width), y: margin), size: textSize)
                companyText.draw(in: companyRect)
            }
            
            
        }
        
        if let image = siteInspection.introductionPhoto {
            let nextYPosition = wipRect.origin.y + wipRect.size.height + (margin/2)
            
            let maxHeight = pageRect.height - nextYPosition - margin
            let maxWidth = pageRect.width - margin
            
            let aspectWidth = maxWidth / image.size.width
            let aspectHeight = maxHeight / image.size.height
            let aspectRatio = min(aspectWidth, aspectHeight)
            
            let scaledWidth = image.size.width * aspectRatio
            let scaledHeight = image.size.height * aspectRatio
            
            let imageX = (pageRect.width - scaledWidth) / 2.0
            let imageRect = CGRect(x: imageX, y: nextYPosition,
                                     width: scaledWidth, height: scaledHeight)
            image.draw(in: imageRect)
        }
    }
    
    static func drawSiteInspectionObjectsPage(withContext context: UIGraphicsPDFRendererContext, siteInspection: SiteInspection) {
        for sio in siteInspection.siteInspectionObjectsArray.filter({ !String.isNilOrEmpty($0.text) }) {
            context.beginPage()
            let text = NSMutableAttributedString()
            text.append(NSMutableAttributedString(string: sio.text ?? "", attributes: paragraphAttributes(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: TextSize.medium.cgFloat)])))
            text.addNewLine()
            text.append(NSMutableAttributedString(string: sio.information ?? "", attributes: paragraphAttributes(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: TextSize.medium.cgFloat)])))
            text.addNewLine()
            text.append(NSMutableAttributedString(string: sio.notes ?? "", attributes: paragraphAttributes(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: TextSize.small.cgFloat)])))
            text.addNewLine()
            text.append(NSMutableAttributedString(string: sio.actionBy ?? "", attributes: paragraphAttributes(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: TextSize.small.cgFloat)])))
            
            let textCanvas = pageRect.insetBy(dx: margin, dy: margin).size
            let textSize = text.boundingRect(with: textCanvas,
                                                     options: [.usesFontLeading, .usesLineFragmentOrigin],
                                                     context: nil).size
            let rect = CGRect(origin: .init(x: margin, y: margin), size: textSize)
            text.draw(in: rect)
            
            var nextYPosition = rect.origin.y + rect.size.height + margin
            let imageHeight = (pageHeight - (margin * 2))/3
            for imageAttachment in sio.attachmentsArray {
                if let image = imageAttachment.image {
                    if nextYPosition + imageHeight > pageHeight {
                        context.beginPage()
                        nextYPosition = pageRect.offsetBy(dx: margin, dy: margin).origin.y
                    }
                    
                    let maxWidth = pageRect.width - (margin * 2)
                    let aspectWidth = maxWidth / image.size.width
                    let aspectHeight = imageHeight / image.size.height
                    let aspectRatio = min(aspectWidth, aspectHeight)
                    
                    let scaledWidth = image.size.width * aspectRatio
                    let scaledHeight = image.size.height * aspectRatio
                    
                    let imageX = (pageRect.width - scaledWidth) / 2.0
                    let imageRect = CGRect(x: imageX, y: nextYPosition,
                                             width: scaledWidth, height: scaledHeight)
                    image.draw(in: imageRect)
                    
                    nextYPosition += imageHeight
                }
            }
        }
    }
    
    static func drawSiteInspectionMapPage(withContext context: UIGraphicsPDFRendererContext, images: [UIImage?]) {
        context.beginPage()
        for image in images {
            if let image = image {
                var newImage = image
                
                if image.size.width > image.size.height {
                    newImage = image.rotate(radians: .pi/2)!
                }
                
                let aspectWidth = (pageWidth - margin) / newImage.size.width
                let aspectHeight = (pageHeight - margin) / newImage.size.height
                let aspectRatio = min(aspectWidth, aspectHeight)
                
                let scaledWidth = newImage.size.width * aspectRatio
                let scaledHeight = newImage.size.height * aspectRatio
                
                let imageX = (pageRect.width - scaledWidth) / 2.0
                let imageRect = CGRect(x: imageX, y: margin/2,
                                         width: scaledWidth, height: scaledHeight)
                newImage.draw(in: imageRect)
            }
        }
    }
}

extension SiteInspectionPDFGenerator {
    static func attributedTitleAndInput(title: String, input: String?) -> NSMutableAttributedString {
        let text = NSMutableAttributedString()
        
        text.append(NSMutableAttributedString(string: "\(title): ", attributes: paragraphAttributes(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: TextSize.medium.cgFloat)])))
        text.append(NSMutableAttributedString(string: input ?? "N/A", attributes: paragraphAttributes(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: TextSize.medium.cgFloat)])))
        text.addNewLine()
        
        return text
    }
    
    static func paragraphAttributes(withAttributes attributes: [NSAttributedString.Key : Any], rightAlign: Bool = false) -> [NSAttributedString.Key : Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = 8
        if rightAlign {
            paragraphStyle.alignment = rightAlign ? .right : .left
        }
        var textAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
          ]
        
        textAttributes.merge(attributes) { _, current in current }
        
        return textAttributes
    }
}
