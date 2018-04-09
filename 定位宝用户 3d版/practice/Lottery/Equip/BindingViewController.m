//
//  BindingViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/3/14.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "BindingViewController.h"

@interface BindingViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIScrollView *scrollView;
    UIView *carView;
    UIButton *typeButton;
    NSArray *typeArr;
    
    UITableView *table;
    BOOL isScroll;
}
@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"模块绑定";
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight)];
    scrollView.contentSize = CGSizeMake(kmainWidth, kmainHeight+300);
    scrollView.backgroundColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1];
    [self.view addSubview:scrollView];
    
    [self createCarView];
    [self createIdentifyView];
    [self createUserInfoView];
    
    
    
    typeArr = [NSArray arrayWithObjects:@"自行车",@"电动车",@"汽车",@"公交车", nil];
    //单击空白区域退出键盘代码
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:tap];
    isScroll = NO;
    
}

- (void)createIdentifyView{
    UIView *identifyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight*0.25)];
    identifyView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:identifyView];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"请输入身份证号:",@"请输入模块id号:", nil];
    for (int i = 0; i < 2; i++) {
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20+30*i, 200, 30)];
//        titleLabel.text = titleArr[i];
//        [identifyView addSubview:titleLabel];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        NSString *str = titleArr[i];
        CGSize textSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]}];
        
        label.frame = CGRectMake(20, 10+35*i, textSize.width, 30);
        label.text = str;
        label.font = [UIFont systemFontOfSize:16.0f];
       // label.backgroundColor = [UIColor redColor];
        [identifyView addSubview:label];
        
        UITextField *textfeild1 = [[UITextField alloc] initWithFrame:CGRectMake(label.frame.size.width+30, 10, kmainWidth-label.frame.size.width-50, 25)];
        [identifyView addSubview:textfeild1];
        textfeild1.backgroundColor = [UIColor redColor];
        
        
        
        UIView *line1;
        if (line1 == nil) {
            
            line1 = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+30, 35, kmainWidth-label.frame.size.width-50, 2)];
            line1.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
            [identifyView addSubview:line1];
        }
        
    }
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, 98, kmainWidth-40, 2)];
    line2.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [identifyView addSubview:line2];
    
    UITextField *textfeild2 = [[UITextField alloc] initWithFrame:CGRectMake(20, 73, kmainWidth-40-90, 25)];
    //textfeild2.backgroundColor = [UIColor redColor];
    [identifyView addSubview:textfeild2];
    
    
    
    
    //扫描按钮
    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake( kmainWidth-100, 68, 80, 25)];
    [scanButton setTitle:@"扫描获取" forState:UIControlStateNormal];
    scanButton.titleLabel.font = [UIFont systemFontOfSize:14];
    scanButton.backgroundColor = [UIColor colorWithRed:210.0f/255 green:210.0f/255 blue:210.0f/255 alpha:0.8];
    scanButton.layer.borderWidth = 1.2f;
    scanButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    scanButton.layer.cornerRadius = 10;
    [identifyView addSubview:scanButton];
    
    
    
    UIButton *identyButton = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth*0.65-20, identifyView.frame.size.height-40, kmainWidth*0.35, 32)];
    identyButton.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    identyButton.layer.cornerRadius = 10;
    [identyButton setTitle:@"点击验证" forState:UIControlStateNormal];
    [identifyView addSubview:identyButton];
    
    
    
}

- (void)createUserInfoView{
    
    UIView *InfoView = [[UIView alloc] initWithFrame:CGRectMake(0, kmainHeight*0.25+8, kmainWidth, kmainHeight*0.2)];
    InfoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:InfoView];
    
    NSArray *userArr = [NSArray arrayWithObjects:@"用户名:",@"手机号:",@"身份证号:",@"模块ID号:", nil];
    for (int i = 0; i < 4; i ++) {
        UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10+28*i, 200, 25)];
        userLabel.text = userArr[i];
        [InfoView addSubview:userLabel];
    }
    
    
    
    
    
}
- (void)createCarView{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kmainHeight*0.5-17, kmainWidth, 40)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"     助动车信息绑定";
    titleLabel.textColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [scrollView addSubview:titleLabel];
    
    carView = [[UIView alloc] initWithFrame:CGRectMake(0, kmainHeight*0.5+32, kmainWidth, kmainHeight*0.5+200)];
    carView.backgroundColor  = [UIColor whiteColor];
    [scrollView addSubview:carView];
    
    NSArray *leftArr = [NSArray arrayWithObjects:@"类型：",@"型号:",@"车牌号:",@"颜色:",@"上传图片（最好可看到车牌号）:", nil];
    for (int i = 0; i< 5; i++) {
//        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20+35*i, 300, 25)];
//        typeLabel.text = leftArr[i];
//        [carView addSubview:typeLabel];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        NSString *str = leftArr[i];
        CGSize textSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]}];
        
        label.frame = CGRectMake(20, 20+35*i, textSize.width, 30);
        label.text = str;
        label.font = [UIFont systemFontOfSize:16.0f];
        // label.backgroundColor = [UIColor redColor];
        [carView addSubview:label];
        
//        if (i!= 0 && i < 4) {
//            
//            UIView *line1 = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+30,10+ 35*(i+1), kmainWidth-label.frame.size.width-50, 1.5)];
//            line1.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
//            [carView addSubview:line1];
//        }
        
        if (i > 0 && i <4) {
            UITextField *textFeild3 = [[UITextField alloc] initWithFrame:CGRectMake(30+label.frame.size.width, 20+35*i, kmainWidth-50-label.frame.size.width, 23)];
            //textFeild3.backgroundColor = [UIColor redColor];
            [carView addSubview:textFeild3];
            textFeild3.delegate = self;
        }
        
        

    }
    
    
    //类型选择按钮
    typeButton = [[UIButton alloc] initWithFrame:CGRectMake(70, 18, 180, 30)];
    typeButton.layer.borderWidth = 1.5;
    typeButton.layer.borderColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1].CGColor;
    typeButton.layer.cornerRadius = 6;
    [typeButton setImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    typeButton.imageEdgeInsets = UIEdgeInsetsMake(6, 155, 6, 5);
    //typeButton.titleLabel.backgroundColor = [UIColor greenColor];
    typeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -120, 0, 0);
    [typeButton addTarget:self action:@selector(expandPickerView) forControlEvents:UIControlEventTouchUpInside];
    [carView addSubview:typeButton];
    
    
    
    
    
    
}

-(void)closeKeyboard:(id)sender{
    [self.view endEditing:YES];
}

- (void)expandPickerView{
    if (table == nil) {
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(70, 51, 180, 160) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        //tableView.backgroundColor = [UIColor colorWithRed:236.0f/255 green:236.0f/255 blue:236.0f/255 alpha:1];
        table.layer.borderWidth = 1.0;
        table.rowHeight = 40;
        table.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [carView addSubview:table];
    }
    
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identyID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identyID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identyID];
    }
    //cell.textLabel.frame = CGRectMake(10, 0, kmainWidth, 30);
    cell.textLabel.text = typeArr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.backgroundColor = [UIColor colorWithRed:240.0f/255 green:240.0f/255 blue:240.0f/255 alpha:0.6];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [typeButton setTitle:typeArr[indexPath.row] forState:UIControlStateNormal];
    [typeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [table removeFromSuperview];
    table = nil;
    
    
    
}


#pragma mark - UITextFeildDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
        
        //弹出键盘，实现上移
        [UIView animateWithDuration:0.6 animations:^{
            CGPoint contentOffset = scrollView.contentOffset;
            [scrollView setContentOffset:CGPointMake(contentOffset.x, contentOffset.y+216) animated:YES];
        }];
        isScroll = 1;
    
    
    
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //收回键盘，实现下移
    
    
    
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
