//
//  CRScanView.h
//  ScanQRCode
//
//  Created by roger wu on 2019/6/10.
//  Copyright © 2019 cocoaroger. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CRScanViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface CRScanView : UIView

@property (weak, nonatomic) id<CRScanViewDelegate> delegate;

- (void)setRectOfIntrest:(CGRect)rect; // 设置扫描区域
- (void)start; // 开始扫描
- (void)stop; // 结束扫描

@end

@protocol CRScanViewDelegate
// 返回扫描内容
- (void)scanView:(CRScanView *)scanView content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
