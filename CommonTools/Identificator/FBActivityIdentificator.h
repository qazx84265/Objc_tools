//
//  FBActivityIdentificator.h
//  EmptyUnityDemo
//
//  Created by ARSeeds on 16/8/2.
//  Copyright © 2016年 ARSeeds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBActivityIdentificator : UIView

@property (nonatomic, strong) UIColor* bgColor;
@property (nonatomic, strong) UIColor* spinnerColor;

@property (nonatomic ,readonly, getter=isAnimating) BOOL animating;

- (void)startAnimation;

- (void)stopAnimation;

@end
