//
//  FZActionView.swift
//  HyphenateCall_Swift
//
//  Created by EaseMob on 2017/5/5.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

import UIKit

@objc protocol FZActionViewDelegate {
    
    @objc optional func actionViewSpeakerout(_ view: FZActionView, _ button: UIButton)
    @objc optional func actionViewSwitchCamera(_ view: FZActionView, _ button: UIButton)
    @objc optional func actionViewMute(_ view: FZActionView, _ button: UIButton)
    @objc optional func actionViewRejectCall(_ view: FZActionView, _ button: UIButton)
    @objc optional func actionViewAnswerCall(_ view: FZActionView, _ button: UIButton)
}

class FZActionView: UIView {

    
    var delegate: FZActionViewDelegate?
    init() {
        super.init(frame: .zero)
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var speakerOutButton: UIButton = {
       
        let button = UIButton.buttonFromImage(image: "Button_Speaker", selectedImage: "Button_Speaker active", aTarget: self, action: #selector(speakeroutAction(_:)))
        return button
    }()
    
    lazy var switchCameraButton: UIButton = {
       
        let button = UIButton.buttonFromImage(image: "Button_Camera switch", selectedImage: "Button_Camera switch active", aTarget: self, action: #selector(switchCameraAction(_:)))
        button.isHidden = true
        return button
    }()
    
    lazy var muteButton: UIButton = {
        let button = UIButton.buttonFromImage(image: "Button_Mute", selectedImage: "Button_Mute active", aTarget: self, action: #selector(muteAction(_:)))
        return button
    }()
    
    lazy var rejectButton: UIButton = {
        let button = UIButton.buttonFromImage(image: "Button_End", selectedImage: "Button_End", aTarget: self, action: #selector(rejectAction(_:)))
        return button
    }()
    
    lazy var answerButton: UIButton = {
        let button = UIButton.buttonFromImage(image: "Button_Answer", selectedImage: "Button_Answer", aTarget: self, action: #selector(answerAction(_:)))
        return button
    }()
    
    private func layoutUI() {
        self.addSubview(speakerOutButton)
        self.addSubview(switchCameraButton)
        self.addSubview(muteButton)
        self.addSubview(rejectButton)
        self.addSubview(answerButton)
        speakerOutButton.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(self.mas_left)?.offset()(100)
            _ = make?.top.equalTo()(self.mas_top)?.offset()(20)
            _ = make?.width.height().equalTo()(40)
        }
        switchCameraButton.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(self.mas_left)?.offset()(100)
            _ = make?.top.equalTo()(self.mas_top)?.offset()(20)
            _ = make?.width.height().equalTo()(40)
        }
        muteButton.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.mas_top)?.offset()(20)
            _ = make?.right.equalTo()(self.mas_right)?.offset()(-100)
            _ = make?.width.height().equalTo()(40)
        }
        rejectButton.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(self.mas_left)?.offset()(60)
            _ = make?.bottom.equalTo()(self.mas_bottom)?.offset()(-35)
            _ = make?.width.height().equalTo()(65)
        }
        
        answerButton.mas_makeConstraints { (make) in
            _ = make?.right.equalTo()(self.mas_right)?.offset()(-60)
            _ = make?.bottom.equalTo()(self.mas_bottom)?.offset()(-35)
            _ = make?.width.height().equalTo()(65)
        }
    }
    
    func remakeRejectButtonConstraints() {
        rejectButton.mas_remakeConstraints { (make) in
            _ = make?.centerX.equalTo()(self.mas_centerX)
            _ = make?.bottom.equalTo()(self.mas_bottom)?.offset()(-35)
            _ = make?.width.height().equalTo()(65)
        }
    }

    @objc private func speakeroutAction(_ sender: UIButton) {
        delegate?.actionViewSpeakerout?(self, sender)
    }
    
    @objc private func switchCameraAction(_ sender: UIButton) {
        delegate?.actionViewSwitchCamera?(self, sender)
    }
    
    @objc private func muteAction(_ sender: UIButton) {
        delegate?.actionViewMute?(self, sender)
    }
    
    @objc private func rejectAction(_ sender: UIButton) {
        delegate?.actionViewRejectCall?(self, sender)
    }
    
    @objc private func answerAction(_ sender: UIButton) {
        delegate?.actionViewAnswerCall?(self, sender)
    }
}
