//
//  DefineTextField.m
//  TestIOS
//
//  Created by bluesky on 15/6/13.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "DefineTextField.h"
#import <CoreGraphics/CoreGraphics.h>

#define MAX_FONT 16.0
#define MIN_FONT 11


#define LEADING 5

@implementation DefineTextField

@synthesize view = _view;
@synthesize textField = _textField;
@synthesize label = _label;

@synthesize isFocused = _isFocused;


- (NSString *)text {
    return _textField.text;
}

- (void)setText:(NSString *)text {
    _textField.text = text;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    //_textField.placeholder = placeHolder;
    _label.text = placeHolder;
}

- (void)setTextColor:(UIColor *)color {
    [_textField setTextColor:color];
}

- (void)setInputView:(UIView *)inputView {
    _textField.inputView = inputView;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
    _textField.returnKeyType = returnKeyType;
}



- (DefineTextField *)initWithFrame:(CGRect)frame /*placeHolder:(NSString *)placeHolder*/ leftImg:(UIImage *)leftImg rightImg:(UIImage *)rightImg{
    _isFocused = NO;
    
    self = [super initWithFrame:frame];
    [self setFrame:frame];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat tfH = frame.size.height-18;
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(LEADING, 16, frame.size.width-LEADING*2, tfH)];
    //_textField.placeholder = placeHolder;
    _textField.font = [UIFont systemFontOfSize:MAX_FONT];
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.returnKeyType = UIReturnKeySend;
    _textField.backgroundColor = [UIColor clearColor];
    
    //右侧图标
    if (rightImg) {
        _textField.rightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        //_textField.rightView.backgroundColor = [UIColor greenColor];
        _textField.rightView = [[UIImageView alloc]initWithImage:rightImg];
        _textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    //左侧图标
    if (leftImg) {
        //_textField.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        //_textField.leftView.backgroundColor = [UIColor redColor];
        //[_textField.leftView setBackgroundColor:[UIColor colorWithPatternImage:leftImg]];
        //_textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    _textField.delegate = self;
    [self addSubview:_textField];
    
    
    //separator
    //[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_textfield_bg"]]];
//    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 0.5)];
//    view.backgroundColor = KCOLOR(95, 158, 160, 1.0);
//    [self addSubview:view];

    _label = [[UILabel alloc]initWithFrame:_textField.frame];
    //_label.text = placeHolder;
    _label.font = [UIFont systemFontOfSize:MAX_FONT];
    _label.textColor = [UIColor grayColor];
    _label.backgroundColor = [UIColor clearColor];
    [self addSubview:_label];
    
    

    
    
    
    return self;
    
}


- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [KCOLOR(95, 158, 160, 1.0) setStroke];
    
    
    if (_isFocused) {
        [path setLineWidth:3.0];
    } else {
        [path setLineWidth:1.0];
    }
    
    [path moveToPoint:CGPointMake(0, self.frame.size.height-5)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    
    [path moveToPoint:CGPointMake(0, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    
    [path moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-5)];
    
    [path stroke];
}





/*
- (CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 1;
    return iconRect;
}
*/

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self diminiHolder:_label];
    

    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    if (textField.text.length > 0) {
//        [self diminiHolder:_label];
//    } else {
//        [self restoreHolder:_label];
//    }
    
    //重绘框线
    _isFocused = YES;
    [self setNeedsDisplay];
    
    
    [self.dDelegate definedTextFieldDidBeginEditing:self];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    _isFocused = NO;
    [self setNeedsDisplay];
    
    if (textField.text.length == 0) {
        [self restoreHolder:_label];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField.text.length == 0) {
//        [self restoreHolder:_label];
//    }
// 
//    return [_label becomeFirstResponder];
    
    [self.dDelegate definedTextFieldShouldReturn:self];
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    /*
     if (textView.text.length == 0) {
     [_placeHolderLb setHidden:NO];
     } else {
     [_placeHolderLb setHidden:YES];
     }
     */
    
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger newLength = new.length;
    NSInteger res = 200 - newLength;
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[text length]+res};
        if (rg.length>0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}



- (void)diminiHolder:(UILabel *)label {
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -18);
        label.font = [UIFont systemFontOfSize:MIN_FONT];
        label.textColor = KCOLOR(135, 206, 235, 1.0);
    }];
}


- (void)restoreHolder:(UILabel *)label {
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformIdentity;
        label.font = [UIFont systemFontOfSize:MAX_FONT];
        label.textColor = [UIColor grayColor];
    }];
}






@end
