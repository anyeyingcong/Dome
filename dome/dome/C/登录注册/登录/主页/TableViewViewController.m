//
//  TableViewViewController.m
//  dome
//
//  Created by 王俊杰 on 2018/4/16.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "TableViewViewController.h"
#import "TableViewObject.h"
#import "ListTableViewCell.h"
#import "AdvertisingTableViewCell.h"
@interface TableViewViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *titleArr;//标题数组
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSString *upOrDown;//下拉或者上拉
@property (nonatomic) NSMutableArray *mArrNewlist;//每个cell数据集合的数组

@property (nonatomic) NSMutableArray *butMarr;


@end

static NSString *listCell = @"listCell";
static NSString *AdvertisingCell = @"AdvertisingCell";
static int pageNumber = 0;

@implementation TableViewViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    NSLog(@" ===\n %@",self.carId);

}
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view setBackgroundColor:[UIColor redColor]];
    
    [self creatTableView];
    
    [self upOrDownTabView];//上拉加载下拉刷新

    
}
-(void)upOrDownTabView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    //或
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setDownRefresh)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    //
    
    
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    //或
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setUpRefresh)];
}
/**
 *  集成下拉刷新
 */
-(void)setDownRefresh
{
    
    self.upOrDown = @"down";
    pageNumber = 0;
    //创建一个并行队列
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadCellData];
    });
}
/**
 *  集成上拉加载
 */

-(void)setUpRefresh{
    self.upOrDown = @"up";
    pageNumber += 1;
    //创建一个并行队列
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadCellData];
    });
    
}
-(void)loadCellData{
    
    NSLog(@" ===\n %@",[NSString stringWithFormat:@"%d",pageNumber]);
    
    [NetworkObject postNetworkRequestWithUrlString:[NSString stringWithFormat:@"%@index/index",IP] parameters:@{@"carId":self.carId,@"page":[NSString stringWithFormat:@"%d",pageNumber],@"token":[NetworkObject md5:@"bangbang"]} isCache:NO isUpdate:NO tableName:[NSString stringWithFormat:@"tabView%@",self.carId] succeed:^(id data) {
        if ([self.upOrDown isEqualToString:@"down"]) {//下拉刷新
            
            [self.mArrNewlist removeAllObjects];
            self.mArrNewlist = [NSMutableArray new];
            
            
            NSMutableArray *newlistMarr = [NSMutableArray new];
            newlistMarr = [data valueForKey:@"newlist"];
            
            for (int i = 0; i<newlistMarr.count; i++) {
                
                TableViewObject *obj = [[TableViewObject alloc]init];
                obj.tid = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"tid"]];
                obj.title = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"title"]];
                obj.comart = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"comart"]];
                obj.visit = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"visit"]];
                obj.forword = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"forword"]];
                obj.image = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"image"]];
                
                
                obj.describe = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"describe"]];
                obj.isopen = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"isopen"]];
                
                
                [self.mArrNewlist addObject:obj];
                
                
            }
            
            
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.mArrNewlist.count > 0) {
                    //给tableView设置背景view
                    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
                    [backImageView setImage:[UIImage imageNamed:@"0"]];
                    self.tableView.backgroundView = backImageView;
                }else{
                    //给tableView设置背景view
                    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
                    [backImageView setImage:[UIImage imageNamed:@"bgNO"]];
                    self.tableView.backgroundView = backImageView;
                }
                //2.刷新表格
                [self.tableView reloadData];
                
                // 3. 结束刷新
                [self.tableView.mj_header endRefreshing];
            });

        }else{//上拉加载
            
            NSMutableArray *newlistMarr = [NSMutableArray new];
            newlistMarr = [data valueForKey:@"newlist"];
            
            
            if ([[data valueForKey:@"sum"] intValue] > [[NSString stringWithFormat:@"%lu",(unsigned long)self.mArrNewlist.count] intValue]) {
                
                for (int i = 0; i<newlistMarr.count; i++) {
                    
                    TableViewObject *obj = [[TableViewObject alloc]init];

                    obj.tid = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"tid"]];
                    obj.title = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"title"]];
                    obj.comart = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"comart"]];
                    obj.visit = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"visit"]];
                    obj.forword = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"forword"]];
                    obj.image = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"image"]];
                    obj.describe = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"describe"]];
                    obj.isopen = [NSString stringWithFormat:@"%@",[newlistMarr[i] valueForKey:@"isopen"]];
                    
                    [self.mArrNewlist addObject:obj];
                    
                }
            }else{
                pageNumber -= 1;
            }
            NSLog(@" ===/n %@",self.mArrNewlist);

            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
                // 3. 结束刷新
                [self.tableView.mj_footer endRefreshing];
            });
            
            
        }
    } fail:^(NSError *error) {
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器连接失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [av show];
            
            // 结束刷新刷新 ，为了避免网络加载失败，一直显示刷新状态的错误
            [self.tableView.mj_header endRefreshing];
            // 3. 结束刷新
            [self.tableView.mj_footer endRefreshing];
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-40)];
//    self.tableView.backgroundColor = [UIColor greenColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//没有数据不显示分割线
    self.tableView.separatorColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:241/255.f alpha:1.0f];//设置分割线颜色
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:listCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"AdvertisingTableViewCell" bundle:nil] forCellReuseIdentifier:AdvertisingCell];
    
//    //给tableView设置表头view
//    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 30)];
//    tableHeaderView.backgroundColor = [UIColor redColor];
//    self.tableView.tableHeaderView = tableHeaderView;
    
//    //给tableView设置背景view
//    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
//    [backImageView setImage:[UIImage imageNamed:@"bgNO"]];
//    self.tableView.backgroundView = backImageView;
    
    
}
#pragma mark 设置表的分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark 设置表的每个分组数cell的个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArrNewlist.count;
    
}
#pragma mark 设置每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewObject *obj = self.mArrNewlist[indexPath.row];
    
    
    if ([[NSString stringWithFormat:@"%@",obj.isopen] isEqualToString:@"1"]) {
        
        return SCREEN_WIDTH/2+44+44;
        
    }else
        return 93;
}
#pragma mark 设置区头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
#pragma mark 设置区尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
#pragma mark 设置区头View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor grayColor];
    return headerView;
}
#pragma mark 设置区尾View
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor grayColor];
    return footerView;
}
#pragma mark 设置tableViewCell视图
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];//左右分割线的位置
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.backgroundColor = [UIColor clearColor];//关键语句
    
    TableViewObject *obj = self.mArrNewlist[indexPath.row];
    if ([[NSString stringWithFormat:@"%@",obj.isopen] isEqualToString:@"0"]) {//如果是一般文本cell
        
        ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
        
        if (!cell) {
            cell = [[ListTableViewCell alloc]init];
        }
        
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        
        
        
        [cell.avatarsImgView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",imgIP,obj.image]] placeholderImage:[UIImage imageNamed:@"main_preinstalled"]];
        
        
        cell.titleLab.text = obj.title;
//
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cell.titleLab.text];
//
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//
//        [paragraphStyle setLineSpacing:5];//你所要设置的行距
//
//        //调整行间距
//        [attributedString addAttribute:NSParagraphStyleAttributeName
//                                 value:paragraphStyle
//                                 range:NSMakeRange(0, [cell.titleLab.text length])];
//
//        cell.titleLab.attributedText = attributedString;
        
        cell.timerLab.text = [NSString stringWithFormat:@"%@",obj.comart];
        cell.browseLab.text = [NSString stringWithFormat:@"%@ 次浏览",obj.visit];
        cell.forwardingLab.text = [NSString stringWithFormat:@"%@ 次转发",obj.forword];
        
        return cell;
        
    }else if([[NSString stringWithFormat:@"%@",obj.isopen] isEqualToString:@"1"]){//如果是广告cell
        
        
        self.butMarr = [NSMutableArray new];
        
        AdvertisingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AdvertisingCell];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中cell后不变色
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lookBut.tag = indexPath.row;
        [cell.lookBut addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.butMarr addObject:cell.lookBut];
        
        
        
        if (!cell) {
            cell = [[AdvertisingTableViewCell alloc]init];
        }
        
        
        cell.imgV_h.constant = SCREEN_WIDTH/2;
        
        [cell.avatarsImgView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",imgIP,obj.image]] placeholderImage:[UIImage imageNamed:@"main_preinstalled"]];//设置用户头像
        
        
        cell.titleLab.text = obj.title;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cell.titleLab.text];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:5];//你所要设置的行距
        
        //调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, [cell.titleLab.text length])];
        
        cell.titleLab.attributedText = attributedString;
        
//        cell.timerLab.text = [NSString stringWithFormat:@"%@",obj.comart];
//
//        cell.browseLab.text = [NSString stringWithFormat:@"%@ 次浏览",obj.visit];
//
//        cell.describeLab.text = [NSString stringWithFormat:@"%@",obj.describe];
        
        
        return cell;
        
    }else
        
        return nil;
    
}
-(void)butClick:(UIButton *)but{
    for (UIButton *but in self.butMarr) {
        if (but.tag == but.tag) {
            TableViewObject *obj = [[TableViewObject alloc]init];
            
            obj = self.mArrNewlist[but.tag];
            
//            DetailsMainControllerViewController *vc = [[DetailsMainControllerViewController alloc]init];
//            vc.tid = self.mainObj.tid;
//            vc.shareTitle = self.mainObj.title;
//            vc.shareComart = self.mainObj.comart;
//            vc.shareImage = [NSString stringWithFormat:@"%@%@",imgIP,self.mainObj.image];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark 设置表cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1 松开手选中颜色消失
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中变一下色
    
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
