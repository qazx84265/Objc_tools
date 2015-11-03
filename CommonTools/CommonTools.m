//
//  CommonTools.m
//  CommonTools
//
//  Created by 123 on 15/11/3.
//
//

#import "CommonTools.h"

@implementation CommonTools



/**
 *  获取nsdata md5
 *
 *  @param data
 *
 *  @return
 */
+ (NSString *)md5StringForData:(NSData*)data{
//    const char *str = [string UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, data.length, r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}


/**
 *  获取nsstring md5
 *
 *  @param str
 *
 *  @return
 */
+ (NSString *)md5StringForString:(NSString*)str{
    const char *str1 = [str UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str1, strlen(str1), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}




/**
 *  转化大小
 *
 *  @param size
 *
 *  @return
 */
+(NSString *)getFileSizeString:(NSString *)size
{
    //    if([size floatValue]>=1024*1024)//大于1M，则转化成M单位的字符串
    //    {
    //        return [NSString stringWithFormat:@"%1.2fM",[size floatValue]/1024/1024];
    //    }
    //    else if([size floatValue]>=1024&&[size floatValue]<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    //    {
    //        return [NSString stringWithFormat:@"%1.2fK",[size floatValue]/1024];
    //    }
    //    else//剩下的都是小于1K的，则转化成B单位
    //    {
    //        return [NSString stringWithFormat:@"%1.2fB",[size floatValue]];
    //    }
    
    
    NSString *sizeStr = @"";
    uint64_t s = [size longLongValue];
    if (s/1024.0/1024.0/1024.0 < 1.0) {
        if (s/1024.0/1024.0 < 1.0) {
            if (s/1024 < 1.0) {
                sizeStr = [NSString stringWithFormat:@"%.1f b",s/1.0];
            } else {
                sizeStr  = [NSString stringWithFormat:@"%.1f Kb",s/1024.0];
            }
        } else {
            sizeStr  = [NSString stringWithFormat:@"%.1f Mb",s/1024.0/1024.0];
        }
    } else {
        sizeStr  = [NSString stringWithFormat:@"%.1f Gb",s/1024.0/1024.0/1024.0];
    }
    
    return sizeStr;
    
    
}




/**
 *  转化大小
 *
 *  @param size
 *
 *  @return
 */
+ (NSString *)stringFromSize:(uint64_t)size {
    NSString *sizeStr = @"";
    if (size/1024.0/1024.0/1024.0 < 1.0) {
        if (size/1024.0/1024.0 < 1.0) {
            if (size/1024 < 1.0) {
                sizeStr = [NSString stringWithFormat:@"%.1f b",size/1.0];
            } else {
                sizeStr  = [NSString stringWithFormat:@"%.1f Kb",size/1024.0];
            }
        } else {
            sizeStr  = [NSString stringWithFormat:@"%.1f Mb",size/1024.0/1024.0];
        }
    } else {
        sizeStr  = [NSString stringWithFormat:@"%.1f Gb",size/1024.0/1024.0/1024.0];
    }
    
    return sizeStr;
}





+(float)getFileSizeNumber:(NSString *)size
{
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000)//是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)//是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)//是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];
    }
    else//没有任何单位的数字字符串
    {
        return [size floatValue];
    }
}




+(NSString *)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}




+(NSString *)getTargetPathWithBasepath:(NSString *)name subpath:(NSString *)subpath{
    NSString *pathstr = [[self class] getDocumentPath];
    pathstr = [pathstr stringByAppendingPathComponent:name];
    if (subpath) {
        pathstr = [pathstr stringByAppendingPathComponent:subpath];
    }
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:pathstr])
    {
        [fileManager createDirectoryAtPath:pathstr withIntermediateDirectories:YES attributes:nil error:&error];
        if(!error)
        {
            NSLog(@"%@",[error description]);
            
        }
    }
    
    return pathstr;
}





+(NSArray *)getTargetFloderPathWithBasepath:(NSString *)name subpatharr:(NSArray *)arr{
    NSMutableArray *patharr = [[NSMutableArray alloc]init];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    NSString *pathstr = [[self class]getDocumentPath];
    pathstr = [pathstr stringByAppendingPathComponent:name];
    for (NSString *str in arr) {
        NSString *path = [pathstr stringByAppendingPathComponent:str];
        
        if(![fileManager fileExistsAtPath:path])
        {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            if(!error)
            {
                NSLog(@"%@",[error description]);
                
            }
        }
        [patharr addObject:path];
    }
    
    return patharr;
}






+(NSString *)getTempFolderPathWithBasepath:(NSString *)name
{
    NSString *pathstr = [[self class]getDocumentPath];
    pathstr = [pathstr stringByAppendingPathComponent:name];
    pathstr =  [pathstr stringByAppendingPathComponent:@"Temp"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:pathstr])
    {
        [fileManager createDirectoryAtPath:pathstr withIntermediateDirectories:YES attributes:nil error:&error];
        if(!error)
        {
            NSLog(@"%@",[error description]);
            
        }
    }
    return pathstr;
}




+ (NSArray *)subfilesOfDir:(NSString *)dir {
    return [[NSFileManager defaultManager] subpathsAtPath:dir];
}





+ (BOOL)isDir:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    return isExist && isDir;
}





+(BOOL)isExistFile:(NSString *)fileName
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}




+(CGFloat)getProgress:(long long)totalSize currentSize:(long long)currentSize
{
    return totalSize==0 ? (float)0 : (float)currentSize/totalSize;
}




+(NSDate *)makeDate:(NSString *)birthday
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"MM-dd HH:mm:ss"];//[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //    NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    //    [df setLocale:locale];
    
    NSDate *date=[df dateFromString:birthday];
    //    [ locale release];
    NSLog(@"%@",date);
    return date;
}




+(NSString *)dateToString:(NSDate*)date{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"MM-dd HH:mm:ss"];//[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [df stringFromDate:date];
    return datestr;
}




+(uint64_t)getFreeDiskspace {
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}




+(uint64_t)getTotalDiskspace {
    uint64_t totalSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalSpace;
}




+(NSString *)getDiskSpaceInfo{
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary)
    {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
    }else
        return nil;
    
    NSString *infostr = [NSString stringWithFormat:@"%.2f GB 可用/总共 %.2f GB", ((totalFreeSpace/1024.0f)/1024.0f)/1024.0f, ((totalSpace/1024.0f)/1024.0f)/1024.0f];
    return infostr;
    
}




/**
 *  拷贝文件
 *
 *  @param from
 *  @param to
 *
 *  @return  拷贝失败与否
 */
+ (BOOL)copyFile:(NSString *)from to:(NSString *)to {
    NSLog(@"------ copy file %@",from);
    return [[NSFileManager defaultManager] copyItemAtPath:from toPath:to error:nil];
}


/**
 *  删除指定文件
 *
 *  @param filePath 文件绝对地址
 *
 *  @return
 */
+ (BOOL)removeFile:(NSString *)filePath {
    NSLog(@"------ remove file %@",filePath);
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}



/**
 *  通过文件名获取文件媒体类型
 *
 *  @param fileName
 *
 *  @return 详见fileType
 */
+ (fileMediaType)getFileType:(NSString*)fileName {
    NSString *fix = [fileName pathExtension];
    fileMediaType ftype = fileType_unknown;
    
    if (![fix isEqualToString:@""]) {
        NSArray *vedio_fix = @[@"avi",@"rm",@"rmvb",@"mp4",@"264",@"asf",@"mpeg",@"vob",@"mkv",@"wmv",@"mpg",@"mpe",@"divx",@"mov"];
        NSArray *audio_fix = @[@"mp3",@"wav",@"aif",@"aiff",@"mp1",@"mp2",@"mpv",@"mpa",@"voc",@"ins",@"cda",@"cmf",@"rcp"];
        NSArray *image_fix = @[@"jpg",@"gif",@"bmp",@"png",@"jpeg",@"tiff",@"psd",@"svg"];
        
        if ([[self class] isStr:fix inArray:vedio_fix]) {
            ftype = fileType_Vedio;
        } else if ([[self class] isStr:fix inArray:audio_fix]) {
            ftype = fileType_Audio;
        } else if ([[self class] isStr:fix inArray:image_fix]) {
            ftype = fileType_Image;
        } else {
            ftype = fileType_File;
        }
    }
    
    return ftype;
}



/**
 *  判断是否为目录
 *
 *  @param string
 *  @param array
 *
 *  @return
 */
+ (BOOL)isStr:(NSString *)string inArray:(NSArray *)array {
    __block BOOL isIn = NO;
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]] && [(NSString*)obj isEqualToString:string]) {
            isIn = YES;
            *stop = YES;
        }
    }];
    
    return isIn;
}




/**
 *  16进制颜色  转  UIColor
 *
 *  @param hexColorString
 *
 *  @return
 */
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString{
    if ([hexColorString length] <6){//长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString=[hexColorString lowercaseString];
    if ([tempString hasPrefix:@"0x"]){//检查开头是0x
        tempString = [tempString substringFromIndex:2];
    }else if ([tempString hasPrefix:@"#"]){//检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] !=6){
        return [UIColor blackColor];
    }
    //分解三种颜色的值
    NSRange range;
    range.location =0;
    range.length =2;
    NSString *rString = [tempString substringWithRange:range];
    range.location =2;
    NSString *gString = [tempString substringWithRange:range];
    range.location =4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r /255.0f)
                           green:((float) g /255.0f)
                            blue:((float) b /255.0f)
                           alpha:1.0f];
}




/**
 *  判断数组中是否存在某对象
 *
 *  @param obj
 *  @param array
 *
 *  @return
 */
+ (BOOL)isObj:(id)obj existInArray:(NSArray *)array {
    NSInteger index = [array indexOfObject:obj];
    
    
    return index != NSNotFound;
}




/**
 *  获取单个文件大小
 *
 *  @param path   文件路径
 *
 *  @return  文件大小
 */
+ (uint64_t)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    uint64_t fileSize = 0;
    if([fileManager fileExistsAtPath:path]){
        fileSize=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
    }
    
    return fileSize;
}


/**
 *  获取目录大小
 *
 *  @param path   目录路径
 *
 *  @return  目录大小
 */
+ (uint64_t)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    uint64_t folderSize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            if ([[self class] isDir:absolutePath]) {
                //                folderSize += [[self class] folderSizeAtPath:absolutePath];
                continue;
            } else {
                folderSize +=[[self class] fileSizeAtPath:absolutePath];
            }
        }
    }
    
    return folderSize;
}




/**
 *  获取文件缩略图名称
 *
 *  @param fileName  文件名
 *
 *  @return 缩略图名
 */
+ (NSString *)getFileImageName:(NSString *)fileName {
    NSAssert(fileName.length>0, @"错误：文件名为空");
    //    NSLog(@"文件名--------  %@",fileName);
    
    NSRange range;
    NSUInteger index = -1;
    NSString *fileImageUrl = @"";
    //  去掉后缀
    if ([fileName containsString:@"."]) {
        range = [fileName rangeOfString:@"."];
        index = range.location;
    }
    if (range.location != NSNotFound) {
        fileName = [fileName substringToIndex:index];
    }
    
    //去掉前缀
    if ([fileName containsString:@"_"]) {
        range = [fileName rangeOfString:@"_"];
        index = range.location+1;
    }
    if (range.location != NSNotFound) {
        fileName = [fileName substringFromIndex:index];
    }
    
    fileImageUrl = [NSString stringWithFormat:@"CIF_%@.jpg",fileName];
    
    
    
    
    
    //    NSLog(@"文件缩略图 ------  %@",fileImageUrl);
    return fileImageUrl;
}


/**
 *  获取指定目录下的文件个数（包括子目录下文件，但不包括目录本身）
 *
 *  @param dirPath
 *
 *  @return
 */
+ (NSUInteger)numberOfSubfilesAtDir:(NSString *)dirPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSUInteger num = 0;
    NSArray *subFiles = [fileManager subpathsAtPath:dirPath];
    if (subFiles.count > 0) {
        for (NSString *fileName in subFiles) {
            NSString *abPath = [dirPath stringByAppendingPathComponent:fileName];
            if ([[self class] isDir:abPath]) {
                //                num += [[self class] numberOfSubfilesAtDir:abPath];
                continue;
            } else {
                num += 1;
            }
        }
    }
    
    return num;
}



/**
 * 颜色转换image
 */
- (UIImage *)imageWithColor:(UIColor *)color {
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
