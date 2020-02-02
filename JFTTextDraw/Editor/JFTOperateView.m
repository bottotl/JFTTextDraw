//
//  JFTOperateView.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTOperateView.h"
#import "JFTItemState.h"
#import "JFTTextStickerLayer.h"

@interface JFTOperateView () <UITextViewDelegate>
@property (nonatomic) JFTProject *project;
@property (nonatomic) UITextView *textView;
@property (nonatomic) JFTTextStickerLayer *testLayer;
@property (nonatomic) UIView *debugCenterView;
@end

@implementation JFTOperateView

- (instancetype)initWithProject:(JFTProject *)project {
    if (self = [super initWithFrame:CGRectZero]) {
        _textView = [UITextView new];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.scrollEnabled = NO;
        _textView.delegate = self;
        [self addSubview:_textView];
        
        _debugCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _debugCenterView.backgroundColor = [UIColor blackColor];
//        [self addSubview:_debugCenterView];
        _project = project;
    }
    return self;
}

- (void)addText {
    if (self.testLayer) {
        [self.testLayer removeFromSuperlayer];
        self.testLayer = nil;
    }
    
    JFTTextModel *model = [JFTTextModel new];
    model.text = @"测试文字贴纸绘制逻辑";
    model.attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:36.0]};
    self.textView.attributedText
    = [[NSAttributedString alloc] initWithString:model.text
                                      attributes:model.attributes];
    
    self.testLayer = [[JFTTextStickerLayer alloc] initWithProject:self.project];
    self.testLayer.model = model;
    [self.layer addSublayer:self.testLayer];
    [self updateTextView];
}

- (void)updateTextView {
    JFTTextModel *model = self.testLayer.model;
    CGFloat maxWidth = 280.0;// 36 号的7个中文字大致这么宽
    self.textView.typingAttributes = model.attributes;
    self.textView.bounds = (CGRect){CGPointZero, CGSizeMake(maxWidth, 0)};
    [self.textView sizeToFit];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    CGSize previewSize = layer.bounds.size;
    self.project.previewSize = previewSize;
    
    CGFloat xScale = projectXScale(self.project);
    CGFloat yScale = projectYScale(self.project);
    CGFloat scale = MIN(xScale, yScale);
    
    self.testLayer.project = self.project;
    self.testLayer.defaultScale = 1 / scale;
    
    self.testLayer.bounds = (CGRect){CGPointZero, self.project.exportSize};
    self.testLayer.position = CGPointMake(CGRectGetWidth(layer.bounds) / 2.0,
                                          CGRectGetHeight(layer.bounds) / 2.0);
    self.testLayer.transform = CATransform3DMakeScale(scale, scale, 1);
    
    [self updateTextView];
}

/// 视频画面在 view 中的 frame
- (CGRect)videoFrame {
    return self.testLayer.frame;
}

- (void)applyOperate:(JFTOperateViewTextViewOperate *)operate {
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformIdentity, operate.rotate), operate.scale, operate.scale);
    self.textView.transform = transform;
    self.debugCenterView.transform = transform;
    
    self.textView.center = operate.center;
    self.debugCenterView.transform = self.textView.transform;
    self.debugCenterView.center = self.textView.center;
    [self.testLayer applyState:({
        JFTItemState *state = [JFTItemState new];
        state.position = ({
            CGRect rect = [self videoFrame];
            CGFloat x = (operate.center.x - CGRectGetMinX(rect)) / (CGRectGetMaxX(rect) - CGRectGetMinX(rect));
            CGFloat y = (operate.center.y - CGRectGetMinY(rect)) / (CGRectGetMaxY(rect) - CGRectGetMinY(rect));
            CGPointMake(x, y);
        });
        state.rotate = operate.rotate;
        state.scale = operate.scale;
        state;
    })];
}

- (void)renderToImage:(UIImage *)image {
    
}

#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.testLayer.model.text = textView.text;
    [self updateTextView];
    [self.testLayer syncTextView:textView];
    
}

@end

@implementation JFTOperateViewTextViewOperate
@end
