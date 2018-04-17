//
//  TeamViewController.m
//  微帮同赚
//
//  Created by 王俊杰 on 2018/4/14.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamObject.h"
@interface TeamViewController ()<UITableViewDelegate, UITableViewDataSource>
//
@property (nonatomic) NSMutableArray *titleArr;//标题数组
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *mtMarr;//数据模型数组

@property (nonatomic) int *listNumber;


@end

@implementation TeamViewController
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
    
    if ([SQLObject SQLTableName:@"main"] != nil) {//如果缓存是空值，去服务器请求数据并且存到SQL
        id dict = [NSJSONSerialization JSONObjectWithData:[SQLObject SQLTableName:@"main"] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    }
}
-(void)downTabView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setDownRefresh)];
    //    // 马上进入刷新状态
    //    [self.tableView.mj_header beginRefreshing];
    //
    
}
-(void)setDownRefresh
{
    
    //创建一个并行队列
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadCellData];
    });
}
-(void)loadCellData{
    [NetworkObject postNetworkRequestWithUrlString:[NSString stringWithFormat:@"%@user/index",IP] parameters:@{@"Uid":@"62",@"actType":@"myTeam",@"Way":@"pass",@"token":[NetworkObject md5:@"bangbang"]} isCache:YES isUpdate:YES tableName:@"team" succeed:^(id data) {
        
        if (([[NSString stringWithFormat:@"%@",[data valueForKey:@"code"]] isEqualToString:@"200"])) {
            
            self.mtMarr = [NSMutableArray new];
            
            
            NSMutableArray *mArr = [data valueForKey:@"errorMessage"];
            
            
            if ([[NSString stringWithFormat:@"%lu",(unsigned long)mArr.count] isEqualToString:@"0"]) {//获取的数据为空值
                
                self.listNumber = 0;
                
            }else{//获取非空数据
                
                
                for (int i = 0; i<mArr.count; i++) {
                    TeamObject *obj = [[TeamObject alloc]init];
                    
                    obj.upper_level = [NSString stringWithFormat:@"%@",[mArr[i] valueForKey:@"upper_level"]];
                    obj.uname = [NSString stringWithFormat:@"%@",[mArr[i] valueForKey:@"uname"]];
                    obj.headimg = [NSString stringWithFormat:@"%@",[mArr[i] valueForKey:@"headimg"]];
                    [self.mtMarr addObject:obj];
                }
            }
            
            self.listNumber = (int)self.mtMarr.count;
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];

            });
            
        }else{
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:[data valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [av show];
            });
            
        }
    } fail:^(NSError *error) {
        
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            // 结束刷新刷新 ，为了避免网络加载失败，一直显示刷新状态的错误
            [self.tableView.mj_header endRefreshing];
            
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器连接失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [av show];
        });

    }];
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
    self.tableView.backgroundColor = [UIColor greenColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//没有数据不显示分割线
    self.tableView.separatorColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:241/255.f alpha:1.0f];//设置分割线颜色
    [self.view addSubview:self.tableView];
    
//    //给tableView设置表头view
//    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 66)];
//    tableHeaderView.backgroundColor = [UIColor redColor];
//    self.tableView.tableHeaderView = tableHeaderView;
    
    //给tableView设置背景view
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [backImageView setImage:[UIImage imageNamed:@"bgNO"]];
    self.tableView.backgroundView = backImageView;
    
    
}
#pragma mark 设置表的分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark 设置表的每个分组数cell的个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listNumber;
}
#pragma mark 设置每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
#pragma mark 设置区头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.listNumber >0 ) {
        return 44;
    }else
        return 0;
}
#pragma mark 设置区尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.listNumber >0 ) {
        return 44;
    }else
        return 0;
}
#pragma mark 设置区头View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
//    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"my_team_friend_list"]];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    but.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    but.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    but.tag = 10;
    [but setTitle:@" 我的团队" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"my_team_friend_list"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:but];
    
    return headerView;
}
#pragma mark 设置区尾View
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]init];
//    footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"my_team_add_friends_green"]];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    but.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    but.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    but.tag = 11;
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but setTitle:@" 扩建团队" forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"my_team_add_friends_green"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:but];
    
    return footerView;
}
-(void)butClick:(UIButton *)but{
    switch (but.tag) {
        case 10:
            {
                
            }
            break;
        case 11:
        {
            
        }
            break;
        default:
            break;
    }
}
#pragma mark 设置tableViewCell视图
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;//点击cell没有变化
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];//左右分割线的位置
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.backgroundColor = [UIColor clearColor];//关键语句
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"BG"];
    
    return cell;
}
#pragma mark 设置表cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1 松开手选中颜色消失
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中变一下色
    
}
-(void)setNAV{
    self.title = @"扩展团队";
    
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
