//
//  SiteInspectionObjectTableViewCell.swift
//  Site Manager
//
//  Created by Samuel Wong on 15/2/21.
//

import UIKit

protocol SiteInspectionNoteTableViewCellDelegate {
    func siteInspectionNoteTableViewCell(siteInspectionNoteTableViewCell: SiteInspectionNoteTableViewCell, didPressHideForSiteInspectionObject siteInspectionObject: SiteInspectionObject)
    func siteInspectionNoteTableViewCell(siteInspectionNoteTableViewCell: SiteInspectionNoteTableViewCell, didPressDeleteForSiteInspectionObject siteInspectionObject: SiteInspectionObject)
}

class SiteInspectionNoteTableViewCell: UITableViewCell {
    
    static var kReuseIdentifier: String {
        return StoryboardConstants.Nib.SiteInspectionNoteTableViewCell.identifier
    }
    static var kNib: UINib {
        return UINib(nibName: StoryboardConstants.Nib.SiteInspectionNoteTableViewCell.identifier, bundle: nil)
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionByLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var _delegate: SiteInspectionNoteTableViewCellDelegate?
    
    var siteInspectionObject: SiteInspectionObject! {
        didSet {
            titleLabel.text = String.selfOrNA(siteInspectionObject.text)
            descriptionLabel.text = String.selfOrNA(siteInspectionObject.information)
            actionByLabel.text = "Action By: " + String.selfOrNA(siteInspectionObject.actionBy)
            noteLabel.text = String.selfOrNA(siteInspectionObject.notes)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        hideButton.addTarget(self, action: #selector(hideButton_didPress), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButton_didPress), for: .touchUpInside)
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: Button Handlers
@objc extension SiteInspectionNoteTableViewCell {
    func hideButton_didPress() {
        _delegate?.siteInspectionNoteTableViewCell(siteInspectionNoteTableViewCell: self, didPressHideForSiteInspectionObject: siteInspectionObject)
    }
    
    func deleteButton_didPress() {
        _delegate?.siteInspectionNoteTableViewCell(siteInspectionNoteTableViewCell: self, didPressDeleteForSiteInspectionObject: siteInspectionObject)
    }
}
