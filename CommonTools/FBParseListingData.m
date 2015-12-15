//
//  FBParseListingData.m
//  ChelerPie
//
//  Created by 123 on 15/10/15.
//  Copyright © 2015年 com.linewin. All rights reserved.
//

#import "FBParseListingData.h"
#import "FileModel.h"
#import "CommonHelper.h"


#define REGEX_RES             @"^(\\d\\d\\d)\\s(.*)"
#define REGEX_MULTILINE       @"^(\\d\\d\\d)-"
#define REGEX_SERVER_RESPONSE @"^(\\d\\d\\d)(.*)"

#define REGEX_UNIX_LIST_START @"^[bcdlps-].*"
#define REGEX_DOS_LIST_START  @"^[0123456789].*"
#define REGEX_LINK_FILE @"(.*)\\s->\\s(.*)"

#define REGEX_LISTING_UNIX @"([bcdlfmpSs-])(((r|-)(w|-)([xsStTL-]))((r|-)(w|-)([xsStTL-]))((r|-)(w|-)([xsStTL-])))\\+?\\s+(\\d+)\\s+(\\S+)\\s+(?:(\\S+)\\s+)?(\\d+)\\s+((?:\\d+[-/]\\d+[-/]\\d+)|(?:\\S+\\s+\\S+))\\s+(\\d+(?::\\d+)?)\\s*(.*)"
#define REGEX_LISTING_DOS @"(\\S+)\\s+(\\S+)\\s+(<DIR>)?\\s*([0-9]+)?\\s*(\\S.*)"

@implementation FBParseListingData
+ (instancetype)sharedParse {
    static dispatch_once_t once;
    static FBParseListingData *sharedParse = nil;
    
    dispatch_once(&once, ^{
        sharedParse = [self new];
    });
    
    return sharedParse;
}


/**
 *  解析unix 或 dos格式数据
 *
 *  @param data
 *  @param callback
 */
- (void)parseListingData:(NSData *)data handler:(parseCallback)callback {
    NSString *listStr = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *entries = [listStr componentsSeparatedByString:@"\r\n"];
    
    
    
    NSMutableArray *filesArray = [@[] mutableCopy];
    FileModel *file = nil;
    
    for (NSString *str in entries) {
        NSString *entry = str;
        // Some servers include an official code-multiline sign at the beginning
        // of every string. We must strip it if that's the case.
        if ([self isString:entry regular:REGEX_MULTILINE]) {
            entry = [entry substringFromIndex:3];
        }
        
        // Filter the whitespace characters at leading or tail.
        entry = [entry stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([self isString:entry regular:REGEX_SERVER_RESPONSE] || [self isString:entry regular:REGEX_RES] || [self isString:entry regular:REGEX_MULTILINE]) {
            continue;
        }
        
        file = [self parseEntry:entry];
        if (file) {
            [filesArray addObject:file];
        }
    }
    
    callback(filesArray);
}

/**
 *  parse every single line
 *
 *  @param entry
 */
- (FileModel*)parseEntry:(NSString*)entry {
    //unix format
    if ([self isString:entry regular:REGEX_UNIX_LIST_START]) {
        return [self parseEntryUnix:entry];
    }
    //dos format
    else if([self isString:entry regular:REGEX_DOS_LIST_START]) {
        return [self parseEntryDos:entry];
    }
    
    return nil;
}


/**
 *  parse unix format:[ drwx------   3 123   staff     102  3 12  2015 Applications ]
 *
 *  @param entry
 *
 *  @return
 */
- (FileModel*)parseEntryUnix:(NSString*)entry {
    //    if (![self isString:entry regular:REGEX_LISTING_UNIX]) {
    //        return nil;
    //    }
    FileModel *file = [FileModel new];
    
    NSArray *matches = [self matchString:entry withRegx:REGEX_LISTING_UNIX];
    if (!matches || matches.count==0) {
        return nil;
    }
    
    NSTextCheckingResult *obj = [matches objectAtIndex:0];
    //    [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        for (int i = 1; i<[obj numberOfRanges]; i++) {
    //            NSRange rg = [obj rangeAtIndex:i];
    //            NSString *s = [entry substringWithRange:rg];
    //            NSLog(@"%@",s);
    //        }
    FileType filetype;
    NSString *fileName = [entry substringWithRange:[obj rangeAtIndex:21]];
    if ([fileName isEqualToString:@"."] || [fileName isEqualToString:@".."]) {
        return nil;
    }
    
    
    UInt64 fileSize = [[entry substringWithRange:[obj rangeAtIndex:18]] longLongValue];
    //        NSString *user = [entry substringWithRange:[obj rangeAtIndex:16]];
    //        NSString *grp = [entry substringWithRange:[obj rangeAtIndex:17]];
    //        NSDate *date;
    NSString *fileLinkTo = @"";
    
    
    NSString *tempStr = @"";
    
    //        //file date
    //        tempStr = [entry substringWithRange:[obj rangeAtIndex:20]];
    //        if ([tempStr containsString:@":"]) {
    //
    //        }
    
    
    //file type
    tempStr = [entry substringWithRange:[obj rangeAtIndex:1]];
    if ([tempStr isEqualToString:@"d"]) {  //folder
        filetype = fileType_dir;
        fileSize = 0;
    }
    //link file
    else if([tempStr isEqualToString:@"l"]) {
        filetype = fileType_link;
        if ([self isString:fileName regular:REGEX_LINK_FILE]) {
            NSArray *ar = [self matchString:fileName withRegx:REGEX_LINK_FILE];
            NSTextCheckingResult *tcr = [ar objectAtIndex:0];
            fileName = [fileName substringWithRange:[tcr rangeAtIndex:1]];
            fileLinkTo = [fileName substringWithRange:[tcr rangeAtIndex:2]];
        }
    }
    //regular file
    else if([tempStr isEqualToString:@"b"] || [tempStr isEqualToString:@"c"] || [tempStr isEqualToString:@"f"] || [tempStr isEqualToString:@"-"]) {
        filetype = fileType_reg;
    } else {
        filetype = fileType_unknown;
    }
    
    //file permissions
    //...
    
    file.fileName = fileName;
    file.fileType = filetype;
    file.fileSize = fileSize;
    //    file.fileModifyTime = [CommonHelper me]
    
    //    }];
    
    
    
    return file;
}


/**
 *  parse dos format
 *
 *  @param entry
 *
 *  @return
 */
- (FileModel*)parseEntryDos:(NSString*)entry {
    FileModel *file = [FileModel new];
    
    NSArray *matches = [self matchString:entry withRegx:REGEX_LISTING_DOS];
    if (!matches || matches.count==0) {
        return nil;
    }
    
    
    NSTextCheckingResult *obj = [matches objectAtIndex:0];
    NSString *fileName = [entry substringWithRange:[obj rangeAtIndex:5]];
    if (!fileName || [fileName isEqualToString:@"."] || [fileName isEqualToString:@".."]) {
        return nil;
    }
    
    UInt64 filesize = [[entry substringWithRange:[obj rangeAtIndex:4]] longLongValue];
    
    FileType type = fileType_unknown;
    NSString *dirstr = [entry substringWithRange:[obj rangeAtIndex:3]];
    if ([dirstr isEqualToString:@"<DIR>"]) {
        type = fileType_dir;
        filesize = 0;
    } else {
        type = fileType_reg;
    }
    
    file.fileName = fileName;
    file.fileSize = filesize;
    file.fileType = type;
    
    
    
    return file;
}



/**
 *  whether the given string matches the sepecified regular expression
 *
 *  @param string
 *  @param regex
 *
 *  @return
 */
- (BOOL)isString:(NSString*)string regular:(NSString*)regex {
    BOOL result = false;
    
    NSPredicate *predica = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [predica evaluateWithObject:string];
    
    return result;
}


/**
 *  split the given string by specified regular expression
 *
 *  @param str
 *  @param regx
 *
 *  @return
 */
- (NSArray*)matchString:(NSString*)str withRegx:(NSString*)regx {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regx options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
    
    return matches;
}
@end
