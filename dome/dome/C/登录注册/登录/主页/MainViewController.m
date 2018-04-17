//
//  MainViewController.m
//  微帮同赚
//
//  Created by 王俊杰 on 2018/4/14.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "MainViewController.h"
#import "LXScrollContentView.h"
#import "TableViewViewController.h"
#import "LXSegmentTitleView.h"
//#import "TableViewViewController.h"
@interface MainViewController ()<LXSegmentTitleViewDelegate,LXScrollContentViewDelegate>

@property (nonatomic, strong) LXSegmentTitleView *titleView;

@property (nonatomic, strong) LXScrollContentView *contentView;

@property (nonatomic) MBProgressHUD *hub;

@property (nonatomic) NSMutableArray *vcs;//分类的VC数组

@property (nonatomic) NSMutableArray *contMarr;//从服务器获取到小帮手数组

@property (nonatomic) NSMutableArray *car_infonameMarr;//分类信息标题数组

@property (nonatomic) NSMutableArray *carIdMarr;//分类信息的id

@end

@implementation MainViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;//从nav底部开始
    
    [self getHubUI];

    //创建一个并行队列
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getRequestData];
    });

    
}
- (void)viewDidLoad {


    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNVC];//设置导航栏
    
    [self creatTitleView];//分类栏
    
    [self creatTableViewControllers];//创建每个分类的TableViewController
    
}
-(void)setNVC{
    self.title = @"主页";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];//导航栏标题字体颜色
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    // 导航栏背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar_2"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];// 导航栏左右按钮字体颜色
}
-(void)creatTitleView{
    self.titleView = [[LXSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    //    self.titleView.backgroundColor = [UIColor redColor];
    self.titleView.itemMinMargin = 10.f;
    self.titleView.titleNormalColor = [UIColor colorWithRed:78/255.f green:75/255.f blue:74/255.f alpha:1.0f];
    self.titleView.delegate = self;
    self.titleView.titleSelectedColor = [UIColor whiteColor];
    self.titleView.backgroundColor = [UIColor colorWithRed:123/255.f green:197/255.f blue:188/255.f alpha:1.f];
    [self.view addSubview:self.titleView];
}
-(void)creatTableViewControllers{
    self.contentView = [[LXScrollContentView alloc] init];
    self.contentView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    self.contentView.delegate = self;
    [self.view addSubview:self.contentView];
}
-(void)getHubUI{
    self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //13,是否强制背景框宽高相等
    //            self.hub.square = YES;
    //设置对话框文字
    self.hub.labelText = @"加载中";

    //细节文字
    self.hub.detailsLabelText = @"请耐心等待";
    self.hub.opacity = 0.5f;
}
-(void)getRequestData{
    
    [NetworkObject postNetworkRequestWithUrlString:[NSString stringWithFormat:@"%@index/index",IP] parameters:@{@"carId":@"0",@"page":@"0",@"token":[NetworkObject md5:@"bangbang"]} isCache:YES isUpdate:NO tableName:@"main" succeed:^(id data) {
        
        self.car_infonameMarr = [NSMutableArray new];
        self.carIdMarr = [NSMutableArray new];
        NSMutableArray *carlistMarr = [NSMutableArray new];
        carlistMarr = [data valueForKey:@"carlist"];
        for (int i = 0; i<[carlistMarr count]; i++) {
            
            [self.car_infonameMarr addObject:[NSString stringWithFormat:@"%@",[carlistMarr[i] valueForKey:@"car_infoname"]]];
            
            [self.carIdMarr addObject:[NSString stringWithFormat:@"%@",[carlistMarr[i] valueForKey:@"id"]]];
        }
        
        
        
        self.contMarr = [NSMutableArray new];
        NSMutableArray *permetMarr = [NSMutableArray new];
        permetMarr = [data valueForKey:@"permet"];
        for (int i = 0; i<[permetMarr count]; i++) {
            [self.contMarr addObject:[NSString stringWithFormat:@"%@",[permetMarr[i] valueForKey:@"cont"]]];
        }
        
//        NSString *text;
//        if (self.contMarr.count <= 0) {
//            text = @"小帮手";
//            [self.titleBut setTitleColor:[UIColor colorWithRed:55/255.f green:101/255.f blue:11/255.f alpha:1] forState:UIControlStateNormal];
//
//        }else{
//            text = [NSString stringWithFormat:@"小帮手:%@",self.contMarr[0]];
//            // 1.创建NSMutableAttributedString实例
//            NSMutableAttributedString *fontAttributeNameStr = [[NSMutableAttributedString alloc]initWithString:text];
//
//            [fontAttributeNameStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:55/255.f green:101/255.f blue:11/255.f alpha:1] range:NSMakeRange(0, 4)];
//            [fontAttributeNameStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:78/255.f green:75/255.f blue:74/255.f alpha:0.5f] range:NSMakeRange(4, text.length - 4)];
//
//            // 3.给label赋值
//            //            [self.titleBut setTitle:fontAttributeNameStr forState:UIControlStateNormal];
//            self.titleBut.titleLabel.attributedText = fontAttributeNameStr;
//            [self.titleBut setAttributedTitle:fontAttributeNameStr forState:UIControlStateNormal];
//        }
        
        
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hub hide:YES];
            [self reloadData];

        });
        
        NSLog(@" ===\n %@",[data valueForKey:@"carlist"]);
        
    } fail:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hub hide:YES];
            
        });
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)segmentTitleView:(LXSegmentTitleView *)segmentView selectedIndex:(NSInteger)selectedIndex lastSelectedIndex:(NSInteger)lastSelectedIndex{
    
    
    
    self.contentView.currentIndex = selectedIndex;
    
    
}

- (void)contentViewDidScroll:(LXScrollContentView *)contentView fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(float)progress{
    
}

- (void)contentViewDidEndDecelerating:(LXScrollContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    
    self.titleView.selectedIndex = endIndex;
    
}


- (void)reloadData{
    
    //@[@"首页",@"体育在线",@"科技日报",@"生活",@"本地",@"精彩视频",@"娱乐",@"时尚",@"房地产",@"经济"]
    NSArray *titles = _car_infonameMarr;
    self.titleView.segmentTitles = titles;
    
    self.vcs = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<titles.count; i++) {
        TableViewViewController *vc = [[TableViewViewController alloc] init];
        //self.carIdMarr[i];
        vc.carId = self.carIdMarr[i];
        [self.vcs addObject:vc];
    }
    
    [self.contentView reloadViewWithChildVcs:self.vcs parentVC:self];
    self.titleView.selectedIndex = 0;
    self.contentView.currentIndex = 0;
}
@end
