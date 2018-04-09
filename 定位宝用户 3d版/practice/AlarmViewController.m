//
//  AlarmViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/18.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "AlarmViewController.h"
#import "SecondViewController.h"

@interface AlarmViewController ()

@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报警须知";
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0/255 alpha:1];
    
    [self addText];
    [self createButtons];
}

- (void)addText{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5,kmainWidth-10, kmainHeight*0.5)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(20, 15, kmainWidth-50, kmainHeight*0.5-15)];
    textV.text = @"1.遇有紧急情况，请你直接拨打110报警。\r\n\r\n2.只受理由杭州地区发生的由我市公安机关管辖的刑事、治安案件和违法犯罪线索。\r\n\r\n3.请留下有效联系电话，身份证号码、住址等联系方式，以便及时与您联系，同时请您积极配合公安机关开展工作。\r\n\r\n4.请按照要求如实详细填写报警内容。对故意谎报警情、扰乱公安机关正常办公秩序情节严重者，将依法追究法律责任。\r\n\r\n5.您的个人信息及您所提供的情况，公安机关将严格保密。";
    textV.editable = NO;
    textV.textColor = [UIColor grayColor];
    textV.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:textV];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textV.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(15, 5)];
   
    
    //textV.attributedText = str;
}

- (void)createButtons{
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(20, kmainHeight*0.5+30, kmainWidth-40, 40)];
    button1.backgroundColor = [UIColor whiteColor];
    [button1 setTitle:@"继   续" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1] forState:UIControlStateNormal];
    button1.layer.cornerRadius = 10;
    [button1 addTarget:self action:@selector(alarmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(20, kmainHeight*0.5+90, kmainWidth-40, 40)];
    button2.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [button2 setTitle:@"立即拨打110" forState:UIControlStateNormal];
    button2.layer.cornerRadius = 10;
    [self.view addSubview:button2];
}


- (void)alarmAction{
    SecondViewController *seconed = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:seconed animated:YES];
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
