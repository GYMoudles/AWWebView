//
//  AWWebView.m
//  Pods
//
//  Created by zgy on 2020/3/12.
//

#import "AWWebView.h"

@interface AWWebView ()<WKUIDelegate, WKNavigationDelegate>


@end

NSString *const kClientRegistedMethodName = @"clientRegistedMethod"; // 客户端注册的js handle
NSString *const kJSHandleFunctionName = @"jsRegistedFunction"; // js端 注册的方法名称

@implementation AWWebView
@synthesize urlString = _urlString, webView = _webView, jsBridge = _jsBridge;

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.webView.translatesAutoresizingMaskIntoConstraints = NO;
//        NSArray<NSLayoutConstraint *> * constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[w]|" options:0 metrics:nil views:@{@"w": self.webView}];
//        NSArray<NSLayoutConstraint *> * constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[w]|" options:0 metrics:nil views:@{@"w": self.webView}];
//        [self addConstraints:constraints1];
//        [self addConstraints:constraints2];
//    }
//    return self;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.webView.frame = self.bounds;
}



- (void)setupDelegates
{
    // UI代理
    self.webView.UIDelegate = self;
    // 导航代理
    // self.webView.navigationDelegate = self; // 用了jsBridge，使用setWebViewDelegate方法
    
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    [WKWebViewJavascriptBridge enableLogging];
    [self.jsBridge setWebViewDelegate:self];
}
- (void)clearDelegatesAndRegistedHadle
{
    [self.jsBridge removeHandler:kClientRegistedMethodName];
    self.webView.UIDelegate = nil;
    //    self.webView.navigationDelegate = nil;
}


- (void)setUrlString:(NSString *)urlString
{
    if (nil == urlString) {
        return;
    }
    _urlString = [urlString copy];
    NSURL *url = [NSURL URLWithString:_urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20]];
}


#pragma mark- JSBridgeActions
- (void)registerJSHandle:(nullable WVJBHandler)handler {
    [self.jsBridge registerHandler:kClientRegistedMethodName handler:handler];
}

- (void)callJSFunction:(nullable NSDictionary *)param responseCallback:(nullable WVJBResponseCallback)responseCallback {
    [self.jsBridge callHandler:kJSHandleFunctionName data:[AWWebView convertToJson:param] responseCallback:responseCallback];
}


#pragma mark- WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"js alert()内容: %@", message);
    completionHandler();
}



#pragma mark- Helper
+ (NSString *)convertToJson:(id)obj
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0, jsonString.length};
    
    // 去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0, mutStr.length};
    
    // 去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (id)convertDataWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return obj;
}

#pragma mark- lazy

- (WKWebView *)webView
{
    if (nil == _webView) {
        _webView = [[WKWebView alloc]init];
        _jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
        [self addSubview:_webView];
    }
    return _webView;
}


@end
