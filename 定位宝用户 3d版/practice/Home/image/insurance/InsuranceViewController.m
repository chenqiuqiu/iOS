//
//  InsuranceViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/25.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "InsuranceViewController.h"
#import "PriceViewController.h"

@interface InsuranceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *textArr;
    NSArray *detailTextArr;
}
@end

@implementation InsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朗阳专享车险";
    self.view.backgroundColor = [UIColor colorWithRed:240.0f/255 green:240.0f/255 blue:240.0f/255 alpha:1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, 230)];
    imageView.backgroundColor = [UIColor greenColor];
    imageView.image = [UIImage imageNamed:@"WechatIMG15.png"];
    
    [self.view addSubview:imageView];
 
    textArr = [NSArray arrayWithObjects:@"投保城市",@"车牌号",@"车主姓名", nil];
    detailTextArr = [NSArray arrayWithObjects:@"请选择投保城市",@"请完善车牌号码",@"请输入车辆所有人姓名", nil];
    [self createTableView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(25, 430, kmainWidth-50, 40)];
    button.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [button setTitle:@"察看报价" forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    [button addTarget:self action:@selector(getToPriceController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    [self chooseTheCompany];
    
}

- (void)createTableView{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(25, 260, kmainWidth-50, 150)];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 50;
    table.scrollEnabled = NO;
    [self.view addSubview:table];
    
    table.layer.cornerRadius = 10;
    table.layer.borderWidth = 1;
    table.layer.borderColor = [UIColor colorWithRed:207.0f/255 green:207.0f/255 blue:207.0f/255 alpha:1].CGColor;
    table.separatorColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1];
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
        cell.textLabel.text = textArr[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.text = detailTextArr[indexPath.row];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:207.0f/255 green:207.0f/255 blue:207.0f/255 alpha:1];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

//显示底部几大保险公司的图片
- (void)chooseTheCompany{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth/2-100, 520, 200, 15)];
    nameLabel.text = @"-报价后可选合作机构-";
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:nameLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 540, kmainWidth-50, kmainHeight-540-20-64)];
    imageView.backgroundColor = [UIColor greenColor];
    imageView.image = [UIImage imageNamed:@"baoxian2.png"];
    
    [self.view addSubview:imageView];
}

- (void)getToPriceController{
    PriceViewController *price = [[PriceViewController alloc] init];
    [self.navigationController pushViewController:price animated:YES];
    
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
