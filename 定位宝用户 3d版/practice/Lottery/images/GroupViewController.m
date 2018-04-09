//
//  GroupViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/3/10.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "GroupViewController.h"

@interface GroupViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *labelArr;
    NSArray *imageArr;
    
    UITextField *textFeild;
}
@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.title = @"群组";
    self.view.backgroundColor = [UIColor colorWithRed:240.0f/255 green:240.0f/255 blue:240.0f/255 alpha:1];
    [self createViews];
    
    
    
    //添加导航栏右侧按钮
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 28)];
    bgView.backgroundColor = [UIColor colorWithRed:105.0f/255 green:105.0f/255 blue:105.0f/255 alpha:0.6];
    bgView.layer.cornerRadius = 10;
    textFeild = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, 130, 28)];
    textFeild.placeholder = @"搜索";
    textFeild.tintColor = [UIColor whiteColor];
    [textFeild setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textFeild setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    textFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFeild.textColor = [UIColor whiteColor];
    [bgView addSubview:textFeild];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -8, 15, 15)];
    imageView.image = [UIImage imageNamed:@"搜索-搜索"];
   // imageView.contentMode = UIViewContentModeCenter;
    textFeild.rightView = imageView;
    textFeild.rightViewMode = UITextFieldViewModeAlways;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    //单击空白区域退出键盘代码
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:tap];
    
    
    
    //做分组列表
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 90, kmainWidth-20, kmainHeight/3-20)];
    scrollView.contentSize = CGSizeMake(kmainWidth-40, kmainHeight/3-20);
    [self.view addSubview:scrollView];
    
    NSArray *imgArr = [NSArray arrayWithObjects:@"家人.jpg",@"朋友.jpeg",@"工作.jpeg", nil];
    NSArray *textArr = [NSArray arrayWithObjects:@"家庭圈",@"朋友圈",@"工作圈", nil];
    for (int i = 0; i < 3; i++) {
        UIView *groupView = [[UIView alloc] initWithFrame:CGRectMake(((kmainWidth-20-16)/3+8)*i, 0, (kmainWidth-20-16)/3, scrollView.frame.size.height)];
        groupView.backgroundColor = [UIColor colorWithRed:230.0f/255 green:230.0f/255 blue:230.0f/255 alpha:1];
        [scrollView addSubview:groupView];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, groupView.frame.size.width, groupView.frame.size.height/2)];
        imgView.image = [UIImage imageNamed:imgArr[i]];
        [groupView addSubview:imgView];
        //添加按钮
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(groupView.frame.size.width/2-20, groupView.frame.size.height/2+20, 40, 40)];
        [addButton setImage:[UIImage imageNamed:@"增加按钮.png"] forState:UIControlStateNormal];
        [groupView addSubview:addButton];
        
        //label
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(groupView.frame.size.width/2-50, groupView.frame.size.height-30, 100, 30)];
        textLabel.text = textArr[i];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel.textColor = [UIColor lightGrayColor];
        [groupView addSubview:textLabel];
        
    }
    
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kmainHeight/3+90, kmainWidth, 30)];
    middleLabel.text = @"查看 定位｜轨迹｜设备";
    middleLabel.textAlignment = NSTextAlignmentCenter;
    middleLabel.textColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [self.view addSubview:middleLabel];
    
    UILabel *smaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kmainHeight/3+100+20, kmainWidth, 30)];
    smaLabel.text = @"实时关注家人的足迹，保障家人的安全";
    smaLabel.font = [UIFont systemFontOfSize:14];
    smaLabel.textColor = [UIColor grayColor];
    smaLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:smaLabel];
    
    
}

- (void)closeKeyboard:(id)sender{
    [textFeild resignFirstResponder];
    
    [textFeild endEditing:YES];
}





- (void)createViews{
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth/2-50, 10, 100, 30)];
    label1.font = [UIFont systemFontOfSize:20];
    label1.textColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    label1.text = @"群组  共享";
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth/2-100, 45, 200, 20)];
    label2.text = @"定位 共享  ｜  紧急 联系人";
    label2.textColor = [UIColor grayColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label2];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kmainHeight/3+170, kmainWidth-20, kmainHeight-64-kmainHeight/3-200-20)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.layer.cornerRadius = 10.0;
    [self.view addSubview:tableView];
   
    labelArr = [NSArray arrayWithObjects:@"查看家庭圈的成员",@"查看朋友圈的成员",@"查看工作组的成员", nil];
    imageArr = [NSArray arrayWithObjects:@"80.png",@"20.png",@"59.png", nil];
    tableView.rowHeight = (kmainHeight-64-kmainHeight/3-200-20)/labelArr.count;
    if (labelArr.count == 3) {
        tableView.scrollEnabled = NO;
    }else{
        tableView.scrollEnabled = YES;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //几个分组；
    return labelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = labelArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.backgroundColor = [UIColor colorWithRed:230.0f/255 green:230.0f/255 blue:230.0f/255 alpha:1];
       // cell.backgroundColor = [UIColor whiteColor];
    }
    cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, [UIScreen mainScreen].scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, 30, 30);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    accessoryView.image = [UIImage imageNamed:@"箭头2.png"];
    cell.accessoryView = accessoryView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
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
