//
//  FZCallController.swift
//  HyphenateCall_Swift
//
//  Created by EaseMob on 2017/5/4.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

import UIKit
import AVFoundation

class FZCallController: UIViewController {

    
    var callSession: EMCallSession?
    var timer: Timer?
    var timeLength: Int = 0
    var isFloating = false
    
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
            if call.type == EMCallTypeVideo {
                try? AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
                try? AVAudioSession.sharedInstance().setActive(false)
            }
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
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    // For floatingWindow
    func tapAction(_ tap: UITapGestureRecognizer) {
        
        guard isFloating else {
            return
        }
        if self.actionView.floatingWindowButton.isSelected {
            self.view.frame = UIScreen.main.bounds
            self.callSession!.localVideoView.isHidden = false
            self.actionView.isHidden = false
            self.topView.isHidden = false
            self.actionView.floatingWindowButton.isSelected = false
            self.callSession!.remoteVideoView.frame = self.view.frame
            self.view.sendSubview(toBack: self.callSession!.remoteVideoView)
            isFloating = false
        }
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
        session.remoteVideoView.isUserInteractionEnabled = true
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
// MARK: - 音视频功能
extension FZCallController: FZActionViewDelegate {
    
    
    func actionViewSpeakerout(_ view: FZActionView, _ button: UIButton) {
        
        print("actionViewSpeakerout\(button)")
        let audioSession = AVAudioSession.sharedInstance()
        if button.isSelected {
            try! audioSession.overrideOutputAudioPort(.none)
        } else {
            try! audioSession.overrideOutputAudioPort(.speaker)
        }
        try! audioSession.setActive(true)
        button.isSelected = !button.isSelected
    }
    
    func actionViewSwitchCamera(_ view: FZActionView, _ button: UIButton) {
        
        print("Debug__切换摄像头")
        self.callSession?.switchCameraPosition(self.actionView.switchCameraButton.isSelected)
        self.actionView.switchCameraButton.isSelected = !self.actionView.switchCameraButton.isSelected
        
    }
    
    func actionViewMute(_ view: FZActionView, _ button: UIButton) {
        print("Debug__静音")
        button.isSelected = !button.isSelected
        if button.isSelected {
            _ = callSession?.pauseVoice()
        } else {
            _ = callSession?.resumeVoice()
        }
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
    
    func actionViewRecordAction(_ view: FZActionView, _ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            var recordPath = NSHomeDirectory()
            recordPath = "\(recordPath)/Library/appdata/chatbuffer"
            let fm = FileManager.default
            if !fm.fileExists(atPath: recordPath) {
                try? fm.createDirectory(atPath: recordPath, withIntermediateDirectories: true, attributes: nil)
            }
            var error: EMError?
            EMVideoRecorderPlugin.sharedInstance().startVideoRecording(toFilePath: recordPath, error: &error)
            if error == nil {
                print("Debug__录制视频开始，路径：\(recordPath)")
                button.setTitle("结束录制", for: .selected)
            } else {
                print("Debug__录制视频开始失败，error:\(error!.code)")
                UIAlertView.showInfo(title: "无法开始录制", info: "\(error?.description)")
                button.isSelected = false
            }
        } else {
            var aError: EMError?
            let path = EMVideoRecorderPlugin.sharedInstance().stopVideoRecording(&aError)
            if aError == nil {
                print("Debug__录制视频结束，路径：\(path!)")
                button.setTitle("录制", for: .normal)
            } else {
                print("Debug__录制视频结束失败，error:\(aError!.code)")
                UIAlertView.showInfo(title: "无法结束录制", info: "\(aError?.description)")
                button.isSelected = true
            }
        }
    }
    
    func actionViewFloatingAction(_ view: FZActionView, _ button: UIButton) {
        guard let window = UIApplication.shared.keyWindow, let callSession = self.callSession else {
            return
        }
        guard window.subviews.contains(self.view) else {
            return
        }
        button.isSelected = !button.isSelected
        if button.isSelected {
            self.view.frame = CGRect.init(x: self.view.frame.size.width - 100, y: 44, width: 80, height: self.view.frame.size.height * 80 / self.view.frame.size.width)

            callSession.localVideoView.isHidden = true
            self.actionView.isHidden = true
            self.topView.isHidden = true
            self.view.bringSubview(toFront: callSession.remoteVideoView)
            isFloating = true
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
