//
//  JFTTextModel.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTTextModel.h"
#import "JFTItemState.h"

@implementation JFTTextModel
@synthesize text = _text;
@synthesize state = _state;
@synthesize identifier = _identifier;
@synthesize attributes = _attributes;

- (instancetype)init {
    if (self = [super init]) {
        _text = @"";
    }
    return self;
}

- (JFTItemState *)state {
    if (!_state) {
        _state = [JFTItemState new];
    }
    return _state;
}

@end
