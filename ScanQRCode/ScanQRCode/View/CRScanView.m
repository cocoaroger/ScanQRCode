//
//  CRScanView.m
//  ScanQRCode
//
//  Created by roger wu on 2019/6/10.
//  Copyright © 2019 cocoaroger. All rights reserved.
//

#import "CRScanView.h"
#import <AVFoundation/AVFoundation.h>

static const CGFloat kScanWH = 300; // 默认扫描区域宽高

@interface CRScanView ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDeviceInput *input; // 输入数据源
@property (nonatomic, strong) AVCaptureMetadataOutput *output; // 输出数据源
@property (nonatomic, strong) AVCaptureSession *session; // 输入输出的中间桥梁 负责把捕获的音视频数据输出到输出设备中
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layerView; // 相机拍摄预览图层
@property (strong, nonatomic) UILabel *errorLabel; // 错误提示

@end

@implementation CRScanView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _errorLabel.center = self.center;
}

- (void)setup {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor blackColor];
    
    _errorLabel = [UILabel new];
    _errorLabel.font = [UIFont systemFontOfSize:16];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.textColor = [UIColor whiteColor];
    _errorLabel.numberOfLines = 0;
    _errorLabel.frame = CGRectMake(0, 0, screenBounds.size.width, 40);
    _errorLabel.hidden = YES;
    [self addSubview:_errorLabel];
    
#if (TARGET_IPHONE_SIMULATOR)
    [self noticeWithContent:@"模拟器不能使用摄像头"];
#else
    AVAuthorizationStatus status =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        [self showError:@"请打开相机权限"];
        return;
    }
    
    // 创建输入数据源
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *inputError = nil;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&inputError];
    if (inputError) {
        [self showError:inputError.localizedDescription];
        return;
    }
    
    // 创建输出数据源
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    CGRect cropRect = CGRectMake((screenBounds.size.width - kScanWH)/2,
                                 (screenBounds.size.height - kScanWH)/2,
                                 kScanWH, kScanWH);
    [self setRectOfIntrest:cropRect];
    
    // Session设置
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:_input];
    [_session addOutput:_output];
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                        AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeCode128Code];
    // 视频图层
    _layerView = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _layerView.backgroundColor = [UIColor blackColor].CGColor;
    _layerView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _layerView.frame = screenBounds;
    [self.layer addSublayer:_layerView];
#endif
}

- (void)showError:(NSString *)error {
    _errorLabel.text = error;
    _errorLabel.hidden = NO;
}

- (void)start {
    if (_session) {
        [_session startRunning];
        _errorLabel.hidden = YES;
    }
}

- (void)stop {
    [_session stopRunning];
}

- (void)setRectOfIntrest:(CGRect)rect {
    _output.rectOfInterest = [self rectOfInterestByScanViewRect:rect];
}

- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGRect selfRect = self.bounds;
    CGFloat width = CGRectGetWidth(selfRect);
    CGFloat height = CGRectGetHeight(selfRect);
    
    CGFloat x = rect.origin.y/height;
    CGFloat y = rect.origin.x/width;
    
    CGFloat w = CGRectGetHeight(rect)/height;
    CGFloat h = CGRectGetWidth(rect)/width;
    
    return CGRectMake(x, y, w, h);
}

#pragma mark - 实现代理方法, 完成二维码扫描
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSString *content = metadataObject.stringValue;
        [self.delegate scanView:self content:content];
    }
}

@end
