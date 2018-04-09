//
//  CustomServicesController.m
//  practice
//
//  Created by 陈彦彤 on 17/2/3.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "CustomServicesController.h"

@interface CustomServicesController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    NSArray *cellArr;
    NSArray *fulitextArr;
    NSArray *fuliImgArr;
}
@end

@implementation CustomServicesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的客服";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    [self createTextFeild];
    
    cellArr = [NSArray arrayWithObjects:@"如何修改绑定的手机号",@"如何修改姓名或证件号码",@"查询身份证名下账户",@"实名认证有有效期吗",@"负面纪录的审核", nil];
    fulitextArr = [NSArray arrayWithObjects:@"[解密]你的信用这么高，究竟能做什么？",@"获得赠送的彩票怎么使用？",@"2017年给你福利第一波，你的车子上险了吗？", nil];
}

- (void)createTableView{
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight-64-120) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else{
    return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    static NSString *cellID2 = @"cellTwo";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID2];
    
     if (indexPath.section == 0) {
         if (cell1 == nil) {
             cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
             cell1.detailTextLabel.text = cellArr[indexPath.row];
             
          }
         return cell1;
        }else{
            if (cell2 == nil) {
                cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
                cell2.textLabel.text = fulitextArr[indexPath.row];
                cell2.textLabel.numberOfLines = 2;
                cell2.imageView.image = [UIImage imageNamed:@"篮子"];
                
            }
            return cell2;
        }
    
    
    }
    



//设置表示图的头
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *string;
    if (section == 0) {
        string = @"猜你想问";
    }else{
        string = @"福利咨讯";
    }
    return string;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }else{return 80;}
}




- (void)createTextFeild{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kmainHeight-64-120, kmainWidth, 120)];
    bgView.backgroundColor = [UIColor colorWithRed:220.0f/255 green:220.0f/255 blue:220.0f/255 alpha:0.5];
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:bgView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 20)];
    textLabel.text = @"您想要：";
    textLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:textLabel];
    
    //三个按钮
    NSArray *titleArr = [NSArray arrayWithObjects:@"自助工具",@"查设备",@"查进度", nil];
    for (int i = 0; i < 3; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(70+75*i, 8, 70, 30)];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.layer.cornerRadius = 15;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:button];
        button.tag = i;
    }
    
    UITextField *textfeild = [[UITextField alloc] initWithFrame:CGRectMake(10, 47, kmainWidth-20, 40)];
    textfeild.backgroundColor = [UIColor whiteColor];
    textfeild.layer.borderWidth = 1;
    textfeild.layer.borderColor = [UIColor colorWithRed:220.0f/255 green:220.0f/255 blue:220.0f/255 alpha:1].CGColor;
    textfeild.delegate = self;
    textfeild.borderStyle = UITextBorderStyleRoundedRect;
    textfeild.placeholder = @"有其他的需要，点此问我";
    [bgView addSubview:textfeild];
    
    //左边显示编辑图片
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    [View addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"编辑.png"];
    textfeild.leftView = View;
    textfeild.leftViewMode = UITextFieldViewModeAlways;

    
    //设置发送消息按钮
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(15, 8, 50, 25)];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor lightGrayColor];
    button.layer.cornerRadius = 8;
    [buttonView addSubview:button];
    textfeild.rightView = buttonView;
    textfeild.rightViewMode = UITextFieldViewModeAlways;

    
    //单击空白区域退出键盘代码
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];

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

#pragma mark - UITextFeildDelegate
//实现弹出键盘时，输入框上移
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y+216+50+120+64);
    NSLog(@"偏移高度 －－－%f",offset);
    if (offset > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = -offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}
//回收键盘时，输入框回到原来的位置
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 64;
        self.view.frame = frame;
    }];
    return YES;
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
