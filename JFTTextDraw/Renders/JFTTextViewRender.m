//
//  JFTTextViewRender.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/27.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTTextViewRender.h"

@interface JFTTextViewRender ()
@property (nonatomic) UITextView *textView;
@end

@implementation JFTTextViewRender

- (instancetype)initWithText:(NSAttributedString *)text {
    if (self = [super initWithText:text]) {
        _textView = [UITextView new];
        _textView.attributedText = text;
        [self addSubview:_textView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (CGSize)preferredSize {
    self.textView.frame = self.bounds;
    [self.textView sizeToFit];
    return self.textView.bounds.size;
}

- (UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(self.textView.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.textView drawViewHierarchyInRect:self.textView.bounds afterScreenUpdates:NO];
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
