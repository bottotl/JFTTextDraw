//
//  JFTItemState.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTItemState.h"
#import <MJExtension/MJExtension.h>

@implementation JFTItemState

- (instancetype)init {
    if (self = [super init]) {
        _scale = 1;
        _rotate = 0;
        _position = CGPointMake(0.5, 0.5);
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self.class alloc] mj_setKeyValues:self.mj_keyValues];
}

@end
