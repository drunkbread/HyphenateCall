//
//  FZHelper.m
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "FZHelper.h"

#import "FZCallController.h"
#import "FZMenuViewController.h"
@interface FZHelper()<EMClientDelegate, EMCallManagerDelegate, EMCallBuilderDelegate>

@property (nonatomic, strong) EMCallSession *currentSession;
@property (nonatomic, strong) FZCallController *callController;
@property (nonatomic, strong) NSTimer *callTimer;
@end

static FZHelper *helper = nil;

@implementation FZHelper

+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        helper = [[FZHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self _unRegisterCallNotifications];
        [self _registerCallNotifications];
        EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
        options.videoResolution = EMCallVideoResolution640_480;
        options.isFixedVideoResolution = YES;
        [[EMClient sharedClient].callManager setCallOptions:options];
    }
    return self;
}

- (void)_unRegisterCallNotifications
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].callManager removeDelegate:self];
}

- (void)_registerCallNotifications
{
    [[EMClient sharedClient] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark -  make call

- (void)makeCall:(NSString *)remote callType:(EMCallType)callType
{
    if (remote.length <= 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[EMClient sharedClient].callManager startCall:callType remoteName:remote ext:nil completion:^(EMCallSession *aCallSession, EMError *aError) {
        if (!aError) {
            
            weakSelf.currentSession = aCallSession;
            weakSelf.callController = [[FZCallController alloc] initWithCallSession:weakSelf.currentSession];
            [weakSelf.menuVC presentViewController:weakSelf.callController animated:YES completion:nil];
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"呼叫失败" message:aError.errorDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

#pragma mark - Timer
// 设置超时时间，超时结束呼叫
- (void)startCallTimer
{
    self.callTimer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(timeToCancelCall) userInfo:nil repeats:NO];
}

- (void)stopCallTimer
{
    if (self.callTimer == nil) {
        return;
    }
    [self.callTimer invalidate];
    self.callTimer = nil;
}
- (void)timeToCancelCall
{
    [self hangupCall:EMCallEndReasonNoResponse];
}

- (void)hangupCall:(EMCallEndReason)aReason
{
    [self stopCallTimer];
    if (self.currentSession) {
        
        [[EMClient sharedClient].callManager endCall:self.currentSession.callId reason:aReason];
    }
    self.currentSession = nil;
    [self clearCallData];
}

- (void)clearCallData
{
    [self stopCallTimer];
    [self.callController clearData];
    [self.callController dismissViewControllerAnimated:YES completion:nil];
    self.callController = nil;
}

- (void)answerIncomingCall:(NSString *)callId
{
    if (!self.currentSession || ![self.currentSession.callId isEqualToString:callId]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient].callManager answerIncomingCall:weakSelf.currentSession.callId];
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf hangupCall:EMCallEndReasonFailed];
            });
        }
    });
}

#pragma mark - EMCallManagerDelegate
- (void)callDidReceive:(EMCallSession *)aSession
{
    if (!aSession || aSession.callId.length <= 0) {
        return;
    }
    // 判断是否正在通话，正在通话时收到请求，直接拒绝请求。
    if (self.currentSession && self.currentSession.status != EMCallSessionStatusDisconnected) {
        
        [[EMClient sharedClient].callManager endCall:aSession.callId reason:EMCallEndReasonBusy];
    }
    
    self.currentSession = aSession;
    self.callController = [[FZCallController alloc] initWithCallSession:self.currentSession];
    [self startCallTimer];
    [self.menuVC presentViewController:self.callController animated:YES completion:nil];
}

- (void)callDidConnect:(EMCallSession *)aSession
{
    if (self.callController) {
        
        [self.callController changeToConnectedState];
    }
}

- (void)callDidAccept:(EMCallSession *)aSession
{
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        
        [self stopCallTimer];
        [self.callController changeToAnsweredState];
    }
}

- (void)callDidEnd:(EMCallSession *)aSession reason:(EMCallEndReason)aReason error:(EMError *)aError
{
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        
        [self stopCallTimer];
        self.currentSession = nil;
        [self clearCallData];
    }
}

- (void)callRemoteOffline:(NSString *)aRemoteName
{
    
}

- (void)callStateDidChange:(EMCallSession *)aSession type:(EMCallStreamingStatus)aType
{
    
}
@end
