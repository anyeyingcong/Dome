//
//  ViewController.m
//  dome
//
//  Created by 王俊杰 on 2018/4/11.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "ViewController.h"
#import "NewViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    NewViewController *vc = [[NewViewController alloc]init];
    vc.view.center = self.view.center;
    vc.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
