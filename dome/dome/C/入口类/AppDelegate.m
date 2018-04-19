//
//  AppDelegate.m
//  dome
//
//  Created by 王俊杰 on 2018/4/11.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "AppDelegate.h"
#import "GuidePageViewController.h"
#import "TBViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self isTtTheFirstRun];////判断APP是否第一次登录
    
    [NSURLProtocol registerClass:[JWCacheURLProtocol class]];
    
    return YES;
}

-(void)isTtTheFirstRun{//判断APP是否第一次登录
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        
        GuidePageViewController *vc = [[GuidePageViewController alloc]init];
        vc.imgSNameArr = @[@"navigation_page_picture_1",@"navigation_page_picture_2",@"navigation_page_picture_3"];
        self.window.rootViewController = vc;
        
        
        NSLog(@"第一次启动跳转至引导页,引导完成后，跳转到主界面，进行核心业务时判断是否已经登录，如果已经登录可以进行后面的业务如果没有登录就跳转至登录界面");
    }else{
        TBViewController *vc = [[TBViewController alloc]init];
        self.window.rootViewController = vc;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
