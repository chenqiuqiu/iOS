//
//  StopCarController.m
//  practice
//
//  Created by 陈彦彤 on 17/2/21.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "StopCarController.h"
#import "MQTTClient.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "NaviViewController.h"


@interface StopCarController ()<MQTTSessionDelegate,AMapNaviDriveManagerDelegate>
{
    MQTTSession *session;
    NSMutableArray *array;
    MAPointAnnotation *a1;
    NSMutableDictionary *dicannotation;
    
}

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;

@property (nonatomic, strong) NSMutableArray *origOverlays;
@property (nonatomic, strong) NSMutableArray *regions;

@end

@implementation StopCarController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    array = [NSMutableArray array];
    a1 = [[MAPointAnnotation alloc] init];
    dicannotation = [NSMutableDictionary dictionary];
    
    
    [self mqtt];
    
    //设置导航的起点和终点
    self.startPoint = [AMapNaviPoint locationWithLatitude:30.285161 longitude:120.01367];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:30.285461 longitude:120.01239];
    
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(gotoNaviAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
}


- (void)gotoNaviAction{
    NaviViewController *navi = [[NaviViewController alloc] init];
    [self.navigationController pushViewController:navi animated:YES];
}




- (void)mqtt{
    
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    transport.host = @"121.196.194.14";
    transport.port = 1883;
    
    session = [[MQTTSession alloc] init];
    
    session.transport = transport;
    session.delegate = self;
    // 设置终端ID(可以根据后台的详细详情进行设置)
    
    session.clientId = @"sudfgf";
    session.userName = @"admin";
    session.password = @"password";
    
    [session connectWithConnectHandler:^(NSError *error) {
        if (!error) {
            //以下部分是订阅一个话题
            [session subscribeToTopic:@"application/2/node/+/rx" atLevel:2 subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss){
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
    
//    MAPointAnnotation *carAnnotation1 = [[MAPointAnnotation alloc] init];
//    carAnnotation1.coordinate = amapcoord;
    
    
    
    
    
//    carAnnotation1.title = @"浙江理工大学科技与艺术学院";
//    carAnnotation1.subtitle = @"杭州市文一西路960号";
   
    NSString *stopName = [dic objectForKey:@"nodeName"];
    if ( ![array containsObject:stopName]) {
        a1 = [[MAPointAnnotation alloc] init];
        
        a1.coordinate = amapcoord;
        a1.title = stopName;
        
        //NSLog(@"定位物信息：%@",dic);
        
        [array addObject:a1.title];
        [dicannotation setObject:a1 forKey:a1.title];
        [_regions addObject:a1];
        NSLog(@"%@",dicannotation);
        [_mapView addAnnotation:a1];
        

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
//
   
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        //路径规划
    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                endPoints:@[self.endPoint]
                                                wayPoints:nil
                                          drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}


- (void)showNaviRoutes
{
    
//    [_mapView removeOverlays:_mapView.overlays];
//    [self.routeIndicatorInfoArray removeAllObjects];
    
    //将路径显示到地图上
    for (NSNumber *aRouteID in [self.driveManager.naviRoutes allKeys])
    {
        AMapNaviRoute *aRoute = [[self.driveManager naviRoutes] objectForKey:aRouteID];
        int count = (int)[[aRoute routeCoordinates] count];
        
        //添加路径Polyline
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < count; i++)
        {
            AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
            coords[i].latitude = [coordinate latitude];
            coords[i].longitude = [coordinate longitude];
        }
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
        
        
        
        [_mapView addOverlay:polyline];
        free(coords);
        
    }
    
}



- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    
    MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
    
    
    polylineView.lineWidth   = 8.f;
    polylineView.strokeColor = [UIColor blueColor];
    
    return polylineView;
    
    
    
}
- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error
{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后显示路径
    [self showNaviRoutes];
}





//- (void)showCarLocation{
//    
//    
//    MAPointAnnotation *carAnnotation1 = [[MAPointAnnotation alloc] init];
//    carAnnotation1.coordinate = CLLocationCoordinate2DMake(30.282353, 120.023488);
//    carAnnotation1.title = @"浙江理工大学科技与艺术学院";
//    carAnnotation1.subtitle = @"杭州市文一西路960号";
//    [_mapView addAnnotation:carAnnotation1];
//    
//    MAPointAnnotation *carAnnotation2 = [[MAPointAnnotation alloc] init];
//    carAnnotation2.coordinate = CLLocationCoordinate2DMake(30.2810297, 120.018679);
//    carAnnotation2.title = @"海创园1号楼";
//    carAnnotation2.subtitle = @"浙江省杭州市余杭文一西路231号";
//    [_mapView addAnnotation:carAnnotation2];
//    
//    MAPointAnnotation *carAnnotation3 = [[MAPointAnnotation alloc] init];
//    carAnnotation3.coordinate = CLLocationCoordinate2DMake(30.2790972, 120.022449);
//    carAnnotation3.title = @"小拇指汽车维修";
//    carAnnotation3.subtitle = @"浙江省杭州市余杭文一西路65号";
//    [_mapView addAnnotation:carAnnotation3];
//    
//    [annotationArr addObject:carAnnotation1];
//    [annotationArr addObject:carAnnotation2];
//    [annotationArr addObject:carAnnotation3];
//    
//    
//    
//}

#pragma mark - mapviewDelegate,设置标注样式

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
         annotationView.pinColor = MAPinAnnotationColorPurple;
         */
        annotationView.image = [UIImage imageNamed:@"p"];
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
