//
//  ViewController.m
//  asynTest
//
//  Created by Rain on 2017/7/20.
//  Copyright © 2017年 Rain. All rights reserved.
//

#import "ViewController.h"

#define num  arc4random() % 10

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadRequest:YES secAdd:YES];
}

#pragma mark - 网络请求 同步
- (void)loadRequest:(BOOL)firAdd secAdd:(BOOL)secAdd
{
    __block int ifRefresh = 0;

    dispatch_group_t dispatchGroup = dispatch_group_create();
    if (firAdd) {
        dispatch_group_enter(dispatchGroup);
        [self httpRequest:^{
            NSLog(@"第一个请求完成成功");
            
            ifRefresh ++;
            
            dispatch_group_leave(dispatchGroup);
            
        } fail:^{
            NSLog(@"第一个请求完成失败");
            dispatch_group_leave(dispatchGroup);
        }];
    }
    if (secAdd) {
        dispatch_group_enter(dispatchGroup);
        [self httpRequestNum:^{
            NSLog(@"第二个请求完成成功");
            
            ifRefresh ++;
            
            dispatch_group_leave(dispatchGroup);
        } fail:^{
            NSLog(@"第二个请求完成失败");
            dispatch_group_leave(dispatchGroup);
        }];
    }
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
       
        NSLog(@"请求完成");
        if (ifRefresh == ((firAdd?0:1)+(secAdd?0:1))) {
            NSLog(@"刷新");
        }
        else
        {
            NSLog(@"不刷新");
        }
        
    });
}
-(void)httpRequest:(void (^)(void))succ fail:(void (^)(void))fail{
    
    if (num>5) {
        succ();
    }
    else{
        fail();
    }
    
}
-(void)httpRequestNum:(void (^)(void))succ fail:(void (^)(void))fail{
    
    sleep(5);
    
    if (num>5) {
        succ();
    }
    else{
        fail();
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
