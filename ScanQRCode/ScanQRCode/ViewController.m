//
//  ViewController.m
//  ScanQRCode
//
//  Created by roger wu on 2019/6/10.
//  Copyright © 2019 cocoaroger. All rights reserved.
//

#import "ViewController.h"
#import "CRScanView.h"
#import "CRScanCoverView.h"

@interface ViewController ()<CRScanViewDelegate>

@property (strong, nonatomic) CRScanView *scanView;
@property (strong, nonatomic) CRScanCoverView *coverView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scanView = [[CRScanView alloc] initWithFrame:self.view.frame];
    _scanView.delegate = self;
    [self.view addSubview:_scanView];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat scanWH = [UIImage imageNamed:@"scan_rect"].size.width;
    CGRect cropRect = CGRectMake((screenBounds.size.width - scanWH)/2,
                                 (screenBounds.size.height - scanWH)/2,
                                 scanWH, scanWH);
    [_scanView setRectOfIntrest:cropRect];
    [_scanView start];
    
    _coverView = [[CRScanCoverView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_coverView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_coverView start];
}

#pragma mark - CRScanViewDelegate
- (void)scanView:(CRScanView *)scanView content:(NSString *)content {
    NSLog(@"扫描结果：%@", content);
    [_scanView stop];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:content
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"继续扫描"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self.scanView start];
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
