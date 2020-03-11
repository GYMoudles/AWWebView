//
//  AWViewController.m
//  AWWebView
//
//  Created by maltsugar on 03/11/2020.
//  Copyright (c) 2020 maltsugar. All rights reserved.
//

#import "AWViewController.h"

@interface AWViewController ()

@end

@implementation AWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
    
    
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn.backgroundColor = [UIColor cyanColor];
    [testBtn setTitle:@"点击调用js" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(handleTestBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    testBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn(==150)]-20-|" options:0 metrics:nil views:@{@"btn": testBtn}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[btn(==30)]-60-|" options:0 metrics:nil views:@{@"btn": testBtn}]];
    
    
    
    [self registerJSHandle:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"dataFrom JS : %@",data);
        responseCallback([self convertToJsonData:@{@"data": @1}]);
    }];
    
    
}


#pragma mark-
- (void)handleTestBtnAction
{
    [self callJSFunction:@{@"jsFunctionID": @1, @"param": @{@"key1": @"100", @"key2": @200}} responseCallback:^(id responseData) {
        NSLog(@"%@", responseData);
    }];
}


@end
