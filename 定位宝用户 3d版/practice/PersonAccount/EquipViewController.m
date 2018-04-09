//
//  EquipViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/2/3.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "EquipViewController.h"

@interface EquipViewController ()
{
    NSUserDefaults *userDefaults;
}
@end

@implementation EquipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:232.0f/255 green:232.0f/255 blue:232.0f/255 alpha:1];
    self.title = @"设备管理";
    
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self createScrollView];
}

- (void)createScrollView{
   // NSArray *lisaArr = [userDefaults objectForKey:@"macArr"];
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, kmainWidth-20, kmainHeight-64-20)];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.contentSize = CGSizeMake(kmainWidth*2-130, kmainHeight-64-50);
    scroll.bounces = YES;//超出边界时反弹
    [self.view addSubview:scroll];
    
    
    
    NSArray *imageArr = [NSArray arrayWithObjects:@"car1.jpeg",@"car2.jpeg",@"car3.png", nil];
    
    
    NSString *equip = [userDefaults objectForKey:@"equip"];
    NSString *macName = [NSString stringWithFormat:@"设备唯一ID:%@",equip];
    NSArray *textArr = [NSArray arrayWithObjects:@"归属人:张三",@"联系电话:136****9543",@"注册时间:2017-01-26",macName,@"型号:MB-WFZS",@"设备状态:正在使用中",nil];
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((scroll.frame.size.width-30)*i, 0, scroll.frame.size.width-50, scroll.frame.size.height)];
        view.backgroundColor = [UIColor whiteColor];
        [scroll addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 220 )];
        imageView.image = [UIImage imageNamed:imageArr[i]];
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth/2-50, 260, 100, 40)];
        label.text = @"绿源电动车";
        [view addSubview:label];
        
        for (int i = 0; i < 6; i++) {
            UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 320+30*i, 250, 30)];
            leftLabel.text = textArr[i];
            [view addSubview:leftLabel];
            
        }
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
