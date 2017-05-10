//
//  FZHelper.swift
//  HyphenateCall_Swift
//
//  Created by EaseMob on 2017/5/4.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

import UIKit
import UserNotifications
class FZHelper: NSObject {

    static let helper = FZHelper()
    var currentSession: EMCallSession?
    var callController: FZCallController?
    var menuVC: FZMenuController!
    private var callTimer: Timer?
    let object = NSObject()
    private override init() {
        super.init()
        self.setupHelper()
    }
    
    // 发起通话请求，语音或者视频
    func makeCall(_ remoteUser: String, callType: EMCallType) {
        guard remoteUser.isEmpty == false else {
            return;
        }
        EMClient.shared().callManager.start!(callType, remoteName: remoteUser, ext: nil) { (aCallSession, aError) in
            if aError == nil || aCallSession == nil {
                
                objc_sync_enter(self.object)
                self.currentSession = aCallSession
                self.callController = FZCallController.init(callSession: self.currentSession)
                self.menuVC .present(self.callController!, animated: true, completion: nil)
                self.startCallTimer()
                objc_sync_exit(self.object)
            } else {
                
                UIAlertView.showInfo(title: "呼叫失败", info: aError!.errorDescription)
            }
        }
    }
    
    func hangup(_ reason: EMCallEndReason) {
        stopCallTimer()
        if let session = self.currentSession {
            _ = EMClient.shared().callManager.endCall!(session.callId, reason: reason)
            clearCallViewAndData()
        }
        
    }
    // 接听通话请求
    func answerCall(_ callId: String) {
        if self.currentSession == nil || self.currentSession?.callId != callId {
            return
        }
        DispatchQueue.global().async {
            
            let aError = EMClient.shared().callManager.answerIncomingCall!(self.currentSession?.callId)
            if aError != nil {
                DispatchQueue.main.async {
                    if aError!.code == EMErrorNetworkUnavailable {
                        UIAlertView.showInfo(title: "接听失败", info: "网络未连接")
                    } else {
                        self.hangup(EMCallEndReasonFailed)
                    }
                }
            }
        }
    }
    // 开启定时器，50s后如果没有接听，直接挂断。
    func startCallTimer() {
        self.callTimer = Timer.scheduledTimer(timeInterval: 50, target: self, selector: #selector(timeToCancelCall), userInfo: nil, repeats: false)
    }
    
    func stopCallTimer() {
        if self.callTimer == nil {
            return
        }
        self.callTimer!.invalidate()
        self.callTimer = nil
    }
    
    @objc func timeToCancelCall() {
        // 挂断
        hangup(EMCallEndReasonNoResponse)
        UIAlertView.showInfo(title: "呼叫失败", info: "对方没有响应")
    }
    
    func clearCallViewAndData() {
        objc_sync_enter(object)
        self.currentSession = nil
        // todo 清除callController的数据
        
        self.callController?.dismiss(animated: false, completion: nil)
        self.callController = nil
        objc_sync_exit(object)
    }
}

extension FZHelper: EMCallManagerDelegate , EMClientDelegate, EMCallBuilderDelegate {
    
    func setupHelper() {
        // 初始化视频录制工具类，必须在通话前调用
        EMVideoRecorderPlugin.initGlobalConfig()
        EMClient.shared().removeDelegate(self)
        EMClient.shared().callManager.remove!(self)
        EMClient.shared().callManager.add!(self, delegateQueue: nil)
        EMClient.shared().add(self, delegateQueue: nil)
        initlizeCallOption()
    }
    private func initlizeCallOption() {
        
        let options = EMClient.shared().callManager.getCallOptions!()
        options?.videoResolution = EMCallVideoResolution640_480
        options?.isFixedVideoResolution = true
        options?.isSendPushIfOffline = true
        options?.offlineMessageText = "您有新的通话请求"
        EMClient.shared().callManager.setCallOptions!(options)
    }
    
    func callDidConnect(_ aSession: EMCallSession!) {
        if self.callController != nil {
            self.callController!.changeToConnectedState()
        }
    }
    
    func callDidAccept(_ aSession: EMCallSession!) {
        if aSession.callId == self.currentSession?.callId {
            self.callController?.changeToAcceptedState()
        }
    }
    
    func callDidReceive(_ aSession: EMCallSession!) {
        
        showCallLocalNotification()
        if aSession == nil || aSession.callId.isEmpty {
            return
        }
        if currentSession != nil && currentSession?.status != EMCallSessionStatusDisconnected {
            _ = EMClient.shared().callManager.endCall!(aSession.callId, reason: EMCallEndReasonBusy)
            return
        }
        objc_sync_enter(object)
        startCallTimer()
        self.currentSession = aSession
        self.callController = FZCallController.init(callSession: self.currentSession)
        self.callController?.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            if let controller = self.callController {
                self.menuVC.present(controller, animated: false, completion: nil)
            }
        }
        objc_sync_exit(object)
    }
    
    func callDidEnd(_ aSession: EMCallSession!, reason aReason: EMCallEndReason, error aError: EMError!) {
        
        if aSession.callId == self.currentSession?.callId {
            stopCallTimer()
            objc_sync_enter(object)
            self.currentSession = nil
            self.clearCallViewAndData()
            objc_sync_exit(object)
            if aReason != EMCallEndReasonHangup {
                var str = "End"
                switch aReason {
                case EMCallEndReasonNoResponse:
                        str = "No Response"
                case EMCallEndReasonDecline:
                        str = "Reject The Call"
                case EMCallEndReasonBusy:
                    str = "In The Call..."
                case EMCallEndReasonFailed:
                    str = "Connect Failed"
                case EMCallEndReasonUnsupported:
                    str = "Unsupported"
                case EMCallEndReasonRemoteOffline:
                    str = "Remote Offline"
                default: break
                }
                if aError != nil {
                    UIAlertView.showInfo(title: "Error", info: aError.description)
                } else {
                    UIAlertView.showInfo(title: "End", info: str)
                }
            }
        }
    }
    
    func callRemoteOffline(_ aRemoteName: String!) {
        let text = EMClient.shared().callManager.getCallOptions!().offlineMessageText
        let textBody = EMTextMessageBody.init(text: text)
        let msg = EMMessage.init(conversationID: aRemoteName, from: EMClient.shared().currentUsername, to: aRemoteName, body: textBody, ext: ["em_apns_ext":["em_push_title":text]])
        msg?.chatType = EMChatTypeChat
        EMClient.shared().chatManager.send(msg, progress: nil, completion: nil)
    }
    
    // MARK: - 本地通知
    func showCallLocalNotification() {
        let application = UIApplication.shared
        guard application.applicationState == .background else {
            return
        }
        if #available(iOS 10, *) {
            let content = UNMutableNotificationContent()
            content.body = "您有新的通话请求"
            content.badge = 1
            content.sound = UNNotificationSound.default()
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.5, repeats: false)
            let identifier = String(Date().timeIntervalSince1970)
            let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            let notification = UILocalNotification()
            notification.fireDate = Date()
            notification.alertBody = "您有新的通话请求"
            notification.alertAction = "Open"
            notification.timeZone = NSTimeZone.default
            notification.soundName = UILocalNotificationDefaultSoundName
            application.scheduleLocalNotification(notification)
        }
    }
    
}
