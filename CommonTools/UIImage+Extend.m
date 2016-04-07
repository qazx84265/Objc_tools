//
//  UIImage.m
//  TestIOS
//
//  Created by 123 on 15/11/4.
//  Copyright © 2015年 ly. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage (Extend)

/**
 *  颜色转化为UIImage
 *
 *  @param color
 *
 *  @return
 */
+ (UIImage*)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
