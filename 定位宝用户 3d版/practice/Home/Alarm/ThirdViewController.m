//
//  ThirdViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/3/2.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "ThirdViewController.h"
#import "BezierView.h"

@interface ThirdViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *button1;
    UIButton *button2;
    UIView *moveView;
    UITableView *table;
    
    UIScrollView *scrollView;
    UIButton *finishButton;
}
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBar];
   
    [self createMissionDetail];
    [self setScrollView];
    
    
    
    
}



- (void)createNavigationBar{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, 64)];
//    topView.layer.shadowColor = [UIColor blackColor].CGColor;
//    topView.layer.shadowOffset = CGSizeMake(3, 3);
//    topView.layer.shadowOpacity = 0.6;
//    topView.layer.shadowRadius = 4;
//    topView.backgroundColor = [UIColor redColor];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 62, kmainWidth, 2)];
    topLine.backgroundColor = [UIColor lightGrayColor];
   // [topView addSubview:topLine];
    [self.view addSubview:topView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 70, 40)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1] forState:UIControlStateNormal];
    //backButton.backgroundColor = [UIColor greenColor];
    [backButton setImage:[UIImage imageNamed:@"返回red.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popToHome) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth/2-40, 20, 80, 40)];
    titleLabel.text = @"警报中心";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    [topView addSubview:titleLabel];
    
    
    
}





- (void)popToHome{
    NSMutableArray *vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSLog(@"%@",vcArr);
    for (int i = 0; i < vcArr.count-1; i++) {
        
        [vcArr removeObjectAtIndex:1];
    }
   
    self.navigationController.viewControllers = vcArr;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createMissionDetail{
    button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, kmainWidth/2, 30)];
    [button1 setTitle:@"处理状态" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(twoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 100;
    
    button2 = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth/2, 64, kmainWidth/2, 30)];
    [button2 setTitle:@"报警详情" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(twoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 101;
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 32+64, kmainWidth, 1)];
    line1.backgroundColor = [UIColor colorWithRed:220.0f/255 green:220.0f/255 blue:220.0f/255 alpha:1];
    [self.view addSubview:line1];
    
    moveView = [[UIView alloc] initWithFrame:CGRectMake(0, 30+64, kmainWidth/2, 2)];
    moveView.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [self.view addSubview:moveView];
    
 
}

- (void)twoButtonAction:(UIButton *)sender{
    if (sender.tag == 100) {
        [table removeFromSuperview];
        table= nil;
        
        if (scrollView == nil) {
            [self setScrollView];
        }
        [button1 setTitleColor:[UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1] forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3 animations:^{
            moveView.frame = CGRectMake(0, 94, kmainWidth/2, 2);
        }];
    }else{
        [button2 setTitleColor:[UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            moveView.frame = CGRectMake(kmainWidth/2, 94, kmainWidth/2, 2);
        }];
        
        [scrollView removeFromSuperview];
        scrollView = nil;
        [finishButton removeFromSuperview];
        finishButton = nil;
        
        [self setTableView];
        
        
        
    }
    
    
    
}

- (void)setScrollView{
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 96, kmainWidth, kmainHeight - 32-40-64)];
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(kmainWidth, kmainHeight+50);
    
    
    //完成按钮
    finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kmainHeight-40, kmainWidth, 40)];
    [finishButton setTitle:@"确认完成" forState:UIControlStateNormal];
    finishButton.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [self.view addSubview:finishButton];
    
    
    
    //旁边的进程线
    CGRect frame = CGRectMake(30, 50, 60, kmainHeight);
    BezierView *bezier = [[BezierView alloc] initWithFrame:frame];
    bezier.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:bezier];
    
    
    NSArray *bigArr = [NSArray arrayWithObjects:@"警报已提交",@"信息已发送",@"警方已接受任务",@"警方正在处理",@"处理完成", nil];
    NSArray *smallArr = [NSArray arrayWithObjects:@"处理中心正在处理",@"请耐心等待警方确认",@"警方收到任务，等待处理",@"警务人员已出勤", @"",nil];
    for (int i = 0; i < 5; i ++) {
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(60, 100+100*i, kmainWidth-60, 2)];
        line.backgroundColor = [UIColor colorWithRed:240.0f/255 green:240.0f/255 blue:240.0f/255 alpha:1];
        [scrollView addSubview:line];
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(65, 30+100*i, 250, 20)];
        label1.text = bigArr[i];
        [scrollView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(65, 60+100*i, 300, 20)];
        label2.text = smallArr[i];
        label2.textColor = [UIColor grayColor];
        label2.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:label2];
        
    }
    
    
}


- (void)setTableView{
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 96, kmainWidth, kmainHeight - 32-40-64) style:UITableViewStyleGrouped] ;
    [self.view addSubview:table];
    table.delegate = self;
    table.dataSource = self;
    //table.backgroundColor = [UIColor]
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (section == 0) {
        number = 5;
    }else if (section == 1){
        number = 2;
    }else{
        number = 3;
    }
    return number;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *name = nil;
    switch (section) {
        case 0:
            name = @"报警详情";
            break;
        case 1:
            name = @"处理进度";
            break;
        case 2:
            name = @"报警信息";
            break;
        default:
            break;
    }
    return name;
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
