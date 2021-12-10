//
//  PrimaryButton.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/12/21.
//

import UIKit

@IBDesignable class PrimaryButton: UIView {
    private var button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 14))
    @IBInspectable var titleText: String! {
        didSet {
            button.setTitle(titleText, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

       initialize()
    }

    private func initialize() {
        addSubViewWithSameSize(subview: button)
        
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = Themes.Color.Primary.uiColor
        config.cornerStyle = .capsule
        
        button.configuration = config
        
        
    }
    
    func addTarget(_ target: Any?, action: Selector, for control: UIControl.Event) {
        button.addTarget(target, action: action, for: control)
    }
}
