//
//  JFTTextContainerView.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/27.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTTextContainerView.h"

@implementation JFTTextContainerView

- (instancetype)initWithText:(NSAttributedString *)text {
    if (self = [super init]) {
        _text = text;
    }
    return self;
}

- (CGSize)preferredSize {
    NSAssert(NO, @"子类必须重写");
    return CGSizeZero;
}

- (UIImage *)image {
    NSAssert(NO, @"子类必须重写");
    return nil;
}

@end
