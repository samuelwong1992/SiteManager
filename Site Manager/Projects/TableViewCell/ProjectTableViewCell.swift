//
//  ProjectTableViewCell.swift
//  Site Manager
//
//  Created by Samuel Wong on 16/2/21.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    static var kNib: UINib {
        return UINib(nibName: StoryboardConstants.Nib.ProjectTableViewCell.identifier, bundle: nil)
    }
    static var kReuseIdentifier = StoryboardConstants.Nib.ProjectTableViewCell.identifier
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var colourIndicator: UIView!
    
    var project: Project! {
        didSet {
            nameLabel.text = project.name
            locationLabel.text = project.location
            colourIndicator.backgroundColor = UIColor.colourWithHexString(project.color ?? "ffffff")
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
