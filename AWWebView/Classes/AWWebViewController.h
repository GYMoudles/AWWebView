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


@interface AWWebViewController : UIViewController


@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic,   copy) NSString *urlString;

- (void)registerJSHandle:(nullable WVJBHandler)handler;
- (void)callJSFunction:(nullable NSDictionary *)param responseCallback:(nullable WVJBResponseCallback)responseCallback;

- (NSString *)convertToJsonData:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
