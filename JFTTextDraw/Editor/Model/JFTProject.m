//
//  JFTProject.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTProject.h"
#import <MJExtension/MJExtension.h>

inline CGFloat projectXScale(JFTProject *project) {
    CGSize previewSize = project.previewSize;
    CGSize exportSize = project.exportSize;
    if (previewSize.height < 1 || previewSize.width < 1) {
        previewSize = CGSizeMake(720, 1280);
    }
    if (exportSize.height < 1 || exportSize.width < 1) {
        exportSize = previewSize;
    }
    return previewSize.width / exportSize.width;
}

inline CGFloat projectYScale(JFTProject *project) {
    CGSize previewSize = project.previewSize;
    CGSize exportSize = project.exportSize;
    if (previewSize.height < 1 || previewSize.width < 1) {
        previewSize = CGSizeMake(720, 1280);
    }
    if (exportSize.height < 1 || exportSize.width < 1) {
        exportSize = previewSize;
    }
    return previewSize.height / exportSize.height;
}

@implementation JFTProject

- (id)copyWithZone:(NSZone *)zone {
    return [[self.class alloc] mj_setKeyValues:self.mj_keyValues];
}

@end
