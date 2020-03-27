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

@class AWWebView;
@protocol AWWebViewDelegate <NSObject>

- (void)webViewdidTapTipView:(AWWebView *)webView;

@end

@interface AWWebView : UIView


@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, strong, readonly) WKWebViewJavascriptBridge *jsBridge;
@property (nonatomic,   copy) NSString *urlString;

@property (nonatomic, weak, nullable) id<AWWebViewDelegate> delegate;
// 提示相关视图
@property (nonatomic, strong) UIView *tipBaseView;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIImageView *tipImgView;


/**
    调用方法传参 统一格式 JSON格式字符串
    {"actionID": 1, param:{"key1": "val1", "key2": "val2"}}
*/
- (void)registerJSHandle:(nullable WVJBHandler)handler; // 页面消失时如果被清理了，在页面出现时注册
- (void)callJSFunction:(nullable NSDictionary *)param responseCallback:(nullable WVJBResponseCallback)responseCallback;

- (void)setupDelegates;/// 页面出现时调用

- (void)clearDelegatesAndRegistedHadle; /// 页面消失时调用，清理代理和注册的handle


+ (NSString *)convertToJson:(id)obj; // 方便其他类调用

+ (id)convertDataWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
