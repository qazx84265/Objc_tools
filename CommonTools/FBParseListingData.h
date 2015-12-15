//
//  FBParseListingData.h
//  ChelerPie
//
//  Created by 123 on 15/10/15.
//  Copyright © 2015年 com.linewin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^parseCallback)(NSArray *);

@interface FBParseListingData : NSObject
+ (instancetype)sharedParse;

- (void)parseListingData:(NSData*)data handler:(parseCallback)callback;
@end
