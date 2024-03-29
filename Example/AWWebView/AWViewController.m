//
//  AWViewController.m
//  AWWebView
//
//  Created by maltsugar on 03/11/2020.
//  Copyright (c) 2020 maltsugar. All rights reserved.
//

#import "AWViewController.h"
#import "AWAppDelegate.h"


@interface AWViewController ()<WKNavigationDelegate, AWWebViewDelegate>
{
    int _cnt;
}


@property (nonatomic, strong) AWWebView *webView;
@end

@implementation AWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView = [[AWWebView alloc] init];
    [self.view addSubview:_webView];
    
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray<NSLayoutConstraint *> * constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[w]|" options:0 metrics:nil views:@{@"w": self.webView}];
    NSArray<NSLayoutConstraint *> * constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[w]|" options:0 metrics:nil views:@{@"w": self.webView}];
    [self.view addConstraints:constraints1];
    [self.view addConstraints:constraints2];
    
    
    NSString *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"].absoluteString;
    self.webView.urlString = url;
    self.webView.delegate = self;
    
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn.backgroundColor = [UIColor cyanColor];
    [testBtn setTitle:@"点击调用js" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(handleTestBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    testBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn(==150)]-20-|" options:0 metrics:nil views:@{@"btn": testBtn}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[btn(==30)]-60-|" options:0 metrics:nil views:@{@"btn": testBtn}]];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.webView.enableLog = YES;
    [self.webView setupDelegates];
    
    [self.webView registerJSHandle:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"dataFrom JS : %@",data);
        _cnt ++;
        responseCallback([AWWebView convertToJson:@{@"data": @(_cnt)} removeSpace:NO]);
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.webView clearDelegatesAndRegistedHadle];
}

#pragma mark- <WKNavigationDelegate, AWWebViewDelegate>
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"加载失败");
    self.webView.tipBaseView.hidden = NO;
}

- (void)webViewdidTapTipView:(AWWebView *)webView
{
    self.webView.tipBaseView.hidden = YES;
    [self.webView.webView reload];
}



#pragma mark-
- (void)handleTestBtnAction
{
    NSLog(@"!!!!!!!!!!!!!!!");
    if (_cnt > 10) {
        AWAppDelegate *delegate = (AWAppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *vc =  [UIViewController new];
        vc.view.backgroundColor = [UIColor whiteColor];
        
        delegate.window.rootViewController = vc;

    }else {
        [self.webView callJSFunction:@{@"jsFunctionID": @1, @"param": @{@"key1": @"100", @"key2": @200}} responseCallback:^(id responseData) {
            NSLog(@"%@", responseData);
        }];
    }

}



- (void)dealloc
{
    NSLog(@"销毁");
}
@end
