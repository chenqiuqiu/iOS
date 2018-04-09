//
//  PriceViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/2/7.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "PriceViewController.h"

@interface PriceViewController ()
{
    UIView *firstView;
    UIView *secondView;
}

@end

@implementation PriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"保险报价";
    
    //做滚动视图
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight-64)];
    scroll.backgroundColor = [UIColor colorWithRed:240.0f/255 green:240.0f/255 blue:240.0f/255 alpha:1];
    [self.view addSubview:scroll];
    scroll.contentSize = CGSizeMake(kmainWidth, kmainHeight*1.5);

    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight*2/3)];
    firstView.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:firstView];
    
    secondView = [[UIView alloc] initWithFrame:CGRectMake(0, kmainHeight*2/3+20, kmainWidth, kmainHeight*2/3)];
    secondView.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:secondView];
    
    
    [self FirstView];
    [self secondView];
    
}

- (void)FirstView{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, 140)];
    imageView.backgroundColor = [UIColor greenColor];
    imageView.image = [UIImage imageNamed:@"WechatIMG17.jpeg"];
    [firstView addSubview:imageView];
    
    UIButton *cityButton = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth/2-80, 160, 160, 30)];
    cityButton.layer.borderWidth = 1;
    cityButton.layer.borderColor = [UIColor colorWithRed:220.0f/255 green:220.0f/255 blue:220.0f/255 alpha:1].CGColor;
    cityButton.layer.cornerRadius = 15;
    cityButton.layer.shadowOffset = CGSizeMake(0,0.8);
    cityButton.layer.shadowRadius = 3.0;
    cityButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cityButton.layer.shadowOpacity = 0.6;
    [cityButton setTitle:@"投保城市：杭州" forState:UIControlStateNormal];
    [cityButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cityButton.backgroundColor = [UIColor whiteColor];
    [firstView addSubview:cityButton];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 210, kmainWidth, 150)];
    imgView.image = [UIImage imageNamed:@"WechatIMG18.jpeg"];
    [firstView addSubview:imgView];
    
    //创建两个按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth/4-40, 370, 80, 40)];
    [leftButton setTitle:@"¥ 1.00 " forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor colorWithRed:205.0f/255 green:104.0f/255 blue:57.0f/255 alpha:1];
    leftButton.layer.cornerRadius = 10;
    [firstView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth*3/4-40, 370, 80, 40)];
    [rightButton setTitle:@"¥ 5.00 " forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor colorWithRed:205.0f/255 green:104.0f/255 blue:57.0f/255 alpha:1];
    rightButton.layer.cornerRadius = 10;
    [firstView addSubview:rightButton];
}

- (void)secondView{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth/2-40, 30, 80, 30)];
    label.text = @"投保须知";
    [secondView addSubview:label];
    
    
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
