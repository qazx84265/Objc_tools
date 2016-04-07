//
//  NSDate+Extend.m
//  TestIOS
//
//  Created by 123 on 15/11/18.
//  Copyright © 2015年 ly. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate(Extend)

/**
 *  解决8小时时间差
 *
 *  @return
 */
+ (NSDate*)currentDate {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [zone secondsFromGMTForDate:date];
    NSDate *currentDate = [date dateByAddingTimeInterval:interval];
    
    return currentDate;
}
@end





@implementation NSDateFormatter(Extend)
/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
+ (NSDateFormatter*)defaultDateFormatter {
    NSDateFormatter *defaultF = [[NSDateFormatter alloc] init];
    [defaultF setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return defaultF;
}
@end