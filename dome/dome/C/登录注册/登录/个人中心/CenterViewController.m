//
//  CenterViewController.m
//  微帮同赚
//
//  Created by 王俊杰 on 2018/4/14.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "CenterViewController.h"

@interface CenterViewController ()

@end

@implementation CenterViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;//从nav底部开始
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人中心";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];//导航栏标题字体颜色
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    // 导航栏背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar_2"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];// 导航栏左右按钮字体颜色

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

@end
