//
//  NSCalendar+Extend.m
//  TestIOS
//
//  Created by 123 on 15/11/19.
//  Copyright © 2015年 ly. All rights reserved.
//

#import "NSCalendar+Extend.h"

@implementation NSCalendar(Extend)
/**
 *  中国农历
 *
 *  @return
 */
+ (NSCalendar*)chineseCalendar {
    return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
}


//+ (NSDateComponents*)chineseDateComponents:(NSDate *)date {
//    
//}


/**
 *  中国农历,年月日名
 *
 *  @return
 */
NSString * const kChineseDateComponentsNameYear   = @"com.breakios.testIOS.chineseDateComponentsName.year";
NSString * const kChineseDateComponentsNameMonth  = @"com.breakios.testIOS.chineseDateComponentsName.month";
NSString * const kChineseDateComponentsNameDay    = @"com.breakios.testIOS.chineseDateComponentsName.day";
NSString * const kChineseDateComponentsNameHour   = @"com.breakios.testIOS.chineseDateComponentsName.hour";
NSString * const kChineseDateComponentsNameMinute = @"com.breakios.testIOS.chineseDateComponentsName.minute";
NSString * const kChineseDateComponentsNameSecond = @"com.breakios.testIOS.chineseDateComponentsName.second";

+ (NSDictionary*)chineseDateComponentsName:(NSDate *)date {
    //中国农历年
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子",   @"乙丑",  @"丙寅",  @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑",  @"戊寅",  @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    //中国农历月
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    //中国农历日
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    //中国农历
    NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    //日历单元，年月日时分秒
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | \
                           NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *localeComp = [chineseCalendar components:unitFlags fromDate:date];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [chineseYears objectAtIndex:localeComp.year-1], kChineseDateComponentsNameYear,
            [chineseMonths objectAtIndex:localeComp.month-1], kChineseDateComponentsNameMonth,
            [chineseDays objectAtIndex:localeComp.day-1], kChineseDateComponentsNameDay,
            [NSString stringWithFormat:@"%d",(int)localeComp.hour], kChineseDateComponentsNameHour,
            [NSString stringWithFormat:@"%d",(int)localeComp.minute], kChineseDateComponentsNameMinute,
            [NSString stringWithFormat:@"%d",(int)localeComp.second], kChineseDateComponentsNameSecond,nil];
}






- (NSString*)weekdayNameOfDate:(NSDate*)date {
    //中国农历
    NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    //日历单元，年月日
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday;
    
    NSDateComponents *localeComp = [chineseCalendar components:unitFlags fromDate:date];
    
    return [[self weekdayNamesWithFirstWeekday:self.firstWeekday] objectAtIndex:localeComp.weekday-self.firstWeekday];
}

/**
 *  获取
 *
 *  @param firstWeekday
 *
 *  @return
 */
- (NSArray*)weekdayNamesWithFirstWeekday:(NSUInteger)firstWeekday {
    NSArray *weekdayNames = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    
    switch (firstWeekday) {
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:{
            weekdayNames = [self leftShiftArray:weekdayNames times:firstWeekday-1];
        } break;
        case 1:
        default:
            break;
    }
    
    return weekdayNames;
}

/**
 *  数组循环左移
 *
 *  @param array 待移动数组
 *  @param n     移动次数
 *
 *  @return 移动后数组
 */
- (NSArray*)leftShiftArray:(NSArray*)array times:(NSUInteger)n {
    NSUInteger nn = n >= array.count ? n % array.count : n;
    if (nn == 0) {
        return array;
    }
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:array];
    
    NSMutableArray *tempArr1 = [[NSMutableArray alloc] init];
    for (int i=0; i<n; i++) {
        [tempArr1 addObject:[tempArr objectAtIndex:i]];
    }
    
    [tempArr removeObjectsInArray:tempArr1];
    return [tempArr arrayByAddingObjectsFromArray:tempArr1];
}




@end
