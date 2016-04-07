//
//  ZTMapSelectActsheet.m
//  LY
//
//  Created by 123 on 16/3/8.
//  Copyright © 2016年 gykj. All rights reserved.
//

#import "ZTMapSelectActsheet.h"
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSUInteger, ThirdMapApp) {
    ThirdMapAppApple = 0,
    ThirdMapAppBaidu,
    ThirdMapAppGaode,
    ThirdMapAppGoogle,
    ThirdMapAppTencent
};

#define kActionSheetTitle @"选择地图"
#define kActionSheetCancel @"取消"



@interface ZTMapSelectActsheet()<UIActionSheetDelegate>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate2d;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appScheme;

@property (nonatomic, strong) NSMutableArray *thirdMapApps;
@end

@implementation ZTMapSelectActsheet

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static ZTMapSelectActsheet *instance = nil;
    
    dispatch_once(&once, ^{
        instance = [[ZTMapSelectActsheet alloc] init];
    });
    
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _coordinate2d = CLLocationCoordinate2DMake(0.0, 0.0);
        
        //
        _appName = @"Z-link";
        _appScheme = @"zotye://";
        
        _thirdMapApps = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)showInViewController:(UIViewController *)controller destCoordinate:(CLLocationCoordinate2D)coordinate2d{
    if (controller == nil) {
        return;
    }
    
    WEAKSELF
    _thirdMapApps = [NSMutableArray arrayWithArray:[self determinThirdMap]];
    if (_thirdMapApps.count == 0) {
        GCD_MAIN(^{
            [weakSelf showAlertWithNoMapAppInViewController:controller];
        });
    }
    else {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            UIAlertController *ac = [self ac];
            [controller presentViewController:ac animated:YES completion:^{
                
            }];
        }
        else {
            UIActionSheet *as = [self as];
            [as showInView:controller.view];
        }
    }
}



- (NSArray*)determinThirdMap {
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]]) {
        [_thirdMapApps addObject:[NSNumber numberWithUnsignedInteger:ThirdMapAppApple]];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [_thirdMapApps addObject:[NSNumber numberWithUnsignedInteger:ThirdMapAppBaidu]];
    }
    
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [_thirdMapApps addObject:[NSNumber numberWithUnsignedInteger:ThirdMapAppGaode]];
    }
    
//    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
//        [_thirdMapApps addObject:[NSNumber numberWithUnsignedInteger:ThirdMapAppGoogle]];
//    }
//    
//    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
//        [_thirdMapApps addObject:[NSNumber numberWithUnsignedInteger:ThirdMapAppTencent]];
//    }
    
    
    
    return _thirdMapApps;
}


- (void)showAlertWithNoMapAppInViewController:(UIViewController *)controller {
    NSString* title = @"提示";
    NSString* msg = @"未安装地图APP,无法导航";
    NSString* cancelTitle = @"确定";
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIAlertController *al = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {
            
        }];
        [al addAction:cancelAction];
        [controller presentViewController:al animated:YES completion:nil];
    }
    else {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
        [al show];
    }
}



- (UIAlertController*)ac {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:kActionSheetTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kActionSheetCancel style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancelAction];
    
    WEAKSELF
    for (NSNumber *nb in _thirdMapApps) {
        NSUInteger i = [nb unsignedIntegerValue];
        
        NSString *title = @"";
        if (i == ThirdMapAppApple) {
            title = @"苹果地图";
        }
        else if (i == ThirdMapAppBaidu) {
            title = @"百度地图";
        }
        else if (i == ThirdMapAppGaode) {
            title = @"高德地图";
        }
//        else if (i == ThirdMapAppGoogle) {
//            title = @"谷歌地图";
//        }
//        else if (i == ThirdMapAppTencent) {
//            title = @"腾讯地图";
//        }
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [weakSelf openMap:i];
        }];
        
        [ac addAction:action];
    }
    

    return ac;
}

- (UIActionSheet*)as {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:kActionSheetTitle delegate:self cancelButtonTitle:kActionSheetCancel destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for (NSNumber *nb in _thirdMapApps) {
        NSUInteger i = [nb unsignedIntegerValue];
        
        NSString *title = @"";
        if (i == ThirdMapAppApple) {
            title = @"苹果地图";
        }
        else if (i == ThirdMapAppBaidu) {
            title = @"百度地图";
        }
        else if (i == ThirdMapAppGaode) {
            title = @"高德地图";
        }
//        else if (i == ThirdMapAppGoogle) {
//            title = @"谷歌地图";
//        }
//        else if (i == ThirdMapAppTencent) {
//            title = @"腾讯地图";
//        }
        
        [as addButtonWithTitle:title];
    }
    
    return as;
}




#pragma mark -- open

- (void)openMap:(ThirdMapApp)type {
    __block NSString *urlScheme = self.appScheme;
    __block NSString *appName = self.appName;
    __block CLLocationCoordinate2D coordinate = self.coordinate2d;
    
    if(type == ThirdMapAppApple) {
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }
    else {
        NSString *urlString = @"";
        
        if(type == ThirdMapAppBaidu) {
            
            urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        else if(type == ThirdMapAppGaode) {
            urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
        }
//        else if(type == ThirdMapAppGoogle) {
//            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//        }
//        else if(type == ThirdMapAppTencent) {
//            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=%f,%f&coord_type=1&policy=0",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    
}








#pragma mark -- actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"clickedButtonAtIndex : %d", (int)buttonIndex);
//    [self openMap:buttonIndex];
}

@end
