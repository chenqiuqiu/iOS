//
//  RouteViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/2/11.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "RouteViewController.h"
#import "AFNetworking.h"
#import "MQTTClient.h"
#import <MAMapKit/MATraceManager.h>

@interface RouteViewController ()<MQTTSessionDelegate,MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
   // MAMapView *_mapView;
    MQTTSession *session;
    MAPointAnnotation *a1;
    
    NSMutableArray *array;
    NSMutableArray *annoArr;
    
    
    CLLocationCoordinate2D commomPolylineCoords[1000];
    
    UITableView *mactableView;
    UIButton *deleteButton;
    NSString *topicStr;
    NSString *macStr;
    NSString *startStr;
    NSString *endStr;
    
    NSDictionary *quipDic;
    UIView *historyview;
    UITextField *macTextFeild;
    UILabel *startLabel;
   
    NSArray *locationArr;
    
    MAPolyline *commonPolylinemqtt;
    MAPolyline *commonPolylinenetwork;
    
    NSMutableArray *polylineArr;
    NSMutableArray *regions;
}
@property (nonatomic, strong) NSOperation *queryOperation;
@property (nonatomic, strong) NSMutableArray *processedOverlays; //处理后的
@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];

    
    array = [NSMutableArray array];
    annoArr = [NSMutableArray array];
    polylineArr = [NSMutableArray array];
  //  _mapView = [[MAMapView alloc] init];
    //_mapView.delegate = self;
    
    regions = [NSMutableArray array];
    quipDic = @{@"10000071":@"9728a5b6b7d89525",
                @"10000072":@"3148369587325565",
                @"10000073":@"1568791236462509",
                @"10000074":@"7925473544143545",
                @"10000075":@"0845367815564122",
                @"10000076":@"0594566934820607",
                @"10000077":@"243678A103742511",
                @"10000078":@"5714929450014016",
                @"10000079":@"9803422165492367",
                @"1000007A":@"8854790913598551",
                @"1000007B":@"9824277357298841",
                @"1000007C":@"7994032568319155",
                @"1000007D":@"9157784638529541",
                @"1000007E":@"2490309843910798"};
    
    //单击空白区域退出键盘代码
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
     self.processedOverlays = [NSMutableArray array];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
   // [self mqtt];
   // [self afnetworking];
    [self createTwoButtons];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [session disconnect];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView removeFromSuperview];
    _mapView = nil;
    _mapView.delegate= nil;
}


- (void)createTwoButtons{
    
    UIView *titleIMG = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 250, 30)];

    UIView *bgIMG = [[UIView alloc] initWithFrame:CGRectMake(124, 2, 2, 26)];
    bgIMG.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1];
    [titleIMG addSubview:bgIMG];
    titleIMG.backgroundColor = [UIColor whiteColor];
    titleIMG.layer.cornerRadius = 15;
    titleIMG.layer.shadowColor = [UIColor blackColor].CGColor;
    titleIMG.layer.shadowRadius = 4;
    titleIMG.layer.shadowOffset = CGSizeMake(5, 5);
    titleIMG.layer.shadowOpacity = 0.4;
    [self.view addSubview:titleIMG];

    UIButton *userButt = [[UIButton alloc] initWithFrame:CGRectMake(15, 1, 100, 30)];
    [userButt setTitle:@"实时显示轨迹" forState:UIControlStateNormal];
    [userButt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    userButt.titleLabel.font = [UIFont systemFontOfSize:14];
    [userButt addTarget:self action:@selector(quipList:) forControlEvents:UIControlEventTouchUpInside];
    userButt.tag = 100;
    [titleIMG addSubview:userButt];

    UIButton *equipButt = [[UIButton alloc] initWithFrame:CGRectMake(128, 1, 100, 30)];
    [equipButt setTitle:@"获取历史轨迹" forState:UIControlStateNormal];
    [equipButt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    equipButt.titleLabel.font = [UIFont systemFontOfSize:14];
    equipButt.tag = 101;
    [equipButt addTarget:self action:@selector(quipList:) forControlEvents:UIControlEventTouchUpInside];
    [titleIMG addSubview:equipButt];
}
//做终端列表
- (void)quipList:(UIButton *)sender{
    NSLog(@"%li",(long)sender.tag);
    
    
    if (sender.tag == 101) {
        //获取历史轨迹
        [self clear];
        [self deleteQuipList];

        [self getHistoryRoute];
    }else{
        [self deleteHistoryView];
        if (mactableView == nil) {
            mactableView = [[UITableView alloc] initWithFrame:CGRectMake(-kmainWidth/3, 50, kmainWidth/3, 140)];
            [self.view addSubview:mactableView];
            mactableView.delegate = self;
            mactableView.dataSource = self;
            mactableView.backgroundColor = [UIColor blackColor];
            mactableView.alpha = 0.4;
            mactableView.rowHeight = 30;
            
            deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, 40, 20, 20)];
            // deleteButton.backgroundColor = [UIColor redColor];
            [deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:0];
            [deleteButton addTarget:self action:@selector(deleteQuipList) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:deleteButton];
            
            [UIView animateWithDuration:0.5 animations:^{
                mactableView.frame = CGRectMake(5, 50, kmainWidth/3, 140);
                deleteButton.frame = CGRectMake(kmainWidth/3-5, 40, 20, 20);
                
            }];
        }
    }
}
- (void)deleteQuipList{
    [UIView animateWithDuration:0.6 animations:^{
        mactableView.frame = CGRectMake(-kmainWidth/3, 50, kmainWidth/3, 140);
        deleteButton.frame = CGRectMake(-20, 40, 20, 20);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [mactableView removeFromSuperview];
        mactableView = nil;
        
        [deleteButton removeFromSuperview];
        deleteButton = nil;
    });
    
}
//做历史数据的ui

- (void)getHistoryRoute{
    if (historyview == nil) {
        
        historyview = [[UIView alloc] initWithFrame:CGRectMake(-200, 50, 200, 200)];
        historyview.backgroundColor = [UIColor blackColor];
        historyview.alpha = 0.5;
        [self.view addSubview:historyview];
        
        [UIView animateWithDuration:0.6 animations:^{
            historyview.frame = CGRectMake(10, 50, 200, 200);
        }];
        
        UILabel *macLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 180, 20)];
        macLabel.text = @"Mac地址：";
        macLabel.textColor = [UIColor whiteColor];
        [historyview addSubview:macLabel];
        
        
        
        
        //做三个输入框
        for (int i = 0; i < 3; i++) {
            //做白线
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, 48+52*i, 180, 1.5)];
            line1.backgroundColor = [UIColor whiteColor];
            [historyview addSubview:line1];
            
            
            macTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(12, 25+52*i, 180, 20)];
            macTextFeild.textColor = [UIColor whiteColor];
            [historyview addSubview:macTextFeild];
            macTextFeild.tag = 105+i;
            macTextFeild.delegate = self;
            
        }
        
        
        
        
        
        
        UILabel *starttimeView = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 180, 20)];
        starttimeView.text = @"开始日期:";
        starttimeView.textColor = [UIColor whiteColor];
        [historyview addSubview:starttimeView];
        
        startLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 180, 20)];
        startLabel.text = @"2017-03-21";
        startLabel.textColor = [UIColor whiteColor];
        [historyview addSubview:startLabel];
        
        
        UILabel *endtimeView = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 180, 20)];
        endtimeView.text = @"结束日期:";
        endtimeView.textColor = [UIColor whiteColor];
        [historyview addSubview:endtimeView];
        
        NSArray *titleBtnArr = [NSArray arrayWithObjects:@"取消",@"确认", nil];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10+120*i, 165, 60, 25)];
            [button setTitle:titleBtnArr[i] forState:0];
            [historyview addSubview:button];
            button.tag = 102+i;
            [button addTarget:self action:@selector(afnetAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    }
}

- (void)afnetAction:(UIButton *)sender{
    
    
    if (sender.tag == 102) {
        //点击取消键
       [self deleteHistoryView];
    }else{
        //获取连网动
       UITextField *firsttextFeild = [self.view viewWithTag:105];
       // NSLog(@"%@",firsttextFeild.text);
        if (![quipDic objectForKey:firsttextFeild.text]) {
            //没有这个设备
            __block UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(kmainWidth/2-100, kmainHeight/2-40, 200, 80)];
            warnLabel.text = @"请输入正确的Mac地址";
            warnLabel.backgroundColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:0.6];
            warnLabel.textColor = [UIColor whiteColor];
            [self.view addSubview:warnLabel];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [warnLabel removeFromSuperview];
                warnLabel = nil;
            });
        }else{
            [self deleteHistoryView];
            [session close];
            macStr = [quipDic objectForKey:firsttextFeild.text];
            UITextField *secondTextFeild = [self.view viewWithTag:106];
            if ([secondTextFeild.text isEqualToString:@""]) {
                startStr = @"2017-03-21";
            }else{
            startStr = secondTextFeild.text;
            NSLog(@"%@",startStr);
            }
            UITextField *thirdTextFeild = [self.view viewWithTag:107];
            endStr = thirdTextFeild.text;
            [self afnetworking];
            [self clear];
            [_mapView removeOverlays:polylineArr];
            }
        
        
    }
}


- (void)closeKeyboard:(id)sender{
    [self.view endEditing:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}


- (void)deleteHistoryView{
    [UIView animateWithDuration:0.6 animations:^{
        historyview.frame = CGRectMake(-200, 50, 200, 200);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [historyview removeFromSuperview];
        historyview = nil;
    });

    
}




//做历史数据的网络接口
- (void)afnetworking{
    // 请求的参数
    
    
    NSDictionary *parameters = @{@"mac":macStr,
                                 @"startTime":startStr,
                                 @"endTime":endStr};
    NSString *path = @"http:121.196.194.14/langyang/Home/Police/getRouteByMac";
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    managers.securityPolicy.allowInvalidCertificates = YES;
    [managers POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"lp"] intValue] == 0) {
            locationArr = [dataDic[@"list"] objectForKey:@"location"];
            NSLog(@"%@",locationArr);
        }else{
            return;
        }
        
        
        [self showHistoryRoute];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
    }];
    
    
}





#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSArray *ARR = [quipDic allKeys];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",ARR[indexPath.row]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor blackColor];
    cell.alpha = 0.4;
    //    cell.contentView.backgroundColor = [UIColor blackColor];
    //    cell.contentView.alpha = 0.3;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [session close];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *quipname = [quipDic objectForKey:cell.textLabel.text];
    NSLog(@"%@",quipname);
    topicStr =[NSString stringWithFormat:@"application/1/node/%@/rx",quipname];
 
    [self mqtt];
   // [_mapView removeOverlay:commonPolylinenetwork];
   // [_mapView removeOverlay:commonPolylinemqtt];
    //[_mapView removeOverlays:self.processedOverlays];
    [self clear];
    [_mapView removeAnnotations:regions];
    [array removeAllObjects];
    [self deleteQuipList];
}




- (void)mqtt{
    
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    transport.host = @"121.196.194.14";
    transport.port = 1883;
    
    session = [[MQTTSession alloc] init];
    
    session.transport = transport;
    session.delegate = self;
    // 设置终端ID(可以根据后台的详细详情进行设置)
    int value = arc4random();
    session.clientId = [NSString stringWithFormat:@"%d",value];
    //session.clientId = @"1323555";
    session.userName = @"admin";
    session.password = @"password";
    NSLog(@"%@",topicStr);
    [session connectWithConnectHandler:^(NSError *error) {
        if (!error) {
            //以下部分是订阅一个话题
            [session subscribeToTopic:topicStr atLevel:2 subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss){
                if (error) {
                    NSLog(@"Subscription failed %@", error.localizedDescription);
                } else {
                    
                    NSLog(@"Subscription sucessfull! Granted Qos: %@", gQoss);
                    
                    
                }
            }];
        }else{
            NSLog(@"error:%@",error);
        }
    }];
    
}

//设置任务代理并连接成功之后，收到订阅的话题信息会执行以下

- (void)newMessage:(MQTTSession *)session  data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid{
    
    //将数据存在数组中
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    CLLocationDegrees latitude = [[dic objectForKey:@"latitude"] floatValue];
    CLLocationDegrees longitude = [[dic objectForKey:@"longitude"] floatValue];
    NSLog(@"%@",dic);
    CLLocationCoordinate2D amapcoord = AMapLocationCoordinateConvert(CLLocationCoordinate2DMake(latitude, longitude),AMapLocationCoordinateTypeGPS);
   // _mapView.center = CGPointMake(amapcoord.latitude, amapcoord.longitude);
        a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = amapcoord;
        a1.title = [dic objectForKey:@"nodeName"];
        [annoArr addObject:a1];
        [_mapView addAnnotation:a1];
        //做定位点
    
    [regions addObject:a1];
    NSString *la = [NSString stringWithFormat:@"%f",amapcoord.latitude];
    NSString *lo = [NSString stringWithFormat:@"%f",amapcoord.longitude];
    
    [array addObject:@[la,lo]];
    [self showRoute];
    
}





- (void)showRoute{
    
   NSLog(@"%@",array);
   
//    for (int i = 0; i<array.count; i++) {
//        
//        CLLocationDegrees latitude = [[array[i] objectAtIndex:0] floatValue];
//        CLLocationDegrees longitude = [[array[i] objectAtIndex:1]  floatValue];
//        NSLog(@"%f,%f",latitude,longitude);
//        commomPolylineCoords[i].latitude = latitude;
//        commomPolylineCoords[i].longitude = longitude;
//    
//    
//    commomPolylineCoords[array.count-1].latitude = [[[array lastObject] objectAtIndex:0] floatValue];
//    commomPolylineCoords[array.count-1].longitude = [[[array lastObject] objectAtIndex:1] floatValue];
//    commonPolylinemqtt = [MAPolyline polylineWithCoordinates:commomPolylineCoords count:array.count];
//    [_mapView addOverlay:commonPolylinemqtt];
//        [polylineArr addObject:commonPolylinemqtt];
//    
//    }
    
    NSArray *laArr = [array copy];
    
   // AMapCoordinateType type = AMapCoordinateTypeGPS;
    NSMutableArray *mArr = [NSMutableArray array];
    
    NSMutableArray *mArr2 = [NSMutableArray arrayWithCapacity:mArr.count];
    for (NSArray *sigleArr in laArr) {
        MATraceLocation *loc = [[MATraceLocation alloc] init];
        loc.loc = CLLocationCoordinate2DMake([sigleArr[0] doubleValue], [sigleArr[1] doubleValue]);
        [mArr addObject:loc];
        
        
        MATracePoint *p = [[MATracePoint alloc] init];
        p.longitude = loc.loc.longitude;
        p.latitude = loc.loc.latitude;
        
        if (fabs(p.longitude - 0) < 0.0001 && fabs(p.latitude - 0) < 0.0001) {
          continue;
        }
        
        [mArr2 addObject:p];
    }
    
    NSLog(@"%@",mArr2);
    MATraceManager *temp = [[MATraceManager alloc] init];
   // [self clear];
    [self addFullTrace:mArr2 toMapView:_mapView];
    
    
    __weak typeof(self) weakSelf = self;
    NSOperation *op = [temp queryProcessedTraceWith:mArr type:-1 processingCallback:^(int index, NSArray<MATracePoint *> *points) {
        [weakSelf addSubTrace:points toMapView:_mapView];
    }  finishCallback:^(NSArray<MATracePoint *> *points, double distance) {
        weakSelf.queryOperation = nil;
        [weakSelf addFullTrace:points toMapView:_mapView];
        
        } failedCallback:^(int errorCode, NSString *errorDesc) {
        NSLog(@"Error: %@", errorDesc);
        weakSelf.queryOperation = nil;
    }];
    
    self.queryOperation = op;

    
    
    
    
    
    
}

- (void)showHistoryRoute{
//    for (int i = 0; i<locationArr.count; i++) {
//        
//        CLLocationDegrees latitude = [[locationArr[i] objectForKey:@"latitude"] floatValue];
//        CLLocationDegrees longitude = [[locationArr[i] objectForKey:@"longitude"]  floatValue];
//        CLLocationCoordinate2D amapcoord = AMapLocationCoordinateConvert(CLLocationCoordinate2DMake(latitude, longitude),AMapLocationCoordinateTypeGPS);
//        NSLog(@"%f,%f",latitude,longitude);
//        commomPolylineCoords[i].latitude = amapcoord.latitude;
//        commomPolylineCoords[i].longitude = amapcoord.longitude;
//        
//        
//   }
//    commomPolylineCoords[locationArr.count-1].latitude = [[[locationArr lastObject] objectForKey:@"latitude"] floatValue];
//    commomPolylineCoords[locationArr.count-1].longitude = [[[locationArr lastObject] objectForKey:@"longitude"] floatValue];
//    commonPolylinenetwork = [MAPolyline polylineWithCoordinates:commomPolylineCoords count:locationArr.count];
//    [_mapView addOverlay:commonPolylinenetwork];
//    [polylineArr addObject:commonPolylinenetwork];
    
    NSMutableArray *mArr = [NSMutableArray array];
    
    NSMutableArray *mArr2 = [NSMutableArray arrayWithCapacity:mArr.count];
    for (NSDictionary *dict in locationArr) {
        
        CLLocationDegrees latitude = [[dict objectForKey:@"latitude"] floatValue];
        CLLocationDegrees longitude = [[dict objectForKey:@"longitude"] floatValue];
        CLLocationCoordinate2D amapcoord = AMapLocationCoordinateConvert(CLLocationCoordinate2DMake(latitude, longitude),AMapLocationCoordinateTypeGPS);
        MATraceLocation *loc = [[MATraceLocation alloc] init];
        //  loc.loc = CLLocationCoordinate2DMake(latitude, longitude);
        loc.loc = amapcoord;
        [mArr addObject:loc];
        
        
        MATracePoint *p = [[MATracePoint alloc] init];
        
        p.latitude = loc.loc.latitude;
        p.longitude = loc.loc.longitude;
        
        //        if (fabs(p.longitude - 0) < 0.0001 && fabs(p.latitude - 0) < 0.0001) {
        //            continue;
        //        }
        
        [mArr2 addObject:p];
    }
    NSLog(@"%@",mArr2);
    MATraceManager *temp = [[MATraceManager alloc] init];
    
    [self clear];
    [self addFullTrace:mArr2 toMapView:_mapView];
    
    
    __weak typeof(self) weakSelf = self;
    NSOperation *op = [temp queryProcessedTraceWith:mArr type:-3 processingCallback:^(int index, NSArray<MATracePoint *> *points) {
        [weakSelf addSubTrace:points toMapView:_mapView];
    }  finishCallback:^(NSArray<MATracePoint *> *points, double distance) {
        weakSelf.queryOperation = nil;
        [weakSelf addFullTrace:points toMapView:_mapView];
    
    } failedCallback:^(int errorCode, NSString *errorDesc) {
        NSLog(@"Error: %@", errorDesc);
        weakSelf.queryOperation = nil;
    }];
    
    self.queryOperation = op;
}
          
- (void)clear {
    [_mapView removeOverlays:self.processedOverlays];
    [self.processedOverlays removeAllObjects];
}





//做出线条
- (MAMultiPolyline *)makePolyLineWith:(NSArray<MATracePoint*> *)tracePoints {
    if(tracePoints.count == 0) {
        return nil;
    }
    
    CLLocationCoordinate2D *pCoords = malloc(sizeof(CLLocationCoordinate2D) * tracePoints.count);
    if(!pCoords) {
        return nil;
    }
    
    for(int i = 0; i < tracePoints.count; ++i) {
        MATracePoint *p = [tracePoints objectAtIndex:i];
        CLLocationCoordinate2D *pCur = pCoords + i;
        pCur->latitude = p.latitude;
        pCur->longitude = p.longitude;
    }
    
    MAMultiPolyline *polyline = [MAMultiPolyline polylineWithCoordinates:pCoords count:tracePoints.count drawStyleIndexes:@[@10, @60]];
    
    if(pCoords) {
        free(pCoords);
    }
    
    return polyline;
}

- (void)addFullTrace:(NSArray<MATracePoint*> *)tracePoints toMapView:(MAMapView *)mapView{
    MAMultiPolyline *polyline = [self makePolyLineWith:tracePoints];
    if(!polyline) {
        return;
    }
    
    [mapView removeOverlays:self.processedOverlays];
    [self.processedOverlays removeAllObjects];
    
    //[mapView setVisibleMapRect:MAMapRectInset(polyline.boundingMapRect, -1000, -1000)];
    
    [self.processedOverlays addObject:polyline];
    [mapView addOverlays:self.processedOverlays];
    
}


- (void)addSubTrace:(NSArray<MATracePoint*> *)tracePoints toMapView:(MAMapView *)mapView {
    MAMultiPolyline *polyline = [self makePolyLineWith:tracePoints];
    if(!polyline) {
        return;
    }
    
    MAMapRect visibleRect = [mapView visibleMapRect];
    if(!MAMapRectContainsRect(visibleRect, polyline.boundingMapRect)) {
        MAMapRect newRect = MAMapRectUnion(visibleRect, polyline.boundingMapRect);
        [mapView setVisibleMapRect:newRect];
    }
    
        [self.processedOverlays addObject:polyline];
        [mapView addOverlay:polyline];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
            polylineView.lineWidth   = 8.f;
            polylineView.strokeColor = [UIColor purpleColor];

        
        return polylineView;
    }
    
    return nil;
}



                       
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
                           
   if ([annotation isKindOfClass:[MAPointAnnotation class]])
   {
       
       static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
       MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
       
       annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
       
       annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
       
       //annotationView.animatesDrop = YES;//设置标注动画显示，默认为NO
       
       // annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
       
       // annotationView.pinColor = MAPinAnnotationColorRed;
       annotationView.image = [UIImage imageNamed:@"定位蓝色.png"];
       return annotationView;
   }
   return nil;
}
/*
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.lineWidth = 8.0f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:106.0f/255 green:90.0f/255 blue:205.0f/255 alpha:0.7];
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
*/
                       
                       
                       
                       

#pragma mark - UITextFeildDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 106) {
        
        [startLabel removeFromSuperview];
        startLabel = nil;
    }
    
    
    return YES;
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
