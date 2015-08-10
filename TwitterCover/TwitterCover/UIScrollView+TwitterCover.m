//
//  UIScrollView+TwitterCover.m
//  TwitterCover
//
//  Created by hangchen on 1/7/14.
//  Copyright (c) 2014 Hang Chen (https://github.com/cyndibaby905)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UIScrollView+TwitterCover.h"
#import <objc/runtime.h>

@interface CHTwitterCoverView : UIImageView

@property (nonatomic, weak) UIScrollView *scrollView;

- (id)initWithFrame:(CGRect)frame andContentTopView:(UIView *)view;

@end

@interface CHTwitterCoverView ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, readonly) CGFloat imageHeight;
@property (nonatomic, readonly) CGFloat imageWidth;

@end

@implementation CHTwitterCoverView

#pragma mark - readonly property

- (CGFloat)imageHeight {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, @(CGRectGetHeight(self.bounds)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSNumber *imageHeight = objc_getAssociatedObject(self, _cmd);
    return [imageHeight floatValue];
}

- (CGFloat)imageWidth {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, @(CGRectGetWidth(self.bounds)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSNumber *imageWidth = objc_getAssociatedObject(self, _cmd);
    return [imageWidth floatValue];
}

#pragma mark - method to override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.scrollView.contentOffset.y < -self.scrollView.contentInset.top) {
        CGFloat offset = -self.scrollView.contentOffset.y - self.scrollView.contentInset.top;
        self.topView.frame = CGRectMake(0, -offset, self.imageWidth, self.topView.bounds.size.height);
        self.frame = CGRectMake(-offset, -offset + self.topView.bounds.size.height, self.imageWidth + offset * 2, self.imageHeight + offset);
    }
    else {
        self.topView.frame = CGRectMake(0, 0, self.imageWidth, self.topView.bounds.size.height);
        self.frame = CGRectMake(0, self.topView.bounds.size.height, self.imageWidth, self.imageHeight);
    }
}

#pragma mark - instance method

- (id)initWithFrame:(CGRect)frame andContentTopView:(UIView *)view {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.topView = view;
    }
    return self;
}

@end

@interface UIScrollView (PrivateTwitterCover)

@property (nonatomic, strong) CHTwitterCoverView *twitterCoverView;

@end

@implementation UIScrollView (PrivateTwitterCover)

#pragma mark - runtime objects

- (void)setTwitterCoverView:(CHTwitterCoverView *)twitterCoverView {
    objc_setAssociatedObject(self, @selector(twitterCoverView), twitterCoverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CHTwitterCoverView *)twitterCoverView {
    return objc_getAssociatedObject(self, _cmd);
}

@end

@implementation UIScrollView (TwitterCover)

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.twitterCoverView setNeedsLayout];
}

#pragma mark - instance methods

- (void)addTwitterCoverWithImage:(UIImage *)image withImageSize:(CGSize)imageSize {
    [self addTwitterCoverWithImage:image withImageSize:imageSize withTopView:nil];
}

- (void)addTwitterCoverWithImage:(UIImage *)image withImageSize:(CGSize)imageSize withTopView:(UIView *)topView {
    if (self.twitterCoverView) {
        [self.twitterCoverView removeFromSuperview];
        [self removeObserver:self forKeyPath:@"contentOffset"];
    }
    CHTwitterCoverView *view = [[CHTwitterCoverView alloc] initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height) andContentTopView:topView];
    view.backgroundColor = [UIColor clearColor];
    view.image = image;
    view.scrollView = self;
    [self addSubview:view];
    
    if (topView) {
        [self addSubview:topView];
    }
    self.twitterCoverView = view;
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - life cycle

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.twitterCoverView && !newSuperview) {
        [self removeObserver:self forKeyPath:@"contentOffset"];
    }
}

@end
