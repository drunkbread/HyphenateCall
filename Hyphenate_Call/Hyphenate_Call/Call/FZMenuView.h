//
//  FZMenuView.h
//  Shengji
//
//  Created by EaseMob on 2017/3/29.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FZMenuView;
@protocol FZMenuViewDelegate <NSObject>

@optional
- (void)view:(FZMenuView *)view videoButtonClicked:(NSString *)remote;

- (void)view:(FZMenuView *)view voiceButtonClicked:(NSString *)remote;

@end

@interface FZMenuView : UIView

- (instancetype)init;

@property (nonatomic, assign) id<FZMenuViewDelegate>delegate;
@end
