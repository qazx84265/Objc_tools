//
//  NSCalendar+Extend.h   日历扩展
//  TestIOS
//
//  Created by 123 on 15/11/19.
//  Copyright © 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar(Extend)

/*
 *中国农历
 */
+ (NSCalendar*)chineseCalendar;

/*
 *中国农历日期年月日等
 */
//+ (NSDateComponents*)chineseDateComponents:(NSDate*)date;


/**
 *  中国农历年、月、日名，如“乙未年 冬月 初八”
 */
//返回key常量
extern NSString * const kChineseDateComponentsNameYear;
extern NSString * const kChineseDateComponentsNameMonth;
extern NSString * const kChineseDateComponentsNameDay;
extern NSString * const kChineseDateComponentsNameHour;
extern NSString * const kChineseDateComponentsNameMinute;
extern NSString * const kChineseDateComponentsNameSecond;

+ (NSDictionary*)chineseDateComponentsName:(NSDate*)date;


/**
 *  获取指定date为星期几
 */
- (NSString*)weekdayNameOfDate:(NSDate*)date;
@end
