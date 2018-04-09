//
//  ViewController.m
//  bluetooth
//
//  Created by 陈彦彤 on 18/3/15.
//  Copyright © 2018年 朗阳科技. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UISlider *freSlider;
@property (weak, nonatomic) IBOutlet UITextField *userTextFeild;

@end

@implementation ViewController

/*蓝牙设备步骤：1、建立中心管理角色
2、扫描外部设备（discover）
3、连接外部设备（connect）
4、扫描外部设备中的服务和特征（discover）
5、与它进行数据交互(explore and interact)
6、断开连接(disconnect)
 */

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];    
    [self.view addGestureRecognizer:singleTap];
    [_freSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //监听键盘view上移
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upView:) name:UIKeyboardWillShowNotification object:nil];
    
    
}

//返回上一页
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//键盘退出时的动作
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    if ([_userTextFeild isFirstResponder] && UIKeyboardDidShowNotification) {
        [_userTextFeild resignFirstResponder];
        //视图还原
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = 0;
        self.view.frame = viewFrame;
    }
//    [self.view endEditing:YES];
}

//监听滑块移动，改变数字百分比的显示。
- (void)sliderValueChanged:(UISlider *)slider{
     _percentLabel.text = [NSString stringWithFormat:@"%i%%",(int)slider.value ];
}

- (void)upView:(NSNotification *)notificawtion{
    //获取键盘的高度
    NSDictionary *userInfo = [notificawtion userInfo];
    NSValue *keyValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyReact = [keyValue CGRectValue];
    int keyboardHeight = keyReact.size.height;
    //视图上移
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = -keyboardHeight;
    self.view.frame = viewFrame;
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
