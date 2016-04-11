////
////  FBPasswordInput.m
////  TestIOS
////
////  Created by 123 on 16/4/7.
////  Copyright © 2016年 ly. All rights reserved.
////
//
//#import "FBPasswordInput.h"
//
//
//#define PWD_LENGTH_PER_TF  1 //单个textField 文本长度，固定为1
//#define PWD_DEFAULT_LENGTH 6 //默认密码长度
//#define PWD_DEFAULT_TYPE  PasswordType_Alpha  //默认键盘类型
//#define PWD_DEFAULT_STYLE PasswordViewStyle_Default  //默认外观样式
//#define PWD_DEFAULT_CORRADIUS 5
//
//
//NSString *const FBPasswordInputDidBeginEditingNotification = @"com.purelake.FBPasswordInputDidBeginEditingNotification";
//NSString *const FBPasswordInputDidEndEditingNotification = @"com.purelake.FBPasswordInputDidEndEditingNotification";
//NSString *const FBPasswordInputDidChangeNotification = @"com.purelake.FBPasswordInputDidChangeNotification";
//NSString *const FBPasswordInputDidCompleteNotification = @"com.purelake.FBPasswordInputDidCompleteNotification";
//
//
//
//
//@interface FBPasswordInput()<UITextFieldDelegate> {
//    PasswordType _mType;
//    NSUInteger _mLength;
//    NSString* _mPwd;
//    UITextField* _mCurrentTF;
//}
//
//
//@property (nonatomic, strong) NSMutableArray *pwdTextFields;
//@end
//
//
//@implementation FBPasswordInput
//
//
//#pragma mark -- init
//
//- (void)dealloc {
//    [self removeNotifications];
//}
//
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        
//        [self perforInitWithPwdLength:PWD_DEFAULT_LENGTH
//                                 type:PWD_DEFAULT_TYPE
//                                style:PWD_DEFAULT_STYLE
//                            corRadius:PWD_DEFAULT_CORRADIUS
//                        completeBlock:nil];
//    }
//    
//    
//    return self;
//}
//
//
//- (id)initWithFrame:(CGRect)frame
//      completeBlock:(pwdInputComplete)completeBlock {
//    
//    return [self initWithFrame:frame
//                     pwdLength:PWD_DEFAULT_LENGTH
//                         style:PWD_DEFAULT_STYLE
//                     corRadius:PWD_DEFAULT_CORRADIUS
//                 completeBlock:completeBlock];
//}
//
//- (id)initWithFrame:(CGRect)frame
//              style:(PasswordViewStyle)style
//      completeBlock:(pwdInputComplete)completeBlock {
//    
//    
//    return [self initWithFrame:frame
//                     pwdLength:PWD_DEFAULT_LENGTH
//                          type:PWD_DEFAULT_TYPE
//                         style:style
//                     corRadius:PWD_DEFAULT_CORRADIUS
//                 completeBlock:completeBlock];
//}
//
//
//- (id)initWithFrame:(CGRect)frame
//              style:(PasswordViewStyle)style
//          corRadius:(CGFloat)corRadius
//      completeBlock:(pwdInputComplete)completeBlock {
//    
//    return [self initWithFrame:frame
//                     pwdLength:PWD_DEFAULT_LENGTH
//                          type:PWD_DEFAULT_TYPE
//                         style:style
//                     corRadius:corRadius
//                 completeBlock:completeBlock];
//}
//
//- (id)initWithFrame:(CGRect)frame
//          pwdLength:(NSUInteger)length
//              style:(PasswordViewStyle)style
//          corRadius:(CGFloat)corRadius
//      completeBlock:(pwdInputComplete)completeBlock {
//    
//    return [self initWithFrame:frame
//                     pwdLength:length
//                          type:PWD_DEFAULT_TYPE
//                         style:style
//                     corRadius:corRadius
//                 completeBlock:completeBlock];
//}
//
//
//- (id)initWithFrame:(CGRect)frame
//          pwdLength:(NSUInteger)length
//               type:(PasswordType)type
//              style:(PasswordViewStyle)style
//          corRadius:(CGFloat)corRadius
//      completeBlock:(pwdInputComplete)completeBlock {
//    
//    if (self = [super initWithFrame:frame]) {
//        
//        self.frame = frame;
//        self.backgroundColor = [UIColor whiteColor];
//        
//        [self perforInitWithPwdLength:length
//                                 type:type
//                                style:style
//                            corRadius:corRadius
//                        completeBlock:completeBlock];
//    }
//    
//    
//    return self;
//}
//
//
//- (void)perforInitWithPwdLength:(NSUInteger)length type:(PasswordType)type style:(PasswordViewStyle)style corRadius:(CGFloat)corRadius completeBlock:(pwdInputComplete)completeBlock {
//    
//    if (completeBlock) {
//        _pwdInputCompleteBlk = [completeBlock copy];
//    }
//    
//    _mPwd = @"";
//    _mLength = length;
//    _mType = type;
//    _pStype = style;
//    _corRadius = corRadius;
//    
//    _pwdTextFields = [NSMutableArray new];
//    
//    
//    [self setUI];
//    
//    [self addNotifications];
//}
//
//
//
//- (void)setUI {
//    
//    //--
//    CGFloat selfh = self.frame.size.height;
//    CGFloat selfw = self.frame.size.width;
//    
//    //-- content view
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, selfw-5*2, selfh-5*2)];
//    view.layer.borderWidth = 0.5;
//    view.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    if (_pStype == PasswordViewStyle_Round) {
//        view.layer.cornerRadius = _corRadius;
//    }
//    [self addSubview:view];
//    
//    
//    //单个密码框size
//    CGFloat h = view.frame.size.height;
//    CGFloat tfw = view.frame.size.width/_mLength;
//    CGFloat tfh = h <= tfw ? h : tfw;
//    
//    //layout
//    for (int i=0; i<_mLength; i++) {
//        
//        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake((tfw-1)*i, (h-tfh)/2, tfw, tfh)];
//        
//        //边框
//        tf.borderStyle = UITextBorderStyleNone;
//
//        if (i!=0 && i<_mLength) {
//            UIView *linev = [[UIView alloc] initWithFrame:CGRectMake(tfw*i, 0, 0.5, h)];
//            linev.backgroundColor = [UIColor darkGrayColor];
//            [view addSubview:linev];
//        }
//        
////        tf.secureTextEntry = YES;
//        tf.textAlignment = NSTextAlignmentRight;  //光标靠右
//        
//        tf.keyboardType = [self configKeyboardWithType:_mType];
//        
//        tf.delegate = self;
//        
//        [_pwdTextFields addObject:tf];
//        [view addSubview:tf];
//    }
//    
//    _mCurrentTF = [_pwdTextFields firstObject];
////    [self beginInput];
//}
//
//
//
///**
// *  根据支持的密码类型来指定默认键盘
// *
// *  @param type
// */
//- (UIKeyboardType)configKeyboardWithType:(PasswordType)type {
//    switch (type) {
//            
//        case PasswordType_Alpha:
//        case PasswordType_AlphaNumber:
//        case PasswordType_AlphaNumberSymbol:{
//            
//            return UIKeyboardTypeASCIICapable;
//        } break;
//        case PasswordType_Number:{
//            
//            return UIKeyboardTypeNumberPad;
//        } break;
//        
//        default:
//            break;
//    }
//}
//
//
//
//#pragma mark-- notifications
//
//- (void)addNotifications {
//    // UITextField通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tfChanged:) name:UITextFieldTextDidChangeNotification object:nil];
//}
//
//
//- (void)removeNotifications {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//
//
//- (void)tfChanged:(NSNotification*)noti {
//    NSLog(@"tfChanged");
//    
//    UITextField *tf = noti.object;
//    
//    __weak typeof(self) weakSelf = self;
//    
//    // input
//    if (tf.text.length == PWD_LENGTH_PER_TF) {
//        
//        _mPwd = [_mPwd stringByAppendingString:tf.text];
//        
//        if (![tf isEqual:[_pwdTextFields lastObject]]) {
//            
//            NSInteger index = [_pwdTextFields indexOfObject:tf];
//            UITextField *nextTF = [_pwdTextFields objectAtIndex:index+1];
//            _mCurrentTF = nextTF;
//            [nextTF becomeFirstResponder];
//            [tf resignFirstResponder];
//            
//        }
//        else {
////            [tf resignFirstResponder];
//            
//            
////            [[NSNotificationCenter defaultCenter] postNotificationName:FBPasswordInputDidCompleteNotification object:weakSelf userInfo:nil];
//            
//            //密码输入完成
//            if (_pwdInputCompleteBlk) {
//                
//                self.pwdInputCompleteBlk(_mPwd, weakSelf);
//            }
//        }
//    }
//    //delete
//    else {
//        
//        NSInteger index = [_pwdTextFields indexOfObject:tf];
//        _mPwd = [_mPwd stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:@""];
//        
////        if (![tf isEqual:[_pwdTextFields firstObject]]) {
////            
////            UITextField *preTF = [_pwdTextFields objectAtIndex:index-1];
////            _mCurrentTF = preTF;
////            [preTF becomeFirstResponder];
////            [tf resignFirstResponder];
////            
////        }
////        else {
////        
////            
////        }
//    }
//    
//    
////    [[NSNotificationCenter defaultCenter] postNotificationName:FBPasswordInputDidChangeNotification object:weakSelf userInfo:nil];
//}
//
//
//
//
//#pragma mark-- UITextField delegate
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    NSLog(@"textFieldDidBeginEditing");
//    
//    if (![textField isEqual:_mCurrentTF]) {
//        return NO;
//    }
//    
//    return YES;
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    NSLog(@"textFieldDidBeginEditing");
//    
////    if ([textField isEqual:[_pwdTextFields firstObject]]) {
////        
////        __weak typeof(self) weakSelf = self;
////        [[NSNotificationCenter defaultCenter] postNotificationName:FBPasswordInputDidBeginEditingNotification object:weakSelf userInfo:nil];
////    }
//}
//
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"textFieldDidEndEditing");
//    
//    
////    __weak typeof(self) weakSelf = self;
////    if ([textField isEqual:[_pwdTextFields lastObject]]) {
////        
////        [[NSNotificationCenter defaultCenter] postNotificationName:FBPasswordInputDidEndEditingNotification object:weakSelf userInfo:nil];
////    }
//}
//
//
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSLog(@"textField_shouldChangeCharactersInRange");
//    
//    //delete
//    if ([string isEqualToString:@""] && range.length!=1) {
//        
//        if (![textField isEqual:[_pwdTextFields firstObject]]) {
//            
//            NSInteger index = [_pwdTextFields indexOfObject:textField];
//            UITextField *preTF = [_pwdTextFields objectAtIndex:index-1];
//            _mCurrentTF = preTF;
//            [preTF becomeFirstResponder];
//            [textField resignFirstResponder];
//            
//        }
//        
//        return YES;
//    }
//    else {
//        
//        // password limits
//        if (range.location + range.length  > textField.text.length) {
//            return NO;
//        }
//        
//        //limit
//        NSCharacterSet *blockedCharacters;
//        
//        switch (_mType) {
//                
//            case PasswordType_Number:{
//                
//                blockedCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
//            } break;
//            case PasswordType_Alpha: {
//                
//                blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
//            } break;
//            case PasswordType_AlphaNumber: {
//                
//                blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
//            } break;
//            case PasswordType_AlphaNumberSymbol:{
//                
//                NSMutableCharacterSet *set = [NSMutableCharacterSet alphanumericCharacterSet];
//                [set formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
//                blockedCharacters = [set invertedSet];
//            } break;
//                
//            default:
//                break;
//        }
//        if ([string rangeOfCharacterFromSet:blockedCharacters].location != NSNotFound) {
//            return NO;
//        }
//        
//        
//        // limit length
//        NSUInteger newLength = [textField.text length] + [string length] - range.length;
//        return newLength <= PWD_LENGTH_PER_TF;
//    }
//
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    return NO;
//}
//
//
//
//
//
//
//
//#pragma mark -- out interfaces
//
//- (void)beginInput {
//    UITextField *tf = (UITextField*)[_pwdTextFields firstObject];
//    [tf becomeFirstResponder];
//    _mCurrentTF = tf;
//}
//
//- (void)endInput {
////    UITextField *tf = (UITextField*)[_pwdTextFields lastObject];
////    [tf resignFirstResponder];
//    
//    for (UITextField *tf in _pwdTextFields) {
//        if ([tf isFirstResponder]) {
//            [tf resignFirstResponder];
//        }
//    }
//}
//
//
//- (NSString*)pwd {
//    return _mPwd;
//}
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//@end
