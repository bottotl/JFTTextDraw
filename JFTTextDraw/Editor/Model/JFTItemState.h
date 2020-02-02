//
//  JFTItemState.h
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFTItemState : NSObject<NSCopying>
/// 0<x<1, 0<y<1 中心
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat rotate;
@end

NS_ASSUME_NONNULL_END
