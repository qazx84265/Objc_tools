////
////  FBPasswordInput.h
////  TestIOS
////
////  Created by 123 on 16/4/7.
////  Copyright © 2016年 ly. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//
//
//typedef NS_ENUM(NSInteger, PasswordViewStyle) {
//    PasswordViewStyle_Default,   // 默认方角
//    PasswordViewStyle_Round      // 圆角, 此style下可以指定圆角半径
//};
//
//
//typedef NS_ENUM(NSInteger, PasswordType) {
//    PasswordType_Number,   // Only numbers , 0~9
//    PasswordType_Alpha,   // Only letters, A~Z or a~z
//    PasswordType_AlphaNumber,  // A~Z , a~z , 0~9
//    PasswordType_AlphaNumberSymbol   // PasswordType_AlphaNumber and symbols, like '_', '?' ,'@' ,etc.
//};
//
//@class FBPasswordInput;
//typedef void (^pwdInputComplete)(NSString* pwd, FBPasswordInput* tf);
//
//
//
@interface FBPasswordInput : UIView
//@property (nonatomic, copy, readonly) NSString *pwd;
//
//@property (nonatomic, assign, readonly) PasswordType pwdType;
//
//@property (nonatomic, assign, readonly) NSUInteger pwdLength;  //password length, default is 6. less than 10 is recommend.
//
//@property (nonatomic, assign) PasswordViewStyle pStype; //
//@property (nonatomic, assign) CGFloat corRadius;  // Only valid in PasswordViewStyle_Round
//
//@property (nonatomic, copy) pwdInputComplete pwdInputCompleteBlk;  //password input complete callback. when the input's length is equal to 'pwdLength', called automatic.
//
//
//- (id)initWithFrame:(CGRect)frame
//      completeBlock:(pwdInputComplete)completeBlock;
//
//- (id)initWithFrame:(CGRect)frame
//              style:(PasswordViewStyle)style
//      completeBlock:(pwdInputComplete)completeBlock;
//
//- (id)initWithFrame:(CGRect)frame
//              style:(PasswordViewStyle)style
//          corRadius:(CGFloat)corRadius
//      completeBlock:(pwdInputComplete)completeBlock;
//
//- (id)initWithFrame:(CGRect)frame
//          pwdLength:(NSUInteger)length
//              style:(PasswordViewStyle)style
//          corRadius:(CGFloat)corRadius
//      completeBlock:(pwdInputComplete)completeBlock;
//
//- (id)initWithFrame:(CGRect)frame
//          pwdLength:(NSUInteger)length
//               type:(PasswordType)type
//              style:(PasswordViewStyle)style
//          corRadius:(CGFloat)corRadius
//      completeBlock:(pwdInputComplete)completeBlock;
//
//
///***/
//- (void)beginInput;
//
//- (void)endInput;
//
//
@end
//
//UIKIT_EXTERN NSString *const FBPasswordInputDidBeginEditingNotification;
//UIKIT_EXTERN NSString *const FBPasswordInputDidEndEditingNotification;
//UIKIT_EXTERN NSString *const FBPasswordInputDidChangeNotification;
//UIKIT_EXTERN NSString *const FBPasswordInputDidCompleteNotification;