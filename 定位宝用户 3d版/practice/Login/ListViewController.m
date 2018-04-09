//
//  ListViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/9.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "ListViewController.h"
#import "baseViewController.h"
#import "ScanViewController.h"
#import "AFNetworking.h"
@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tbView;
    NSString *equipName;
    
    NSArray *macArr;
    NSArray *tongrenArr;
    
}
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备选择";
   // self.navigationController.navigationBar.tintColor = [UIColor whiteColor];设置按钮的颜色的
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [self netWorking];
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight-80) style:UITableViewStylePlain];
    tbView.rowHeight = kmainHeight/9;
    [self.view addSubview:tbView];
    tbView.delegate = self;
    tbView.dataSource = self;

    
    [self createDeviceButton];
    
   tongrenArr  = @[@"10000071",
                @"10000072",
                @"10000073",
                @"10000074",
                @"10000075",
                @"10000076",
                @"10000077",
                @"10000078",
                @"10000079",
                @"1000007A",
                @"1000007B",
                @"1000007C",
                @"1000007D",
                @"1000007E"];
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];//设置按钮的颜色的
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];

}

//获取个人列表
- (void)netWorking{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:@"id"];
    NSLog(@"%@",userID);
    NSDictionary *parameters = @{@"userid":userID};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   
    
    [manager POST:@"http://121.196.194.14/langyang/Home/User/getDeviceList" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"lp"]] isEqualToString:@"1"]) {
            return;
        }else{
            
            macArr = responseObject[@"data"][@"list"];
            NSLog(@"%@",macArr);
            
            [tbView reloadData];
            [userDefaults setObject:macArr forKey:@"macArr"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
   
}

- (void)createDeviceButton{
    
    UIButton *deviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth/2-100, kmainHeight-65, 200, 50)];
    [deviceBtn setTitle:@"录入设备" forState:UIControlStateNormal];
    deviceBtn.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    deviceBtn.layer.cornerRadius = 10.0;
    [deviceBtn addTarget:self action:@selector(gotoDevice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deviceBtn];
    
}
- (void)gotoDevice{
    ScanViewController *scan = [[ScanViewController alloc] init];
    [self.navigationController pushViewController:scan animated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    NSLog(@"%li",macArr.count);
//    return macArr.count;
    
    return 14;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
//    cell.textLabel.text = [macArr[indexPath.row] objectForKey:@"mac"] ;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",tongrenArr[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    baseViewController *base = [[baseViewController alloc] init];
    [self.navigationController pushViewController:base animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //添加绑定的设备数据；
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cell.textLabel.text forKey:@"equip"];
    NSLog(@"%@",userDefaults);
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
