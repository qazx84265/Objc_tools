//
//  UINavigationController+NavBarAlpha.m
//  SmoothNavDemo
//
//  Created by fb on 17/3/31.
//  Copyright © 2017年 Cloudox. All rights reserved.
//

#import "UINavigationController+NavBarAlpha.h"
#import "UIViewController+NavBarAlpha.h"
#import <objc/runtime.h>

@implementation UINavigationController(NavBarAlpha)
// 设置导航栏背景透明度
- (void)setNeedsNavigationBackground:(float)alpha {
    // 导航栏背景透明度设置
    UIView *barBackgroundView = [[self.navigationBar subviews] objectAtIndex:0];// _UIBarBackground
    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView
    if (self.navigationBar.isTranslucent) {
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            barBackgroundView.alpha = alpha;
        } else {
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    } else {
        barBackgroundView.alpha = alpha;
    }
    
    // 对导航栏下面那条线做处理
    if (backgroundImageView) {
        backgroundImageView.alpha = alpha;
    }
    else {
        self.navigationBar.clipsToBounds = alpha == 0.0;
    }
}

+ (void)initialize {
    if (self == [UINavigationController self]) {
        // 交换方法
        SEL originalSelector = NSSelectorFromString(@"_updateInteractiveTransition:");
        SEL swizzledSelector = NSSelectorFromString(@"et__updateInteractiveTransition:");
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

// 交换的方法，监控滑动手势
- (void)et__updateInteractiveTransition:(CGFloat)percentComplete {
    [self et__updateInteractiveTransition:(percentComplete)];
    UIViewController *topVC = self.topViewController;
    if (topVC == nil) {
        return;
    }
    
    id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
    if (coor == nil) {
        return;
    }
    
    // 随着滑动的过程设置导航栏透明度渐变
    CGFloat fromAlpha = [coor viewControllerForKey:UITransitionContextFromViewControllerKey].navBarBgAlpha;
    CGFloat toAlpha = [coor viewControllerForKey:UITransitionContextToViewControllerKey].navBarBgAlpha;
    CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
    //NSLog(@"from:%f, to:%f, now:%f",fromAlpha, toAlpha, nowAlpha);
    [self setNeedsNavigationBackground:nowAlpha];
    
}

#pragma mark - UINavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
        id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
        if (coor != nil) {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
                [self dealInteractionChanges:context];
            }];
        }
    }
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    if ([context isCancelled]) {// 自动取消了返回手势
        NSTimeInterval cancelDuration = [context transitionDuration] * (double)[context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            CGFloat nowAlpha = [context viewControllerForKey:UITransitionContextFromViewControllerKey].navBarBgAlpha;
            NSLog(@"自动取消返回到alpha：%f", nowAlpha);
            [self setNeedsNavigationBackground:nowAlpha];
        }];
    } else {// 自动完成了返回手势
        NSTimeInterval finishDuration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            CGFloat nowAlpha = [context viewControllerForKey:UITransitionContextToViewControllerKey].navBarBgAlpha;
            NSLog(@"自动完成返回到alpha：%f", nowAlpha);
            [self setNeedsNavigationBackground:nowAlpha];
        }];
    }
}


#pragma mark - UINavigationBar Delegate
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    if (self.viewControllers.count >= navigationBar.items.count) {// 点击返回按钮
        UIViewController *popToVC = self.viewControllers[self.viewControllers.count - 1];
        [self setNeedsNavigationBackground:popToVC.navBarBgAlpha];
        //        [self popViewControllerAnimated:YES];
    }
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {
    // push到一个新界面
    [self setNeedsNavigationBackground:self.topViewController.navBarBgAlpha];
}
@end
