//
//  UITextView+BoundingRect.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "UITextView+BoundingRect.h"
#import <objc/runtime.h>
#import "JFTTextLayout.h"

@implementation JFTTextViewLinesLayout
+ (JFTTextViewLinesLayout *)makeLyaoutLinesWithTextView:(UITextView *)textView font:(UIFont *)font {
    if (!font) {
        font = textView.typingAttributes[NSFontAttributeName];
    }
    JFTTextViewLinesLayout *linesLayout = [JFTTextViewLinesLayout new];
    NSLayoutManager *layoutManager = textView.layoutManager;
    
    CGRect caretRect = ({
        UITextPosition *position = textView.selectedTextRange.end;
        [textView caretRectForPosition:position];
    });
    
    // 最宽的那一行文字所占用的宽度
    __block CGFloat maxLineWidth = 0;
    /**
     计算每行文字的字形所占的矩形区域
     
     当设置了行间距时 enumerateLineFragmentsForGlyphRange 得到的字形 Rect 包含了行间距。
     需要调用 [JFTTextViewContentUtil innerLineFragmentRectWithLayoutManager:textStoragelineGlyphRange:usedRect] 成用户所理解的文字所占据的矩形
     
     */
    NSMutableArray<JFTTextFragment *> *lines = [NSMutableArray array];
    [layoutManager enumerateLineFragmentsForGlyphRange:NSMakeRange(0, layoutManager.numberOfGlyphs)
                                            usingBlock:
     ^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange glyphRange, BOOL * _Nonnull stop) {
         
         NSRange characterRange = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
         JFTTextFragment *line = [JFTTextFragment new];
         line.usedRect
         = [JFTTextViewContentUtil innerLineFragmentRectWithLayoutManager:textView.layoutManager
                                                               textStorage:textView.textStorage
                                                            lineGlyphRange:glyphRange
                                                                  usedRect:usedRect
                                                                      font:font];
         line.characterRange = characterRange;
         [lines addObject:line];
         maxLineWidth
        = MAX(ceil(CGRectGetWidth(usedRect)) + (textView.ks_disableAppendBoundingSizeWithCaretRect ? 0 : caretRect.size.width/*光标*/),
               maxLineWidth);
     }];
    CGSize defaultStringSize = ({
        NSAttributedString *attributedString
        = [[NSAttributedString alloc] initWithString:@"A"
                                          attributes:textView.typingAttributes];
        CGSize size = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                     context:nil].size;
        size.height = ceil(size.height);
        size;
    });
    CGSize size = CGSizeZero;
    {
        if (lines.count) {
            // 设置了 minimumLineHeight 和 maximumLineHeight boundingRectForGlyphRange 的值会非常诡异，只在适当必须的时候去读这个值
            CGRect rect = [layoutManager boundingRectForGlyphRange:NSMakeRange(0, layoutManager.numberOfGlyphs)
                                                   inTextContainer:textView.textContainer];
            // 遇到换行的情况，宽度不太符合预期，这里只使用 boundingRectForGlyphRange 的高度
            {// 系统 bug。当文字为一大串空格的时候，系统忽然告知字形所占用矩形宽度不到 0.1。尝试绕过系统 bug
                if (layoutManager.textStorage.length > 2 && (CGRectGetWidth(rect) < 0.1)) {
                    CGFloat fixedWidth = ({
                        NSAttributedString *attr = layoutManager.textStorage;
                        [attr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                           context:nil].size.width;
                    });
                    
                    maxLineWidth = fixedWidth;
                }
            }
            
            JFTTextFragment *lastLine = nil;
            if (textView.textContainer.maximumNumberOfLines == 0) {
                lastLine = lines.lastObject;
            } else {
                lastLine = lines[MIN(textView.textContainer.maximumNumberOfLines, lines.count) - 1];
            }
            
            CGFloat height = CGRectGetMaxY(lastLine.usedRect);
            
            size = CGSizeMake(ceil(maxLineWidth), ceil(height));
        } else {
            size = defaultStringSize;
        }
    }

    CGPoint textLeftTop = ({// 文本左上角的坐标（boundingRectForGlyphRange 经常不准，我已经不相信爱情了）
        __block CGFloat x = 0;
        __block CGFloat y = 0;
        [lines enumerateObjectsUsingBlock:^(JFTTextFragment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                x = obj.usedRect.origin.x;
                y = obj.usedRect.origin.y;
            } else {// 找到最左边的点
                x = MIN(obj.usedRect.origin.x, x);
            }
        }];
        CGPointMake(x, y);
    });
    
    linesLayout.lineCount = lines.count;
    linesLayout.lines = lines;
    CGRect boundingRect = (CGRect){textLeftTop, size};
    // 光标不参与排版，boundingRect 中不包含光标的占位
    // 应视觉要求，让光标也展示出来
    CGPoint caretCenter = CGPointMake(CGRectGetMidX(caretRect),
                                      CGRectGetMidY(caretRect));
    // 只在没有达到最大行数的时候计算才有意义
    BOOL caretOverText = lines.count < (textView.textContainer.maximumNumberOfLines == 0 ? NSUIntegerMax : textView.textContainer.maximumNumberOfLines) && caretCenter.y > CGRectGetMaxY(boundingRect);
    BOOL lineEmpty = lines.count == 0;
    if (caretOverText || lineEmpty) {
        linesLayout.lineCount = lines.count + 1;
        [lines addObject:({
            CGRect lastRect = lines.lastObject.usedRect;
            CGPoint fakeOrigin = CGPointMake(CGRectGetMinX(lastRect), CGRectGetMaxY(lastRect));
            JFTTextFragment *line = [JFTTextFragment new];
            line.usedRect = (CGRect){fakeOrigin, defaultStringSize};
            line.characterRange = NSMakeRange(0, 0);
            line;
        })];
        boundingRect = CGRectMake(boundingRect.origin.x,
                                  boundingRect.origin.y,
                                  boundingRect.size.width,
                                  CGRectGetMaxY(lines.lastObject.usedRect) - CGRectGetMinY(boundingRect));
    }
    linesLayout.boundingRect = boundingRect;
    return linesLayout;
}

@end

static void *kdisableAppendBoundingSizeWithCaretRect = &kdisableAppendBoundingSizeWithCaretRect;

@implementation UITextView (BoundingRect)

- (CGRect)jft_boundingRect {
    return [self jft_boundingRect:nil];
}

- (CGRect)jft_boundingRect:(UIFont *)font {
    return [self jft_boundingRect:font lineCount:nil];
}

- (BOOL)ks_disableAppendBoundingSizeWithCaretRect {
    return [objc_getAssociatedObject(self, kdisableAppendBoundingSizeWithCaretRect) boolValue];
}

- (void)setKs_disableAppendBoundingSizeWithCaretRect:(BOOL)ks_disableAppendBoundingSizeWithCaretRect {
    objc_setAssociatedObject(self, kdisableAppendBoundingSizeWithCaretRect, @(ks_disableAppendBoundingSizeWithCaretRect), OBJC_ASSOCIATION_RETAIN);
}

- (CGRect)jft_boundingRect:(UIFont *)font lineCount:(NSUInteger *)lineCount {
    JFTTextViewLinesLayout *layout = [JFTTextViewLinesLayout makeLyaoutLinesWithTextView:self font:font];
    if (lineCount) {
        *lineCount = layout.lineCount;
    }
    return layout.boundingRect;
}

@end
