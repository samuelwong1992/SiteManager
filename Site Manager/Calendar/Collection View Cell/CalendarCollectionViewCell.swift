//
//  CalendarCollectionViewCell.swift
//  Site Manager
//
//  Created by Samuel Wong on 5/2/21.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    static let kNib = UINib(nibName: StoryboardConstants.Nib.CalendarCollectionViewCell.identifier, bundle: nil)
    static let kReuseIdentifier = StoryboardConstants.Nib.CalendarCollectionViewCell.identifier
    
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var selectedViewSize: CGSize?
    
    var siteInspectionIndicators: [UIView] = []
    var siteInspections: [SiteInspection] = [] {
        didSet {
            setupSiteInspectionIndicators()
        }
    }
    
    var date: Date! {
        didSet {
            dateLabel.text = "\(date.day)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectedView.setupAsCircleView()
        
        if let selectedViewSize = selectedViewSize {
            if selectedViewSize != selectedView.frame.size {
                setupSiteInspectionIndicators()
            }
        } else {
            selectedViewSize = selectedView.frame.size
            setupSiteInspectionIndicators()
        }
    }
}

//MARK: Initialization
extension CalendarCollectionViewCell {
    func initialize() {
        
    }
    
    func setupSiteInspectionIndicators() {
        for view in siteInspectionIndicators {
            view.removeFromSuperview()
        }
        
        siteInspectionIndicators.removeAll()
        
        let center = CGPoint(x: selectedView.bounds.size.width/2, y: selectedView.bounds.size.height/2)
        let radius: CGFloat = selectedView.frame.size.width/2 - selectedView.frame.size.width/5
        let count = siteInspections.count

        let pi = Double.pi
        var angle = CGFloat(3*pi/2)
        let step = CGFloat(2 *  pi) / CGFloat(count > 8 ? 8 : count)

        // Set objects around the circle
        for index in 0..<count {
            if(index >= 8) {
                return
            }
            let indicator = UILabel(frame: CGRect(x: 0, y: 0, width: selectedView.frame.size.width/5, height: selectedView.frame.size.width/5))
            indicator.textAlignment = .center
            if index == 7 && count > 8 {
                indicator.text = "+"
                indicator.addBorder(colour: .black)
            } else {
                indicator.backgroundColor = UIColor.colourWithHexString(siteInspections[index].project?.color ?? "ffffff")
                indicator.text = "\(index + 1)"
            }
            
            // Position
            let x = cos(angle) * radius + center.x
            let y = sin(angle) * radius + center.y
            let midX = indicator.frame.origin.x + indicator.frame.width / 2
            let mixY = indicator.frame.origin.y + indicator.frame.height / 2
            
            indicator.frame.origin.x = x - midX/2
            indicator.frame.origin.y = y - mixY/2
            
            indicator.setupAsCircleView()
            
            addSubview(indicator)
            siteInspectionIndicators.append(indicator)
            angle += step
        }

    }
}
