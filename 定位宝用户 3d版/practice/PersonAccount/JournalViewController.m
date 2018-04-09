//
//  JournalViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/10.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "JournalViewController.h"

@interface JournalViewController ()
{
    UIScrollView *scrollV;
}
@end

@implementation JournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight)];
    scrollV.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0/255 alpha:1];
    [self.view addSubview:scrollV];
    
    
    [self createLabels];
    
}

- (void)createLabels{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 10, 200, 50)];
    titleLabel.text = @"已完成订单";
    titleLabel.textColor = [UIColor grayColor];
    [scrollV addSubview:titleLabel];
    
    
#warning 创建多少取决于数据库中的返回值 i<array.count
    for (int i = 0; i < 2; i++) {
        UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(10, 50+i*(20+160), kmainWidth-20, 160)];
        detailView.backgroundColor = [UIColor whiteColor];
        detailView.layer.borderWidth = 1.5;
        detailView.layer.borderColor = [UIColor colorWithRed:205.0f/255 green:201.0f/255 blue:201.0/255 alpha:0.2].CGColor;
        [scrollV addSubview:detailView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(18, 15, 60, 30)];
        label1.text = @"助动车";
        [detailView addSubview:label1];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(38, 50, kmainWidth-20, 30)];
        label2.text = @"11月29日 23:07";
        [detailView addSubview:label2];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(38, 80, kmainWidth-20, 30)];
        label3.text = @"余杭区.五常街道.高教路海创园";
        [detailView addSubview:label3];
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(38, 110, kmainWidth-20, 30)];
        label4.text = @"余杭区良上线附近中共连具塘村委员会";
        [detailView addSubview:label4];
    }
    
    
    
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
