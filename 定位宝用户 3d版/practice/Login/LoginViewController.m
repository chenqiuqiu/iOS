//
//  LoginViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/9.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "LoginViewController.h"
#import "ListViewController.h"
#import "RegisterViewController.h"
#import "AFNetworking.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *userTF;
    UITextField *passTF;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kmainWidth/8 , kmainHeight/8.2, kmainWidth/8*6, kmainHeight/7-8)];
    imageView.image = [UIImage imageNamed:@"狼羊科技"];
    [self.view addSubview:imageView];
    
    [self createUsernameView];
    [self createPassView];
    [self createButtons];
    
    
    //单击空白区域退出键盘代码
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:tap];
   
    
}








- (void)closeKeyboard:(id)sender{
    [self.view endEditing:YES];
}


-(void)createUsernameView{
    //底层背景
    UIImageView *bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(20, kmainHeight/2.8, kmainWidth - 40, 43)];
    bgimg.layer.cornerRadius = 10.0;
    bgimg.layer.borderWidth = 1.65;
    bgimg.layer.borderColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1].CGColor;
    [bgimg.layer setMasksToBounds:YES];
    [self.view addSubview:bgimg];
    
    //+86
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, kmainHeight/2.8+2, 39, 39)];
    label1.text = @"+86";
    label1.textColor = [UIColor redColor];
    [self.view addSubview:label1];
    
    UIImageView *gray = [[UIImageView alloc] initWithFrame:CGRectMake(77.5, kmainHeight/2.8+5, 2, 33)];
    gray.backgroundColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1];
    
    [self.view addSubview:gray];
    
    userTF = [[UITextField alloc] initWithFrame:CGRectMake(94, kmainHeight/2.8+5,kmainWidth-40-94 , 33)];
    userTF.placeholder = @"请输入手机号";
    userTF.backgroundColor = [UIColor clearColor];
    userTF.keyboardType = UIKeyboardTypeDefault;
    userTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    userTF.delegate = self;
    [self.view addSubview:userTF];
    
}

- (void)createPassView{
    //底层背景
    UIImageView *bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(20, kmainHeight/2.8+55, kmainWidth - 40, 43)];
    bgimg.layer.cornerRadius = 10.0;
    bgimg.layer.borderWidth = 1.65;
    bgimg.layer.borderColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1].CGColor;
    [bgimg.layer setMasksToBounds:YES];
    [self.view addSubview:bgimg];
    
    UIImageView *passIMG = [[UIImageView alloc] initWithFrame:CGRectMake(34, kmainHeight/2.8+55+8.5, 26, 26)];
    passIMG.image = [UIImage imageNamed:@"password.png"];
    [self.view addSubview:passIMG];
    
    UIImageView *gray = [[UIImageView alloc] initWithFrame:CGRectMake(77.5, kmainHeight/2.8+55+5, 2, 33)];
    gray.backgroundColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1];
    
    [self.view addSubview:gray];
    
    passTF = [[UITextField alloc] initWithFrame:CGRectMake(94, kmainHeight/2.8+55+5, kmainWidth-40-94, 33)];
    passTF.placeholder = @"请输入密码";
    passTF.backgroundColor = [UIColor clearColor];
    passTF.keyboardType = UIKeyboardTypeDefault;
    passTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passTF.delegate = self;
    [self.view addSubview:passTF];
    
    
    
    
}

- (void)createButtons{
    //登录按钮
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(20, kmainHeight/2+53, kmainWidth-40, 43)];
    loginButton.layer.cornerRadius = 10.0;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [loginButton addTarget:self action:@selector(denglu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    //注册按钮
    UIButton *regisButton = [[UIButton alloc] initWithFrame:CGRectMake(20, kmainHeight/2+53+3+43, 80, 30)];
    [regisButton setTitle:@"注册账号" forState:UIControlStateNormal];
    [regisButton setTitleColor:[UIColor colorWithRed:205.0f/255 green:201.0f/255 blue:201.0f/255 alpha:1] forState:UIControlStateNormal];
    [regisButton addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regisButton];
    
    
    
    
    //忘记密码
    UIButton *forget = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth-20-80, kmainHeight/2+53+3+43, 80, 30)];
    [forget setTitle:@"忘记密码 " forState:UIControlStateNormal];
    [forget setTitleColor:[UIColor colorWithRed:205.0f/255 green:201.0f/255 blue:201.0f/255 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:forget];
    
    
    
}






- (void)denglu{
    
    //获取输入帐号
    NSString *username = userTF.text;
    NSString *password = passTF.text;
    //请求的参数
    
    NSDictionary *parameters = @{@"telephone":username,
                                 @"pwd":password,
                                 @"type":@"3"};
    NSString *path = @"http://121.196.194.14/langyang/Home/User/login";
    
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    managers.securityPolicy.allowInvalidCertificates = YES;
    [managers POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"lp"] intValue] == 0) {
            
            NSString *string = [responseObject[@"data"] objectForKey:@"msg"];
            NSString *string1 = [[[responseObject[@"data"] objectForKey:@"list"] objectAtIndex:0] objectForKey:@"id"];
            NSLog(@"%@,%@",string,string1);

            //保存用户信息
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:username forKey:@"name"];
            [userDefaults setObject:password forKey:@"password"];
            [userDefaults setObject:string1 forKey:@"id"];
            [userDefaults synchronize];
            
            ListViewController *list = [[ListViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:list];
            [self presentViewController:navi animated:YES completion:nil];
        }else{
            return ;
        #warning 登陆不匹配，跳出提示框
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
    }];
    

}

- (void)zhuce{
    RegisterViewController *registerCtrl = [[RegisterViewController alloc] init];
    [self presentViewController:registerCtrl animated:YES completion:nil];
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
