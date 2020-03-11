//
//  AWWebViewController.h
//  Pods
//
//  Created by zgy on 2020/3/11.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

NS_ASSUME_NONNULL_BEGIN


extern NSString *const kJSHandleFunctionName;/// js端 注册的方法名称

@interface AWWebViewController : UIViewController

@property (nonatomic, strong) WKWebView *webView;


- (void)registerJSHandle:(WVJBHandler)handler;
- (void)callJSFunction:(NSDictionary *)param responseCallback:(WVJBResponseCallback)responseCallback;

- (NSString *)convertToJsonData:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
