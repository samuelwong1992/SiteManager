//
//  MainNavBar.swift
//  Site Manager
//
//  Created by Samuel Wong on 9/2/21.
//

import UIKit

protocol MainNavBarDelegate: AnyObject {
    func shouldClose(forMainNavBar mainNavBar: MainNavBar)
}

class MainNavBar: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    
    weak var _delegate: MainNavBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        super.loadViewFromNib(StoryboardConstants.Nib.MainNavBar.identifier, forClass: MainNavBar.self)
        
        initialize()
    }
}

//MARK: Initialization
extension MainNavBar {
    func initialize() {
        backgroundColor = .white
        closeButton.addTarget(self, action: #selector(closeButton_didPress), for: .touchUpInside)
        secondaryButton.isHidden = true
    }
}

//MARK: Button Handlers
@objc extension MainNavBar {
    func closeButton_didPress() {
        _delegate?.shouldClose(forMainNavBar: self)
    }
}
