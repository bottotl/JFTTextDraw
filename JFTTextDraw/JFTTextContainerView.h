//
//  JFTTextContainerView.h
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/27.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JFTTextContainerView <NSObject>

@property (nonatomic, copy) NSAttributedString *text;

- (CGSize)preferredSize;
- (UIImage * _Nullable )image;

@end

@interface JFTTextContainerView : UIView <JFTTextContainerView>
@property (nonatomic, copy) NSAttributedString *text;
- (instancetype)initWithText:(NSAttributedString *)text;
@end

NS_ASSUME_NONNULL_END
