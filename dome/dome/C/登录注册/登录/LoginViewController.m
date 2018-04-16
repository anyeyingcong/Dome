//
//  LoginViewController.m
//  微帮同赚
//
//  Created by 王俊杰 on 2018/4/13.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "TBViewController.h"

@interface LoginViewController ()

@property (nonatomic) UITextField *phoneTF;
@property (nonatomic) UITextField *passwordTF;
@property (nonatomic) UIButton *loginBut;


@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;//从nav底部开始

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNVC];
    
    [self creatBG];//背景
    
    [self creatPhoneTF];//账号
    
    [self creatPassWordTF];//密码
    
    [self setUpForDismissKeyboard];//键盘下落

    [self creatLoginBut];//登录按钮
    
}

-(void)setNVC{
    self.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];//导航栏标题字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];// 导航栏左右按钮字体颜色
}

-(void)creatBG{
    UIImageView *imgv = [[UIImageView alloc]init];
    imgv.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    imgv.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:imgv];
}

-(UITextField *)creatPhoneTF{
    if (!self.passwordTF) {
        
        self.passwordTF = [[UITextField alloc]init];
        self.passwordTF.keyboardType = UIKeyboardTypeNumberPad;
        self.passwordTF.textColor = [UIColor whiteColor];
        self.passwordTF.font = [UIFont systemFontOfSize:15];
        self.passwordTF.textAlignment = NSTextAlignmentLeft;
        self.passwordTF.frame = CGRectMake(20, 104, SCREEN_WIDTH-40, 44);
        self.passwordTF.placeholder = @"请输入您的手机号";
        [self.view addSubview:self.passwordTF];
        
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
        lineV.frame = CGRectMake(64, 152, SCREEN_WIDTH-84, 0.5f);
        [self.view addSubview:lineV];
        
        UIView *tfLiftView = [[UIView alloc]init];//设置手机号输入框右视图
        tfLiftView.bounds = CGRectMake(0, 0, 44, 44);
        self.passwordTF.leftView = tfLiftView;
        self.passwordTF.leftViewMode= UITextFieldViewModeAlways;
        
        UIImageView *tfLiftImgV = [[UIImageView alloc]init];
        tfLiftImgV.contentMode = UIViewContentModeCenter;
        tfLiftImgV.frame = CGRectMake(0, 0, 44, 44);
        tfLiftImgV.image = [UIImage imageNamed:@"login_telephone"];
        [tfLiftView addSubview:tfLiftImgV];
    }
    return self.passwordTF;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(UITextField *)creatPassWordTF{
    if (!self.phoneTF) {
        
        self.phoneTF = [[UITextField alloc]init];
        self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneTF.textColor = [UIColor whiteColor];
        self.phoneTF.font = [UIFont systemFontOfSize:15];
        self.phoneTF.textAlignment = NSTextAlignmentLeft;
        self.phoneTF.frame = CGRectMake(20, 168, SCREEN_WIDTH-40, 44);
        self.phoneTF.placeholder = @"请输入验证码";
        [self.view addSubview:self.phoneTF];
        
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
        lineV.frame = CGRectMake(64, 216, SCREEN_WIDTH-84, 0.5f);
        [self.view addSubview:lineV];
        
        UIView *tfLiftView = [[UIView alloc]init];//设置手机号输入框右视图
        tfLiftView.bounds = CGRectMake(0, 0, 44, 44);
        self.phoneTF.leftView = tfLiftView;
        self.phoneTF.leftViewMode= UITextFieldViewModeAlways;
        
        UIImageView *tfLiftImgV = [[UIImageView alloc]init];
        tfLiftImgV.contentMode = UIViewContentModeCenter;
        tfLiftImgV.frame = CGRectMake(0, 0, 44, 44);
        tfLiftImgV.image = [UIImage imageNamed:@"login_verification_code"];
        [tfLiftView addSubview:tfLiftImgV];
        
        
        // 根据字体得到NSString的尺寸
        CGSize size = [self sizeWithText: @"获取验证码" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        UIView *tfRightView = [[UIView alloc]init];//设置手机号输入框右视图
        tfRightView.bounds = CGRectMake(0, 0, size.width, 44);
        tfRightView.contentMode = UIViewContentModeCenter;
        self.phoneTF.rightView = tfRightView;
        self.phoneTF.rightViewMode = UITextFieldViewModeAlways;
        
        UIButton *tfRightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        tfRightBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [tfRightBut setTintColor:[UIColor whiteColor]];
        [tfRightBut setTitle:@"获取验证码" forState:UIControlStateNormal];
        tfRightBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        tfRightBut.frame = CGRectMake(0, 0, size.width, 44);
        [tfRightBut addTarget:self action:@selector(tfRightButClick) forControlEvents:UIControlEventTouchUpInside];
        [tfRightView addSubview:tfRightBut];
    }
    return self.phoneTF;
}


-(void)tfRightButClick{
    
}

-(UIButton *)creatLoginBut{
    if (!_loginBut) {
        _loginBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBut.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
        _loginBut.frame = CGRectMake(20, 252, SCREEN_WIDTH-40, 44);
        [_loginBut setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginBut.layer setCornerRadius:22];
        [_loginBut.layer setMasksToBounds:YES];
        [_loginBut addTarget:self action:@selector(loginButClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginBut];
    }
    return _loginBut;
}

-(void)loginButClick{
    
    NSLog(@" ===\n %@",self.passwordTF.text);
    NSLog(@" ===\n %@",self.phoneTF.text);
    
//    MainViewController *vc = [[MainViewController alloc]init];
//    self.view.window.rootViewController = vc;
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

//点击屏幕任意地方隐藏键盘
- (void)setUpForDismissKeyboard {
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQuene
                usingBlock:^(NSNotification *note){
                    
                    [self.view addGestureRecognizer:singleTapGR];
                    
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQuene usingBlock:^(NSNotification *note){
        
        [self.view removeGestureRecognizer:singleTapGR];
        
    }];
    
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
    
}
@end
