//
//  UITextField+Responder.m
//  TestIOS
//
//  Created by 123 on 16/4/13.
//  Copyright © 2016年 ly. All rights reserved.
//

#import "UITextField+Responder.h"
#import <objc/runtime.h>


static const void* countOfBecomingFirstResponderKey = &countOfBecomingFirstResponderKey;


@implementation UITextField(Responder)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (NSInteger)countOfBecomingFirstResponder {
    return [objc_getAssociatedObject(self, countOfBecomingFirstResponderKey) integerValue];
}

- (void)setCountOfBecomingFirstResponder:(NSInteger)countOfBecomingFirstResponder {
    objc_setAssociatedObject(self, countOfBecomingFirstResponderKey, [NSNumber numberWithInteger:countOfBecomingFirstResponder], OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
