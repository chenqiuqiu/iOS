//
//  BezierView.m
//  practice
//
//  Created by 陈彦彤 on 17/3/3.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

#import "BezierView.h"

@implementation BezierView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect{
    
    UIBezierPath *mPath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(5, 5) radius:5 startAngle:0 endAngle:6.25 clockwise:YES];
    UIColor *fill = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [fill set];
    [mPath1 fill];
    UIBezierPath *mPath2 = [UIBezierPath bezierPath];
    [mPath2 moveToPoint:CGPointMake(5, 10)];
   // [mPath addLineToPoint:CGPointMake(40, 10)];
    [mPath2 addLineToPoint:CGPointMake(5, 75)];
   // [mPath closePath];
    mPath2.lineWidth = 1.5;
    
    
    UIColor *stroke = [UIColor colorWithRed:178.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
    [stroke set];
    [mPath2 stroke];
    
    
}





@end

