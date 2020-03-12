//
//  AWViewController.m
//  AWWebView
//
//  Created by maltsugar on 03/11/2020.
//  Copyright (c) 2020 maltsugar. All rights reserved.
//

#import "AWViewController.h"

@interface AWViewController ()
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
    
    
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn.backgroundColor = [UIColor cyanColor];
    [testBtn setTitle:@"点击调用js" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(handleTestBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    testBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn(==150)]-20-|" options:0 metrics:nil views:@{@"btn": testBtn}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[btn(==30)]-60-|" options:0 metrics:nil views:@{@"btn": testBtn}]];
    
    
    
    [self.webView registerJSHandle:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"dataFrom JS : %@",data);
        _cnt ++;
        responseCallback([self.webView convertToJsonData:@{@"data": @(_cnt)}]);
    }];
    
    
}


#pragma mark-
- (void)handleTestBtnAction
{
    [self.webView callJSFunction:@{@"jsFunctionID": @1, @"param": @{@"key1": @"100", @"key2": @200}} responseCallback:^(id responseData) {
        NSLog(@"%@", responseData);
    }];
}


@end
