//
//  JFTProject.h
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JFTProject;
extern inline CGFloat projectXScale(JFTProject *project);
extern inline CGFloat projectYScale(JFTProject *project);

@class JFTTextModel;
@interface JFTProject : NSObject <NSCopying>

@property (nonatomic) CGSize previewSize;
@property (nonatomic) CGSize exportSize;
@property (nonatomic, copy) NSArray<JFTTextModel *> *texts;

@end

NS_ASSUME_NONNULL_END
