//
//  FZTopView.swift
//  HyphenateCall_Swift
//
//  Created by EaseMob on 2017/5/4.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

import UIKit

private extension UILabel {
    
    class func createOneLabel(_ title: String, _ fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.text = title
        return label
    }
}
class FZTopView: UIView {

    var timeLength: Int = 0
    lazy var remoteNameLabel: UILabel = {
       
        return UILabel.createOneLabel("Remote Name", 20)
    }()
    
    lazy var statusLabel: UILabel = {
       return UILabel.createOneLabel("Calling", 17)
    }()
    
    lazy var timeLabel: UILabel = {
       return UILabel.createOneLabel("00:00", 30)
    }()
    
    lazy var showInfoButton: UIButton = {
       let button = UIButton.init(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.init(named: "Button_Stats"), for: .normal)
        button.setImage(UIImage.init(named: "Button_Stats disabled"), for: .disabled)
        button.addTarget(self, action: #selector(showCallInfoAction(_:)), for: .touchUpInside)
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        self.layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutUI() {
        self.addSubview(remoteNameLabel)
        self.addSubview(statusLabel)
        self.addSubview(timeLabel)
        self.addSubview(showInfoButton)
        remoteNameLabel.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(self.mas_left)?.offset()(20)
            _ = make?.top.equalTo()(self.mas_top)?.offset()(30)
            _ = make?.right.equalTo()(self.mas_right)?.offset()(-20)
            _ = make?.height.equalTo()(30)
        }
        showInfoButton.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(self.mas_left)?.offset()(10)
            _ = make?.top.equalTo()(self.remoteNameLabel.mas_top)
            _ = make?.width.height().equalTo()(40)
        }
        statusLabel.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(self.mas_left)?.offset()(20)
            _ = make?.top.equalTo()(self.remoteNameLabel.mas_bottom)?.offset()(20)
            _ = make?.right.equalTo()(self.mas_right)?.offset()(-20)
            _ = make?.height.equalTo()(30)
        }
        timeLabel.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(self.mas_left)?.offset()(20)
            _ = make?.top.equalTo()(self.remoteNameLabel.mas_bottom)?.offset()(20)
            _ = make?.right.equalTo()(self.mas_right)?.offset()(-20)
            _ = make?.height.equalTo()(30)
        }
    }
    

    
    @objc private func showCallInfoAction(_: UIButton) {
        
        print("Debug__showCallInfoAction")
    }

}
