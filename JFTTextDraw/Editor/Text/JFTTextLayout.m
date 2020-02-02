//
//  JFTTextLayout.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTTextLayout.h"
#import "JFTTextFragment.h"
#import <CoreText/CoreText.h>

@implementation JFTTextViewContentUtil

+ (CGRect)innerLineFragmentRectWithLayoutManager:(NSLayoutManager *)layoutManager
                                     textStorage:(NSTextStorage *)textStorage
                                  lineGlyphRange:(NSRange)glyphRange
                                        usedRect:(CGRect)usedRect {
    return [self innerLineFragmentRectWithLayoutManager:layoutManager
                                            textStorage:textStorage
                                         lineGlyphRange:glyphRange
                                               usedRect:usedRect
                                                   font:nil];
}

+ (CGRect)innerLineFragmentRectWithLayoutManager:(NSLayoutManager *)layoutManager
                                     textStorage:(NSTextStorage *)textStorage
                                  lineGlyphRange:(NSRange)glyphRange
                                        usedRect:(CGRect)usedRect
                                            font:(UIFont *)defaultFont {
    NSUInteger glyphIndex = glyphRange.location;
    NSUInteger charIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
    CTFontRef font = nil;
    if (defaultFont) {// 尝试绕过 emoji 高度比较高的问题
        // 使用 NSLayoutManagerDelegate 能实现控制行高的问题（但是我不会调行间距），暂时用这种方案解决了
        font = (__bridge_retained CTFontRef)defaultFont;
    } else {
        if (charIndex < textStorage.length) {
            font = (__bridge_retained CTFontRef)[textStorage attribute:NSFontAttributeName
                                                               atIndex:charIndex
                                                        effectiveRange:NULL];
        }
        if (font == nil) {
            return CGRectZero;
        }
    }
    
    CGPoint location = [layoutManager locationForGlyphAtIndex:glyphIndex];
    location = CGPointMake(location.x,
                           location.y + CGRectGetMinY(usedRect));
    CGFloat ascent = CTFontGetAscent(font);
    CGFloat descent = CTFontGetDescent(font);
    CFRelease(font);
    
    //                                    Glyph Advance
    //                             +-------------------------+
    //                             |                         |
    //                             |                         |
    // +------------------------+--|-------------------------|--+-----------+-----+ What TextKit returns sometimes
    // |                        |  |             XXXXXXXXXXX +  |           |     | (approx. correct height, but
    // |               ---------|--+---------+  XXX       XXXX +|-----------|-----|  sometimes inaccurate bounding
    // |               |        |             XXX          XXXXX|           |     |  widths)
    // |               |        |             XX             XX |           |     |
    // |               |        |            XX                 |           |     |
    // |               |        |           XXX                 |           |     |
    // |               |        |           XX                  |           |     |
    // |               |        |      XXXXXXXXXXX              |           |     |
    // |   Cap Height->|        |          XX                   |           |     |
    // |               |        |          XX                   |  Ascent-->|     |
    // |               |        |          XX                   |           |     |
    // |               |        |          XX                   |           |     |
    // |               |        |          X                    |           |     |
    // |               |        |          X                    |           |     |
    // |               |        |          X                    |           |     |
    // |               |        |         XX                    |           |     |
    // |               |        |         X                     |           |     |
    // |               ---------|-------+ X +-------------------------------------|
    // |                        |        XX                     |                 |
    // |                        |        X                      |                 |
    // |                        |      XX         Descent------>|                 |
    // |                        | XXXXXX                        |                 |
    // |                        |  XXX                          |                 |
    // +------------------------+-------------------------------------------------+
    //                                                          |
    //                                                          +--+Actual bounding box
    
    // 我们只要
    // +------------------------+--|-------------------------|--+-----------+-----+ What TextKit returns sometimes
    // |                        |  |             XXXXXXXXXXX +  |           |     | (approx. correct height, but
    // |               ---------|--+---------+  XXX       XXXX +|-----------|-----|  sometimes inaccurate bounding
    // |               |        |             XXX          XXXXX|           |     |  widths)
    // |               |        |             XX             XX |           |     |
    // |               |        |            XX                 |           |     |
    // |               |        |           XXX                 |           |     |
    // |               |        |           XX                  |           |     |
    // |               |        |      XXXXXXXXXXX              |           |     |
    // |   Cap Height->|        |          XX                   |           |     |
    // |               |        |          XX                   |  Ascent-->|     |
    // |               |        |          XX                   |           |     |
    // |               |        |          XX                   |           |     |
    // |               |        |          X                    |           |     |
    // |               |        |          X                    |           |     |
    // |               |        |          X                    |           |     |
    // |               |        |         XX                    |           |     |
    // |               |        |         X                     |           |     |
    // |               ---------|-------+ X +-------------------------------------|
    
    
    return CGRectMake(usedRect.origin.x,
                      usedRect.origin.y,
                      usedRect.size.width,
                      ascent + descent);
}

@end

@implementation JFTTextLayout

- (instancetype)init {
    if (self = [super init]) {
        
        _textStorage = [NSTextStorage new];
        
        _layoutManager = ({
            NSLayoutManager *layoutManager = [NSLayoutManager new];
            [_textStorage addLayoutManager:layoutManager];
            layoutManager;
        });
        
        _textContainer = ({
            NSTextContainer *container = [NSTextContainer new];
            container.lineFragmentPadding = 0;
            [_layoutManager addTextContainer:container];
            container;
        });
    }
    
    return self;
}

- (CGSize)currentSize {
    UIFont *font = self.typingAttributes[NSFontAttributeName];
    if (self.textStorage.length) {
        font = [self.textStorage attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
    }
    CGRect rect = [self boundingRect:font lineCount:nil];
    return rect.size;
}

- (CGRect)boundingRect:(UIFont *)font lineCount:(NSUInteger *)lineCount {
    NSLayoutManager *layoutManager = self.layoutManager;
    
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
        = [JFTTextViewContentUtil innerLineFragmentRectWithLayoutManager:self.layoutManager
                                                              textStorage:self.textStorage
                                                           lineGlyphRange:glyphRange
                                                                 usedRect:usedRect
                                                                     font:font];
        line.characterRange = characterRange;
        [lines addObject:line];
        
        maxLineWidth = MAX(ceil(CGRectGetWidth(usedRect)), maxLineWidth);
     }];
    
    CGSize size = CGSizeZero;
    {
        if (lines.count) {
            // 设置了 minimumLineHeight 和 maximumLineHeight boundingRectForGlyphRange 的值会非常诡异，只在适当必须的时候去读这个值
            CGRect rect = [layoutManager boundingRectForGlyphRange:NSMakeRange(0, layoutManager.numberOfGlyphs)
                                                   inTextContainer:self.textContainer];
            // 遇到换行的情况，宽度不太符合预期，这里只使用 boundingRectForGlyphRange 的高度
            {// 当文字为一大串空格的时候，系统忽然告知字形所占用矩形宽度不到 0.1。尝试绕过系统 bug
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
            if (self.textContainer.maximumNumberOfLines == 0) {
                lastLine = lines.lastObject;
            } else {
                lastLine = lines[MIN(self.textContainer.maximumNumberOfLines, lines.count) - 1];
            }
            
            CGFloat height = CGRectGetMaxY(lastLine.usedRect);
            
            size = CGSizeMake(ceil(maxLineWidth), ceil(height));
        } else {
            NSAttributedString *attributedString
            = [[NSAttributedString alloc] initWithString:@"A"
                                              attributes:self.typingAttributes];
            size = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil].size;
            size.height = ceil(size.height);
            size.height = ceil(size.height);
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
    
    if (lineCount) {
        *lineCount = lines.count;
    }
    CGRect boundingRect = (CGRect){textLeftTop, size};
    return boundingRect;
}

- (void)setTypingAttributes:(NSDictionary<NSAttributedStringKey,id> *)typingAttributes {
    _typingAttributes = typingAttributes.copy;
    [self.textStorage setAttributes:typingAttributes range:NSMakeRange(0, self.textStorage.length)];
}

@end
