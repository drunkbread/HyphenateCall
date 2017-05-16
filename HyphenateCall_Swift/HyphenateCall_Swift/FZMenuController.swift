//
//  FZMenuController.swift
//  HyphenateCall_Swift
//
//  Created by EaseMob on 2017/5/4.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

import UIKit

private extension Selector {
    
    static let buttonAction = #selector(FZMenuController.buttonAction(_:))
}

class FZMenuController: UIViewController {

    var chatter: String
    
    // MARK: - Init
    init(chatter: String) {
        self.chatter = chatter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lazy method
    lazy var voiceButton: UIButton = {

        return UIButton.createButton(title: "Voice", tag: 101, fontSize: 14, width: 100.0, target: self, selector: .buttonAction)
    }()
    
    lazy var videoButton: UIButton = {
       
        return UIButton.createButton(title: "Video", tag: 102, fontSize: 14, width: 100.0, target: self, selector: .buttonAction)
    }()

    // MARK: - setupUI
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func buttonAction(_ button: UIButton) {
        print("Debug__buttonAction")
        if button.tag == 101 {
            voiceAction()
        } else if button.tag == 102 {
            videoAction()
        }
    }
    
    private func setupUI() {
        view.addSubview(voiceButton)
        view.addSubview(videoButton)
        
        self.voiceButton.mas_makeConstraints { (make) in
            _ = make?.centerX.equalTo()(self.view.mas_centerX)
            _ = make?.centerY.equalTo()(self.view.mas_centerY)?.multipliedBy()(0.5)
            _ = make?.width.height().equalTo()(100)
        }
        videoButton.mas_makeConstraints { (make) in
            _ = make?.centerX.equalTo()(self.view.mas_centerX)
            _ = make?.centerY.equalTo()(self.view.mas_centerY)?.multipliedBy()(1.5)
            _ = make?.width.height().equalTo()(100)
        }
        
        
    }
    
    // MARK: - Actions
    @objc private func voiceAction() {
        print("Debug__voiceAction")
        FZHelper.helper.makeCall(self.chatter, callType: EMCallTypeVoice)
    }
    @objc private func videoAction() {
        print("Debug__videoAction")
        FZHelper.helper.makeCall(self.chatter, callType: EMCallTypeVideo)
    }

}

extension FZMenuController {

    
}
