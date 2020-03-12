//
//  AWWebView.h
//  Pods
//
//  Created by zgy on 2020/3/12.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWWebView : UIView

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic,   copy) NSString *urlString;

- (void)registerJSHandle:(nullable WVJBHandler)handler;
- (void)callJSFunction:(nullable NSDictionary *)param responseCallback:(nullable WVJBResponseCallback)responseCallback;


- (void)setupBridge; /// 页面出现时调用
- (void)clearDelegate; /// 页面消失时调用


- (NSString *)convertToJsonData:(NSDictionary *)dict; // 方便子类调用

@end

NS_ASSUME_NONNULL_END
