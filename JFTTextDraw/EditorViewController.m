//
//  EditorViewController.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/30.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "EditorViewController.h"
#import "JFTOperateView.h"
#import "JFTProject.h"

@interface EditorViewController ()
@property (nonatomic) UIImageView *playerView;
@property (nonatomic) JFTOperateView *operateView;
@property (nonatomic) CADisplayLink *displayLink;
@end

@implementation EditorViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playerView = [UIImageView new];
    _playerView.userInteractionEnabled = YES;
    _playerView.contentMode = UIViewContentModeScaleAspectFit;
    _playerView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:_playerView];
    
    _operateView = [[JFTOperateView alloc] initWithProject:({
        JFTProject *project = [JFTProject new];
        project.exportSize = CGSizeMake(1080, 1920);
        project.previewSize = CGSizeMake(720, 1280);
        project;
    })];
    
    [self.playerView addSubview:_operateView];
    [self.operateView addText];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self testApplyState];
    });
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
    _displayLink.preferredFramesPerSecond = 30;
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                       forMode:NSRunLoopCommonModes];
}

- (void)tick {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1080, 1920), NO, 1);
    [self.operateView renderToContext:UIGraphicsGetCurrentContext()];
    self.playerView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.playerView.frame = self.view.bounds;
    self.operateView.frame = self.playerView.bounds;
}

- (void)testApplyState {
    // 输入框缩放2倍，旋转45，平移个 20 point, 40 point
    [self.operateView applyOperate:({
        JFTOperateViewTextViewOperate *op = [JFTOperateViewTextViewOperate new];
        op.center = ({
            CGRect rect = self.operateView.bounds;
            CGPoint center = CGPointMake(CGRectGetMidX(rect),
                                         CGRectGetMidY(rect));
            CGFloat x = center.x + 20;
            CGFloat y = center.y + 40;
            CGPointMake(x, y);
        });
        op.scale = 6;
        op.rotate = M_PI_4;
        op;
    })];
}

@end
