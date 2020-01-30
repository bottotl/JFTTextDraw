//
//  JFTCoreTextRender.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTCoreTextRender.h"
#import <CoreText/CoreText.h>

@interface JFTCoreTextRender ()
@property (nonatomic) CTFrameRef frameRef;
@end

@implementation JFTCoreTextRender
- (instancetype)initWithText:(NSAttributedString *)text {
    if (self = [super initWithText:text]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CTFrameDraw(self.frameRef, ctx);
}

- (CGSize)preferredSize {
    CGFloat width = CGRectGetWidth(self.bounds);
    CGRect rect = CGRectMake(0, 0, width, CGFLOAT_MAX);
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.text);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, self.text.length), nil, rect.size, nil);
    CGPathRef framePath = [UIBezierPath bezierPathWithRect:(CGRect){CGPointZero, size}].CGPath;
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, self.text.length), framePath, NULL);
    self.frameRef = frameRef;
    CFRelease(framesetterRef);
    return size;
}

- (UIImage *)image {
    CGRect rect = self.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CTFrameDraw(self.frameRef, ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

- (void)dealloc {
    if (self.frameRef) {
        CFRelease(self.frameRef);
    }
}

@end
