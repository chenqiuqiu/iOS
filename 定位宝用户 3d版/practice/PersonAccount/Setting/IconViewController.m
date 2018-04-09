//
//  IconViewController.m
//  practice
//
//  Created by 陈彦彤 on 17/1/24.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "IconViewController.h"
#import "AFNetworking.h"

@interface IconViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *imgagePickController;
    NSString *userID;
    NSUserDefaults *userDefaults;
   
}

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;





@end

@implementation IconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人头像";
    
    imgagePickController = [[UIImagePickerController alloc] init];
    
    imgagePickController.delegate = self;
    imgagePickController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    imgagePickController.allowsEditing = YES;
    
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    userID = [userDefaults objectForKey:@"id"];
    NSData *imgData = [userDefaults objectForKey:@"iconimageView"];
    _imageView.image = [UIImage imageWithData:imgData];
    NSLog(@"%@",userID);
}


- (IBAction)longPress:(id)sender {
    _longPress = sender;
    if (_longPress.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *pickerAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self PicturesPick];
        }];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:photoAction];
        [alert addAction:pickerAction];
        [alert addAction:saveAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
}

- (void)PicturesPick{
   imgagePickController = [[UIImagePickerController alloc] init];
    imgagePickController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imgagePickController.delegate = self;
    imgagePickController.allowsEditing = YES;
    [self presentViewController:imgagePickController animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
   // NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    UIImage *srcImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = srcImage;
    [self netWorking];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //通知。告诉settingControllser头像的改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification" object:self userInfo:@{@"iconImage":self.imageView.image}];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) netWorking{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json", nil];
    
    NSDictionary *parameters = @{@"id":userID};
    NSLog( @"%@",userID);
    NSString *path = @"http://121.196.194.14/langyang/Home/User/uploadAvater";
    
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //fileData = UIImageJPEGRepresentation(_imageView.image, 1);
             NSData *fileData = UIImageJPEGRepresentation(_imageView.image, 1);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png",str];
        
            [formData appendPartWithFileData:fileData name:@"image"fileName:fileName mimeType:@"image/png"];
            NSLog( @"%@",formData);
           } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
       
      // [userDefaults setObject:fileData forKey:@"iconimageView"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
     
     
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
