//
//  UITextView+BoundingRect.h
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTTextFragment.h"

NS_ASSUME_NONNULL_BEGIN

/// 描述文字布局的数据结构
@interface JFTTextViewLinesLayout : NSObject
@property (nonatomic) NSArray<JFTTextFragment *> *lines;
@property (nonatomic) CGRect boundingRect;
@property (nonatomic) NSUInteger lineCount;
+ (JFTTextViewLinesLayout *)makeLyaoutLinesWithTextView:(UITextView *)textView font:(UIFont *)font;
@end

@interface UITextView (BoundingRect)

/// 不要把光标的宽度算到 TextView 的宽度中。默认是需要给 TextView 加一点宽度，防止光标被截断的
@property (nonatomic, assign) BOOL ks_disableAppendBoundingSizeWithCaretRect;
/**
 算出文字的 boundingRect。替代 boundingRectForGlyphRange

 @return text boundingRect
 */
- (CGRect)jft_boundingRect;

/**
 算出文字的 boundingRect。替代 boundingRectForGlyphRange。

 这个方法可以减少 emoji 高度较高导致的计算不符合预期
 @param font UIFont for textView
 @return text boundingRect
 */
- (CGRect)jft_boundingRect:(nullable UIFont *)font;

- (CGRect)jft_boundingRect:(UIFont *)font lineCount:(nullable NSUInteger *)lineCount;

@end

NS_ASSUME_NONNULL_END
