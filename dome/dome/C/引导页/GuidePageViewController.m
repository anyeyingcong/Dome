//
//  GuidePageViewController.m
//  微帮同赚
//
//  Created by 王俊杰 on 2018/4/13.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "GuidePageViewController.h"
//#import "LoginViewController.h"
#import "TBViewController.h"
@interface GuidePageViewController ()<UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollV;
@property (nonatomic) UIButton *stantBut;


@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 11.0, *))
    {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self creatScrollViewWithImgViewsAndStartBut];
}

-(UIScrollView *)creatScrollViewWithImgViewsAndStartBut{
    
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollV.contentSize = CGSizeMake(SCREEN_WIDTH*_imgSNameArr.count, SCREEN_HEIGHT);
        _scrollV.delegate = self;
        _scrollV.showsVerticalScrollIndicator = NO;
        _scrollV.showsHorizontalScrollIndicator = NO;
        _scrollV.pagingEnabled = YES;
        [self.view addSubview:_scrollV];
        
        for (int i = 0; i<_imgSNameArr.count; i++)
        {
            //背景图片
            UIImageView *imgV1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            imgV1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _imgSNameArr[i]]];
            [_scrollV addSubview:imgV1];
            
            //滑动的小圆点指示器
            UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-102/2+i*SCREEN_WIDTH, SCREEN_HEIGHT-20-17, 102, 17)];
            pageControl.numberOfPages = _imgSNameArr.count;
            pageControl.userInteractionEnabled = YES;
            pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
            pageControl.pageIndicatorTintColor = [UIColor colorWithRed:177/255.f green:220/255.f blue:214/255.f alpha:1];
            pageControl.currentPage = i;
            [_scrollV addSubview:pageControl];
            
        }

        //开始体验按钮
        self.stantBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.stantBut.frame = CGRectMake(83, SCREEN_HEIGHT-20-17-20-44, SCREEN_WIDTH-164, 44);
        [self.stantBut setTitle:@"开始体验" forState:UIControlStateNormal];
        [self.stantBut setTitleColor:[UIColor colorWithRed:0/255.f green:60/255.f blue:73/255.f alpha:1] forState:UIControlStateNormal];
        self.stantBut.backgroundColor = [UIColor colorWithRed:208/255.f green:235/255.f blue:230/255.f alpha:1];
        [self.stantBut addTarget:self action:@selector(stantButButClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.stantBut];
        
        //开始体验按钮 设置圆角
        [self.stantBut.layer setCornerRadius:22];
        [self.stantBut.layer setMasksToBounds:YES];
        
        //隐藏   最后一页时显示
        [self.stantBut setHidden:YES];
    }
    return _scrollV;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x/SCREEN_WIDTH >= _imgSNameArr.count-1)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.stantBut setHidden:NO];
        }];
    }else
        [UIView animateWithDuration:0.5 animations:^{
            [self.stantBut setHidden:YES];
        }];
}
-(void)stantButButClick{
    
//    LoginViewController *vc = [[LoginViewController alloc]init];
//    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
//    self.view.window.rootViewController = nvc;
    TBViewController *vc = [[TBViewController alloc]init];
    self.view.window.rootViewController = vc;
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
