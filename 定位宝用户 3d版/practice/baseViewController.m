//
//  baseViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/9.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "baseViewController.h"
#import "SettingViewController.h"
#import "EquipViewController.h"
#import "HomeViewController.h"
#import "WeilanViewController.h"
#import "RouteViewController.h"
#import "StopCarController.h"
#import "BindingViewController.h"

#import "GroupViewController.h"
#import "AlarmViewController.h"
#import "InsuranceViewController.h"
#import "CustomServicesController.h"
#import "ThirdViewController.h"


@interface baseViewController ()<AMapLocationManagerDelegate,MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    HomeViewController *homeVC;
    WeilanViewController *weilanVC;
    UIViewController *currentVC;
    RouteViewController *routeVC;
    StopCarController *carVC;
    
    UIImageView *imgView;
   
    
    NSMutableArray *_btnmArr;
        UIView *whiteV;
        UIToolbar *toolbar;
        UIView *personV;
        UILabel *reGeoLabel;
    
}
@property (strong, nonatomic) UIWindow *window2;


@end

@implementation baseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    //设置导航栏纯色
    self.navigationController.navigationBar.translucent=NO;
    //设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:220.0f/255 green:220.0f/255 blue:220.0f/255 alpha:1];
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    
    [self initControllers];

    [self setItemButton];
    [self createButtons];
    
}




- (void)initControllers{
    
    homeVC = [[HomeViewController alloc] init];
    homeVC.view.frame = CGRectMake(0, 40, kmainWidth,kmainHeight);
    [self addChildViewController:homeVC];
    [self.view insertSubview:homeVC.view belowSubview:imgView];
    
//    weilanVC = [[WeilanViewController alloc] init];
//    weilanVC.view.frame = CGRectMake(0, 40, kmainWidth,kmainHeight-64);
//    [self addChildViewController:weilanVC];
//    
//    
//    routeVC = [[RouteViewController alloc] init];
//    routeVC.view.frame = CGRectMake(0, 40, kmainWidth,kmainHeight);
//    [self addChildViewController:routeVC];
//
//    carVC = [[StopCarController alloc] init];
//    carVC.view.frame = CGRectMake(0, 40, kmainWidth,kmainHeight);
//    [self addChildViewController:carVC];
//    
    
    
    
    [self.view addSubview:homeVC.view];
    currentVC = homeVC;

    
}






- (void)setItemButton{
    UIImage *image =[UIImage imageNamed:@"个人中心.png"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(getPersonalAccountAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"取消绑定.png"] style:UIBarButtonItemStylePlain target:self action:@selector(scanAction)];
}


//绑定设备
- (void)scanAction{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    
    BindingViewController *scan = [[BindingViewController alloc] init];
    [self.navigationController pushViewController:scan animated:YES];
    
}


- (void)createButtons{
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, 40)];
    imgView.userInteractionEnabled = YES;
    imgView.backgroundColor = [UIColor whiteColor];
    imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    imgView.layer.shadowRadius = 4;
    imgView.layer.shadowOffset = CGSizeMake(5, 5);
    imgView.layer.shadowOpacity = 0.4;
    [self.view addSubview:imgView];
    
    
    NSArray *array = [NSArray arrayWithObjects:@"定位",@"电子围栏",@"轨迹",@"开车停车", @"报警",nil];
    _btnmArr = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth/6*i+10 , 5, 60, 30)];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.tag = i+100;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
      //  [button addTarget:self action:@selector(goOtherViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_btnmArr addObject:button];
        [imgView addSubview:button];
        
    }
    UIButton *largeButt = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth-58, 7, 40, 25)];
    [largeButt setBackgroundImage:[UIImage imageNamed:@"树行_展开"] forState:UIControlStateNormal];
    [largeButt addTarget:self action:@selector(getOtherBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:largeButt];
    
    
}

- (void)buttonAction:(UIButton *)sender{
    
    [self deleteBtnAction];
    for (UIButton *btn in _btnmArr) {
        if (btn.tag == sender.tag) {
            [btn setTitleColor:[UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }

    
    
    if ((currentVC == homeVC && sender.tag == 100) || (currentVC == weilanVC && sender.tag == 101) || (currentVC == routeVC && sender.tag == 102) || (currentVC == carVC && sender.tag == 103)) {
        return;
    }else{
        
        switch (sender.tag) {
            case 100:
                homeVC = [[HomeViewController alloc] init];
                homeVC.view.frame = CGRectMake(0, 40, kmainWidth,kmainHeight);
                [self addChildViewController:homeVC];
                [self replaceController:currentVC newController:homeVC];
                break;
            case 101:
                weilanVC = [[WeilanViewController alloc] init];
                weilanVC.view.frame = CGRectMake(0, 40, kmainWidth,kmainHeight-64);
                [self addChildViewController:weilanVC];
                [self replaceController:currentVC newController:weilanVC];
                break;
            case 102:
                routeVC = [[RouteViewController alloc] init];
                routeVC.view.frame = CGRectMake(0, 40, kmainWidth,kmainHeight);
                [self addChildViewController:routeVC];
                [self replaceController:currentVC newController:routeVC];

                break;
            case 103:
                carVC = [[StopCarController alloc] init];
                carVC.view.frame = CGRectMake(0, 40, kmainWidth,kmainHeight);
                [self addChildViewController:carVC];
                
                [self replaceController:currentVC newController:carVC];
                break;
            case 104:
            {
                UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
                back.title = @"返回";
                self.navigationItem.backBarButtonItem = back;

                AlarmViewController *alarm = [[AlarmViewController alloc] init];
                [self.navigationController pushViewController:alarm animated:YES];
                break;
            }
            default:
                break;
        }
    }
    
}

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController{
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.2 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newController didMoveToParentViewController:self];
            [self.view insertSubview:newController.view belowSubview:imgView];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            currentVC = newController;
        }else{
            currentVC = oldController;
        }
    }];
}





- (void)getOtherBtnAction{
    whiteV = [[UIView alloc] initWithFrame:CGRectMake(0, -kmainHeight*0.3, kmainWidth, kmainHeight*0.3+5)];
    [self.view addSubview:whiteV];
    whiteV.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.5 animations:^{
        whiteV.frame = CGRectMake(0, 0, kmainWidth, kmainHeight*0.3+5);
    }];
    
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.alpha = 0.6;
    [self.view insertSubview:toolbar belowSubview:whiteV];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth/2-50, 0, 100, 40)];
    label1.text = @"全部服务";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor grayColor];
    [whiteV addSubview:label1];
    
    UIButton *deletBtn = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth-51, 8, 24, 24)];
    [deletBtn setBackgroundImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
    [deletBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteV addSubview:deletBtn];
    
    //画分割线
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, kmainWidth, 2)];
    line1.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1];
    [whiteV addSubview:line1];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, kmainHeight*0.15 +28, kmainWidth, 2)];
    line2.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1];
    [whiteV addSubview:line2];
    UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(0, kmainHeight*0.3+3, kmainWidth, 2)];
    line4.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1];
    [whiteV addSubview:line4];
    
    for (int i = 0; i < 3; i++) {
        UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth/4*(i+1), 60, 2, kmainHeight*0.3-55)];
        line3.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1];
        [whiteV addSubview:line3];
    }
    
    
    
    
    
    //做8个按钮
    NSArray *picArr = [NSArray arrayWithObjects:@"定位button",@"围栏",@"来校路线",@"车子1-01",@"报警",@"群组",@"保险",@"联系我们", nil];
    NSArray *titleArr = [NSArray arrayWithObjects:@"定位",@"电子围栏",@"轨迹",@"开车停车",@"报警",@"群组",@"购买保险",@"联系我们", nil];
    for (int i = 0; i < 8; i ++) {
        if (i < 4) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5+kmainWidth/4 * i, 60, kmainWidth/4-10, kmainHeight*0.1)];
            [button setImage:[UIImage imageNamed:picArr[i]] forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(15, 30, 25, 30);
            button.tag = i+100;
            [button addTarget:self action:@selector(goOtherViewAction:) forControlEvents:UIControlEventTouchUpInside];
            [whiteV addSubview:button];
            
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+kmainWidth/4 * i, kmainHeight*0.1+35, kmainWidth/4-10, 20)];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.text = titleArr[i];
            titleLabel.textColor = [UIColor lightGrayColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [whiteV addSubview:titleLabel];
            
        }else{
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth/4*(i-4)+5, kmainHeight*0.15+28, kmainWidth/4-10, kmainHeight*0.1)];
            [button setImage:[UIImage imageNamed:picArr[i]] forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(20, 30, 20, 30);
            button.tag = i+100;
            [button addTarget:self action:@selector(goOtherViewAction:) forControlEvents:UIControlEventTouchUpInside];
            [whiteV addSubview:button];
            
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+kmainWidth/4*(i-4), kmainHeight*0.26+2, kmainWidth/4-10, 20)];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.text = titleArr[i];
            titleLabel.textColor = [UIColor lightGrayColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [whiteV addSubview:titleLabel];
        }
    }
}
-(void)goOtherViewAction:(UIButton *)sender{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    if (sender.tag < 104) {
        [self buttonAction:sender];
    }else{
        switch (sender.tag) {
            case 104:
            {
                
                AlarmViewController *alarm = [[AlarmViewController alloc] init];
                [self.navigationController pushViewController:alarm animated:YES];
                
                break;
            }
            case 105:
            {
//                UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
//                back.title = @"返回";
//                self.navigationItem.backBarButtonItem = back;
                GroupViewController *group = [[GroupViewController alloc] init];
                [self.navigationController pushViewController:group animated:YES];
                break;
               
            }

            case 106:
            {
//                UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
//                back.title = @"返回";
//                self.navigationItem.backBarButtonItem = back;

                InsuranceViewController *insurance = [[InsuranceViewController alloc] init];
                [self.navigationController pushViewController:insurance animated:YES];
                break;
            }
            case 107:
            {
//                UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
//                back.title = @"返回";
//                self.navigationItem.backBarButtonItem = back;

                CustomServicesController *custom = [[CustomServicesController alloc] init];
                [self.navigationController pushViewController:custom animated:YES];
                break;
            }

            default:
                break;
        }
        
    }
}
    
    
    
    
    
    
    
    


- (void)deleteBtnAction{
    
    [UIView animateWithDuration:0.3 animations:^{
        whiteV.frame = CGRectMake(0, -kmainHeight*0.3, kmainWidth, kmainHeight*0.3);
    }];
    //[whiteV removeFromSuperview];
    [toolbar removeFromSuperview];
}


- (void)getPersonalAccountAction{
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight)];
    window.windowLevel = UIWindowLevelAlert;
    window.backgroundColor = [UIColor clearColor];
    _window2 = window;
    [window makeKeyAndVisible];
    
    UIToolbar *toolbar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight)];
    toolbar1.barStyle = UIBarStyleBlackTranslucent;
    toolbar1.alpha = 0.6;
    [_window2 addSubview:toolbar1];
    personV = [[UIView alloc] initWithFrame:CGRectMake(-kmainWidth*0.6, 0, kmainWidth*0.6, kmainHeight)];
    personV.backgroundColor = [UIColor whiteColor];
    [_window2 addSubview:personV];
    [UIView animateWithDuration:0.5 animations:^{
        personV.frame = CGRectMake(0, 0, kmainWidth*0.6, kmainHeight);
    }];
    
    //单击移除window
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindow:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [toolbar1 addGestureRecognizer:tap];
    
    //设置头像和帐号
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(kmainWidth*0.3-35, 50, 70, 70)];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"iconimageView"]) {
        
        NSData *imageData = [userDefaults objectForKey:@"iconimageView"];
        UIImage *iconImage = [UIImage imageWithData:imageData];
        icon.image = iconImage;
    }else{
        icon.image = [UIImage imageNamed:@"me_avatar_girl_65x65_@3x.png"];
    }
    
    [personV addSubview:icon];
    
    NSString *name = [userDefaults objectForKey:@"name"];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, kmainWidth*0.6-100, 30)];
    phoneLabel.text = name;
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.font = [UIFont systemFontOfSize:23];
    [personV addSubview:phoneLabel];
    
    UIImageView *vipIMG = [[UIImageView alloc] initWithFrame:CGRectMake(kmainWidth*0.3-35, 152, 20, 20)];
    vipIMG.image = [UIImage imageNamed:@"会员.png"];
    [personV addSubview:vipIMG];
    UILabel *vipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth*0.3-12, 152, 80, 20)];
    vipLabel.text = @"普通会员";
    vipLabel.font = [UIFont systemFontOfSize:15];
    vipLabel.textColor = [UIColor lightGrayColor];
    [personV addSubview:vipLabel];
    
    UIButton *personBtn = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth*0.1, 50, 150, 150)];
    personBtn.backgroundColor = [UIColor clearColor];
    [personV insertSubview:personBtn atIndex:3];
    [personBtn addTarget:self action:@selector(gotoPersonAccount) forControlEvents:UIControlEventTouchUpInside];
    
    //创建单元格
    UITableView *tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 230, kmainWidth*0.6, 320) style:UITableViewStylePlain];
    [personV addSubview:tbView];
    tbView.rowHeight = 50;
    tbView.separatorStyle = UITableViewCellSelectionStyleNone;
    tbView.dataSource = self;
    tbView.delegate = self;
    
    
}

- (void)gotoPersonAccount{
    [_window2 resignKeyWindow];
    _window2 = nil;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    
    
    
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    SettingViewController *setting = [story instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:setting animated:YES];
    
    
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"NewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    NSArray *imgArr = [NSArray arrayWithObjects:@"行程",@"追踪",@"设备",@"设置", nil];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 20, 20)];
    imgV.image = [UIImage imageNamed:imgArr[indexPath.row]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 60, 30)];
    label.text = imgArr[indexPath.row];
    
    [cell.contentView addSubview:imgV];
    [cell.contentView addSubview:label];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_window2 resignKeyWindow];
    _window2 = nil;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    
    switch (indexPath.row) {
        case 0:
        {
            JournalViewController *journal = [[JournalViewController alloc]init];
            [self.navigationController pushViewController:journal animated:YES];
            
            
            break;
        }
        case 1:
        {
            //钱包
//            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Wallet" bundle:nil];
//            WalletViewController *wallet = [main instantiateViewControllerWithIdentifier:@"WalletViewController"];
//            [self.navigationController pushViewController:wallet animated:YES];
            
            
            ThirdViewController *third = [[ThirdViewController alloc] init];
            [self.navigationController pushViewController:third animated:YES];
            
            
            
            
            break;
        }
        case 3:
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
            SettingViewController *setting = [story instantiateViewControllerWithIdentifier:@"SettingViewController"];
            [self.navigationController pushViewController:setting animated:YES];
            break;
        }
        case 2:{
            UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
            back.title = @"返回";
            self.navigationItem.backBarButtonItem = back;
            EquipViewController *equip = [[EquipViewController alloc] init];
            [self.navigationController pushViewController:equip animated:YES];
            
            break;
        }
    }
    
}








- (void)closeWindow:(id)sender{
    
    [UIWindow animateWithDuration:0.3 animations:^{
        personV.frame = CGRectMake(-kmainWidth*0.6, 0, kmainWidth*0.6, kmainHeight);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.27 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_window2 resignKeyWindow];
        _window2 = nil;
    });
    
    
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
