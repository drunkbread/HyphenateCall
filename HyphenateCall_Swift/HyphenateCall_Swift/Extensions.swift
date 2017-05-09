//
//  Extensions.swift
//  HyphenateCall_Swift
//
//  Created by EaseMob on 2017/5/4.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

import Foundation

extension UIButton {
    
    class func createButton(title: String, tag: Int, fontSize: CGFloat, width: Double, target: AnyObject, selector: Selector) -> UIButton {
        let button = UIButton.init(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.tag = tag
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.layer.cornerRadius = CGFloat(width / 2)
        button.layer.masksToBounds = true
        button.addTarget(target, action: selector, for: .touchUpInside)
        return button
    }
    
    class func buttonFromImage(image: String, selectedImage: String, aTarget: AnyObject, action: Selector) -> UIButton {
        let button = UIButton.init(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.init(named: image), for: .normal)
        button.setImage(UIImage.init(named: selectedImage), for: .selected)
        button.addTarget(aTarget, action: action, for: .touchUpInside)
        return button
    }
}

extension UIAlertView {
    
    class func showInfo(title: String!, info: String!) {
        let alert = UIAlertView.init(title: title, message: info, delegate: nil, cancelButtonTitle: "确定")
        alert.show()
    }
}



