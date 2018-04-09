//
//  WalletViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/10.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "WalletViewController.h"

@interface WalletViewController ()

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的钱包";
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1];
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
