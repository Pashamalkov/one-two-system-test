//
//  AppointButton.swift
//  one-two-system-test
//
//  Created by Павел on 26/01/2019.
//  Copyright © 2019 Павел. All rights reserved.
//

import Foundation
import UIKit

class AppointButton: UIButton {
    var bottomInset: CGFloat = 16
    var shadowOpacity: Float = 0.5 {
        didSet {
            setStyle()
        }
    }
    var title: String = "" {
        didSet {
            setStyle()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            setStyle()
        }
    }
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupSubviews()
    }
    
    private func setupSubviews() {
        titleEdgeInsets.top = 4
        setStyle()
    }
    
    private func setStyle() {
        if !isEnabled {
            backgroundColor = .lightGrayColor
            self.layer.shadowOpacity = 0
        } else {
            backgroundColor = .blueColor
            self.layer.shadowOpacity = shadowOpacity
        }
        
        setAttributedTitle(
            NSAttributedString(string: title, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.kern: 0.2,
                NSAttributedString.Key.foregroundColor: UIColor.white
                ]),
            for: .normal)
        setAttributedTitle(
            NSAttributedString(string: title, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.kern: 0.2,
                NSAttributedString.Key.foregroundColor: UIColor.white
                ]),
            for: .disabled)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.buttonShadowColor().cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowRadius = 8
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x: self.bounds.origin.x+8, y: self.bounds.origin.y+8, width: self.bounds.width-16, height: self.bounds.height-8)).cgPath
    }
    
    func changeAppointButton(_ isHidden: Bool) {
        guard let superview = superview else { return }
        var y = superview.frame.maxY
        if !isHidden {
            y -= (frame.height + bottomInset)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.origin.y = y
        })
    }
}
