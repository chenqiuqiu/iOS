//
//  SettingViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/22.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "AFNetworking.h"

@interface SettingViewController ()<UIGestureRecognizerDelegate>
{
    NSUserDefaults *userDefaults;
    NSDictionary *userdic;
    
    UIView *whiteView;
    UIToolbar *toolbar;
    UIButton *confirmButton;
    UILabel *titleLabel;
    UITextField *textFeild;
    
    UILabel *maleLabel;
    UILabel *femaleLabel;
    
}
@property (weak, nonatomic) IBOutlet UILabel *favorName;

@property (weak, nonatomic) IBOutlet UILabel *pswLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *idcardLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsSelection = YES;
   // [self showUserInfo];
    [self getPersonInfo];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [userDefaults objectForKey:@"iconimageView"];
    UIImage *iconImage = [UIImage imageWithData:imageData];
    _iconImageView.image = iconImage;
    
    //监听头像通知的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseToNotification:) name:@"Notification" object:nil];
}
- (void)responseToNotification:(NSNotification *)notification{
    NSDictionary *dic = [notification userInfo];
    
    _iconImageView.image = dic[@"iconImage"];
    
    NSData *imageData = UIImageJPEGRepresentation(_iconImageView.image, 0.8);
   [userDefaults setObject:imageData forKey:@"iconimageView"];
    
}
//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}


//- (void)showUserInfo{
//       if ([userdic[@"address"] isKindOfClass:[NSNull class]]) {
//           _birthLabel.text = @"未填写";
//          // _favorName.text = @"未填写";
//          
//           _sexLabel.text = @"未填写";
//           _phoneLabel.text = @"未填写";
//           _favorName.text = userdic[@"username"];
//           NSLog(@"%@",_favorName.text);
//        //   _idcardLabel.text = @"未填写";
//       }else{
//        
//        _birthLabel.text =[NSString stringWithFormat:@"%@",userdic[@"birthday"]];
//        
//        NSString *sexString =[NSString stringWithFormat:@"%@",userdic[@"sex"]];
//           if ([sexString intValue] == 0) {
//               _sexLabel.text = @"男";
//           }else{
//               _sexLabel.text = @"女";
//           }
//        _phoneLabel.text = [NSString stringWithFormat:@"%@",userdic[@"telephone"]];
//        _idcardLabel.text = [NSString stringWithFormat:@"%@",userdic[@"idcardnumber"]];
//        _favorName.text = [NSString stringWithFormat:@"%@",userdic[@"username"]];
//    }
//    [self.tableView reloadData];
//}
//
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 50;
    }else{
        return 10;
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.row) {
        case 0:
        {
//            if (indexPath.section == 1) {
//                [self createChangeView];
//                textFeild.text = _name.text;
//                titleLabel.text = @"修改用户名";
//                [confirmButton addTarget:self action:@selector(changeName) forControlEvents:UIControlEventTouchUpInside];
//            }
             if(indexPath.section == 2)
           {
                userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults removeObjectForKey:@"name"];
                [userDefaults removeObjectForKey:@"password"];
                [userDefaults synchronize];
                
                LoginViewController *login = [[LoginViewController alloc] init];
                [self presentViewController:login animated:YES completion:nil];
           }
            }
            break;
            
            case 1:
        {
            if (indexPath.section == 0) {
    
                [self createChangeView];
                textFeild.text = _favorName.text;
                titleLabel.text = @"修改昵称";
                [confirmButton addTarget:self action:@selector(changeInfoAction) forControlEvents:UIControlEventTouchUpInside];


            }else{
                [self sexSelector];
            }
            break;
            
        }
            
        
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//
- (void)createChangeView{
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(kmainWidth/2-130, kmainHeight/2-64-50, 260, 100)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.alpha = 0.6;
    [self.view insertSubview:toolbar belowSubview:whiteView];
    
    textFeild = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, 240, 20)];
    //textFeild.text = _favorName.text;
    [whiteView addSubview:textFeild];
    textFeild.font = [UIFont systemFontOfSize:13];
    textFeild.clearButtonMode = UITextFieldViewModeAlways;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
   // titleLabel.text = @"修改昵称";
    [whiteView addSubview:titleLabel];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 237, 2)];
    line.backgroundColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1];
    [whiteView addSubview:line];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 70, 50, 25)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(removeChangeView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [whiteView addSubview:cancelButton];
    
    
    confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 70, 50, 25)];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [confirmButton addTarget:self action:@selector(removeChangeView) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:confirmButton];
    
}

- (void)closeKeyboard:(id)sender{
    [self.view endEditing:YES];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}


- (void)removeChangeView{
    
    [whiteView removeFromSuperview];
    [toolbar removeFromSuperview];
}

- (void)changeInfoAction{
    _favorName.text = textFeild.text;
//    if (![_favorName.text isEqualToString:userdic[@"username"]]) {
//        [self updatePersonalInfo];
//    }
}

- (void)sexSelector{
    self.tableView.scrollEnabled = NO;
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(kmainWidth/2-130, kmainHeight/2-64-50, 260, 62)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.alpha = 0.6;
    [self.view insertSubview:toolbar belowSubview:whiteView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 260, 2)];
    line.backgroundColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1];
    [whiteView addSubview:line];
    
    maleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, whiteView.frame.size.width, whiteView.frame.size.height/2)];
    maleLabel.text = @"男";
    maleLabel.userInteractionEnabled = YES;
    maleLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:maleLabel];
    femaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, 260, 30)];
    femaleLabel.text = @"女";
    femaleLabel.userInteractionEnabled = YES;
    femaleLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:femaleLabel];
    
    UIButton *male = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, whiteView.frame.size.width, whiteView.frame.size.height/2)];
    male.tag = 101;
    [male addTarget:self action:@selector(sexmaleAction:) forControlEvents:UIControlEventTouchUpInside];
    [maleLabel addSubview:male];
    
    UIButton *female = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    female.tag = 102;
    [female addTarget:self action:@selector(sexmaleAction:) forControlEvents:UIControlEventTouchUpInside];
    [femaleLabel addSubview:female];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeChangeView)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];


}
//
- (void)sexmaleAction:(UIButton *)sender{
    if (sender.tag == 101) {
        _sexLabel.text = maleLabel.text;
        
    }else{
        _sexLabel.text = femaleLabel.text;
    }
    [self updatePersonalInfo];
    
    [self removeChangeView];
}








- (void)getPersonInfo{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:@"id"];
    
    NSDictionary *parameters = @{@"id":userID};
    NSString *path = @"http://121.196.194.14/langyang/Home/User/watchInfo";
    
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    managers.securityPolicy.allowInvalidCertificates = YES;
    [managers POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    }
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
               NSLog(@"%@",responseObject);
               //userdic = [[responseObject[@"data"] objectForKey:@"list"] objectAtIndex:0];
              // [self showUserInfo];
           }
           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               NSLog(@"失败%@",error);
           }];
    }


- (void)updatePersonalInfo{
   
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:@"id"];
    NSLog(@"%@",_sexLabel.text);
    NSInteger i = 0;
    if ([_sexLabel.text isEqualToString:@"男"]) {
        i = 0;
    }else{
        i = 1;
    }
    NSDictionary *parameters = @{@"id":userID,
                                 @"sex":[NSString stringWithFormat:@"%li",i],
                                 @"telephone":_phoneLabel.text,
                                 @"realname":@"",
                                @"idcardnumber":_idcardLabel.text,
                                @"birthday":_birthLabel.text,
                                @"address":@"",};
    NSString *path = @"http://121.196.194.14/langyang/Home/compeleteInfo";
    
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    managers.securityPolicy.allowInvalidCertificates = YES;
    [managers POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    }
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
               NSLog(@"%@",responseObject);
              
           }
           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               NSLog(@"失败%@",error);
           }];
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
