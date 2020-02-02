//
//  JFTLayoutManagerRender.h
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JFTTextLayout;
@interface JFTLayoutManagerRender : NSObject

@property (nonatomic, assign) BOOL strokeJoinRound;
@property (nonatomic, assign) BOOL hidden;

@property (nonatomic, assign) CGPoint textPoint;
@property (nonatomic, readonly) NSTextStorage *storage;
@property (nonatomic, readonly) NSLayoutManager *layoutManager;
@property (nonatomic, readonly) NSTextContainer *textContainer;
@property (nonatomic, readonly) JFTTextLayout *layout;

/// 默认为空，直接使用 UITextView 的富文本。使用此属性可以实现 UITextView 透明，KSPMLayoutManagerRenderLayer 有颜色。
@property (nonatomic, copy) NSDictionary *textAttributes;

- (void)updateRenderWithTextView:(UITextView *)textView;
- (void)drawInContext:(CGContextRef)ctx;

@end

NS_ASSUME_NONNULL_END
