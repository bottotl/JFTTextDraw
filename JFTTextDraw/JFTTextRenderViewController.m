//
//  JFTTextRenderViewController.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/27.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTTextRenderViewController.h"
#import <Masonry/Masonry.h>
#import "JFTTextContainerView.h"

@interface JFTTextRenderViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *separateLineView;

@end

@implementation JFTTextRenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.textContainerView];
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 60;
    self.textContainerView.frame = CGRectMake(0, 0, width, 0);
    [self.textContainerView setNeedsLayout];
    [self.textContainerView layoutIfNeeded];
    CGSize size = [self.textContainerView preferredSize];
    [self.textContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(size));
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(30);
        make.top.equalTo(self.separateLineView.mas_bottom).offset(60);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(size));
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(30);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(60);
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 依赖 drawViewHierarchyInRect 的组件需要先在屏幕中渲染一次才能调用这个方法
        self.imageView.image = [self.textContainerView image];
    });
}

@end
