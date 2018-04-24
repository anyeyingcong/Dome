//
//  MainWKWebView.m
//  dome
//
//  Created by 王俊杰 on 2018/4/19.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "MainWKWebView.h"

#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"

@interface MainWKWebView ()<UIWebViewDelegate>
@property (nonatomic) UIButton *but;
@property (nonatomic) UIWebView *webView;
@property (nonatomic) id data;
@property (nonatomic) NSString *surl;
@property (nonatomic) NSString *url;
@property (nonatomic) WYWebProgressLayer *progressLayer; ///< 网页加载进度条

@property (nonatomic) MBProgressHUD *hub;


@end

@implementation MainWKWebView
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    [self setNVC];
    [self creatWebView];
//    NSLog(@" ===\n %@",[NSString stringWithFormat:@"WKWebView%@",self.tid]);
    //创建一个并行队列
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([SQLObject SQLTableName:[NSString stringWithFormat:@"WKWebView%@",self.tid]] != nil) {//如果缓存是空值，去服务器请求数据并且存到SQL
            id dict = [NSJSONSerialization JSONObjectWithData:[SQLObject SQLTableName:[NSString stringWithFormat:@"WKWebView%@",self.tid]] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            self.data = dict;
            [self dataUpdate];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self getHubUI];
                           });
            [self dataRequst];
        }
    });
    [self creatShareBut];
}
-(void)setNVC{
    self.title = @"文章详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick)];
}
-(void)rightBarButtonClick{
    
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
-(UIWebView *)creatWebView{
    if (!self.webView) {
        self.webView = [[UIWebView alloc]init];
        self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44);
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        [self.view addSubview:self.webView];
    }
    return self.webView;
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 2)];
    [self.view.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
}
#pragma mark -网页加载完毕，注册ios对象，并且自动检查打印机是否自动连接
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [_progressLayer finishedLoad];
    
//    [JWCacheURLProtocol cancelListeningNetWorking];
    
}
-(void)dataRequst{
    
//    NSLog(@" ===\n %@",[NSString stringWithFormat:@"WKWebView%@",self.tid]);
    [NetworkObject getNetworkRequestWithUrlString:[NSString stringWithFormat:@"%@article/index?fuid=62&aid=%@&showAct=in&sendType=api&token=887f2f0d3db09ced4dadec55810e1028",IP,self.tid] parameters:nil isCache:NO isUpdate:NO tableName:[NSString stringWithFormat:@"WKWebView%@",self.tid] succeed:^(id data) {
        self.data = data;
        [self dataUpdate];
    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self.hub hide:YES];
                       });
    }];
}
-(void)dataUpdate{
    if ([[self.data valueForKey:@"code"] isEqualToString:@"200"])
    {
        self.surl = [NSString stringWithFormat:@"%@",[self.data valueForKey:@"surl"]];
        self.url = [NSString stringWithFormat:@"%@",[self.data valueForKey:@"url"]];
        NSLog(@" ===\n %@",[NSString stringWithFormat:@"%@",[self.data valueForKey:@"url"]]);
        NSLog(@" ===\n %@",[NSString stringWithFormat:@"%@",[self.data valueForKey:@"surl"]]);

        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.hub hide:YES];
//            [JWCacheURLProtocol startListeningNetWorking];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        });
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hub hide:YES];
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求数据失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [av show];
            
        });
    }
}

-(UIButton *)creatShareBut{
    if (!self.but) {
        self.but = [UIButton buttonWithType:UIButtonTypeCustom];
        self.but.frame = CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44);
        self.but.tag = 10;
        self.but.backgroundColor = [UIColor colorWithRed:123/255.f green:197/255.f blue:188/255.f alpha:1];
        [self.but setTitle:@"分享" forState:UIControlStateNormal];
        [self.but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.but];
    }
    return self.but;
}
-(void)butClick:(UIButton *)but{
    
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
