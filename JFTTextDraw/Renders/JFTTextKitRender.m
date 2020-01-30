//
//  JFTTextKitRender.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/29.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTTextKitRender.h"

@interface JFTTextKitRender ()
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic) UITextView *textView;

@property (nonatomic) NSTextStorage *textStorage;

@property (nonatomic) NSTextContainer *textContainer;

@property (nonatomic) NSLayoutManager *layoutManager;

@end

@implementation JFTTextKitRender

- (instancetype)initWithText:(NSAttributedString *)text {
    if (self = [super initWithText:text]) {
        _textView = [UITextView new];
        _textView.attributedText = text;
        _lock = [NSLock new];
        [self addSubview:_textView];
        _textView.scrollEnabled = NO;
        
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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = self.bounds;
    [self updateRenderWithTextView:self.textView];
}

- (void)updateRenderWithTextView:(UITextView *)textView {
    [self.lock lock];
    NSTextContainer *textContainer = textView.textContainer;
    NSTextContainer *innerTextContainer = self.textContainer;
    innerTextContainer.size = textContainer.size;
    innerTextContainer.maximumNumberOfLines = textContainer.maximumNumberOfLines;
    innerTextContainer.lineBreakMode = textContainer.lineBreakMode;
    innerTextContainer.lineFragmentPadding = textContainer.lineFragmentPadding;
    innerTextContainer.exclusionPaths = textContainer.exclusionPaths;
    
    // copy textView attr to storage
    NSTextStorage *storage = self.textStorage;
    NSAttributedString *attributedText = textView.attributedText;
    [storage replaceCharactersInRange:NSMakeRange(0, storage.length)
                 withAttributedString:attributedText];
    
    [self.lock unlock];
}

- (CGSize)preferredSize {
    NSRange range = [self glyphRange];
    CGRect rect = [self.layoutManager boundingRectForGlyphRange:range
                                                inTextContainer:self.textContainer];
    return rect.size;
}

- (NSRange)glyphRange {
    return NSMakeRange(0, self.layoutManager.numberOfGlyphs);
}

- (UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(self.textView.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layoutManager drawGlyphsForGlyphRange:[self glyphRange] atPoint:CGPointZero];
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
