//
//  FZMenuView.m
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "FZMenuView.h"

@interface FZMenuView()

@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *voiceButton;
@end

@implementation FZMenuView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Getters

- (UIButton *)videoButton
{
    if (!_videoButton) {
        
        _videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _videoButton.translatesAutoresizingMaskIntoConstraints = NO;
        _videoButton.layer.cornerRadius = 50;
        _videoButton.layer.masksToBounds = YES;
        _videoButton.backgroundColor = [UIColor blueColor];
        _videoButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_videoButton setTitle:@"Video" forState:UIControlStateNormal];
        [_videoButton addTarget:self action:@selector(videoAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_videoButton];
    }
    return _videoButton;
}

- (UIButton *)voiceButton
{
    if (!_voiceButton) {
        
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.translatesAutoresizingMaskIntoConstraints = NO;
        _voiceButton.layer.cornerRadius = 50;
        _voiceButton.layer.masksToBounds = YES;
        _voiceButton.backgroundColor = [UIColor lightGrayColor];
        [_voiceButton setTitle:@"Voice" forState:UIControlStateNormal];
        _voiceButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voiceButton addTarget:self action:@selector(voiceAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_voiceButton];
    }
    return _voiceButton;
}

#pragma mark - layout UI

- (void)setupUI
{
    
    [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(0.5);
        make.width.height.equalTo(@100);

    }];
    
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(1.5);
        make.width.height.equalTo(@100);
    }];
}

- (void)layoutSubviews
{
    [self setupUI];
}

#pragma mark - Button Actions

- (void)videoAction
{
    FLog(@"---videoAction")
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:videoButtonClicked:)]) {
        
        [self.delegate view:self videoButtonClicked:nil];
    }
}

- (void)voiceAction
{
    FLog(@"---voiceAction")
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:voiceButtonClicked:)]) {
        
        [self.delegate view:self voiceButtonClicked:nil];
    }
}

@end
