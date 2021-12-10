//
//  NewSiteInspectionTableViewCell.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/12/21.
//

import UIKit

class NewSiteInspectionTableViewCell: UITableViewCell {

    static let kNib = UINib(nibName: StoryboardConstants.Nib.NewSiteInspectionTableViewCell.identifier, bundle: nil)
    static let kReuseIdentifier = StoryboardConstants.Nib.NewSiteInspectionTableViewCell.identifier
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }
}

//MARK: Initialization
extension NewSiteInspectionTableViewCell {
    func initialize() {
        
    }
}
