//
//  WeilanViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/2/13.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "WeilanViewController.h"

#import <AMapSearchKit/AMapSearchKit.h>
#import "AFNetworking.h"


@interface WeilanViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    MACircle *circle200;
    
//    AMapLocationManager *_locationManager;
//    AMapSearchAPI *search;
    MAPointAnnotation *pointAnnatation;
    AMapLocationCircleRegion *cirRegion;
    NSString *adcode;
    UIView *insertView;
    UIView *bgView;
    UIView *inputView;
    UILabel *locationLabel;
    UITextField *locatonFeild;
    UIButton *addButton;
    NSArray *twoBtnArr;
    
    
    NSUserDefaults *userDefault;
    
    UITableView *table;
    UIView *whiteView;
    NSArray *copyArr;
    NSMutableArray *circleArr;
   // NSDictionary *circleDic;
    
}
@property (nonatomic, strong) NSMutableArray *regions;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation WeilanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self initMapView];
    
   // [self startLocation];
    [self creatTwoButton];
    
    _regions = [NSMutableArray array];
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
     userDefault = [NSUserDefaults standardUserDefaults];
    circleArr = [NSMutableArray array];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView removeFromSuperview];
    _mapView = nil;
    _mapView.delegate = nil;
}





//- (void)initMapView{
//    
//    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight)];
//    _mapView.delegate = self;
//    _mapView.showsScale = NO;
//    _mapView.showsCompass = NO;
//    
//    
//    _mapView.zoomLevel = 10.8;
//    [self.view addSubview:_mapView];
//    
//    userDefault = [NSUserDefaults standardUserDefaults];
//    
//}
//- (void)startLocation{
//    
//    _locationManager = [[AMapLocationManager alloc] init];
//    _locationManager.delegate = self;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    _locationManager.locatingWithReGeocode = YES;
//    
//    [_locationManager startUpdatingLocation];
//    
//    _mapView.showsUserLocation = YES;
//    _mapView.userTrackingMode = MAUserTrackingModeFollow;
//    
//    
//    
//}

- (void)creatTwoButton{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(60, kmainHeight-64-20-70, kmainWidth-20, 40)];
    bgView.backgroundColor = [UIColor colorWithRed:230.f/255 green:230.f/255 blue:230.f/255 alpha:1];
    [_mapView addSubview:bgView];
    bgView.layer.borderWidth=1.5;
    bgView.layer.borderColor = [UIColor colorWithRed:220.f/255 green:220.f/255 blue:220.f/255 alpha:1].CGColor;
    bgView.layer.cornerRadius=10;
    
    
    
    
    addButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,kmainWidth/2-10,40)];
    [addButton setTitle:@"添加新围栏" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bgView addSubview:addButton];
    addButton.tag = 101;
    [addButton addTarget:self action:@selector(addNewWeilan) forControlEvents:UIControlEventTouchUpInside];
    [addButton addTarget:self action:@selector(MoveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *getButton = [[UIButton alloc] initWithFrame:CGRectMake(kmainWidth/2-10,0,kmainWidth/2-10,40)];
    [getButton setTitle:@"获取已有地理围栏" forState:UIControlStateNormal];
    [getButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    getButton.tag = 201;
    [bgView addSubview:getButton];
    [getButton addTarget:self action:@selector(MoveAction:) forControlEvents:UIControlEventTouchUpInside];
    [getButton addTarget:self action:@selector(getAllWeilan) forControlEvents:UIControlEventTouchUpInside];
    
    insertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth/2,40)];
    insertView.backgroundColor = [UIColor whiteColor];
    insertView.layer.cornerRadius = 10;
    [bgView insertSubview:insertView belowSubview:addButton];
    
    twoBtnArr = [NSArray arrayWithObjects:addButton,getButton,nil];
    
}
//移动白色滑块
- (void)MoveAction:(UIButton *)sender{
    //UIButton *button = twoBtnArr[0];
    
    //NSLog(@"%li,%li",button.tag,sender.tag);
    for (UIButton *Btn in twoBtnArr) {
        if (Btn.tag == sender.tag) {
            [UIView animateWithDuration:0.3 animations:^{
                insertView.frame = Btn.frame;
            }];
        }
    }
    
}




- (void)createInputView{
    
    [whiteView removeFromSuperview];
    whiteView = nil;
    
    inputView = [[UIView alloc] initWithFrame:CGRectMake(60, kmainHeight-64-20-65, kmainWidth-20, 20)];
    inputView.backgroundColor = [UIColor clearColor];
    [_mapView insertSubview:inputView belowSubview:bgView];
    inputView.layer.shadowOpacity=0.6f;
    inputView.layer.shadowOffset=CGSizeMake(1, 1);
    inputView.layer.shadowColor=[UIColor blackColor].CGColor;
    inputView.layer.shadowRadius=3;
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(inputView.frame.size.width-37, 5, 28, 28)];
    [deleteButton setImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
    [inputView addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(removeInputView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
    topLabel.text = @"新建地理围栏";
    [inputView addSubview:topLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, inputView.frame.size.width-48, 2)];
    line.backgroundColor = [UIColor colorWithRed:220.f/255 green:220.f/255 blue:220.f/255 alpha:0.5];
    [inputView addSubview:line];
    
    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 200, 20)];
    centerLabel.font = [UIFont systemFontOfSize:14];
    centerLabel.text = @"获取经纬度信息";
    centerLabel.textColor = [UIColor grayColor];
    [inputView addSubview:centerLabel];
    //经纬度
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 65,inputView.frame.size.width-48,20)];
    locationLabel.font = [UIFont systemFontOfSize:12];
    locationLabel.textColor = [UIColor lightGrayColor];
    locationLabel.text = @"请在地图中长按添加围栏中心点";
    [inputView addSubview:locationLabel];
    
    
    
    //半径
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, 200, 20)];
    label1.text = @"半径（单位：米）";
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor grayColor];
    [inputView addSubview:label1];
    
    locatonFeild = [[UITextField alloc] initWithFrame:CGRectMake(20, 107, inputView.frame.size.width-128, 25)];
    locatonFeild.placeholder = @"    输入围栏半径";
    locatonFeild.font = [UIFont systemFontOfSize:14];
    [inputView addSubview:locatonFeild];
    locatonFeild.delegate = self;
    locatonFeild.backgroundColor = [UIColor colorWithRed:220.f/255 green:220.f/255 blue:220.f/255 alpha:0.3];
    locatonFeild.layer.borderWidth = 1;
    locatonFeild.layer.borderColor = [UIColor colorWithRed:220.f/255 green:220.f/255 blue:220.f/255 alpha:0.5].CGColor;
   // locatonFeild.borderStyle = UITextBorderStyleLine;
    

    //单击空白区域退出键盘代码
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    
    
    UIButton *bulidButton = [[UIButton alloc] initWithFrame:CGRectMake(inputView.frame.size.width-100, 107, 65, 24)];
    [bulidButton setTitle:@"新  建" forState:UIControlStateNormal];
    bulidButton.backgroundColor = [UIColor colorWithRed:205.f/255 green:85.f/255 blue:85.f/255 alpha:0.8];
    [inputView addSubview:bulidButton];
    [bulidButton addTarget:self action:@selector(updateNewWeilan) forControlEvents:UIControlEventTouchUpInside];
    
    
}
//连网。上传围栏数据
- (void)updateNewWeilan{
    
    NSString *lonString = [NSString stringWithFormat:@"%f",pointAnnatation.coordinate.longitude];
    NSString *latString = [NSString stringWithFormat:@"%f",pointAnnatation.coordinate.latitude];
    //请求的参数
    if (pointAnnatation != nil &locatonFeild.text.length != 0) {
        
    
        
    NSString *userid = [userDefault objectForKey:@"id"];
    NSDictionary *parameters = @{@"longitude":lonString,
                                 @"latitude":latString,
                                 @"adcode":adcode,
                                 @"radius":locatonFeild.text,
                                 @"name":@"1",
                                 @"userid":userid};
    NSString *path = @"http://121.196.194.14/langyang/Home/User/addElectronicFence";
    
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    managers.securityPolicy.allowInvalidCertificates = YES;
    [managers POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSLog(@"%@",responseObject);
        
        
        [self doWeilan];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
    }];

    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请确定围栏的中心点与半径" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    
}


- (void)getAllWeilan{
    
    [inputView removeFromSuperview];
    inputView = nil;
    addButton.tag = 101;
    
    //请求的参数
   
    NSString *userid = [userDefault objectForKey:@"id"];
   // NSLog(@"%@",userid);
    NSDictionary *parameters = @{@"userid":userid};
    NSString *path = @"http://121.196.194.14/langyang/Home/User/watchElectronicFences";
    
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    managers.securityPolicy.allowInvalidCertificates = YES;
    [managers POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"lp"] intValue] == 1) {
            NSLog(@"%@",responseObject);
            return ;
        }else{
        _dataArr = [responseObject[@"data"] objectForKey:@"list"];
        NSLog(@"%@",_dataArr);
        
        [self createTableView];
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
    }];
    
    

    
    
    
    
    
    
    
    
}

- (void)createTableView{
    if (whiteView == nil) {
        
        whiteView = [[UIView alloc] initWithFrame:CGRectMake(60, kmainHeight-64-20-260, kmainWidth-20, 180)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [_mapView insertSubview:whiteView belowSubview:bgView];
        whiteView.layer.shadowOpacity=0.6f;
        whiteView.layer.shadowOffset=CGSizeMake(1, 1);
        whiteView.layer.shadowColor=[UIColor blackColor].CGColor;
        whiteView.layer.shadowRadius=3;
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth/2-100, 0, 200, 28)];
        titleLabel.text = @"围栏列表";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor lightGrayColor];
        [whiteView addSubview:titleLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, whiteView.frame.size.width-20, 2)];
        line.backgroundColor = [UIColor colorWithRed:220.f/255 green:220.f/255 blue:220.f/255 alpha:0.3];
        [whiteView addSubview:line];
        
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(whiteView.frame.size.width-32, 5, 20, 20)];
        [deleteButton setImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteTableView) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:deleteButton];
        
               
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0,30, kmainWidth-20, 150) style:UITableViewStylePlain];
        
        [whiteView insertSubview:table belowSubview:bgView];
        table.dataSource = self;
        table.delegate = self;
        
    }
   
    

    
}

- (void)deleteTableView{
    
    [whiteView removeFromSuperview];
    whiteView = nil;
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}


//表示图的委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        cell.textLabel.text = [_dataArr[indexPath.row] objectForKey:@"name"];
        NSLog(@"%@",cell.textLabel.text);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@,%@",[_dataArr[indexPath.row] objectForKey:@"latitude"],[_dataArr[indexPath.row] objectForKey:@"longitude"],[_dataArr[indexPath.row] objectForKey:@"radius"]];
        
    }
    return cell;
    
}

//从列表中添加地理围栏
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"circleRegion%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    
    
    if (_regions.count == 0) {
        CLLocationDegrees latitude = [[_dataArr[indexPath.row] objectForKey:@"latitude"] floatValue];
        CLLocationDegrees longitude = [[_dataArr[indexPath.row] objectForKey:@"longitude"] floatValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        cirRegion = [[AMapLocationCircleRegion alloc] initWithCenter:coordinate radius:[[_dataArr[indexPath.row] objectForKey:@"radius"] integerValue] identifier:identifier];
        
        [_locationManager startMonitoringForRegion:cirRegion];
        
        
        //保存地理围栏
        [self.regions addObject:cirRegion];
        
        
        //添加Overlay
        circle200 = [MACircle circleWithCenterCoordinate:coordinate radius:[[_dataArr[indexPath.row] objectForKey:@"radius"] integerValue]];
        [_mapView addOverlay:circle200];
        [circleArr addObject:circle200];

        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        
        NSString *string = [_regions componentsJoinedByString:@""];
        //
        
        if ([string rangeOfString:identifier].location == NSNotFound) {
            CLLocationDegrees latitude = [[_dataArr[indexPath.row] objectForKey:@"latitude"] floatValue];
            CLLocationDegrees longitude = [[_dataArr[indexPath.row] objectForKey:@"longitude"] floatValue];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            
            cirRegion = [[AMapLocationCircleRegion alloc] initWithCenter:coordinate radius:[[_dataArr[indexPath.row] objectForKey:@"radius"] integerValue] identifier:identifier];
            circle200 = [MACircle circleWithCenterCoordinate:coordinate radius:[[_dataArr[indexPath.row] objectForKey:@"radius"] integerValue]];
            
            
            [_locationManager startMonitoringForRegion:cirRegion];
            [circleArr addObject:circle200];
            
            //保存地理围栏
            [self.regions addObject:cirRegion];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            //添加Overlay
            [_mapView addOverlay:circle200];

            
        }else{
            [_regions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AMapLocationCircleRegion *region = (AMapLocationCircleRegion *)obj;
                if ([region.identifier isEqualToString:[NSString stringWithFormat:@"circleRegion%li",indexPath.row]]) {
                    [self.regions removeObject:region];
                    cirRegion = nil;
               }
            }];
           
            [circleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MACircle *circle = (MACircle *)obj;
                if (circle.coordinate.latitude == [[_dataArr[indexPath.row] objectForKey:@"latitude"] floatValue]) {
            
                    [_mapView removeOverlay:circle];
                    circle200 = nil;
                    [circleArr removeObject:circle];
                }
            }];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}


//是否允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
   return YES;
}

//修改删除按钮为中文
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
/*
//左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //1、删除数据源
#warning bug 删除不了，可能一开始就没加进去
        NSMutableArray *mutableArr = [_dataArr mutableCopy];
        [mutableArr removeObjectAtIndex:indexPath.row];
        //UI上删除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}
*/





- (void)closeKeyboard:(id)sender{
    [self.view endEditing:YES];
}

#pragma mark - UITextFeildDelegate
//实现弹出键盘时，输入框上移
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
//    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y+216+250);
    CGFloat offset = 216 - kmainHeight+64+80+150;
    
    NSLog(@"偏移高度 －－－%f",offset);
    if (offset < 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = inputView.frame;
            frame.origin.y = -offset;
            inputView.frame = frame;
        }];
    }
    return YES;
}
//回收键盘时，输入框回到原来的位置
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = inputView.frame;
        frame.origin.y = kmainHeight-64-20-80-150;
        inputView.frame = frame;
    }];
    return YES;
}



- (void)removeInputView{


    [inputView removeFromSuperview];
    
    addButton.tag = 101;
}



- (void)addNewWeilan{
    if (addButton.tag == 101) {
        
        [self createInputView];
        [UIView animateWithDuration:0.5 animations:^{
            
            inputView.frame = CGRectMake(60, kmainHeight-64-20-80-150, kmainWidth-20, 150);
            inputView.backgroundColor = [UIColor whiteColor];
        }];
        addButton.tag = 102;
    }
    
    
}



//画出围栏
- (void)doWeilan{
    
    self.regions = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    
    CLLocationCoordinate2D coordinate = pointAnnatation.coordinate;
    [weakSelf addCircleReionForCoordinate:coordinate];
    
    }
- (void)addCircleReionForCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapLocationCircleRegion *cirRegion200 = [[AMapLocationCircleRegion alloc] initWithCenter:coordinate radius:[locatonFeild.text doubleValue] identifier:@"circleRegion200"];
    
     [_locationManager startMonitoringForRegion:cirRegion200];
    
    
    //保存地理围栏
    [self.regions addObject:cirRegion200];
    
    //添加Overlay
    circle200 = [MACircle circleWithCenterCoordinate:coordinate radius:[locatonFeild.text doubleValue]];
    [_mapView addOverlay:circle200];
   // [_mapView setVisibleMapRect:circle200.boundingMapRect];
   // _mapView.centerCoordinate = pointAnnatation.coordinate;
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.lineWidth = 5.0f;
        polylineRenderer.strokeColor = [UIColor redColor];
       // polylineRenderer.lineJoin = kCGLineJoinRound;
        return polylineRenderer;
    }
    else if ([overlay isKindOfClass:[MACircle class]])
    {
        
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth = 5.0f;
        circleRenderer.strokeColor = [UIColor blueColor];
        circleRenderer.fillColor = [UIColor colorWithRed:106.0f/255 green:90.0f/255 blue:205.0f/255 alpha:0.4];
        return circleRenderer;
        
        
    }
    
    return nil;
}

#pragma mark - AMapLocationManagerDelegate


- (void)amapLocationManager:(AMapLocationManager *)manager didStartMonitoringForRegion:(AMapLocationRegion *)region
{
    NSLog(@"开始监听地理围栏:%@", region);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"开始监听地理围栏" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [self removeInputView];
}


- (void)amapLocationManager:(AMapLocationManager *)manager didEnterRegion:(AMapLocationRegion *)region
{
    NSLog(@"进入地理围栏:%@", region);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"进入地理围栏" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)amapLocationManager:(AMapLocationManager *)manager didExitRegion:(AMapLocationRegion *)region{
    
    NSLog(@"出了地理围栏:%@", region);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"出了地理围栏" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}


//长按地图显示围栏中心点
- (void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (addButton.tag == 102 ) {
        
        pointAnnatation = [[MAPointAnnotation alloc] init];
        pointAnnatation.coordinate = coordinate;
        NSLog(@"%f,%f",coordinate.latitude,coordinate.longitude);
        [_mapView addAnnotation:pointAnnatation];
        
        
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        regeo.requireExtension = YES;
        [_search AMapReGoecodeSearch:regeo];
    }else{
        return;
    }
    
}
//逆地理编码回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    
    if (response.regeocode != nil) {
        locationLabel.text = response.regeocode.formattedAddress;
        NSLog(@"%@",response.regeocode.formattedAddress);
        
        AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
        geo.address = locationLabel.text;
        [_search AMapGeocodeSearch:geo];
    }
    
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    
    if (response.geocodes != nil) {
        adcode = response.geocodes[0].adcode;
        NSLog(@"%@",adcode);
    }
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
    static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
    MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
    if (annotationView == nil)
    {
        annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
    }
    annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
    annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
    annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
    annotationView.pinColor = MAPinAnnotationColorPurple;
    return annotationView;
    }
    return nil;



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
