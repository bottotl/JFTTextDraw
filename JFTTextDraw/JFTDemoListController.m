//
//  JFTDemoListController.m
//  JFTTextDraw
//
//  Created by 於林涛 on 2020/1/27.
//  Copyright © 2020 於林涛. All rights reserved.
//

#import "JFTDemoListController.h"
#import "JFTTextViewRender.h"
#import "JFTLabelRender.h"
#import "JFTTextLayerRender.h"
#import "JFTTextKitRender.h"
#import "JFTCoreTextRender.h"
#import "JFTTextRenderViewController.h"

@interface JFTDemoListCell : UITableViewCell
@end

@implementation JFTDemoListCell
@end
@interface JFTCellModel : NSObject
@property (nonatomic) Class cls;
@property (nonatomic, copy) NSString *name;
@end

@implementation JFTCellModel
@end

@interface JFTDemoListController ()
@property (nonatomic, copy) NSAttributedString *text;
@property (nonatomic, copy) NSArray<JFTCellModel *> *models;
@end

@implementation JFTDemoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:JFTDemoListCell.class forCellReuseIdentifier:@"cell"];
    self.text = [self createAttributedString];
}

- (NSArray<JFTCellModel *> *)models {
    if (!_models) {
        NSMutableArray *models = [[NSMutableArray alloc] init];
        [models addObject:({
            JFTCellModel *model = [JFTCellModel new];
            model.name = @"textView";
            model.cls = JFTTextViewRender.class;
            model;
        })];
        [models addObject:({
            JFTCellModel *model = [JFTCellModel new];
            model.name = @"label";
            model.cls = JFTLabelRender.class;
            model;
        })];
        [models addObject:({
            JFTCellModel *model = [JFTCellModel new];
            model.name = @"textLayer";
            model.cls = JFTTextLayerRender.class;
            model;
        })];
        [models addObject:({
            JFTCellModel *model = [JFTCellModel new];
            model.name = @"textKit";
            model.cls = JFTTextKitRender.class;
            model;
        })];
        [models addObject:({
            JFTCellModel *model = [JFTCellModel new];
            model.name = @"coreText";
            model.cls = JFTCoreTextRender.class;
            model;
        })];
        
        _models = models;
    }
    return _models;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFTDemoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    JFTCellModel *model = self.models[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JFTCellModel *model = self.models[indexPath.row];
    JFTTextContainerView *view = [[model.cls alloc] initWithText:self.text];
    if (view) {
        [self pushToVC:view];
    }
}

- (NSAttributedString *)createAttributedString {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"威廉·莎士比亚（英语：William Shakespeare，1564年4月23日—1616年4月23日），华人社会常尊称为莎翁，是英国文学史上最杰出的戏剧家，也是欧洲文艺复兴时期最重要、最伟大的作家，当时人文主义文学的集大成者，以及全世界最卓越的文学家。\n莎士比亚在埃文河畔斯特拉特福（Stratford）出生长大，18岁时与安妮·海瑟薇结婚，两人共生育了三个孩子：苏珊娜、双胞胎哈姆尼特和朱迪思。16世纪末到17世纪初的20多年期间莎士比亚在伦敦开始了成功的职业生涯，他不仅是演员、剧作家，还是宫内大臣剧团的合伙人之一，后来改名为国王剧团。1613年左右，莎士比亚退休回到埃文河畔斯特拉特福，3年后逝世。\n1590年到1600年是莎士比亚的创作的黄金时代。"];
    [text addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} range:NSMakeRange(0, text.length)];
    return text;
}

- (void)pushToVC:(JFTTextContainerView *)view {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    
    JFTTextRenderViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"display"];
    vc.textContainerView = view;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
