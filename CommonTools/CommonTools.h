//
//  CommonTools.h
//  CommonTools
//
//  Created by 123 on 15/11/3.
//
//

#import <Foundation/Foundation.h>

@interface CommonTools : NSObject
/**
 *  获取nsdata md5
 *
 *  @param data
 *
 *  @return
 */
+ (NSString *)md5StringForData:(NSData*)data;


/**
 *  获取nsstring md5
 *
 *  @param str
 *
 *  @return
 */
+ (NSString *)md5StringForString:(NSString*)str;




/**
 *  转化大小
 *
 *  @param size
 *
 *  @return
 */
+(NSString *)getFileSizeString:(NSString *)size;




/**
 *  转化大小
 *
 *  @param size
 *
 *  @return
 */
+ (NSString *)stringFromSize:(uint64_t)size;





+(float)getFileSizeNumber:(NSString *)size;




+(NSString *)getDocumentPath;




+(NSString *)getTargetPathWithBasepath:(NSString *)name subpath:(NSString *)subpath;





+(NSArray *)getTargetFloderPathWithBasepath:(NSString *)name subpatharr:(NSArray *)arr;






+(NSString *)getTempFolderPathWithBasepath:(NSString *)name;




+ (NSArray *)subfilesOfDir:(NSString *)dir;





+ (BOOL)isDir:(NSString *)filePath;





+(BOOL)isExistFile:(NSString *)fileName;




+(CGFloat)getProgress:(long long)totalSize currentSize:(long long)currentSize;




+(NSDate *)makeDate:(NSString *)birthday;




+(NSString *)dateToString:(NSDate*)date;




+(uint64_t)getFreeDiskspace;




+(uint64_t)getTotalDiskspace;




+(NSString *)getDiskSpaceInfo;




/**
 *  拷贝文件
 *
 *  @param from
 *  @param to
 *
 *  @return  拷贝失败与否
 */
+ (BOOL)copyFile:(NSString *)from to:(NSString *)to;


/**
 *  删除指定文件
 *
 *  @param filePath 文件绝对地址
 *
 *  @return
 */
+ (BOOL)removeFile:(NSString *)filePath;





/**
 *  判断是否为目录
 *
 *  @param string
 *  @param array
 *
 *  @return
 */
+ (BOOL)isStr:(NSString *)string inArray:(NSArray *)array;




/**
 *  16进制颜色  转  UIColor
 *
 *  @param hexColorString
 *
 *  @return
 */
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString;




/**
 *  判断数组中是否存在某对象
 *
 *  @param obj
 *  @param array
 *
 *  @return
 */
+ (BOOL)isObj:(id)obj existInArray:(NSArray *)array;




/**
 *  获取单个文件大小
 *
 *  @param path   文件路径
 *
 *  @return  文件大小
 */
+ (uint64_t)fileSizeAtPath:(NSString *)path;


/**
 *  获取目录大小
 *
 *  @param path   目录路径
 *
 *  @return  目录大小
 */
+ (uint64_t)folderSizeAtPath:(NSString *)path;




/**
 *  获取文件缩略图名称
 *
 *  @param fileName  文件名
 *
 *  @return 缩略图名
 */
+ (NSString *)getFileImageName:(NSString *)fileName;


/**
 *  获取指定目录下的文件个数（包括子目录下文件，但不包括目录本身）
 *
 *  @param dirPath
 *
 *  @return
 */
+ (NSUInteger)numberOfSubfilesAtDir:(NSString *)dirPath;



/**
 * 颜色转换image
 */
- (UIImage *)imageWithColor:(UIColor *)color;
@end
