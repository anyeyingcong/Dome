//
//  TBViewController.m
//  微帮同赚
//
//  Created by 王俊杰 on 2018/4/14.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "TBViewController.h"
#import "MainViewController.h"
#import "TeamViewController.h"
#import "CenterViewController.h"
@interface TBViewController ()

@end

@implementation TBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [UITabBar appearance].translucent = NO;//这句表示取消tabBar的透明效果
//    [UINavigationBar appearance].translucent = NO;//这句表示取消tabBar的透明效果
    
//    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"title_bar_2"]];
    
    MainViewController *mainVC = [[MainViewController alloc]init];
    mainVC.tabBarItem = [[UITabBarItem alloc] init];
    mainVC.tabBarItem.title = @"首页";
    mainVC.tabBarItem.image = [[UIImage imageNamed:@"navigation_first_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"navigation_first_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mainVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:123/255.f green:197/255.f blue:188/255.f alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];//选中
    [mainVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont   systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithRed:33/255.f green:33/255.f blue:33/255.f alpha:.5]}   forState:UIControlStateNormal];//未选中
    UINavigationController *mainNVC = [[UINavigationController alloc]initWithRootViewController:mainVC];
    
    
    
    
    TeamViewController *teamVC = [[TeamViewController alloc]init];
    teamVC.tabBarItem = [[UITabBarItem alloc] init];
    teamVC.tabBarItem.title = @"我的团队";
    teamVC.tabBarItem.image = [[UIImage imageNamed:@"navigation_second_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    teamVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"navigation_second_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    [teamVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:123/255.f green:197/255.f blue:188/255.f alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];//选中
    [teamVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont   systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithRed:33/255.f green:33/255.f blue:33/255.f alpha:.5]}   forState:UIControlStateNormal];//未选中
    UINavigationController *teamNVC = [[UINavigationController alloc]initWithRootViewController:teamVC];
    
    
    
    CenterViewController *centerVC = [[CenterViewController alloc]init];
    centerVC.tabBarItem = [[UITabBarItem alloc] init];
    centerVC.tabBarItem.title = @"个人中心";
    centerVC.tabBarItem.image = [[UIImage imageNamed:@"navigation_third_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    centerVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"navigation_third_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    [centerVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:123/255.f green:197/255.f blue:188/255.f alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];//选中
    [centerVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont   systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithRed:33/255.f green:33/255.f blue:33/255.f alpha:.5]}   forState:UIControlStateNormal];//未选中
    UINavigationController *centerNVC = [[UINavigationController alloc]initWithRootViewController:centerVC];
    
    
    
    self.viewControllers = @[mainNVC,teamNVC,centerNVC];
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
