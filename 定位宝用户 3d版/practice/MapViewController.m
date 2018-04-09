//
//  MapViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/2/21.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //加载地图
    [self initMapView];
    
    
    //用户定位
    [self startLocation];


}

- (void)initMapView{
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(-50, 0, kmainWidth+100, kmainHeight)];
    _mapView.delegate = self;
    _mapView.showsScale = NO;
    _mapView.showsCompass = NO;
    [_mapView setZoomLevel:14.5];
   // _mapView.centerCoordinate = CLLocationCoordinate2DMake(30.3, 120.3);
    
    [self.view addSubview:_mapView];
    
}

- (void)startLocation{
    
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.locatingWithReGeocode = YES;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [_locationManager startUpdatingLocation];
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    
    
    
    
}

//- (void)getGPSinfo{
//    UIImageView *titleIMG = [[UIImageView alloc] initWithFrame:CGRectMake(10, kmainHeight - 185, 250, 30)];
//    
//    UIImageView *bgIMG = [[UIImageView alloc] initWithFrame:CGRectMake(124, 2, 2, 26)];
//    bgIMG.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1];
//    [titleIMG addSubview:bgIMG];
//    titleIMG.backgroundColor = [UIColor whiteColor];
//    titleIMG.layer.cornerRadius = 15;
//    titleIMG.layer.shadowColor = [UIColor blackColor].CGColor;
//    titleIMG.layer.shadowRadius = 4;
//    titleIMG.layer.shadowOffset = CGSizeMake(5, 5);
//    titleIMG.layer.shadowOpacity = 0.4;
//    [self.view addSubview:titleIMG];
//    
//    UIButton *userButt = [[UIButton alloc] initWithFrame:CGRectMake(15, 1, 100, 30)];
//    [userButt setTitle:@"追踪用户位置" forState:UIControlStateNormal];
//    [userButt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    userButt.titleLabel.font = [UIFont systemFontOfSize:14];
//    [titleIMG addSubview:userButt];
//    
//    UIButton *equipButt = [[UIButton alloc] initWithFrame:CGRectMake(128, 1, 100, 30)];
//    [equipButt setTitle:@"追踪设备位置" forState:UIControlStateNormal];
//    [equipButt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    equipButt.titleLabel.font = [UIFont systemFontOfSize:14];
//    [titleIMG addSubview:equipButt];
//    
//    
//    
//    UIImageView *InfoIMG = [[UIImageView alloc] initWithFrame:CGRectMake(10, kmainHeight-150, kmainWidth-20, 70)];
//    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(60, 34, kmainWidth - 81, 2)];
//    line.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1];
//    [InfoIMG addSubview:line];
//    InfoIMG.backgroundColor = [UIColor whiteColor];
//    InfoIMG.layer.shadowColor = [UIColor blackColor].CGColor;
//    InfoIMG.layer.shadowRadius = 4;
//    InfoIMG.layer.shadowOffset = CGSizeMake(5, 5);
//    InfoIMG.layer.shadowOpacity = 0.4;
//    [self.view addSubview:InfoIMG];
//    
//    UIImageView *spotIMG1 = [[UIImageView alloc] initWithFrame:CGRectMake(28, 18, 5, 5)];
//    spotIMG1.image = [UIImage imageNamed:@"FA5C5FAC-0663-48DC-8564-02FBC4A16015"];
//    [InfoIMG addSubview:spotIMG1];
//    UIImageView *spotIMG2 = [[UIImageView alloc] initWithFrame:CGRectMake(28, 49, 5, 5)];
//    spotIMG2.image = [UIImage imageNamed:@"FA5C5FAC-0663-48DC-8564-02FBC4A16015"];
//    [InfoIMG addSubview:spotIMG2];
//    reGeoLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 300, 24)];
//    
//    [InfoIMG addSubview:reGeoLabel];
//    
//    
//    
//}
//
//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
//    if (reGeocode) {
//        // NSLog(@"%@",reGeocode);
//        reGeoLabel.text = [NSString stringWithFormat:@"%@",reGeocode.POIName];
//        reGeoLabel.font = [UIFont fontWithName:@"Arial" size:15];
//        
//        NSString *latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
//        NSString *longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
//        NSArray *locationArr = [NSArray arrayWithObjects:latitude,longitude,reGeoLabel.text, nil];
//        
//        //通知传值
//        NSNotification *note = [[NSNotification alloc] initWithName:@"TextValueChanged" object:locationArr userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:note];
//    }
//    
//}










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
