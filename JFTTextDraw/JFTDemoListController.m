//
//  JFTDemoListController.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/27.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTDemoListController.h"
#import "JFTTextViewRender.h"
#import "JFTTextRenderViewController.h"

@interface JFTDemoListCell : UITableViewCell
@end

@implementation JFTDemoListCell
@end

@interface JFTDemoListController ()
@property (nonatomic, copy) NSAttributedString *text;
@end

@implementation JFTDemoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:JFTDemoListCell.class forCellReuseIdentifier:@"cell"];
    self.text = [self createAttributedString];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFTDemoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"UITextView";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JFTTextContainerView *view = nil;
    if (indexPath.row == 0) {
        view = [[JFTTextViewRender alloc] initWithText:self.text];
    }
    if (view) {
        [self pushToVC:view];
    }
}

- (NSAttributedString *)createAttributedString {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"威廉·莎士比亚（英语：William Shakespeare，1564年4月23日—1616年4月23日），华人社会常尊称为莎翁，是英国文学史上最杰出的戏剧家，也是欧洲文艺复兴时期最重要、最伟大的作家，当时人文主义文学的集大成者，以及全世界最卓越的文学家。\n莎士比亚在埃文河畔斯特拉特福（Stratford）出生长大，18岁时与安妮·海瑟薇结婚，两人共生育了三个孩子：苏珊娜、双胞胎哈姆尼特和朱迪思。16世纪末到17世纪初的20多年期间莎士比亚在伦敦开始了成功的职业生涯，他不仅是演员、剧作家，还是宫内大臣剧团的合伙人之一，后来改名为国王剧团。1613年左右，莎士比亚退休回到埃文河畔斯特拉特福，3年后逝世。\n1590年到1600年是莎士比亚的创作的黄金时代。他的早期剧本主要是喜剧和历史剧，在16世纪末期达到了深度和艺术性的高峰。接下来1601到1608年他主要创作悲剧，莎士比亚崇尚高尚情操，常常描写牺牲与复仇，包括《奥赛罗》、《哈姆雷特》、《李尔王》和《麦克白》，被认为属于英语最佳范例。在他人生最后阶段，他开始创作悲喜剧，又称为传奇剧。\n莎士比亚流传下来的作品包括37部戏剧、154首十四行诗、两首长叙事诗。他的戏剧有各种主要语言的译本，且表演次数远远超过其他所有戏剧家的作品。"];
    
    return text;
}

- (void)pushToVC:(JFTTextContainerView *)view {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    
    JFTTextRenderViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"display"];
    vc.textContainerView = view;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
