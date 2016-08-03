//
//  FBActivityIdentificator.m
//  EmptyUnityDemo
//
//  Created by ARSeeds on 16/8/2.
//  Copyright © 2016年 ARSeeds. All rights reserved.
//

#import "FBActivityIdentificator.h"


// Default values
#define kDefaultNumberOfSpinnerMarkers 12
#define kDefaultSpeed 1.0

#define kMarkerAnimationKey @"MarkerAnimationKey"
#define kSpinnerScaleAnimationKey @"SpinnerScaleAnimationKey"
#define kSpinnerPositionAnimationKey @"SpinnerPositionAnimationKey"

@interface FBActivityIdentificator() {
    BOOL _mIsAnimating;
    CGFloat _mSpinnerLenth;
    CGFloat _mSpinnerThickness;
    CGFloat _mInnerMargin;
    CGFloat _mOutterMargin;
    CGFloat _mCenterX;
    CGFloat _mCenterY;
    CGFloat _mRadius;
}
@property (nonatomic, strong) CALayer* rlayer;
@property (nonatomic, strong) CALayer* containLayer;
@end

@implementation FBActivityIdentificator


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _mIsAnimating = NO;
    _mSpinnerLenth = 50.0;
    _mSpinnerThickness = 8.0;
    _mInnerMargin = 5.0;
    _mOutterMargin = 5.0;
    
    self.layer.masksToBounds = YES;
    CGRect selfFrame = self.frame;
    
    //--
    CGFloat sw = selfFrame.size.width;
    CGFloat sh = selfFrame.size.height;
    CGFloat layerW = MIN(sw, sh);
    
    //-- container layer
    self.containLayer = [CALayer layer];
    self.containLayer.position = CGPointMake(sw/2, sh/2);
    self.containLayer.bounds = CGRectMake(0, 0, layerW, layerW);
    self.containLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:self.containLayer];
    
    
    //-- spinner layer
    _mCenterX = layerW/2;
    _mCenterY = layerW/2;
    
    _mInnerMargin = layerW/10;
    _mOutterMargin = layerW/10;
    _mSpinnerLenth = layerW/2 - _mInnerMargin - _mOutterMargin;
    _mSpinnerThickness = _mSpinnerLenth/8;//_mSpinnerLenth/5;
    
    _mRadius = layerW/4;
    CGFloat angle = 360 / kDefaultNumberOfSpinnerMarkers;
    for (int i=0; i<kDefaultNumberOfSpinnerMarkers; i++) {
        CALayer* layer = [CALayer layer];
        layer.backgroundColor = [UIColor whiteColor].CGColor;
        layer.cornerRadius = _mSpinnerThickness/2;
        layer.bounds = CGRectMake(0, 0, _mSpinnerLenth, _mSpinnerThickness);
        
        //NSLog(@"------->>>>>>>>> angle: %.f, radius: %.f", i*angle, radius);
        
        //-- layer position
        CGFloat aa = i*angle*M_PI/180;
        CGPoint p = CGPointMake(_mCenterX+_mRadius*cos(aa), _mCenterY+_mRadius*sin(aa));
        //NSLog(@"--------->>>>>>>>cx:%.f, cy:%.f, x:%.f, y:%.f", centerX, centerY, p.x, p.y);
        layer.position = p;
        
        //-- layer rotation
        layer.transform = CATransform3DMakeRotation(aa, 0, 0, 1.0);
        
        //-- add animation
        [layer addAnimation:[self tranAnimWithIndex:i] forKey:kSpinnerScaleAnimationKey];
//        [layer addAnimation:[self positionAnimWithIndex:i] forKey:kSpinnerPositionAnimationKey];
        
        [self.containLayer addSublayer:layer];
    }
    _mIsAnimating = YES;

    
    [self addNoti];
}


- (CABasicAnimation*)tranAnimWithIndex:(int)index {
    CABasicAnimation* trans = [CABasicAnimation animationWithKeyPath:@"bounds"];
    //    [trans setFromValue:[NSValue valueWithCGRect:CGRectMake(0, 0, kDefaultThickness, kDefaultLength)]];
    [trans setToValue:[NSValue valueWithCGRect:CGRectMake(0, 0, _mSpinnerLenth/3, _mSpinnerThickness)]];
    [trans setRepeatCount:HUGE_VALF];
    [trans setDuration:kDefaultSpeed];
    trans.beginTime = index*kDefaultSpeed/kDefaultNumberOfSpinnerMarkers;
    
    
    return trans;
}

- (CABasicAnimation*)positionAnimWithIndex:(int)index {
    CABasicAnimation* posit = [CABasicAnimation animationWithKeyPath:@"position"];
    
    CGFloat aa = index*(360/kDefaultNumberOfSpinnerMarkers)*M_PI/180;
    CGPoint p = CGPointMake(_mCenterX+(_mSpinnerLenth/6+_mInnerMargin)*cos(aa), _mCenterY+(_mSpinnerLenth/6+_mInnerMargin)*sin(aa));
    [posit setToValue:[NSValue valueWithCGPoint:CGPointMake(p.x, p.y)]];
    [posit setRepeatCount:HUGE_VALF];
    [posit setDuration:kDefaultSpeed];
    posit.beginTime = index*kDefaultSpeed/kDefaultNumberOfSpinnerMarkers;
    
    
    return posit;
}




- (void)addNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)removeNoti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appEnterBackground:(NSNotification*)noti {
    if (_mIsAnimating) {
        [self stopAnimation];
    }
}

- (void)appEnterForeground:(NSNotification*)noti {
    if (!_mIsAnimating) {
        [self startAnimation];
    }
}

- (void)dealloc {
    [self removeNoti];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark -- private
- (void)startAnimation {
    
    NSArray* layers = self.containLayer.sublayers;
    for (int i=0; i<layers.count; i++) {
        CALayer* layer = [layers objectAtIndex:i];
        if (layer) {
            [layer addAnimation:[self tranAnimWithIndex:i] forKey:kSpinnerScaleAnimationKey];
        }
    }
    _mIsAnimating = YES;
}


- (void)stopAnimation {
    for (CALayer* layer in self.containLayer.sublayers) {
        if (layer) {
            [layer removeAnimationForKey:kSpinnerScaleAnimationKey];
        }
    }
    _mIsAnimating = NO;
}



#pragma mark -- getters && setters
- (void)setBgColor:(UIColor *)bgColor {
    self.containLayer.backgroundColor = bgColor.CGColor;
}

- (void)setSpinnerColor:(UIColor *)spinnerColor {
    for (CALayer* layer in self.containLayer.sublayers) {
        if (layer) {
            layer.backgroundColor = spinnerColor.CGColor;
        }
    }
}

- (BOOL)isAnimating {
    return _mIsAnimating;
}

@end
