//
//  HomeViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/9.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "HomeViewController.h"
#import "MQTTClient.h"


@interface HomeViewController ()<MQTTSessionDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UILabel *reGeoLabel;
    UILabel *macLabel;
    NSDictionary *dic;
    NSMutableArray *array;
    NSString *macStr;
    
    UIViewController *currentVC;
    
    MQTTSession *session;
    MAPointAnnotation *a1;
    CLLocationCoordinate2D amapcoord;//gps转换过的码
    
    NSMutableDictionary *dicannotation;
    NSMutableArray *annoArr;
    NSString *plistPath;
    
    int count;
    UITableView *mactableView;
    NSString *topicStr;
    UIButton *deleteButton;
    NSDictionary *quipDic;
    
    int value;
    
}
@property (nonatomic, strong) NSMutableArray *regions;




@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getGPSinfo];
    count = 0;
    
    a1 = [[MAPointAnnotation alloc] init];
    array = [NSMutableArray array];
    dicannotation = [NSMutableDictionary dictionary];
    _regions = [NSMutableArray array];
    macStr = nil;
    
     value = arc4random();
    
    //做plist表格
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    plistPath = [documentPath stringByAppendingPathComponent:@"annotation.plist"];
    NSMutableArray *testArr = [[NSMutableArray alloc] init];
   // [testArr addObject:[NSArray arrayWithObjects:@"0.0",@"0.0",@"mac名称", nil]];
    [testArr writeToFile:plistPath atomically:YES];
    NSLog(@"%@",plistPath);
    //创建含有多个终端模块的表格
    
    
    //做两个按钮
    NSArray *chooseArr = [NSArray arrayWithObjects:@"显示所有终端",@"选择一个终端", nil];
    for (int i = 0; i < 2; i++) {
        UIView *chooseView = [[UIView alloc] initWithFrame:CGRectMake(-20, 30+40*i, 120, 30)];
        chooseView.backgroundColor = [UIColor whiteColor];
        chooseView.layer.cornerRadius = 15;
        chooseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        chooseView.layer.borderWidth = 1.5;
        [self.view addSubview:chooseView];
        
        UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 120, 30)];
        chooseButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [chooseButton setTitle:chooseArr[i] forState:0];
        [chooseButton setTitleColor:[UIColor grayColor] forState:0];
        [chooseButton addTarget:self action:@selector(quipList:) forControlEvents:UIControlEventTouchUpInside];
        chooseButton.tag = i;
        [chooseView addSubview:chooseButton];
        
    }
    
    quipDic = @{@"10000071":@"9728a5b6b7b89525",
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:quipDic forKey:@"quipDic"];
    
    [self mqtt];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView removeFromSuperview];
    _mapView = nil;
    
    _mapView.showsUserLocation = NO;
    _mapView.delegate = nil;
    
    
    [session disconnect];
}






//做终端列表
- (void)quipList:(UIButton *)sender{
   // NSLog(@"%li",sender.tag);
    
    
    if (sender.tag == 0) {
       //点击显示所有终端按钮
        [mactableView removeFromSuperview];
        mactableView = nil;
        topicStr = @"application/1/node/+/rx";
        [self mqtt];
    }else{
       if (mactableView == nil) {
            mactableView = [[UITableView alloc] initWithFrame:CGRectMake(-kmainWidth/3, 105, kmainWidth/3, 140)];
            [self.view addSubview:mactableView];
            mactableView.delegate = self;
            mactableView.dataSource = self;
            mactableView.backgroundColor = [UIColor blackColor];
            mactableView.alpha = 0.4;
            mactableView.rowHeight = 30;
           
           deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, 95, 20, 20)];
          // deleteButton.backgroundColor = [UIColor redColor];
           [deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:0];
           [deleteButton addTarget:self action:@selector(deleteQuipList) forControlEvents:UIControlEventTouchUpInside];
           [self.view addSubview:deleteButton];

            [UIView animateWithDuration:0.5 animations:^{
                 mactableView.frame = CGRectMake(5, 105, kmainWidth/3, 140);
                deleteButton.frame = CGRectMake(kmainWidth/3-5, 95, 20, 20);
                
            }];
       }
    }
}
- (void)deleteQuipList{
    [UIView animateWithDuration:0.6 animations:^{
        mactableView.frame = CGRectMake(-kmainWidth/3, 105, kmainWidth/3, 140);
        deleteButton.frame = CGRectMake(-20, 95, 20, 20);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [mactableView removeFromSuperview];
        mactableView = nil;
        
        [deleteButton removeFromSuperview];
        deleteButton = nil;
    });
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    //从单例中取出在list中选择的设备号；
   //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //macStr = [userDefaults objectForKey:@"equip"];
    topicStr = @"application/1/node/+/rx";
    
    
}






- (void)mqtt{
    
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    transport.host = @"121.196.194.14";
    transport.port = 1883;
    
    session = [[MQTTSession alloc] init];
    
    session.transport = transport;
    session.delegate = self;
    // 设置终端ID(可以根据后台的详细详情进行设置)
    
    session.clientId = [NSString stringWithFormat:@"%d",value];
    session.userName = @"admin";
    session.password = @"password";
    
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
    dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    CLLocationDegrees latitude = [[dic objectForKey:@"latitude"] floatValue];
    CLLocationDegrees longitude = [[dic objectForKey:@"longitude"] floatValue];
    NSLog(@"%@",dic);
    amapcoord = AMapLocationCoordinateConvert(CLLocationCoordinate2DMake(latitude, longitude),AMapLocationCoordinateTypeGPS);
//    a1 = [[MAPointAnnotation alloc] init];
//    a1.coordinate = amapcoord;
//    a1.title = [dic objectForKey:@"nodeName"];
//    [_mapView addAnnotation:a1];
    macStr = [dic objectForKey:@"nodeName"];

//
//    if ([macStr isEqualToString:@"1000007B"]) {
//       
//        if (annoArr.count < 8) {
//           //传过来的是第1个或第二个  要用紫色表示
//            
////            NSString *la = [NSString stringWithFormat:@"%f",amapcoord.latitude];
////            NSString *lo = [NSString stringWithFormat:@"%f",amapcoord.longitude];
////            
////            NSArray *arraylocation = [NSArray arrayWithObjects:la,lo,[dic objectForKey:@"nodeName"], nil];
////            annoArr = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath] mutableCopy];
////            
////            [annoArr addObject:arraylocation];
////            [annoArr writeToFile:plistPath atomically:YES];
////            NSLog(@"同一定位物定出来的不同位置：%@",annoArr);
////            
////            
////            
////            MAPointAnnotation *averAnnotation = [[MAPointAnnotation alloc] init];
////            averAnnotation.coordinate = CLLocationCoordinate2DMake(amapcoord.latitude, amapcoord.longitude);
////            averAnnotation.title = @"1000007B 测试点";
////            [_mapView addAnnotation:averAnnotation];
//            
//            
//        }else {
//            //代表传过来的是第三个点，第六个点，第九个点等
//            
//            CGFloat totallat = 0.0;
//            CGFloat totallot = 0.0;
//            for (NSArray *array1 in annoArr) {
//                totallat = [array1[0] floatValue] + totallat;
//                totallot = [array1[1] floatValue] + totallot;
//            }
//            MAPointAnnotation *averAnnotation;
//            CLLocationDegrees averLoti = totallat / 8;
//            CLLocationDegrees averLogi = totallot / 8;
//            NSLog(@"平均值：%f,%f",averLoti,averLogi);
//           
//                
//                averAnnotation = [[MAPointAnnotation alloc] init];
//                averAnnotation.coordinate = CLLocationCoordinate2DMake(averLoti, averLogi);
//                averAnnotation.title = @"1000007B";
//                [_mapView addAnnotation:averAnnotation];
//            
//            annoArr = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath] mutableCopy];
//            
//            [annoArr removeAllObjects];
//            [annoArr writeToFile:plistPath atomically:YES];
//            NSLog(@"同一定位物定出来的不同位置：%@",annoArr);
//            
//            [_regions addObject:averAnnotation];
//            
//            
//        }
//        count ++;
//    }else{
    
//     [array addObject:@[la,lo]];
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    //做定位点
    
    if ( ![array containsObject:[dic objectForKey:@"nodeName"]]) {
        a1 = [[MAPointAnnotation alloc] init];

        a1.coordinate = amapcoord;
        a1.title = [dic objectForKey:@"nodeName"];
        
        //NSLog(@"定位物信息：%@",dic);
        
        [array addObject:a1.title];
        [dicannotation setObject:a1 forKey:a1.title];
        [_regions addObject:a1];
        NSLog(@"%@",dicannotation);
        [_mapView addAnnotation:a1];
        
        if ([a1.title isEqualToString:macStr]) {
            
            //逆地理编码
            AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
            regeo.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
            NSLog(@"%@",regeo.location);
            regeo.requireExtension = YES;
            
            _search = [[AMapSearchAPI alloc] init];
            _search.delegate = self;
            [_search AMapReGoecodeSearch:regeo];
            
            
        }
        }else{
            
            [_mapView removeAnnotation:dicannotation[[dic objectForKey:@"nodeName"]]];
            
            MAPointAnnotation *anno = dicannotation[[dic objectForKey:@"nodeName"]];
            anno.coordinate = amapcoord;
            anno.title = [dic objectForKey:@"nodeName"];
            [_mapView addAnnotation:anno];
            if (anno != nil) {
                
                [_regions addObject:anno];
            }
            NSLog(@"%@",dicannotation);
        }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if (response.regeocode != nil) {
        NSArray *addressArr = response.regeocode.pois;
        if (addressArr && addressArr.count > 0) {
            AMapPOI *poiTemp = addressArr[0];
            macLabel.text = [NSString stringWithFormat:@"%@",poiTemp.name];
        }
    }
    
    
}


- (void)getGPSinfo{
    UIImageView *titleIMG = [[UIImageView alloc] initWithFrame:CGRectMake(10, kmainHeight - 226, 250, 30)];
   
    UIImageView *bgIMG = [[UIImageView alloc] initWithFrame:CGRectMake(124, 2, 2, 26)];
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
    [userButt setTitle:@"追踪用户位置" forState:UIControlStateNormal];
    [userButt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    userButt.titleLabel.font = [UIFont systemFontOfSize:14];
    [titleIMG addSubview:userButt];
    
    UIButton *equipButt = [[UIButton alloc] initWithFrame:CGRectMake(128, 1, 100, 30)];
    [equipButt setTitle:@"追踪设备位置" forState:UIControlStateNormal];
    [equipButt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    equipButt.titleLabel.font = [UIFont systemFontOfSize:14];
    [titleIMG addSubview:equipButt];
    
    
    
    UIImageView *InfoIMG = [[UIImageView alloc] initWithFrame:CGRectMake(10, kmainHeight-190, kmainWidth-20, 70)];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(60, 34, kmainWidth - 81, 2)];
    line.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1];
    [InfoIMG addSubview:line];
    InfoIMG.backgroundColor = [UIColor whiteColor];
    InfoIMG.layer.shadowColor = [UIColor blackColor].CGColor;
    InfoIMG.layer.shadowRadius = 4;
    InfoIMG.layer.shadowOffset = CGSizeMake(5, 5);
    InfoIMG.layer.shadowOpacity = 0.4;
    [self.view addSubview:InfoIMG];
    
    UIImageView *spotIMG1 = [[UIImageView alloc] initWithFrame:CGRectMake(28, 18, 5, 5)];
    spotIMG1.image = [UIImage imageNamed:@"FA5C5FAC-0663-48DC-8564-02FBC4A16015"];
    [InfoIMG addSubview:spotIMG1];
    UIImageView *spotIMG2 = [[UIImageView alloc] initWithFrame:CGRectMake(28, 49, 5, 5)];
    spotIMG2.image = [UIImage imageNamed:@"FA5C5FAC-0663-48DC-8564-02FBC4A16015"];
    [InfoIMG addSubview:spotIMG2];
    reGeoLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 300, 24)];
    
    [InfoIMG addSubview:reGeoLabel];
    
    macLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 300, 24)];
    macLabel.font = [UIFont systemFontOfSize:14];
    [InfoIMG addSubview:macLabel];
    
       
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    if (reGeocode) {
        reGeoLabel.text = [NSString stringWithFormat:@"%@",reGeocode.POIName];
        reGeoLabel.font = [UIFont fontWithName:@"Arial" size:15];
        
         NSString *latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
         NSString *longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
         NSArray *locationArr = [NSArray arrayWithObjects:latitude,longitude,reGeoLabel.text, nil];
         
        //通知传值
         NSNotification *note = [[NSNotification alloc] initWithName:@"TextValueChanged" object:locationArr userInfo:nil];
         [[NSNotificationCenter defaultCenter] postNotification:note];
    }
    
}





#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{
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
            circleRenderer.strokeColor = [UIColor colorWithRed:164.0f/255 green:211.0f/255 blue:238.0f/255 alpha:0.4];
            circleRenderer.fillColor = [UIColor colorWithRed:164.0f/255 green:211.0f/255 blue:238.0f/255 alpha:0.4];
            return circleRenderer;
        
    }else if ([overlay isKindOfClass:[MAUserLocation class]])
    {
        
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth = 5.0f;
        circleRenderer.strokeColor = [UIColor blueColor];
        circleRenderer.fillColor = [UIColor colorWithRed:106.0f/255 green:90.0f/255 blue:205.0f/255 alpha:0.4];
        return circleRenderer;
        
    }
    return nil;
}
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        /*
         annotationView.animatesDrop = YES;//设置标注动画显示，默认为NO
         
         annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
         */
        // annotationView.pinColor = MAPinAnnotationColorPurple;
        if ([annotation.title isEqualToString:@"1000007B 测试点"]) {
                 annotationView.pinColor = MAPinAnnotationColorPurple;
            }else{
                
                annotationView.image = [UIImage imageNamed:@"定位红"];
            }
        
        
        
        return annotationView;
    }
    return nil;
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
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *quipname = [quipDic objectForKey:cell.textLabel.text];
    NSLog(@"%@",quipname);
    topicStr =[NSString stringWithFormat:@"application/1/node/%@/rx",quipname];
    //留下一个，其余的删除
    NSArray *delearray = [_regions copy];
    for (MAPointAnnotation *deleAno in delearray) {
        if (deleAno.title != cell.textLabel.text) {
            [_mapView removeAnnotation:deleAno];
        }
    }
    
    
    
    
    
    
    [self mqtt];
    
    
    [self deleteQuipList];
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
