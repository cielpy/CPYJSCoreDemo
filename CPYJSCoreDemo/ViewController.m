//
//  ViewController.m
//  CPYJSCoreDemo
//
//  Created by ciel on 16/6/18.
//  Copyright © 2016年 CPY. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSBridge.h"

@interface ViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) JSContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JSCoreDemo" ofType:@"html"];
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
    self.webView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    [context setExceptionHandler:^(JSContext *ctx, JSValue *expectValue) {
        NSLog(@"%@", expectValue);
    }];
    
    self.context = context;
    
    self.context[@"ocObj"] = [[JSBridge alloc] init];
}


- (IBAction)buttonClick:(UIButton *)sender {
    if (!self.context) {
        return;
    }
    
    JSValue *funcValue = self.context[@"alertFunc"];
    [funcValue callWithArguments:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
