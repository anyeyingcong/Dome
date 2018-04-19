//
//  CenterViewController.m
//  微帮同赚
//
//  Created by 王俊杰 on 2018/4/14.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "CenterViewController.h"
#import "CenterTableViewCell.h"

@interface CenterViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) MBProgressHUD *hub;
@property (nonatomic) NSMutableArray *titleArr;//标题数组
@property (nonatomic) UITableView *tableView;
@property (nonatomic) id data;

@end
static NSString *CenterCell = @"CenterCell";

@implementation CenterViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;//从nav底部开始
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNAV];
    [self creatTableView];
    [self downTabView];
    
    //创建一个并行队列
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([SQLObject SQLTableName:@"center"] != nil) {//如果缓存是空值，去服务器请求数据并且存到SQL
            id dict = [NSJSONSerialization JSONObjectWithData:[SQLObject SQLTableName:@"center"] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            NSLog(@" ===\n %@",dict);
            self.data = dict;
            [self dataUpdate];
        }else{
            //    // 马上进入刷新状态
            [self.tableView.mj_header beginRefreshing];
        }
    });
}

-(void)downTabView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setDownRefresh)];
    
}
-(void)setDownRefresh
{
    
    //创建一个并行队列
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadCellData];
    });
}
-(void)loadCellData{
    
    
    
    [NetworkObject postNetworkRequestWithUrlString:[NSString stringWithFormat:@"%@user/index",IP] parameters:@{@"Uid":@"62",@"Way":@"pass",@"token":[NetworkObject md5:@"bangbang"]} isCache:YES isUpdate:YES tableName:@"center" succeed:^(id data) {
        NSLog(@" ===\n %@",data);
        self.data = data;
        [self dataUpdate];
    } fail:^(NSError *error) {
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器连接失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [av show];
        });
    }];
}
-(void)dataUpdate{

    if ([[NSString stringWithFormat:@"%@",[self.data valueForKey:@"code"]] isEqualToString:@"200"]) {//取到正确的数据，进行更新数据
        
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[NSString stringWithFormat:@"%@",[self.data valueForKey:@"sign"]] isEqualToString:@"0"]) {
                
                self.navigationController.navigationBar.tintColor = [UIColor whiteColor];// 导航栏左右按钮字体颜色
            }else{
                
                self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:190/255.f green:227/255.f blue:222/255.f alpha:.6];// 导航栏左右按钮字体颜色
            }
            
            [self.hub hide:YES];
            
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            
        });
        
    }else{
        [self.hub hide:YES];
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"errorMessage"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [av show];
        });
    }
}
-(void)creatTableView{
    
    //去除上下偏移
    if (@available(iOS 11.0, *))
    {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.tableView.backgroundColor = [UIColor greenColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//没有数据不显示分割线
    self.tableView.separatorColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:241/255.f alpha:1.0f];//设置分割线颜色
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterTableViewCell" bundle:nil] forCellReuseIdentifier:CenterCell];

    
//    //给tableView设置表头view
//    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 66)];
//    tableHeaderView.backgroundColor = [UIColor redColor];
//    self.tableView.tableHeaderView = tableHeaderView;
    
//    //给tableView设置背景view
//    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
//    [backImageView setImage:[UIImage imageNamed:@"BG"]];
//    self.tableView.backgroundView = backImageView;
    
    
}
#pragma mark 设置表的分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
#pragma mark 设置表的每个分组数cell的个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return 2;
    }else
        return 1;
}
#pragma mark 设置每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 64;
    }else
        return 44;
}
#pragma mark 设置区头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else
        return 20;
}
#pragma mark 设置区尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
#pragma mark 设置区头View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:241/255.f alpha:1.0f];
    return headerView;
}
#pragma mark 设置区尾View
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]init];
//    footerView.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:241/255.f alpha:1.0f];
    return footerView;
}
#pragma mark 设置tableViewCell视图
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;//点击cell没有变化
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];//左右分割线的位置
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右箭头

    cell.backgroundColor = [UIColor clearColor];//关键语句
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.textLabel.textColor = [UIColor colorWithRed:154/255.f green:154/255.f blue:154/255.f alpha:1];
    
    switch (indexPath.section) {
        case 0:
        {
            
            CenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CenterCell];
            
            if (!cell) {
                cell = [[CenterTableViewCell alloc]init];
            }
            
            
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];//左右分割线的位置
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右箭头

            [cell.headPortraitImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"headImg"]]] placeholderImage:[UIImage imageNamed:@"personal_center_sign_head_portrait"]];
        
            if ([[NSString stringWithFormat:@"%@",[self.data valueForKey:@"nickName"]] isEqualToString:@"(null)"]) {
                cell.nameLab.text = @"";
            }else{
                cell.nameLab.text = [NSString stringWithFormat:@"%@",[self.data valueForKey:@"nickName"]];
            }
            
            if ([[NSString stringWithFormat:@"%@",[self.data valueForKey:@"invate"]] isEqualToString:@"(null)"]) {
                cell.InviteCodeLab.text = @"";

            }else{
                cell.InviteCodeLab.text = [NSString stringWithFormat:@"%@",[self.data valueForKey:@"invate"]];
            }
            return cell;
        }
            break;
        case 1:
        {
            
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.imageView.image = [UIImage imageNamed:@"personal_center_icon_withdraw_money"];
                    cell.textLabel.text = @"我要提现";
                }
                    break;
                case 1:
                {
                    cell.imageView.image = [UIImage imageNamed:@"personal_center_icon_withdraw_record"];
                    cell.textLabel.text = @"提现记录";
                }
                    break;
                case 2:
                {
                    cell.imageView.image = [UIImage imageNamed:@"personal_center_icon_my_team"];
                    cell.textLabel.text = @"我的团队";
                }
                    break;
                case 3:
                {
                    cell.imageView.image = [UIImage imageNamed:@"personal_center_icon_join_us"];
                    cell.textLabel.text = @"加入我们";
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            
            switch (indexPath.row) {
                case 0:
                {
#pragma mark 解注释
                    cell.imageView.image = [UIImage imageNamed:@"personal_center_icon_help"];
                    cell.textLabel.text = @"新手课堂";
//                    cell.imageView.image = [UIImage imageNamed:@"personal_center_icon_systematic_notification"];
//                    cell.textLabel.text = @"系统通知";
                }
                    break;
                case 1:
                {
                    cell.imageView.image = [UIImage imageNamed:@"personal_center_icon_systematic_notification"];
                    cell.textLabel.text = @"系统通知";
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.imageView.image = [UIImage imageNamed:@"personal_center_icon_set"];
                    cell.textLabel.text = @"设置";
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}
#pragma mark 设置表cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1 松开手选中颜色消失
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中变一下色
    
}
-(void)setNAV{
    self.title = @"个人中心";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];//导航栏标题字体颜色
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    // 导航栏背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar_2"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"personal_center_sign_in_default"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonClick)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:190/255.f green:227/255.f blue:222/255.f alpha:.6];// 导航栏左右按钮字体颜色

}
#pragma mark 签到按钮方法
-(void)rightBarButtonClick{
    //创建一个并行队列
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NetworkObject postNetworkRequestWithUrlString:[NSString stringWithFormat:@"%@user/index",IP] parameters:@{@"Uid":@"62",@"actType":@"sign",@"token":[NetworkObject md5:@"bangbang"]} isCache:NO isUpdate:NO tableName:@"center" succeed:^(id data) {
            NSLog(@" ===\n %@",data);
            if (([[NSString stringWithFormat:@"%@",[self.data valueForKey:@"code"]] isEqualToString:@"200"])) {//签到成功
                // 主线程执行：
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:190/255.f green:227/255.f blue:222/255.f alpha:.6];// 导航栏左右按钮字体颜色
                });

            }else{//签到未成功
                // 主线程执行：
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];// 导航栏左右按钮字体颜色
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:[self.data valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                    [av show];
                });
            }
            
        } fail:^(NSError *error) {
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
                
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器连接失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [av show];
            });
        }];
    });
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
