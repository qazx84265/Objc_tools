//
//  ZTMapSelectActsheet.h
//  LY
//
//  Created by 123 on 16/3/8.
//  Copyright © 2016年 gykj. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface ZTMapSelectActsheet : NSObject

+ (instancetype)sharedInstance;
- (void)showInViewController:(UIViewController*)controller destCoordinate:(CLLocationCoordinate2D)coordinate2d;
@end
