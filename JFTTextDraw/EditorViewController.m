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

static CGSize exportSize;

@interface EditorViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic) UIImageView *playerView;
@property (nonatomic) JFTOperateView *operateView;
@property (nonatomic) CADisplayLink *displayLink;

@property (nonatomic, assign) CGPoint centerBeforeDragStart;

@property (nonatomic, assign) CGFloat scaleBefore;
@property (nonatomic, assign) CGFloat rotationBefore;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;

@end

@implementation EditorViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playerView = [UIImageView new];
    _playerView.userInteractionEnabled = YES;
    _playerView.contentMode = UIViewContentModeScaleAspectFit;
    _playerView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:_playerView];
    exportSize = CGSizeMake(1080, 1920);
    _operateView = [[JFTOperateView alloc] initWithProject:({
        JFTProject *project = [JFTProject new];
        project.exportSize = exportSize;
        project.previewSize = CGSizeMake(720, 1280);
        project;
    })];
    
    [self.playerView addSubview:_operateView];
    [self.operateView addText];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self testApplyState];
        [self tick];
    });
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
    _displayLink.preferredFramesPerSecond = 60;
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                       forMode:NSRunLoopCommonModes];
    [_displayLink setPaused:YES];
    [self addGesture];
}

- (void)tick {
    UIGraphicsBeginImageContextWithOptions(exportSize, NO, 1);
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
    [self.operateView applyOperate:({
        JFTOperateViewTextViewOperate *op = [JFTOperateViewTextViewOperate new];
        op.center = ({
            CGRect rect = self.operateView.bounds;
            CGPoint center = CGPointMake(CGRectGetMidX(rect),
                                         CGRectGetMidY(rect));
            CGFloat x = center.x;
            CGFloat y = center.y;
            CGPointMake(x, y);
        });
        op.scale = 1;
        op.rotate = 0;
        op;
    })];
}

#pragma mark -

- (void)addGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_didDragBanner:)];
    pan.delegate = self;
    _panGestureRecognizer = pan;
    [self.playerView addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(p_didPinchBubbleView:)];
    pinch.delegate = self;
    _pinchGestureRecognizer = pinch;
    [self.playerView addGestureRecognizer:pinch];
}

- (CGFloat)shapeRotate {
    return self.operateView.currentState.rotate;
}

- (CGFloat)shapeScale {
    return self.operateView.currentState.scale;
}

- (void)p_didDragBanner:(UIPanGestureRecognizer *)sender {
    if (UIGestureRecognizerStateBegan == sender.state) {
        self.centerBeforeDragStart = self.operateView.currentState.center;
        [self.displayLink setPaused:NO];
    } else if (UIGestureRecognizerStateChanged == sender.state || UIGestureRecognizerStateEnded == sender.state) {
        CGPoint t = [sender translationInView:self.playerView];
        CGPoint center = self.centerBeforeDragStart;
        center.y += t.y;
        center.x += t.x;
        
        JFTOperateViewTextViewOperate *op = self.operateView.currentState;
        op.center = center;
        [self.operateView applyOperate:op];
        if (sender.state == UIGestureRecognizerStateEnded) {
            [self.displayLink setPaused:YES];
        }
    }
}

- (void)p_didPinchBubbleView:(UIPinchGestureRecognizer *)recognizer {
    JFTOperateViewTextViewOperate *op = self.operateView.currentState;
    if (UIGestureRecognizerStateBegan == recognizer.state) {
        self.scaleBefore = self.shapeScale;
        [self.displayLink setPaused:NO];
    } else if (UIGestureRecognizerStateChanged == recognizer.state || UIGestureRecognizerStateEnded == recognizer.state) {
        op.scale = recognizer.scale * self.scaleBefore;
        [self.operateView applyOperate:op];
        
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            [self.displayLink setPaused:YES];
        }
    }
}

@end
