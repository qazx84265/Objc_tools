//
//  UIViewController+NavBarAlpha.m
//  SmoothNavDemo
//
//  Created by fb on 17/3/31.
//  Copyright © 2017年 Cloudox. All rights reserved.
//

#import "UIViewController+NavBarAlpha.h"
#import "UINavigationController+NavBarAlpha.h"
#import <objc/runtime.h>


static char *kNavBarBgAlphaKey = "navBarBgAlphaKey";

@implementation UIViewController(NavBarAlpha)

-(void)setNavBarBgAlpha:(float)navBarBgAlpha{
    /*
     OBJC_ASSOCIATION_ASSIGN;            //assign策略
     OBJC_ASSOCIATION_COPY_NONATOMIC;    //copy策略
     OBJC_ASSOCIATION_RETAIN_NONATOMIC;  // retain策略
     
     OBJC_ASSOCIATION_RETAIN;
     OBJC_ASSOCIATION_COPY;
     */
    /*
     * id object 给哪个对象的属性赋值
     const void *key 属性对应的key
     id value  设置属性值为value
     objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
     */
    
    objc_setAssociatedObject(self, kNavBarBgAlphaKey, @(navBarBgAlpha), OBJC_ASSOCIATION_ASSIGN);
    
    // 设置导航栏透明度（利用Category自己添加的方法）
    [self.navigationController setNeedsNavigationBackground:navBarBgAlpha];
}

-(float)navBarBgAlpha{
    id value = objc_getAssociatedObject(self, kNavBarBgAlphaKey);
    if (value == nil) {
        return 0;
    }
    return [value floatValue];
}
@end
