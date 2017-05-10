//
//  FZCallController.swift
//  HyphenateCall_Swift
//
//  Created by EaseMob on 2017/5/4.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

import UIKit
import AVFoundation

class FZCallController: UIViewController, FZActionViewDelegate {

    
    var callSession: EMCallSession?
    var timer: Timer?
    var timeLength: Int = 0

    
    lazy var topView: FZTopView = {
        let topView = FZTopView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = .clear
        return topView
    }()
    
    lazy var actionView: FZActionView = {
        let actionView = FZActionView()
        actionView.delegate = self
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.backgroundColor = .clear
        return actionView
    }()
    // MARK: - 初始化
    init?(callSession: EMCallSession?) {
        if let call = callSession {
            self.callSession = call
        } else {
            return nil
        }
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI处理
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 62 / 255, green: 92 / 255, blue: 120 / 255, alpha: 1.0)
        view.addSubview(topView)
        view.addSubview(actionView)
        layoutUI()
        initializeCallUI()
    }
    
    // MARK: - Action
    
    func startCallTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        guard self.timer != nil else {
            return
        }
        self.timer?.invalidate()
        self.timer = nil
    }
    func clearCallData() {
        callSession?.remoteVideoView.isHidden = true
        callSession?.remoteVideoView = nil
        callSession = nil
        stopTimer()
    }

    
    // MARK: - FZActionViewDelegate
    
    func actionViewSpeakerout(_ view: FZActionView, _ button: UIButton) {
        
        print("actionViewSpeakerout\(button)")
    }
    
    func actionViewSwitchCamera(_ view: FZActionView, _ button: UIButton) {
        
    }
    
    func actionViewMute(_ view: FZActionView, _ button: UIButton) {
        
    }
    
    func actionViewRejectCall(_ view: FZActionView, _ button: UIButton) {
        stopTimer()
        if (self.callSession?.isCaller)! {
            FZHelper.helper.hangup(EMCallEndReasonNoResponse)
        } else {
        FZHelper.helper.hangup(EMCallEndReasonDecline)
        }
    }
    
    func actionViewAnswerCall(_ view: FZActionView, _ button: UIButton) {
        FZHelper.helper.answerCall((self.callSession!.callId)!)
    }

}
// MARK: - 通话页面的UI处理
extension FZCallController {
    
    // 初始化UI部分，添加按钮
    func layoutUI() {
        topView.mas_makeConstraints { (make) in
            _ = make?.left.top().right().equalTo()(self.view)
            _ = make?.centerY.equalTo()(self.view.mas_centerY)?.multipliedBy()(2/3)
        }
        actionView.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.topView.mas_bottom)
            _ = make?.left.right().bottom().equalTo()(self.view)
        }
    }
    
    func initializeCallUI() {
        
        guard let callSession = self.callSession else {
            dismiss(animated: true, completion: nil)
            return;
        }
        topView.remoteNameLabel.text = callSession.remoteName
        topView.timeLabel.isHidden = true
        topView.statusLabel.text = "Calling.."
        if callSession.type == EMCallTypeVoice {
            topView.showInfoButton.isHidden = true
            actionView.switchCameraButton.isHidden = true
            if callSession.isCaller {
                actionView.answerButton.isHidden = true
                actionView.remakeRejectButtonConstraints()
            }
        } else if callSession.type == EMCallTypeVideo {
            actionView.speakerOutButton.isHidden = true
            actionView.switchCameraButton.isHidden = false
            if callSession.isCaller {
                actionView.answerButton.isHidden = true
                actionView.remakeRejectButtonConstraints()
            }
            setupLocalVideoView()
        }
        
    }
    // 设置本地视频图像
    private func setupLocalVideoView() {
        callSession?.localVideoView = EMCallLocalView()
        callSession?.localVideoView.scaleMode = EMCallViewScaleModeAspectFit
        if let local = callSession?.localVideoView {
            view.addSubview(local)
            view.bringSubview(toFront: local)
            local.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()(self.view.mas_top)?.offset()(40)
                _ = make?.right.equalTo()(self.view.mas_right)?.offset()(-20)
                let width: CGFloat = 80
                let boundsWidth: CGFloat = self.view.bounds.size.width
                let boundsHeight: CGFloat = self.view.bounds.size.height
                let height = boundsHeight * (width / boundsWidth)
                _ = make?.width.equalTo()(width)
                _ = make?.height.equalTo()(height)
            })
        }
        
    }
    
    func setupRemoteVideoView() {
        
        
        guard let session = self.callSession else {
            return
        }
        guard session.type == EMCallTypeVideo && callSession?.remoteVideoView == nil else {
            return
        }
        session.remoteVideoView = EMCallRemoteView()
        session.remoteVideoView.scaleMode = EMCallViewScaleModeAspectFill
        view.addSubview(session.remoteVideoView)
        view.sendSubview(toBack: session.remoteVideoView)
        session.remoteVideoView.mas_makeConstraints { (make) in
            _ = make?.top.left().bottom().right().equalTo()(self.view)
        }
    }
    
    @objc func timeAction()  {
        timeLength += 1
        let hour = timeLength / 3_600
        let min = (timeLength - hour * 3_600) / 60
        let sec = timeLength - hour * 3_600 - min * 60
        if hour > 0 {
            topView.timeLabel.text = "\(hour):\(min):\(sec)"
        } else if min > 0 {
            topView.timeLabel.text = "\(min):\(sec)"
        } else {
            topView.timeLabel.text = "00:\(sec)"
        }
    }

}
// 通话的状态
extension FZCallController {
    
    func changeToConnectedState() {
        self.topView.statusLabel.text = "连接建立完成"
    }
    
    func changeToAcceptedState() {
        topView.statusLabel.isHidden = true
        topView.timeLabel.isHidden = false
        // todo
        startCallTimer()
        actionView.answerButton.isHidden = true
        actionView.remakeRejectButtonConstraints()
        setupRemoteVideoView()
    }
}
