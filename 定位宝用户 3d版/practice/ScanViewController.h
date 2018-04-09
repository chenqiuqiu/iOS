//
//  ScanViewController.h
//  practice
//
//  Created by 陈彦彤 on 17/1/9.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ScanViewController : UIViewController

@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;//输入输出中间桥梁
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;


@end
