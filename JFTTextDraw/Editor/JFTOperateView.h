//
//  JFTOperateView.h
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTProject.h"
#import "JFTItemState.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFTOperateViewTextViewOperate : NSObject
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat rotate;
@end

/// 文字操作
@interface JFTOperateView : UIView

- (instancetype)initWithProject:(JFTProject *)project;

- (void)addText;

- (void)applyOperate:(JFTOperateViewTextViewOperate *)operate;

/// 模拟绘制到视频上
- (void)renderToContext:(CGContextRef)ctx;

@end

NS_ASSUME_NONNULL_END
