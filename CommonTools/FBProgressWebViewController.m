//
//  FBProgressWebViewController.m
//  AVFoundationDemo
//
//  Created by 123 on 15/12/14.
//  Copyright © 2015年 com.pureLake. All rights reserved.
//

#import "FBProgressWebViewController.h"
//#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0)
#import <WebKit/WebKit.h>
//#endif


#define WEBVIEW_PROGRESS_TINTCOLOR [UIColor orangeColor]
#define WEBVIEW_TRACK_TINTCOLOR [UIColor whiteColor]

@interface FBProgressWebViewController ()<UIWebViewDelegate, WKNavigationDelegate, UIActionSheetDelegate>
@property (retain, nonatomic) UIProgressView *progressView;
@property (retain, nonatomic) NSURL *homeURL;

//#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0)
@property (retain, nonatomic) WKWebView *wkwebView;
//#else
@property (retain, nonatomic) UIWebView *webView;
@property (assign, nonatomic) NSUInteger loadCount;
//#endif
@end

@implementation FBProgressWebViewController


+ (void)showInViewController:(UIViewController *)viewController withURLString:(NSString *)urlString withTitle:(NSString *)title {
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    FBProgressWebViewController *pwvc = [[FBProgressWebViewController alloc] init];
    pwvc.showRightBtns = YES;
    pwvc.homeURL = [NSURL URLWithString:urlString];
    pwvc.title = title;
    
    [viewController.navigationController pushViewController:pwvc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self configUI];
    [self configLeftBarItems];
    if (self.showRightBtns) {
        [self configRightBarItems];
    }
}




/**
 *  UI
 */
- (void)configUI {
    //progress view
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0)];
    self.progressView.progressTintColor = WEBVIEW_PROGRESS_TINTCOLOR;
    self.progressView.trackTintColor = WEBVIEW_TRACK_TINTCOLOR;
    [self.view addSubview:self.progressView];
    
    
    //web view
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
        WKPreferences* preferences = [[WKPreferences alloc] init];
        preferences.javaScriptEnabled = YES;
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preferences;

        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        config.userContentController = wkUController;

        self.wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64) configuration:config];
        self.wkwebView.navigationDelegate = self;
        self.wkwebView.UIDelegate = self;
        [self.view insertSubview:self.wkwebView belowSubview:self.progressView];
        
        //kvo
        [self.wkwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        //load url
        NSURLRequest *request = [NSURLRequest requestWithURL:self.homeURL];
        [self.wkwebView loadRequest:request];
    } else {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        self.webView.delegate = self;
        [self.view insertSubview:self.webView belowSubview:self.progressView];
        
        //load url
        NSURLRequest *request = [NSURLRequest requestWithURL:self.homeURL];
        [self.webView loadRequest:request];
    }
    
}


/**
 *  navigation left bar items
 */
- (void)configLeftBarItems {
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = back;
}


/**
 *  navigation right bar items
 */
- (void)configRightBarItems {
    UIBarButtonItem *moreBt  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(more:)];
    self.navigationItem.rightBarButtonItem = moreBt;
}


/**
 *  web view close
 */
- (void)configCloseBarItems {
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stop:)];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:self.navigationItem.leftBarButtonItem, close, nil];
}


/**
 *  back
 *
 *  @param sender
 */
- (void)back:(id)sender {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.wkwebView canGoBack]) {
            [self.wkwebView goBack];
            if (self.navigationItem.leftBarButtonItems.count == 1) {
                [self configCloseBarItems];
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
            if (self.navigationItem.leftBarButtonItems.count == 1) {
                [self configCloseBarItems];
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

/**
 *  more
 *
 *  @param sender
 */
- (void)more:(id)sender {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alVC = [UIAlertController alertControllerWithTitle:@"已复制链接到粘贴板" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *safari = [UIAlertAction actionWithTitle:@"safari打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openInSafari:[self absoluteURLString]];
        }];
        
        UIAlertAction *copy = [UIAlertAction actionWithTitle:@"复制链接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pasteUrl:[self absoluteURLString]];
        }];
        
        UIAlertAction *reflash = [UIAlertAction actionWithTitle:@"刷新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self reloadWebView];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alVC addAction:safari];
        [alVC addAction:copy];
        [alVC addAction:reflash];
        [alVC addAction:cancel];
        [self presentViewController:alVC animated:YES completion:nil];
    } else {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"safari打开",@"复制链接"/*,@"分享"*/,@"刷新", nil];
        [as showInView:self.view];
    }
}


/**
 *  close web view
 *
 *  @param sender
 */
- (void)stop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -- UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //safari 打开
    if (buttonIndex == 0) {
        [self openInSafari:[self absoluteURLString]];
    }
    //复制链接
    else if (buttonIndex == 1) {
        [self pasteUrl:[self absoluteURLString]];
    }
    //刷新
    else if (buttonIndex == 2) {
        [self reloadWebView];
    }
}


/**
 *  safari打开
 *
 *  @param urlString
 */
- (void)openInSafari:(NSString*)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
    }
}


/**
 *  复制
 *
 *  @param urlString
 */
- (void)pasteUrl:(NSString*)urlString {
    if (urlString.length > 0) {
        [[UIPasteboard generalPasteboard] setString:urlString];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            UIAlertController *alVC = [UIAlertController alertControllerWithTitle:@"已复制链接到粘贴板" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alVC addAction:cancel];
            [self presentViewController:alVC animated:YES completion:nil];
        } else {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"已复制链接到粘贴板" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [al show];
        }
    }
}


/**
 *  刷新
 */
- (void)reloadWebView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.wkwebView reload];
    } else {
        [self.webView reload];
    }
}



- (NSString*)absoluteURLString {
    NSString *urlStr = self.homeURL.absoluteString;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        urlStr = self.wkwebView.URL.absoluteString;
    } else {
        urlStr = self.webView.request.URL.absoluteString;
    }
    
    return urlStr;
}


/**
 *  kvo
 *
 *  @param keyPath
 *  @param object
 *  @param change
 *  @param context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.wkwebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        //        NSLog(@"wkwebview_estimatedProgress");
        CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (progress == 1) {
            [self.progressView setHidden:YES];
            [self.progressView setProgress:0 animated:YES];
        } else {
            [self.progressView setHidden:NO];
            [self.progressView setProgress:progress animated:YES];
        }
    }
}



#pragma mark -- WKWebview delegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}



- (void)setLoadCount:(NSUInteger)loadCount {
    
    _loadCount = loadCount;
    
    if (_loadCount == 0) {
        
        [self.progressView setHidden:YES];
        [self.progressView setProgress:0 animated:YES];
    }
    else {
        
        [self.progressView setHidden:NO];
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
    
}


#pragma mark - - UIWebview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loadCount ++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loadCount --;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.loadCount --;
}








- (void)dealloc {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.wkwebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    
//    NSURL *url = [request URL];
//    NSString *urlStr = url.absoluteString;
//    
//    return [self processURL:urlStr];
//    
//}
//
//- (BOOL) processURL:(NSString *) url
//{
//    NSString *urlStr = [NSString stringWithString:url];
//    
//    NSString *protocolPrefix = @"js2ios://";
//    
//    //process only our custom protocol
//    if ([[urlStr lowercaseString] hasPrefix:protocolPrefix])
//    {
//        //strip protocol from the URL. We will get input to call a native method
//        urlStr = [urlStr substringFromIndex:protocolPrefix.length];
//        
//        //Decode the url string
//        urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
//        NSError *jsonError;
//        
//        //parse JSON input in the URL
//        NSDictionary *callInfo = [NSJSONSerialization
//                                  JSONObjectWithData:[urlStr dataUsingEncoding:NSUTF8StringEncoding]
//                                  options:kNilOptions
//                                  error:&jsonError];
//        
//        //check if there was error in parsing JSON input
//        if (jsonError != nil)
//        {
//            NSLog(@"Error parsing JSON for the url %@",url);
//            return NO;
//        }
//        
//        //Get function name. It is a required input
//        NSString *functionName = [callInfo objectForKey:@"functionname"];
//        if (functionName == nil)
//        {
//            NSLog(@"Missing function name");
//            return NO;
//        }
//        
//        NSString *successCallback = [callInfo objectForKey:@"success"];
//        NSString *errorCallback = [callInfo objectForKey:@"error"];
//        NSArray *argsArray = [callInfo objectForKey:@"args"];
//        
//        [self callNativeFunction:functionName withArgs:argsArray onSuccess:successCallback onError:errorCallback];
//        
//        //Do not load this url in the WebView
//        return NO;
//        
//    }
//    
//    return YES;
//}
//
//- (void) callNativeFunction:(NSString *) name withArgs:(NSArray *) args onSuccess:(NSString *) successCallback onError:(NSString *) errorCallback
//{
//    //We only know how to process sayHello
//    if ([name compare:@"sayHello" options:NSCaseInsensitiveSearch] == NSOrderedSame)
//    {
//        if (args.count > 0)
//        {
//            NSString *resultStr = [NSString stringWithFormat:@"Hello %@ !", [args objectAtIndex:0]];
//            
//            [self callSuccessCallback:successCallback withRetValue:resultStr forFunction:name];
//        }
//        else
//        {
//            NSString *resultStr = [NSString stringWithFormat:@"Error calling function %@. Error : Missing argument", name];
//            [self callErrorCallback:errorCallback withMessage:resultStr];
//        }
//    }
//    else
//    {
//        //Unknown function called from JavaScript
//        NSString *resultStr = [NSString stringWithFormat:@"Cannot process function %@. Function not found", name];
//        [self callErrorCallback:errorCallback withMessage:resultStr];
//        
//    }
//}
//
//-(void) callErrorCallback:(NSString *) name withMessage:(NSString *) msg
//{
//    if (name != nil)
//    {
//        //call error handler
//        
//        NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
//        [resultDict setObject:msg forKey:@"error"];
//        [self callJSFunction:name withArgs:resultDict];
//    }
//    else
//    {
//        NSLog(@"%@",msg);
//    }
//    
//}
//
//-(void) callSuccessCallback:(NSString *) name withRetValue:(id) retValue forFunction:(NSString *) funcName
//{
//    if (name != nil)
//    {
//        //call succes handler
//        
//        NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
//        [resultDict setObject:retValue forKey:@"result"];
//        [self callJSFunction:name withArgs:resultDict];
//    }
//    else
//    {
//        NSLog(@"Result of function %@ = %@", funcName,retValue);
//    }
//    
//}
//
//-(void) callJSFunction:(NSString *) name withArgs:(NSMutableDictionary *) args
//{
//    NSError *jsonError;
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:args options:0 error:&jsonError];
//    
//    if (jsonError != nil)
//    {
//        //call error callback function here
//        NSLog(@"Error creating JSON from the response  : %@",[jsonError localizedDescription]);
//        return;
//    }
//    
//    //initWithBytes:length:encoding
//    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"jsonStr = %@", jsonStr);
//    
//    if (jsonStr == nil)
//    {
//        NSLog(@"jsonStr is null. count = %zd", [args count]);
//    }
//    
//    [self.wkwebView evaluateJavaScript:[NSString stringWithFormat:@"%@('%@');",name,jsonStr] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
//        
//    }];
//}

@end
