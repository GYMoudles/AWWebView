//
//  AWWebViewController.h
//  Pods
//
//  Created by zgy on 2020/3/11.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>



NS_ASSUME_NONNULL_BEGIN


extern NSString *const kJSHandleFunctionName;/// js端 注册的方法名称


#if __has_include(<AWBaseSDK/AWBaseViewController.h>)
#import <AWBaseSDK/AWBaseViewController.h>
@interface AWWebViewController : AWBaseViewController
#else
@interface AWWebViewController : UIViewController
#endif


@property (nonatomic, strong) WKWebView *webView;


- (void)registerJSHandle:(WVJBHandler)handler;
- (void)callJSFunction:(NSDictionary *)param responseCallback:(WVJBResponseCallback)responseCallback;

- (NSString *)convertToJsonData:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
