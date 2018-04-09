//
//  SecondViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/18.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "SecondViewController.h"
#import "AFNetworking.h"
#import "ThirdViewController.h"

@interface SecondViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITextView *textV;
    UILabel *placeholderLabel;
    UITableView *table;
    NSArray *titleArray;
    NSArray *detailArray;
    
    NSString *address;
    NSString *phoneNumber;
    NSString *latitudeStr;
    NSString *longitudeStr;
    NSString *mac;
    NSString *username;
    NSString *dateString;
    NSString *idcardStr;
    
    NSUserDefaults *userDefaults;
    
//    UIView *changeView;
//    UIToolbar *toolBar;
//    UITextField *nameTF;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要报警";
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255 green:248.0f/255 blue:255.0f/255 alpha:1];
    
        //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteReceived:) name:@"TextValueChanged" object:nil];
    
    [self setTextView];
   // [self addDetailInfo];
  //  [self addPictures];
    
    
    UIButton *alarmButton = [[UIButton alloc] initWithFrame:CGRectMake(10, kmainHeight-64-40-20, kmainWidth-20, 40)];
    alarmButton.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [alarmButton setTitle:@"立即报警" forState:UIControlStateNormal];
    alarmButton.layer.cornerRadius = 10;
    [alarmButton addTarget:self action:@selector(callPoliceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alarmButton];
    
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    [self watchInfo];
    [self addDetailInfo];
}

- (void)setTextView{
    textV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, 100)];
    textV.backgroundColor = [UIColor whiteColor];
    textV.font = [UIFont systemFontOfSize:16];
    textV.delegate = self;
    textV.layer.borderWidth = 2;
    textV.layer.borderColor = [UIColor colorWithRed:220.f/255 green:220.f/255 blue:220.f/255 alpha:0.5].CGColor;
    [self.view addSubview:textV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 300, 30)];
    placeholderLabel.font = [UIFont systemFontOfSize:18];
    placeholderLabel.text = @"填写详细信息（必填）";
    placeholderLabel.textColor = [UIColor lightGrayColor];
    placeholderLabel.alpha = 0.3;
    [textV addSubview:placeholderLabel];
    
    
}


#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [placeholderLabel removeFromSuperview];
    placeholderLabel = nil;
    
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return YES;
//}

- (void)closeKeyboard:(id)sender{
    [self.view endEditing:YES];
    if (textV.text.length == 0) {
         [self.view addSubview:placeholderLabel];
    }
   
}

- (void)noteReceived:(NSNotification *)note{
    
    
    address = note.object[2];
    latitudeStr = note.object[0];
    longitudeStr = note.object[1];
   
  //  [table reloadData];
    NSIndexPath *path = [NSIndexPath indexPathForRow:5 inSection:0];
    [table reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)watchInfo{
    NSString *idStr = [userDefaults objectForKey:@"id"];
    NSDictionary *parameters = @{@"id":idStr};
    NSString *path = @"http://121.196.194.14/langyang/Home/User/watchInfo";
    
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    managers.securityPolicy.allowInvalidCertificates = YES;
    [managers POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"lp"] intValue] == 0) {
            NSDictionary *dic2 = [[responseObject[@"data"] objectForKey:@"list"] objectAtIndex:0];
            username = dic2[@"realname"];
            idcardStr = dic2[@"idcardnumber"];
            NSLog(@"%@,%@",username,idcardStr);
            [table reloadData];
        }else{
            return ;

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
    }];
    

    
}




- (void)addDetailInfo{
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 115 , kmainWidth, kmainHeight-64-20-40-115-10)];
    table.delegate = self;
    table.dataSource = self;
   // table.scrollEnabled = NO;
    [self.view addSubview:table];
    table.layer.borderColor = [UIColor colorWithRed:220.0f/255 green:220.0f/255 blue:220.0f/255 alpha:0.5].CGColor;
    table.layer.borderWidth = 2;
    table.rowHeight = 65;
    

    
    
    titleArray = [NSArray arrayWithObjects:@"用户姓名",@"用户身份证号码",@"Mac名称",@"Mac类型",@"地区编码",@"地址",@"电话",@"报警时间", nil];

    //获取当前的时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateString = [formatter stringFromDate:[NSDate date]];
   
    
   // userDefaults = [NSUserDefaults standardUserDefaults];
    phoneNumber = [userDefaults objectForKey:@"name"];
   // userid = [userDefaults objectForKey:@"id"];
    mac = [userDefaults objectForKey:@"equip"];
  //  NSLog(@"%@,%@,%@",phoneNumber,address,mac);
    
    detailArray = [NSArray arrayWithObjects:@"",@"",mac,@"1",@"330110",@"",phoneNumber,dateString, nil];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    if (indexPath.row != 5 && indexPath.row != 0 &&indexPath.row != 1) {

        cell.detailTextLabel.text = detailArray[indexPath.row ];
    }else if(indexPath.row == 5){
        cell.detailTextLabel.text = address;
    }else if(indexPath.row == 0){
        if ([username isKindOfClass:[NSNull class]]) {
            cell.detailTextLabel.text = @"未填写";
        }else{
            cell.detailTextLabel.text = username;
        }
        }else{
            if ([username isKindOfClass:[NSNull class]]) {
                cell.detailTextLabel.text = @"未填写";
            }else{
                cell.detailTextLabel.text = idcardStr;
            }

        }

    return cell;
}
    


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = @"填写基本信息";
    return title;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    [self setChangeView:indexPath.row];
//    
//}

//- (void)setChangeView:(NSInteger)integer{
//    
//    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight)];
//    toolBar.barStyle = UIBarStyleBlackTranslucent;
//    toolBar.alpha = 0.6;
//    [self.view insertSubview:toolBar atIndex:4];
//
//    changeView = [[UIView alloc] initWithFrame:CGRectMake(kmainWidth/2-130, kmainHeight/2-150, 260, 150)];
//    changeView.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1];
//    changeView.alpha = 1;
//    changeView.layer.cornerRadius = 5;
//    [self.view insertSubview:changeView atIndex:5];
//    
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 150, 20)];
//    titleLabel.font = [UIFont systemFontOfSize:14];
//    titleLabel.textColor = [UIColor grayColor];
//    [changeView addSubview:titleLabel];
//    
//    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(18, 30, 224, 30)];
//    nameTF.layer.cornerRadius = 8;
//    nameTF.layer.borderWidth = 0.3;
//    nameTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
//    nameTF.backgroundColor = [UIColor whiteColor];
//    [changeView addSubview:nameTF];
//    
//    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 220, 30)];
//    
//    textLabel.numberOfLines = 4;
//    textLabel.font = [UIFont systemFontOfSize:12];
//    textLabel.textColor = [UIColor grayColor];
//    [changeView addSubview:textLabel];
//    
//    UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 110, 105, 25)];
//    [checkButton setTitle:@"确认" forState:UIControlStateNormal];
//    [checkButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    checkButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    checkButton.backgroundColor = [UIColor whiteColor];
//    checkButton.layer.borderWidth = 0.3;
//    checkButton.layer.cornerRadius = 8;
//    checkButton.layer.borderColor =[UIColor lightGrayColor].CGColor;
//    [changeView addSubview:checkButton];
//    checkButton.tag = 101;
//    
//    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(137, 110, 105, 25)];
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    cancelButton.backgroundColor = [UIColor whiteColor];
//    cancelButton.layer.borderWidth = 0.3;
//    cancelButton.layer.borderColor =[UIColor lightGrayColor].CGColor;
//    cancelButton.layer.cornerRadius = 8;
//    [changeView addSubview:cancelButton];
//    cancelButton.tag = 102;
//    
//    
//    if (integer == 0) {
//        titleLabel.text = @"填入真实姓名";
//        textLabel.text = @"请确保您输入的姓名与您身份证上的姓名一致，方便警察管理，谢谢合作！";
//        [checkButton addTarget:self action:@selector(goActionButton:) forControlEvents:UIControlEventTouchUpInside];
//        [cancelButton addTarget:self action:@selector(goActionButton:) forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        titleLabel.text = @"填入身份证号";
//        textLabel.text = @"请确保您输入的身份证号与您身份证上的号码一致，方便警察管理，谢谢合作！";
//        [checkButton addTarget:self action:@selector(changeIDCardAction:) forControlEvents:UIControlEventTouchUpInside];
//        [cancelButton addTarget:self action:@selector(changeIDCardAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//}
////两个button的动作
//- (void)goActionButton:(UIButton *)sender{
//    if (sender.tag == 101) {
//            username = nameTF.text;
//            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//            [table reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//
//    }
//    [toolBar removeFromSuperview];
//    toolBar = nil;
//    
//    [changeView removeFromSuperview];
//    changeView = nil;
//    
//}
//- (void)changeIDCardAction:(UIButton *)sender{
//     if (sender.tag == 101) {
//         idcardStr = nameTF.text;
//         NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
//         [table reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//    }
//    [toolBar removeFromSuperview];
//    toolBar = nil;
//    
//    [changeView removeFromSuperview];
//    changeView = nil;
//}



- (void)callPoliceAction{
    NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",username,idcardStr,mac,textV.text,longitudeStr,latitudeStr,address,phoneNumber);
    NSDictionary *parameters = @{@"realname":username,
                                     @"idcard_number":idcardStr,
                                     @"mac":mac,
                                 @"device_type":@"1",
                                     @"message":textV.text,
                                     @"adcode":@"330110",
                                     @"longitude":longitudeStr,
                                     @"latitude":latitudeStr,
                                     @"address":address,
                                     @"telephone":phoneNumber,
                                 @"heppen_time":dateString};
    NSString *path = @"http://121.196.194.14/langyang/Home/User/giveAlarm";
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    [managers POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([[responseObject objectForKey:@"lp"] intValue] == 0) {
            
            UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
            back.title = @"返回";
            self.navigationItem.backBarButtonItem = back;
            
            ThirdViewController *third = [[ThirdViewController alloc] init];
            [self.navigationController pushViewController:third animated:YES];
        }else{
            
            NSLog(@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]);
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
 
    
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
