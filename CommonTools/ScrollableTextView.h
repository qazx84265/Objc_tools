//
//  ScrollableTextView.h
//  Demo
//
//  Created by FB on 2017/11/3.
//  Copyright © 2017年 FB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ScrollableTextDirection) {
    ScrollableTextDirectionUp,
    ScrollableTextDirectionDown
};

@interface ScrollableTextView : UIView
@property (nonatomic, assign) ScrollableTextDirection scrollDirection;

@property (nonatomic, assign) CGFloat scrollDuration;

@property (nonatomic, copy) NSArray<NSString*> *strings;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign, readonly, getter=isScrolling) BOOL scrolling;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame direction:(ScrollableTextDirection)direction;

- (void)startScrolling;

- (void)stopScrolling;
@end
