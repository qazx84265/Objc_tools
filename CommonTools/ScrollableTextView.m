//
//  ScrollableTextView.m
//  Demo
//
//  Created by FB on 2017/11/3.
//  Copyright © 2017年 FB. All rights reserved.
//

#import "ScrollableTextView.h"

#import <QuartzCore/QuartzCore.h>

static CGFloat const kDefaultScrollDuration = 2;


@interface ScrollableTextView() {
    BOOL _mIsScrolling;
}
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;

@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) UILabel *animationLabel;

@property (nonatomic, assign) BOOL isStopped;
@end

@implementation ScrollableTextView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame direction:ScrollableTextDirectionUp];
}

- (instancetype)initWithFrame:(CGRect)frame direction:(ScrollableTextDirection)direction {
    if (self = [super initWithFrame:frame]) {
        _scrollDirection = direction;
        _scrollDuration = kDefaultScrollDuration;
        
        _mIsScrolling = NO;
        self.isStopped = YES;
        self.currentIndex = 0;
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    CGRect frame = self.bounds;
    
    self.firstLabel = [[UILabel alloc] init];
    self.firstLabel.frame = frame;
    self.firstLabel.numberOfLines = 0;
    [self addSubview:self.firstLabel];
    
    frame.origin.y = _scrollDirection == ScrollableTextDirectionUp ? CGRectGetHeight(self.bounds) : -CGRectGetHeight(self.bounds);
    self.secondLabel = [[UILabel alloc] init];
    self.secondLabel.frame = frame;
    self.secondLabel.numberOfLines = 0;
    [self addSubview:self.secondLabel];
    
    self.currentLabel = self.firstLabel;
    self.animationLabel = self.secondLabel;
}

- (void)setScrollDirection:(ScrollableTextDirection)scrollDirection {
    BOOL temp = _isStopped;
    _isStopped = YES;
    
    _scrollDirection = scrollDirection;
    
    CGRect frame = self.bounds;
    self.currentLabel.frame = frame;
    frame.origin.y = _scrollDirection == ScrollableTextDirectionUp ? CGRectGetHeight(self.bounds) : -CGRectGetHeight(self.bounds);
    self.animationLabel.frame = frame;
    
    // restart
    if (!temp) {
        [self startScrolling];
    }
}

- (BOOL)isScrolling {
//    return _mIsScrolling;
    return !_isStopped;
}

- (void)setStrings:(NSArray *)strings {
    _strings = strings;
    
    if (_strings == nil) {
        return;
    }
    
    _currentIndex = 0;
    [self changeLabelText];
}

- (void)startScrolling {
    NSAssert(self.strings != nil && self.strings.count != 0, @"text strings should not be nil");
    
    if (!self.isStopped || _mIsScrolling) {
        return;
    }
    
    self.isStopped = NO;
    _mIsScrolling = YES;
    
    [UIView animateWithDuration:self.scrollDuration animations:^{
        CGRect frame = self.bounds;
        self.animationLabel.frame = frame;
        
        frame.origin.y = _scrollDirection == ScrollableTextDirectionUp ? -CGRectGetHeight(self.bounds) : CGRectGetHeight(self.bounds);
        self.currentLabel.frame = frame;
    } completion:^(BOOL finished) {
        UILabel *temp = self.currentLabel;
        self.currentLabel = self.animationLabel;
        self.animationLabel = temp;
        
        CGRect frame = self.bounds;
        self.currentLabel.frame = frame;
        frame.origin.y = _scrollDirection == ScrollableTextDirectionUp ? CGRectGetHeight(self.bounds) : -CGRectGetHeight(self.bounds);
        self.animationLabel.frame = frame;
        
        _currentIndex = _currentIndex + (_scrollDirection == ScrollableTextDirectionUp ? 1 : -1);
        if (_currentIndex >= (NSInteger)self.strings.count) {
            _currentIndex = 0;
        }
        if (_currentIndex < 0) {
            _currentIndex = self.strings.count - 1;
        }
        [self changeLabelText];
        
        _mIsScrolling = NO;
        self.isStopped = YES;
        
        if (self.isStopped) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startScrolling];
            });
        }
    }];
}

- (void)stopScrolling {
    self.isStopped = YES;
}

- (NSString*)getNextStringForIndex:(NSUInteger)index {
    NSInteger nextIndex = 0;
    if (self.scrollDirection == ScrollableTextDirectionUp) {
        nextIndex = index + 1;
        if (nextIndex >= (NSInteger)self.strings.count) {
            nextIndex = 0;
        }
    }
    else {
        nextIndex = index - 1;
        if (nextIndex < 0) {
            nextIndex = self.strings.count-1;
        }
    }
    
    return [self.strings objectAtIndex:nextIndex % self.strings.count];
}

- (void)changeLabelText {
    _currentLabel.text = [_strings objectAtIndex:_currentIndex];
    _animationLabel.text = [self getNextStringForIndex:_currentIndex];
}


#pragma mark -- dealloc
- (void)dealloc {
    NSLog(@"----->>>>>> dealloc: %@", NSStringFromClass([self class]));
}

@end
