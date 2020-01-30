//
//  JFTTextLayerRender.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/28.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTTextLayerRender.h"

@interface JFTTextLayerRender ()

@property (nonatomic) CATextLayer *textLayer;
@end

@implementation JFTTextLayerRender
- (instancetype)initWithText:(NSAttributedString *)text {
    if (self = [super initWithText:text]) {
        _textLayer = [CATextLayer new];
        _textLayer.string = text;
        _textLayer.wrapped = YES;
        _textLayer.truncationMode = kCATruncationEnd;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:_textLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLayer.frame = self.bounds;
}

- (CGSize)preferredSize {
    CGFloat width = CGRectGetWidth(self.bounds);
    CGRect boundingRect = [self.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil];
    CGSize size = CGSizeMake(ceil(width), ceil(CGRectGetHeight(boundingRect)));
    return size;
}

- (UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.textLayer renderInContext:UIGraphicsGetCurrentContext()];
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
