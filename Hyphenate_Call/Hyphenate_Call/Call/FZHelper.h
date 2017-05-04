//
//  FZHelper.h
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FZMenuViewController;
@interface FZHelper : NSObject

@property (nonatomic, strong) FZMenuViewController *menuVC;
+ (instancetype)shareHelper;
- (void)makeCall:(NSString *)remote callType:(EMCallType)callType;

- (void)hangupCall:(EMCallEndReason)aReason;

- (void)answerIncomingCall:(NSString *)callId;
@end
