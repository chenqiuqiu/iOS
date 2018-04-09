//
//  ResetPwdController.m
//  practice
//
//  Created by 陈彦彤 on 17/3/6.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "ResetPwdController.h"

@interface ResetPwdController ()

@end

@implementation ResetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
   // NSArray *array1 = [NSArray arrayWithObjects:@"原密码",@"新密码",@"确认密码", nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"请输入原密码",@"请输入新密码",@"请再次输入新密码", nil];
    
    //做三个textfeild
    for (int i = 0; i < 3; i ++) {
        UITextField *firstFeild = [[UITextField alloc] initWithFrame:CGRectMake(20, 30+80*i, kmainWidth-40, 50)];
        firstFeild.placeholder = array2[i];
        firstFeild.secureTextEntry = YES;
        firstFeild.clearButtonMode = UITextFieldViewModeWhileEditing;

        [self.view addSubview:firstFeild];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 48, kmainWidth-40, 2)];
        line.backgroundColor = [UIColor colorWithRed:210.0f/255 green:210.0f/255 blue:210.0f/255 alpha:1];
        [firstFeild addSubview:line];
    }
    
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 270, kmainWidth-40, 36)];
    confirmBtn.backgroundColor = [UIColor colorWithRed:205.0f/255 green:51.0f/255 blue:51.0f/255 alpha:1];
    [confirmBtn setTitle:@"确  认" forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = 2;
    [self.view addSubview:confirmBtn];
    
    //单击空白区域退出键盘代码
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:tap];
    
    
}

- (void)closeKeyboard:(id)sender{
    [self.view endEditing:YES];
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
