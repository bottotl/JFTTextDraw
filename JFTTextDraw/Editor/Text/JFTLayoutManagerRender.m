//
//  JFTLayoutManagerRender.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTLayoutManagerRender.h"
#import "JFTTextLayout.h"

@interface JFTLayoutManagerRender()

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) JFTTextLayout *layout;

@end

@implementation JFTLayoutManagerRender
- (instancetype)init {
    if (self = [super init]) {
        _layout = [JFTTextLayout new];
        _lock = [NSLock new];
    }
    return self;
}

- (void)setStrokeJoinRound:(BOOL)strokeJoinRound {
    _strokeJoinRound = strokeJoinRound;
}

- (NSTextContainer *)textContainer {
    return self.layout.textContainer;
}

- (NSTextStorage *)storage {
    return self.layout.textStorage;
}

- (NSLayoutManager *)layoutManager {
    return self.layout.layoutManager;
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
    NSTextStorage *storage = self.storage;
    NSAttributedString *attributedText = nil;
    if (self.textAttributes) {
        attributedText = [[NSAttributedString alloc] initWithString:textView.text
                                                         attributes:self.textAttributes];
    } else {
        attributedText = textView.attributedText;
    }
    [storage replaceCharactersInRange:NSMakeRange(0, storage.length)
                 withAttributedString:attributedText];
    
    [self.lock unlock];
}

- (void)drawInContext:(CGContextRef)ctx {
    [self.lock lock];
    UIGraphicsPushContext(ctx);
    CGContextSaveGState(ctx);
    if (self.strokeJoinRound) {
        CGContextSetTextDrawingMode(ctx, kCGTextStroke);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
    }
    if (!self.hidden) {
        [self.layoutManager drawGlyphsForGlyphRange:NSMakeRange(0, self.layoutManager.numberOfGlyphs)
                                            atPoint:self.textPoint];
    }
    CGContextRestoreGState(ctx);
    UIGraphicsPopContext();
    [self.lock unlock];
}

@end
