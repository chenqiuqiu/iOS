//
//  RegisterViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/9.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworking.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    UITextField *userTF;
    UITextField *passTF;
    UITextField *passTF2;
    UILabel *warnLabel;
    NSTimer *timer;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createButtons];
    [self createPassView];
    [self createUsernameView];
    
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
    UIImageView *bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(20, kmainHeight/3.5, kmainWidth - 40, 43)];
    bgimg.layer.cornerRadius = 10.0;
    bgimg.layer.borderWidth = 1.65;
    bgimg.layer.borderColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1].CGColor;
    [bgimg.layer setMasksToBounds:YES];
    [self.view addSubview:bgimg];
    
    //+86
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, kmainHeight/3.5+2, 39, 39)];
    label1.text = @"+86";
    label1.textColor = [UIColor redColor];
    [self.view addSubview:label1];
    
    UIImageView *gray = [[UIImageView alloc] initWithFrame:CGRectMake(77.5, kmainHeight/3.5+5, 2, 33)];
    gray.backgroundColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1];
    
    [self.view addSubview:gray];
    
    userTF = [[UITextField alloc] initWithFrame:CGRectMake(94, kmainHeight/3.5+5,kmainWidth-40-94 , 33)];
    userTF.placeholder = @"请输入手机号";
    userTF.backgroundColor = [UIColor clearColor];
    userTF.keyboardType = UIKeyboardTypeDefault;
    userTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    userTF.delegate = self;
    [self.view addSubview:userTF];
    
}

- (void)createPassView{
    //底层背景
    UIImageView *bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(20, kmainHeight/3.5+55, kmainWidth - 40, 43)];
    bgimg.layer.cornerRadius = 10.0;
    bgimg.layer.borderWidth = 1.65;
    bgimg.layer.borderColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1].CGColor;
    [bgimg.layer setMasksToBounds:YES];
    [self.view addSubview:bgimg];
    
    UIImageView *passIMG = [[UIImageView alloc] initWithFrame:CGRectMake(34, kmainHeight/3.5+55+8.5, 26, 26)];
    passIMG.image = [UIImage imageNamed:@"password.png"];
    [self.view addSubview:passIMG];
    
    UIImageView *gray = [[UIImageView alloc] initWithFrame:CGRectMake(77.5, kmainHeight/3.5+55+5, 2, 33)];
    gray.backgroundColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1];
    
    [self.view addSubview:gray];
    
    passTF = [[UITextField alloc] initWithFrame:CGRectMake(94, kmainHeight/3.5+55+5, kmainWidth-40-94, 33)];
    passTF.placeholder = @"请输入密码";
    passTF.backgroundColor = [UIColor clearColor];
    passTF.keyboardType = UIKeyboardTypeDefault;
    passTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passTF.delegate = self;
    [self.view addSubview:passTF];
    
    
    
    UIImageView *bgimg2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, kmainHeight/3.5+55+58, kmainWidth - 40, 43)];
    bgimg2.layer.cornerRadius = 10.0;
    bgimg2.layer.borderWidth = 1.65;
    bgimg2.layer.borderColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1].CGColor;
    [bgimg.layer setMasksToBounds:YES];
    [self.view addSubview:bgimg2];
    
    UIImageView *passIMG2 = [[UIImageView alloc] initWithFrame:CGRectMake(34, kmainHeight/3.5+55+8.5+58, 26, 26)];
    passIMG2.image = [UIImage imageNamed:@"password.png"];
    [self.view addSubview:passIMG2];
    
    UIImageView *gray2 = [[UIImageView alloc] initWithFrame:CGRectMake(77.5, kmainHeight/3.5+55+5+58, 2, 33)];
    gray2.backgroundColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1];
    
    [self.view addSubview:gray2];
    
    passTF2 = [[UITextField alloc] initWithFrame:CGRectMake(94, kmainHeight/3.5+55+5+58, kmainWidth-40-94, 33)];
    passTF2.placeholder = @"请重新输入密码";
    passTF2.backgroundColor = [UIColor clearColor];
    passTF2.keyboardType = UIKeyboardTypeDefault;
    passTF2.clearButtonMode = UITextFieldViewModeWhileEditing;
    passTF2.delegate = self;
    [self.view addSubview:passTF2];
    
}

- (void)createButtons{
    //登录按钮
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(20, kmainHeight/2+53, kmainWidth-40, 43)];
    loginButton.layer.cornerRadius = 10.0;
    [loginButton setTitle:@"注册" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [loginButton addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth/2-75, kmainHeight-50, 150, 30)];
    [backButton setTitle:@"返回登陆界面" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:13];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [backButton addTarget:self action:@selector(backLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}

- (void)backLoginAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)zhuce{
    
    //获取输入帐号
    NSString *username = userTF.text;
    NSString *password = passTF.text;
    NSString *repassword = passTF2.text;
    
    if (![password isEqualToString:repassword])
    {
        warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth/2-45, kmainHeight/2-64, 90, 40)];
        warnLabel.text = @"密码不一致";
        warnLabel.backgroundColor = [UIColor blackColor];
        warnLabel.layer.cornerRadius = 10;
        warnLabel.alpha = 0.3;
        warnLabel.clipsToBounds = YES;
        warnLabel.textAlignment = NSTextAlignmentCenter;
        [self.view insertSubview:warnLabel atIndex:10];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(delete) userInfo:nil repeats:NO];
    }
    else if(username.length == 0 || username.length == 0)
    {
        warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth/2-80, kmainHeight/2-64, 160, 40)];
        warnLabel.text = @"账号或密码不能为空";
        warnLabel.textColor = [UIColor whiteColor];
        warnLabel.backgroundColor = [UIColor blackColor];
        warnLabel.alpha = 0.3;
        warnLabel.layer.cornerRadius = 10;
        warnLabel.clipsToBounds = YES;
        warnLabel.textAlignment = NSTextAlignmentCenter;
        [self.view insertSubview:warnLabel atIndex:10];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(delete) userInfo:nil repeats:NO];
        
    }else{
        NSDictionary *parameters = @{@"telephone":username,
                                     @"pwd":password,
                                     @"type":@"3"};
        NSLog(@"%@",parameters);
        NSString *path = @"http://121.196.194.14/langyang/Home/User/register";
        
        
        AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
        managers.securityPolicy.allowInvalidCertificates = YES;
        [managers POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"response:%@",responseObject);
            
            if ([responseObject[@"lp"] intValue] == 0) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                return ;
                
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败%@",error);
        }];
        
    }
    
    
}

- (void)delete{
    
    [warnLabel removeFromSuperview];
}


- (void)dealloc{
    [timer invalidate];
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
