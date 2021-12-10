//
//  SiteInspectionTableViewCell.swift
//  Site Manager
//
//  Created by Samuel Wong on 5/2/21.
//

import UIKit

class SiteInspectionTableViewCell: UITableViewCell {
    
    static let kNib = UINib(nibName: StoryboardConstants.Nib.SiteInspectionTableViewCell.identifier, bundle: nil)
    static let kReuseIdentifier = StoryboardConstants.Nib.SiteInspectionTableViewCell.identifier

    @IBOutlet weak var colourIndicatorView: UIView!
    @IBOutlet weak var completedIndicator: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colourIndicatorView.setupAsCircleView()
    }
    
    var siteInspection: SiteInspection! {
        didSet {
            titleLabel.text = siteInspection.name
            locationLabel.text = siteInspection.workInProgress
            if let date = siteInspection.date {
                timeLabel.text = date.timeDayMonthYearReadableString
            }
            colourIndicatorView.backgroundColor =  UIColor.colourWithHexString(siteInspection.project?.color ?? "ffffff")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
