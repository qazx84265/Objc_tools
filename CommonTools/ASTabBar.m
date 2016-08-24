//
//  ASTabBar.h
//  ARSeek
//
//  Created by ARSeeds on 16/7/12.
//  Copyright © 2016年 ARSeeds. All rights reserved.
//

#import "ASTabBar.h"
#import <objc/runtime.h>

#define LBMagin 7
@interface ASTabBar ()

/** 中间按钮 */
@property (nonatomic, strong) UIButton *plusBtn ;

//-- 凸起
@property (nonatomic, strong) CAShapeLayer* shapeLayer;

@end

@implementation ASTabBar

- (id)initWithItemClickHandler:(itemClick)handler {
    if (self = [super init]) {
        if (handler) {
            self.itemClickHandler = [handler copy];
        }
        
        [self commonInit];
    }
    
    
    return self;
}


- (UIButton*)plusBtn {
    if (_plusBtn == nil) {
        _plusBtn = [[UIButton alloc] init];
        [_plusBtn setBackgroundImage:[UIImage imageNamed:@"mid"] forState:UIControlStateNormal];
        [_plusBtn setBackgroundImage:[UIImage imageNamed:@"mid"] forState:UIControlStateHighlighted];
        [_plusBtn addTarget:self action:@selector(plusBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusBtn;
}


- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    [self setShadowImage:nil];

    //--
    [self addSubview:self.plusBtn];
    
    //-- 去黑线
    [self setShadowImage:[[UIImage alloc] init]];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    self.layer.borderWidth = 0;
    self.layer.backgroundColor = 0;
    
    //-- 凸起
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    self.shapeLayer.fillColor = [UIColor whiteColor].CGColor;//RGB(245, 245, 245).CGColor;
    self.shapeLayer.lineWidth = 0.5;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineCap = kCALineCapRound;
    [self.layer insertSublayer:self.shapeLayer atIndex:0];
   
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");

    self.plusBtn.centerX = self.centerX;
    //调整发布按钮的中线点Y值
    self.plusBtn.centerY = self.height * 0.5 - 2*LBMagin ;

    self.plusBtn.size = CGSizeMake(self.plusBtn.currentBackgroundImage.size.width, self.plusBtn.currentBackgroundImage.size.height);

    //--- mid item label
//    UILabel *label = [[UILabel alloc] init];
//    label.text = @"发布";
//    label.font = [UIFont systemFontOfSize:11];
//    [label sizeToFit];
//    label.textColor = [UIColor grayColor];
//    [self addSubview:label];
//    label.centerX = self.plusBtn.centerX;
//    label.centerY = CGRectGetMaxY(self.plusBtn.frame) + LBMagin-1 ;

    int btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //每一个按钮的宽度==tabbar的五分之一
            btn.width = self.width / 5;

            btn.left = btn.width * btnIndex;

            btnIndex++;
            //如果是索引是2(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来发布按钮的位置
            if (btnIndex == 2) {
                btnIndex++;
            }
            
        }
    }
    
    [self bringSubviewToFront:self.plusBtn];

    //--
    CGPoint startPoint = CGPointMake((self.width-self.plusBtn.width)/2-1, 0);
    CGPoint endPoint = CGPointMake((self.width+self.plusBtn.width)/2+1, 0);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.width, 0)];
    [path addLineToPoint:endPoint];
    [path addArcWithCenter:self.plusBtn.center radius:self.plusBtn.width/2+3 startAngle:-30*M_PI/180 endAngle:199*M_PI/180 clockwise:NO];
    [path moveToPoint:startPoint];
    [path addLineToPoint:CGPointMake(0, 0)];
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    self.shapeLayer.path = path.CGPath;
}

//点击了发布按钮
- (void)plusBtnDidClick
{
    //如果tabbar的代理实现了对应的代理方法，那么就调用代理的该方法
    if (self.itemClickHandler) {
        self.itemClickHandler();
    }

}

//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {

        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.plusBtn];

        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.plusBtn pointInside:newP withEvent:event]) {
            return self.plusBtn;
        }else{//如果点不在发布按钮身上，直接让系统处理就可以了

            return [super hitTest:point withEvent:event];
        }
    }

    else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

@end
