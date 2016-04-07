//
//  NSDate+Extend.h
//  TestIOS
//
//  Created by 123 on 15/11/18.
//  Copyright © 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Extend)
/*
 *当前日期，解决8小时时间差
 */
+ (NSDate*)currentDate;
@end



@interface NSDateFormatter(Extend)
/**
 *
 */
+ (NSDateFormatter*)defaultDateFormatter;
@end