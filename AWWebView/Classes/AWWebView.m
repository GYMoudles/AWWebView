//
//  AWWebView.m
//  Pods
//
//  Created by zgy on 2020/3/12.
//

#import "AWWebView.h"

API_AVAILABLE(ios(9.0))
@interface AWWebView ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UIStackView *tipStackView;

@end

NSString *const kClientRegistedMethodName = @"clientRegistedMethod"; // 客户端注册的js handle
NSString *const kJSHandleFunctionName = @"jsRegistedFunction"; // js端 注册的方法名称

@implementation AWWebView
//@synthesize urlString = _urlString;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _webView = [[WKWebView alloc]init];
        _jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
        [self addSubview:_webView];
        
        self.tipBaseView.backgroundColor = [UIColor whiteColor];
        [self.tipStackView addArrangedSubview:self.tipImgView];
        [self.tipStackView addArrangedSubview:self.tipLab];
        self.tipBaseView.hidden = YES;
    }
    return self;
}

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

- (void)handleTipBaseViewTapAction
{
    if ([self.delegate respondsToSelector:@selector(webViewdidTapTipView:)]) {
        [self.delegate webViewdidTapTipView:self];
    }
}


#pragma mark- JSBridgeActions
- (void)registerJSHandle:(nullable WVJBHandler)handler {
    [self.jsBridge registerHandler:kClientRegistedMethodName handler:handler];
}

- (void)callJSFunction:(nullable NSDictionary *)param responseCallback:(nullable WVJBResponseCallback)responseCallback {
    [self.jsBridge callHandler:kJSHandleFunctionName data:[AWWebView convertToJson:param removeSpace:NO] responseCallback:responseCallback];
}


#pragma mark- WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"js alert()内容: %@", message);
    completionHandler();
}

#pragma mark- WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"请求失败");
    
}



#pragma mark- Helper
+ (NSString *)convertToJson:(id)obj removeSpace:(BOOL)removeSpace
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
    if (removeSpace) {
        NSRange range = {0, jsonString.length};
        // 去掉字符串中的空格
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        NSRange range2 = {0, mutStr.length};
        // 去掉字符串中的换行符
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    }
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


+ (nullable id)getValueInParamWithKey:(NSString *)key dict:(id)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dic = (NSDictionary *)dict;
    
    if([dic[@"param"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *param = (NSDictionary *)dic[@"param"];
        return param[key];
    }
    return nil;
}



+ (UIImage *)awImageName:(NSString *)imageName forClass:(Class)cls bundleName:(NSString *)bundleName
{
    NSBundle *bundle = [AWWebView awBundleForClass:cls bundleName:bundleName];
    return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
}



+ (NSBundle *)awBundleForClass:(Class)cls bundleName:(NSString *)name
{
//    NSBundle *bundle = [NSBundle bundleForClass:cls];
//    NSURL *url = [bundle URLForResource:name withExtension:@"bundle"];
//    return [self bundleWithURL:url];
    
    NSBundle *mainBundle = [NSBundle bundleForClass:cls];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:name ofType:@"bundle"]];
    if (nil != resourcesBundle) {
        mainBundle = resourcesBundle;
    }
    return mainBundle;
}





#pragma mark- lazy
- (UIStackView *)tipStackView API_AVAILABLE(ios(9.0)) {
    if (nil == _tipStackView) {
        _tipStackView = [[UIStackView alloc]init];
        _tipStackView.axis = UILayoutConstraintAxisVertical;
        _tipStackView.distribution = UIStackViewDistributionEqualCentering;
        _tipStackView.alignment = UIStackViewAlignmentCenter;
        _tipStackView.spacing = 20;
    }
    return _tipStackView;
}

- (UIView *)tipBaseView
{
    if (nil == _tipBaseView) {
        _tipBaseView = [[UIView alloc]init];
        [self addSubview:_tipBaseView];
        _tipBaseView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[s]|" options:0 metrics:nil views:@{@"s": _tipBaseView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[s]|" options:0 metrics:nil views:@{@"s": _tipBaseView}]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTipBaseViewTapAction)];
        [_tipBaseView addGestureRecognizer:tap];
        
        
        [_tipBaseView addSubview:self.tipStackView];
        self.tipStackView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tipBaseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=0)-[s]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"s": self.tipStackView, @"superview": _tipBaseView}]];
        [_tipBaseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=0)-[s]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"s": self.tipStackView, @"superview": _tipBaseView}]];
        
    }
    return _tipBaseView;
}


- (UIImageView *)tipImgView
{
    if (nil == _tipImgView) {
        _tipImgView = [[UIImageView alloc]init];
        [self.tipStackView addArrangedSubview:_tipImgView];
        
        _tipImgView.translatesAutoresizingMaskIntoConstraints = NO;
        _tipImgView.image = [AWWebView awImageName:@"reload" forClass:[self class] bundleName:kAWWebViewBundleName];
        [_tipImgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[i(60)]" options:0 metrics:nil views:@{@"i": _tipImgView}]];
        [_tipImgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[i(60)]" options:0 metrics:nil views:@{@"i": _tipImgView}]];
        
    }
    return _tipImgView;
}

- (UILabel *)tipLab
{
    if (nil == _tipLab) {
        _tipLab = [[UILabel alloc]init];
        [self.tipStackView addArrangedSubview:_tipLab];
        
        _tipLab.translatesAutoresizingMaskIntoConstraints = NO;
        _tipLab.text = @"请检查网络，并刷新页面";
        _tipLab.textColor = [UIColor darkGrayColor];
        _tipLab.font = [UIFont systemFontOfSize:15];
        [_tipLab addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[i(30)]" options:0 metrics:nil views:@{@"i": _tipLab}]];
//        [_tipLab addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[i(160)]" options:0 metrics:nil views:@{@"i": _tipLab}]];
    }
    return _tipLab;
}

@end
