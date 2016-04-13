//
//  DefineTextField.h
//  TestIOS
//
//  Created by bluesky on 15/6/13.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DefineTextField;

@protocol DefinedTextFieldDelegate <NSObject>

- (void)definedTextFieldDidBeginEditing:(DefineTextField *)definedTextField;
- (BOOL)definedTextFieldShouldReturn:(DefineTextField *)definedTextField;
@end



@interface DefineTextField : UIView<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,retain) UIView *view;
@property (nonatomic,retain) UITextField *textField;
//@property (nonatomic,strong) UITextView *textField;
@property (nonatomic,retain) UILabel *label;

@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) UIColor *textColor;
@property (nonatomic,copy) NSString *placeHolder;
@property (nonatomic,retain) UIView *inputView;
@property (nonatomic,assign) UIReturnKeyType returnKeyType;


@property (nonatomic,assign) BOOL isFocused;

@property (nonatomic,assign) id<DefinedTextFieldDelegate> dDelegate;


- (DefineTextField *)initWithFrame:(CGRect)frame leftImg:(UIImage *)leftImg rightImg:(UIImage *)rightImg;





@end
