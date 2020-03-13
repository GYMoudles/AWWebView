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



- (void)setupDelegates;/// 页面出现时调用
- (void)clearDelegates; /// 页面消失时调用


+ (NSString *)convertToJson:(id)obj; // 方便其他类调用

+ (id)convertDataWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
