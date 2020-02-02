//
//  JFTTextRenderLayer.h
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JFTTextModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JFTProject;
/// 大小和视频导出尺寸大小一致，使用的时候需要加缩放
@interface JFTTextStickerLayer : CALayer
- (instancetype)initWithProject:(JFTProject *)project;
@property (nonatomic, copy) JFTProject *project;
@property (nonatomic) JFTTextModel *model;

- (void)applyState:(JFTItemState *)state;
- (void)syncTextView:(UITextView *)textView;

@property (nonatomic) CGFloat defaultScale;

@end

NS_ASSUME_NONNULL_END
