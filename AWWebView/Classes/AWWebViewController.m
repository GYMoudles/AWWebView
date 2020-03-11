//
//  AWWebViewController.m
//  Pods
//
//  Created by zgy on 2020/3/11.
//

#import "AWWebViewController.h"


@interface AWWebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WebViewJavascriptBridge *jsBridge;

@end


static NSString *kClientRegistedMethodName = @"clientRegistedMethod"; // 客户端注册的js handle
NSString *const kJSHandleFunctionName = @"jsRegistedFunction"; // js端 注册的方法名称

@implementation AWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _webView = [[WKWebView alloc] init];
    [self.view addSubview:_webView];
    
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray<NSLayoutConstraint *> * constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[w]|" options:0 metrics:nil views:@{@"w": _webView}];
    NSArray<NSLayoutConstraint *> * constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[w]|" options:0 metrics:nil views:@{@"w": _webView}];
    [self.view addConstraints:constraints1];
    [self.view addConstraints:constraints2];
    
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
    
    _jsBridge = [WebViewJavascriptBridge bridgeForWebView:_webView];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_jsBridge removeHandler:kClientRegistedMethodName];
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
}


#pragma mark- JSBridgeActions
- (void)registerJSHandle:(WVJBHandler)handler {
    [_jsBridge registerHandler:kClientRegistedMethodName handler:handler];
}

- (void)callJSFunction:(NSDictionary *)param responseCallback:(WVJBResponseCallback)responseCallback {
    [_jsBridge callHandler:kJSHandleFunctionName data:[self convertToJsonData:param] responseCallback:responseCallback];
}


#pragma mark- WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"js alert()内容: %@", message);
    completionHandler();
}


#pragma mark- Helper
- (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0, jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0, mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}


@end
