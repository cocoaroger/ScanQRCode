//
//  CRScanCoverView.m
//  ScanQRCode
//
//  Created by roger wu on 2019/6/10.
//  Copyright © 2019 cocoaroger. All rights reserved.
//

#import "CRScanCoverView.h"

static const CGFloat kLineImageViewHeight = 20;

@interface CRScanCoverView ()

@property (strong, nonatomic) UIImageView *rectImageView;
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UILabel *noticeLabel;

@end

@implementation CRScanCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    _rectImageView = [UIImageView new];
    _rectImageView.image = [UIImage imageNamed:@"scan_rect"];
    [self addSubview:_rectImageView];
    
    _lineImageView = [UIImageView new];
    _lineImageView.image = [UIImage imageNamed:@"scan_line"];
    [_rectImageView addSubview:_lineImageView];
    
    _noticeLabel = [UILabel new];
    _noticeLabel.font = [UIFont systemFontOfSize:12];
    _noticeLabel.textColor = [UIColor whiteColor];
    _noticeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_noticeLabel];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    _rectImageView.frame = [self centerFrame];
    _lineImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_rectImageView.frame), kLineImageViewHeight);
    _noticeLabel.frame = CGRectMake(0, CGRectGetMaxY(_rectImageView.frame) + 20, screenSize.width, 20);
}

- (void)start {
    _lineImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_rectImageView.frame), kLineImageViewHeight);
    [UIView animateWithDuration:2
                          delay:0
                        options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.lineImageView.frame = CGRectMake(0,
                                                               CGRectGetHeight(self.rectImageView.frame) - kLineImageViewHeight,
                                                               CGRectGetWidth(self.rectImageView.frame),
                                                               kLineImageViewHeight);
                     } completion:nil];
}

- (CGRect)centerFrame {
    UIImage *rectImage = [UIImage imageNamed:@"scan_rect"];
    CGFloat width = rectImage.size.width;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat x = (screenSize.width - width)/2;
    CGFloat y = (screenSize.height - width)/2;
    CGRect centerFrame = CGRectMake(x, y, width, width);
    return centerFrame;
}

- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithWhite:0 alpha:0.5] setFill];
    UIRectFill(rect);
    CGRect holeiInterSection = CGRectIntersection([self centerFrame], rect);
    [[UIColor clearColor] setFill];
    UIRectFill(holeiInterSection);
}

@end
