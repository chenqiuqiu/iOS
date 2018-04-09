//
//  ScanViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/9.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "ScanViewController.h"
//#import "AFNetworking.h"
//#import "HomeViewController.h"

@interface ScanViewController ()
 <AVCaptureMetadataOutputObjectsDelegate>
{
    CAGradientLayer *scanLayer;
    UIView *scanBox;
    
    NSString *stringValue;
    AVMetadataMachineReadableCodeObject *metadataObject;
}
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   // [self setupCamera];
    [self createNavigationBar];
    
}


- (void)createNavigationBar{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, 64)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    
    
}








- (void)setupCamera
{
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.output setRectOfInterest:CGRectMake(0.35f, 0.2f, 0.7f, 0.8f)];
    
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    // 条码类型
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0, 0, kmainWidth, kmainHeight);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainWidth, kmainHeight)];
    [maskView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [self.view addSubview:maskView];
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kmainWidth,kmainHeight)];
    
    // MARK: circlePath 画圆
    // [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(SelfW / 2, 200) radius:100 startAngle:0 endAngle:2*M_PI clockwise:NO]];
    
    // MARK: roundRectanglePath 画矩形！
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(kmainWidth *0.2f, kmainHeight*0.35f, kmainWidth - kmainWidth*0.4f, kmainHeight - kmainHeight *0.7f) cornerRadius:0] bezierPathByReversingPath]];
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.path = path.CGPath;
    
    [maskView.layer setMask:shapeLayer];
    
    
    scanBox = [[UIView alloc]initWithFrame:CGRectMake(kmainWidth *0.2f, kmainHeight*0.35f, kmainWidth - kmainWidth*0.4f, kmainHeight - kmainHeight *0.7f)];
    
    scanBox.layer.borderColor = [UIColor greenColor].CGColor;
    scanBox.layer.borderWidth = 1.0f;
    [self.view addSubview:scanBox];
    
    // 扫描线
    scanLayer = [[CAGradientLayer alloc]init];
    scanLayer.frame = CGRectMake(0, 0, scanBox.bounds.size.width, 30);
    [scanBox.layer addSublayer:scanLayer];
    // 设置渐变颜色方向
    scanLayer.startPoint = CGPointMake(0, 0);
    scanLayer.endPoint = CGPointMake(0, 1);
    // 设定颜色组
    scanLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor brownColor].CGColor];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    
    // Start
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
   
    if (metadataObjects.count>0) {
        //[session stopRunning];
        metadataObject = [metadataObjects objectAtIndex : 0 ];
       stringValue = [NSString stringWithFormat:@"设备%@已绑定" ,metadataObject.stringValue];
    }
    //输出扫描字符串
    [self.session stopRunning];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:stringValue preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //[self netWorking];
    }];
    
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = scanLayer.frame;
    if (scanBox.frame.size.height < (scanLayer.frame.origin.y+30 + 5)) {
        frame.origin.y = -5;
        scanLayer.frame = frame;
    }else{
        frame.origin.y += 5;
        [UIView animateWithDuration:0.1 animations:^{
            scanLayer.frame = frame;
        }];
    }
    
    
}

//- (void)netWorking{
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *userID = [userDefaults objectForKey:@"id"];
//    
//    NSDictionary *parameters = @{@"userid":userID,
//                                 @"mac":[NSString stringWithFormat:@"%@",metadataObject.stringValue]};
//    NSLog(@"%@",metadataObject.stringValue);
//    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
//    [managers POST:@"http://121.196.194.14/langyang/Home/Langyang/bindDevice" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        //界面跳转
//        HomeViewController *home = [[HomeViewController alloc] init];
//        [self.navigationController pushViewController:home animated:YES];
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
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
