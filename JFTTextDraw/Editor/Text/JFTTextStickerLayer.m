//
//  JFTTextRenderLayer.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTTextStickerLayer.h"
#import "JFTLayoutManagerRender.h"
#import "JFTProject.h"
#import "JFTItemState.h"
#import "JFTTextLayout.h"
#import "UITextView+BoundingRect.h"

@interface JFTTextStickerLayer () <CALayerDelegate>
@property (nonatomic, strong) JFTLayoutManagerRender *render;
@property (nonatomic) CGSize textViewSize;
@end

@implementation JFTTextStickerLayer

- (instancetype)initWithProject:(JFTProject *)project {
    if (self = [super init]) {
        self.frame = (CGRect){CGPointZero, project.previewSize};
        _render = [JFTLayoutManagerRender new];
        self.needsDisplayOnBoundsChange = YES;
        self.delegate = self;
    }
    return self;
}

- (void)syncTextView:(UITextView *)textView {
    [self.render updateRenderWithTextView:textView];
    self.textViewSize = [textView jft_boundingRect].size;
    [self setNeedsDisplay];
}

- (void)applyState:(JFTItemState *)state {
    self.model.state = [state copy];
    [self setNeedsDisplay];
}

#pragma mark - CALayerDelegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [CATransaction setDisableActions:YES];
//    CGContextSetFillColorWithColor(ctx, [UIColor.greenColor colorWithAlphaComponent:0.5].CGColor);
//    CGContextFillRect(ctx, layer.bounds);
    CGPoint textOrigin = [self textCenter];
    CGSize size = [self textViewSize];
    CGContextTranslateCTM(ctx, textOrigin.x, textOrigin.y);
    CGContextRotateCTM(ctx, self.model.state.rotate);
    CGFloat scale = self.defaultScale * self.model.state.scale;
//    {// debug
//        CGContextSaveGState(ctx);
//        CGContextScaleCTM(ctx, self.defaultScale, self.defaultScale);
//        CGRect originRect = CGRectMake(0, 0, 10 * self.model.state.scale, 10 * self.model.state.scale);
//        CGContextTranslateCTM(ctx,
//                              -CGRectGetWidth(originRect) / 2.0,
//                              -CGRectGetHeight(originRect) / 2.0);
//        CGContextSetFillColorWithColor(ctx, [UIColor.whiteColor colorWithAlphaComponent:0.5].CGColor);
//        CGContextFillRect(ctx, originRect);
//        CGContextRestoreGState(ctx);
//    }
    CGContextScaleCTM(ctx, scale, scale);
    CGContextTranslateCTM(ctx, -size.width / 2.0, -size.height/ 2.0);
    
    [self.render drawInContext:ctx];
}

- (CGPoint)textCenter {
    CGPoint pos = self.model.state.position;
    CGSize size = self.project.exportSize;
    return CGPointMake(size.width * pos.x,
                       size.height * pos.y);
}

- (CGSize)textViewSize {
    if (CGSizeEqualToSize(_textViewSize, CGSizeZero)) {
        return [self.render.layout currentSize];
    }
    return _textViewSize;
}

@end
