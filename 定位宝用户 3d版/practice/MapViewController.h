//
//  MapViewController.h
//  practice
//
//  Created by 陈彦彤 on 17/2/21.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MapViewController : UIViewController<AMapSearchDelegate,MAMapViewDelegate,AMapLocationManagerDelegate>
{
        MAMapView *_mapView;
        AMapLocationManager *_locationManager;
        AMapSearchAPI *_search;
        
      


}
@end
