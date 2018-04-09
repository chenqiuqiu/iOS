//
//  Click.h
//  bluetooth
//
//  Created by 陈彦彤 on 18/3/16.
//  Copyright © 2018年 朗阳科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Click : UIButton
//为按钮添加点击间隔 eventTimeInternal秒
@property (nonatomic, assign) NSTimeInterval eventTimeInterval;

@end
