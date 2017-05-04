//
//  FZMenuViewController.m
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "FZMenuViewController.h"
#import "FZMenuView.h"
#import "FZCallController.h"
#import "FZHelper.h"
@interface FZMenuViewController ()<FZMenuViewDelegate>
@property (nonatomic, strong) FZCallController *callController;
@property (nonatomic, copy) NSString *remote;
@end

@implementation FZMenuViewController
- (instancetype)initWithRemoteUser:(NSString *)remoteName
{
    self = [super init];
    if (self) {
        _remote = remoteName;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    FZMenuView *menuView = [[FZMenuView alloc] init];
    menuView.delegate = self;
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
}

- (BOOL)isRemoteValid:(NSString *)remote
{
    if (remote.length <= 0 || [remote isEqualToString:[[EMClient sharedClient] currentUsername]]) {
        return NO;
    }
    return YES;
}

#pragma mark - FZMenuViewDelegate

- (void)view:(FZMenuView *)view videoButtonClicked:(NSString *)remote
{
    if (![self isRemoteValid:_remote]) {
        return;
    }
    [[FZHelper shareHelper] makeCall:_remote callType:EMCallTypeVideo];
}

- (void)view:(FZMenuView *)view voiceButtonClicked:(NSString *)remote
{
    if (![self isRemoteValid:_remote]) {
        return;
    }
    [[FZHelper shareHelper] makeCall:_remote callType:EMCallTypeVoice];
}

@end
