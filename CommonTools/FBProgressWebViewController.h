//
//  FBFBProgressWebViewController.h
//  CommonTools
//
//  Created by 123 on 15/12/14.
//
//

#import <UIKit/UIKit.h>

@interface FBProgressWebViewController : UIViewController
@property (nonatomic, assign) BOOL showRightBtns;
+ (void)showInViewController:(UIViewController*)viewController withURLString:(NSString*)urlString withTitle:(NSString*)title;
@end
