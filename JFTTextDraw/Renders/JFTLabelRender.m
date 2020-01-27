//
//  JFTLabelRender.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/27.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTLabelRender.h"

@interface JFTLabelRender ()
@property (nonatomic) UILabel *label;
@end

@implementation JFTLabelRender

- (instancetype)initWithText:(NSAttributedString *)text {
    if (self = [super initWithText:text]) {
        _label = [UILabel new];
        _label.attributedText = text;
        _label.numberOfLines = 0;
        [self addSubview:_label];
    }
    return self;
}

- (CGSize)preferredSize {
    self.label.frame = self.bounds;
    [self.label sizeToFit];
    return self.label.bounds.size;
}

- (UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(self.label.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.label drawViewHierarchyInRect:self.label.bounds afterScreenUpdates:NO];
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
