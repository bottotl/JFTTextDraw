//
//  JFTTextModel.h
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JFTItemState;

@protocol JFTTextModel<NSObject>
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong, null_resettable) JFTItemState *state;
@property (nonatomic, copy, nullable) NSString *identifier;
@property (nonatomic, copy, nullable) NSDictionary *attributes;
@end

@interface JFTTextModel : NSObject <JFTTextModel>
@end

NS_ASSUME_NONNULL_END
