//
//  FBPasswordInputView.m
//  TestIOS
//
//  Created by 123 on 16/4/11.
//  Copyright © 2016年 ly. All rights reserved.
//

#import "FBPasswordInputView.h"
#import "UITextField+Responder.h"

#define PWD_LENGTH_PER_TF  1 //单个textField 文本长度，固定为1
#define PWD_DEFAULT_LENGTH 6 //默认密码长度
#define PWD_DEFAULT_TYPE  PasswordType_Number  //默认键盘类型
#define PWD_DEFAULT_STYLE PasswordViewStyle_Default  //默认外观样式
#define PWD_DEFAULT_CORRADIUS 5


NSString *const FBPasswordInputDidBeginEditingNotification = @"com.purelake.FBPasswordInputDidBeginEditingNotification";
NSString *const FBPasswordInputDidEndEditingNotification = @"com.purelake.FBPasswordInputDidEndEditingNotification";
NSString *const FBPasswordInputDidChangeNotification = @"com.purelake.FBPasswordInputDidChangeNotification";
NSString *const FBPasswordInputDidCompleteNotification = @"com.purelake.FBPasswordInputDidCompleteNotification";




@interface FBPasswordInputView()<UITextFieldDelegate> {
    PasswordType _mType;
    NSUInteger _mLength;
    NSString* _mPwd;
    UITextField* _mPwdTF;
}
@property (nonatomic, assign) BOOL isCursorAnim;
@property (nonatomic, strong) UIView *cursorView;
@property (nonatomic, strong) NSTimer *cursorTimer;

@property (nonatomic, strong) NSMutableArray *pwdLbs;
@end


@implementation FBPasswordInputView


#pragma mark -- init

- (void)dealloc {
    [self removeNotifications];
    [self releaseTimer];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        [self perforInitWithPwdLength:PWD_DEFAULT_LENGTH
                                 type:PWD_DEFAULT_TYPE
                                style:PWD_DEFAULT_STYLE
                            corRadius:PWD_DEFAULT_CORRADIUS
                        completeBlock:nil];
    }
    
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
      completeBlock:(pwdInputComplete)completeBlock {
    
    return [self initWithFrame:frame
                     pwdLength:PWD_DEFAULT_LENGTH
                         style:PWD_DEFAULT_STYLE
                     corRadius:PWD_DEFAULT_CORRADIUS
                 completeBlock:completeBlock];
}

- (id)initWithFrame:(CGRect)frame
              style:(PasswordViewStyle)style
      completeBlock:(pwdInputComplete)completeBlock {
    
    
    return [self initWithFrame:frame
                     pwdLength:PWD_DEFAULT_LENGTH
                          type:PWD_DEFAULT_TYPE
                         style:style
                     corRadius:PWD_DEFAULT_CORRADIUS
                 completeBlock:completeBlock];
}


- (id)initWithFrame:(CGRect)frame
              style:(PasswordViewStyle)style
          corRadius:(CGFloat)corRadius
      completeBlock:(pwdInputComplete)completeBlock {
    
    return [self initWithFrame:frame
                     pwdLength:PWD_DEFAULT_LENGTH
                          type:PWD_DEFAULT_TYPE
                         style:style
                     corRadius:corRadius
                 completeBlock:completeBlock];
}

- (id)initWithFrame:(CGRect)frame
          pwdLength:(NSUInteger)length
              style:(PasswordViewStyle)style
          corRadius:(CGFloat)corRadius
      completeBlock:(pwdInputComplete)completeBlock {
    
    return [self initWithFrame:frame
                     pwdLength:length
                          type:PWD_DEFAULT_TYPE
                         style:style
                     corRadius:corRadius
                 completeBlock:completeBlock];
}


- (id)initWithFrame:(CGRect)frame
          pwdLength:(NSUInteger)length
               type:(PasswordType)type
              style:(PasswordViewStyle)style
          corRadius:(CGFloat)corRadius
      completeBlock:(pwdInputComplete)completeBlock {
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        [self perforInitWithPwdLength:length
                                 type:type
                                style:style
                            corRadius:corRadius
                        completeBlock:completeBlock];
    }
    
    
    return self;
}


- (void)perforInitWithPwdLength:(NSUInteger)length type:(PasswordType)type style:(PasswordViewStyle)style corRadius:(CGFloat)corRadius completeBlock:(pwdInputComplete)completeBlock {
    
    if (completeBlock) {
        _pwdInputCompleteBlk = [completeBlock copy];
    }
    
    _mPwd = @"";
    _mLength = length;
    _mType = type;
    _pStype = style;
    _corRadius = corRadius;
    
    _pwdLbs = [NSMutableArray new];
    
    
    [self setUI];
    
    [self addNotifications];
}



- (void)setUI {
    
    //--
    CGFloat selfh = self.frame.size.height;
    CGFloat selfw = self.frame.size.width;
    
    //real text field
    _mPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, selfw-5*2, selfh-5*2)];
    _mPwdTF.delegate = self;
    _mPwdTF.textAlignment = NSTextAlignmentRight;
    _mPwdTF.secureTextEntry = YES;
    _mPwdTF.countOfBecomingFirstResponder = 0;
    _mPwdTF.keyboardType = [self configKeyboardWithType:_mType];
    [self addSubview:_mPwdTF];
    
    
    //--  view
    UIView *view = [[UIView alloc] initWithFrame:_mPwdTF.frame];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor darkGrayColor].CGColor;
    view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(edit:)];
    [view addGestureRecognizer:tap];
    if (_pStype == PasswordViewStyle_Round) {
        view.layer.cornerRadius = _corRadius;
    }
    [self addSubview:view];
    
    
    
    
    //单个密码框size
    CGFloat h = view.frame.size.height;
    CGFloat tfw = view.frame.size.width/_mLength;
    CGFloat tfh = h;//h <= tfw ? h : tfw;
    
    //layout
    for (int i=0; i<_mLength; i++) {
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake((tfw)*i, (h-tfh)/2, tfw, tfh)];
        lb.textAlignment = NSTextAlignmentCenter;  //光标靠右
        lb.font = [UIFont systemFontOfSize:50.0f];
        lb.textColor = [UIColor blackColor];
        [_pwdLbs addObject:lb];
        [view addSubview:lb];
        
        if (i!=0 && i<_mLength) {
            UIView *linev = [[UIView alloc] initWithFrame:CGRectMake(tfw*i, 0, 0.5, h)];
            linev.backgroundColor = [UIColor darkGrayColor];
            [view addSubview:linev];
        }
        
    }
    
    //--
    _cursorView = [[UIView alloc] init];
    _cursorView.backgroundColor = [UIColor blackColor];
    _cursorView.hidden = YES;
    [view addSubview:_cursorView];
    _isCursorAnim = NO;
    
}

- (void)edit:(UITapGestureRecognizer*)tapGes {
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    
    UIViewController *vc = target;
    [self resignOthers:vc.view];
    
    [self beginInput];
}

- (void)resignOthers:(UIView*)view {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[self class]]) {
            
            FBPasswordInputView *pv = (FBPasswordInputView*)v;
            [pv endInput];
        }
        else {
            [self resignOthers:v];
        }
    }
}


#pragma mark -- cursor -- 光标模拟


- (void)cursorAnim:(NSTimer*)timer {
    if (_cursorView.isHidden) {
        [_cursorView setHidden:NO];
    }
    else {
        [_cursorView setHidden:YES];
    }
}



- (void)startCursor {
    [self.cursorTimer setFireDate:[NSDate distantPast]];
    
    
    [self setCursor:_mPwd.length==0?0:(_mPwd.length==PWD_DEFAULT_LENGTH?_mPwd.length-1:_mPwd.length)];
    [_cursorView setHidden:NO];
    _isCursorAnim = YES;
}


- (void)stopCursor {
    [self.cursorTimer setFireDate:[NSDate distantFuture]];
    [_cursorView setHidden:YES];
    _isCursorAnim = NO;
}


- (NSTimer*)cursorTimer {
    if (_cursorTimer == nil) {
        _cursorTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(cursorAnim:) userInfo:nil repeats:YES];
    }
    
    return _cursorTimer;
}


- (void)releaseTimer {
    if (_isCursorAnim) {
        [self stopCursor];
    }
    
    if (_cursorTimer) {
        [_cursorTimer invalidate];
        _cursorTimer = nil;
    }
}



/**
 *  set cursor
 */
- (void)setCursor:(NSInteger)index {
    UILabel *lb = [_pwdLbs firstObject];
    CGFloat lbw = lb.frame.size.width;
    
    _cursorView.frame = CGRectMake(lbw*(index+1)-1, 5, 1, _mPwdTF.frame.size.height-5*2);
}




/**
 *  根据支持的密码类型来指定默认键盘
 *
 *  @param type
 */
- (UIKeyboardType)configKeyboardWithType:(PasswordType)type {
    switch (type) {
            
        case PasswordType_Alpha:
        case PasswordType_AlphaNumber:
        case PasswordType_AlphaNumberSymbol:{
            
            return UIKeyboardTypeASCIICapable;
        } break;
        case PasswordType_Number:{
            
            return UIKeyboardTypeNumberPad;
        } break;
            
        default:
            break;
    }
}



#pragma mark-- notifications

- (void)addNotifications {
    // UITextField通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tfChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)tfChanged:(NSNotification*)noti {
    
    UITextField *tf = noti.object;
    if (![tf isEqual:_mPwdTF]) {
        return;
    }
    
    //input
    NSInteger len  = tf.text.length;
    if (len > _mPwd.length) {
        
        //模拟密码点
        UILabel *lb = [_pwdLbs objectAtIndex:len-1];
        lb.text = @"•";
        
        if (len != PWD_DEFAULT_LENGTH) {
            //移动光标
            [self setCursor:len];
        }
        
    }
    //back trace
    else {
        
        UILabel *lb = [_pwdLbs objectAtIndex:len];
        lb.text = @"";
        
        if (len < PWD_DEFAULT_LENGTH-1) {
            
            //移动光标
            [self setCursor:len];
        }
    }
    
    _mPwd = tf.text;
    
    if (_mPwd.length == PWD_DEFAULT_LENGTH) {
        
        __weak typeof(self) weakSelf = self;
        if (self.pwdInputCompleteBlk) {
            self.pwdInputCompleteBlk(_mPwd, weakSelf);
        }
        
        //        [self clearPassword];
    }
}




#pragma mark-- UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_mPwdTF]) {
        _mPwdTF.countOfBecomingFirstResponder += 1;
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:_mPwdTF]) {
        
        //        // 防止重新获得焦点，退格清空内容
        //        if (range.location > 0 && range.length == 1 && string.length == 0) {
        //
        //            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        //            _mPwd = textField.text;
        //            if (textField.text.length != 0 && textField.text.length != PWD_DEFAULT_LENGTH-1) {
        //                [self setCursor:textField.text.length];
        //            }
        //            UILabel *lb = [_pwdLbs objectAtIndex:textField.text.length];
        //            lb.text = @"";
        //
        //            return NO;
        //        }
        
        
        /*防止重新获取焦点后 输入 或 键盘退格 会清空内容*/
        /*重新获得焦点后键盘退格删除*/
        BOOL becomeFirstResponderAgainAndBackspace = textField.countOfBecomingFirstResponder>1 && string.length == 0 && range.length == 1;
        /*重新获得焦点后输入*/
        BOOL becomeFirstResponderAgainAndInput = textField.countOfBecomingFirstResponder>1 && range.length ==0 && string.length != 0;
        
        if (becomeFirstResponderAgainAndBackspace || becomeFirstResponderAgainAndInput) {
            
            // Stores cursor position
            UITextPosition *beginning = textField.beginningOfDocument;
            UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
            NSInteger cursorOffset = [textField offsetFromPosition:beginning toPosition:start] + string.length;
            
            // Save the current text, in case iOS deletes the whole text
            NSString *text = textField.text;
            
            // Trigger deletion
            if (becomeFirstResponderAgainAndBackspace){
                [textField deleteBackward];
            }
            
            
            // iOS deleted the entire string
            if (textField.text.length != text.length - 1)
            {
                textField.text = [text stringByReplacingCharactersInRange:range withString:string];
                
                // Update cursor position
                UITextPosition *newCursorPosition = [textField positionFromPosition:textField.beginningOfDocument offset:cursorOffset];
                UITextRange *newSelectedRange = [textField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
                [textField setSelectedTextRange:newSelectedRange];
            }
            return NO;
        }
        
        // password limits
        if (range.location + range.length  > textField.text.length) {
            return NO;
        }
        
        //limit
        NSCharacterSet *blockedCharacters;
        
        switch (_mType) {
                
            case PasswordType_Number:{
                
                blockedCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            } break;
            case PasswordType_Alpha: {
                
                blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
            } break;
            case PasswordType_AlphaNumber: {
                
                blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
            } break;
            case PasswordType_AlphaNumberSymbol:{
                
                NSMutableCharacterSet *set = [NSMutableCharacterSet alphanumericCharacterSet];
                [set formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
                blockedCharacters = [set invertedSet];
            } break;
                
            default:
                break;
        }
        if ([string rangeOfCharacterFromSet:blockedCharacters].location != NSNotFound) {
            return NO;
        }
        
        
        // limit length
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= PWD_DEFAULT_LENGTH;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return NO;
}







#pragma mark -- out interfaces

- (void)beginInput {
    
    if (![_mPwdTF isFirstResponder]) {
        [_mPwdTF becomeFirstResponder];
    }
    
    if (!_isCursorAnim) {
        [self clearPassword];
    }
    
}

- (void)endInput {
    
    if ([_mPwdTF isFirstResponder]) {
        [_mPwdTF resignFirstResponder];
    }
    
    if (_isCursorAnim) {
        [self stopCursor];
    }
    
}



- (void)clearPassword {
    if (![_mPwd isEqualToString:@""]) {
        
        _mPwd = @"";
        _mPwdTF.text = @"";
        
        for (UILabel* lb in _pwdLbs) {
            lb.text = @"";
        }
        
        [self setCursor:0];
    }
}




- (NSString*)pwd {
    return _mPwd;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end