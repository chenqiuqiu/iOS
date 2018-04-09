//
//  MyCoinViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/22.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "MyCoinViewController.h"

@interface MyCoinViewController ()
{
    UILabel *countingLabel;
    int i;
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIView *OrangeView;



@end


@implementation MyCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    i = 0;
    
    _OrangeView.layer.cornerRadius = 68;
    
    countingLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 41, 60, 60)];
    countingLabel.font = [UIFont systemFontOfSize:30];
    countingLabel.textColor = [UIColor whiteColor];
    countingLabel.textAlignment = NSTextAlignmentCenter;
    [_OrangeView addSubview:countingLabel];
   
    
   timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(setCountingLabel) userInfo:nil repeats:YES];
   

}

- (void)setCountingLabel{
    if (i < 34) {
        countingLabel.text = [NSString stringWithFormat:@"%d",i];
        i++;
    }else{
        [timer invalidate];
        timer = nil;
    }
    NSLog(@"%@",countingLabel.text);
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
