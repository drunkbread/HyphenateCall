//
//  FZActionView.h
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FZActionView;
@protocol FZActionViewDelegate <NSObject>

@optional

- (void)view:(FZActionView *)actionView speakerOutAction:(UIButton *)sender;

- (void)view:(FZActionView *)actionView switchCaremaAction:(UIButton *)sender;

- (void)view:(FZActionView *)actionView muteAction:(UIButton *)sender;

- (void)view:(FZActionView *)actionView rejectCallAction:(UIButton *)sender;

- (void)view:(FZActionView *)actionView answerCallAction:(UIButton *)sender;

@end

@interface FZActionView : UIView

@property (nonatomic, strong) UIButton *speakerOutButton;
@property (nonatomic, strong) UIButton *switchCameraButton;
@property (nonatomic, strong) UIButton *muteButton;
@property (nonatomic, strong) UIButton *rejectButton;
@property (nonatomic, strong) UIButton *answerButton;

@property (nonatomic, weak) id<FZActionViewDelegate>acDelegate;

- (void)remakeRejectButtonLayout;

@end
