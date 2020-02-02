//
//  JFTTextLayout.h
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFTTextLayout : NSObject

@property (nonatomic) NSTextStorage *textStorage;

@property (nonatomic) NSTextContainer *textContainer;

@property (nonatomic) NSLayoutManager *layoutManager;

@property (nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *typingAttributes;

- (CGSize)currentSize;

@end

@interface JFTTextViewContentUtil : NSObject
// 解决行间距导致的文字边缘计算问题
+ (CGRect)innerLineFragmentRectWithLayoutManager:(NSLayoutManager *)layoutManager
                                     textStorage:(NSTextStorage *)textStorage
                                  lineGlyphRange:(NSRange)glyphRange
                                        usedRect:(CGRect)usedRect;

+ (CGRect)innerLineFragmentRectWithLayoutManager:(NSLayoutManager *)layoutManager
                                     textStorage:(NSTextStorage *)textStorage
                                  lineGlyphRange:(NSRange)glyphRange
                                        usedRect:(CGRect)usedRect
                                            font:(nullable UIFont *)font;
@end

NS_ASSUME_NONNULL_END
