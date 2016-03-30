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

@interface CHTwitterCoverView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readonly) NSInteger currentIndex;

- (id)initWithFrame:(CGRect)frame andContentTopView:(UIView *)view andImages:(NSArray<UIImage *> *)images;
- (void)updateImage:(UIImage *)image atIndex:(NSInteger)index;

@end

@interface CHTwitterCoverView ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIScrollView *internalScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, readonly) NSInteger imageCount;
@property (nonatomic, readonly) CGFloat imageHeight;
@property (nonatomic, readonly) CGFloat imageWidth;

@end

@implementation CHTwitterCoverView

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger currentPage = ((scrollView.contentOffset.x - width / 2) / width) + 1;
    if (self.pageControl.currentPage != currentPage) {
        self.pageControl.currentPage = currentPage;
    }
}

#pragma mark - readonly property

- (NSInteger)currentIndex {
    return self.pageControl.currentPage;
}

- (NSInteger)imageCount {
    return self.internalScrollView.subviews.count;
}

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
    
    // scrollview 下拉
    if (self.scrollView.contentOffset.y < -self.scrollView.contentInset.top) {
        UIImageView *currentImageView = self.internalScrollView.subviews[self.pageControl.currentPage];
        CGFloat baseX = self.imageWidth * self.pageControl.currentPage;
        CGFloat offset = -self.scrollView.contentOffset.y - self.scrollView.contentInset.top;
        
        // topview 需要上移, 大小, 高度皆不變
        self.topView.frame = CGRectMake(0, -offset, self.imageWidth, CGRectGetHeight(self.topView.bounds));
        
        // CHTwitterCoverView 隨著 topview 上移, 並且同時拉高他的大小, 大小改變, contentSize 隨之改變
        self.frame = CGRectMake(0, -offset + CGRectGetHeight(self.topView.bounds), self.imageWidth, self.imageHeight + offset);
        self.internalScrollView.frame = CGRectMake(0, 0, self.imageWidth, self.imageHeight + offset);
        self.internalScrollView.contentSize = CGSizeMake(self.imageWidth * self.imageCount, self.imageHeight + offset);
        
        // 最後, 對當前頁數上的圖片做置中, 放大長寬的效果
        currentImageView.frame = CGRectMake(-offset + baseX, 0, self.imageWidth + offset * 2, self.imageHeight + offset);
    }
    // scrollview 上滑
    else {
        CGFloat offset = self.scrollView.contentOffset.y;
        if (offset >= CGRectGetHeight(self.topView.bounds)) {
            offset -= CGRectGetHeight(self.topView.bounds);
            
            // topview 不動
            self.topView.frame = CGRectMake(0, 0, self.imageWidth, CGRectGetHeight(self.topView.bounds));
            
            // CHTwitterCoverView 貼著 topview, 並且減少自己的高度, contentSize 隨之改變
            self.frame = CGRectMake(0, CGRectGetHeight(self.topView.bounds) + offset, self.imageWidth, self.imageHeight - offset);
            self.internalScrollView.frame = CGRectMake(0, 0, self.imageWidth, self.imageHeight - offset);
            self.internalScrollView.contentSize = CGSizeMake(self.imageWidth * self.imageCount, self.imageHeight - offset);
            
            // 為了確保圖片的一致性, 在上滑時, 對全部的圖片都做一樣的調整, 皆為縮減高度
            for (NSInteger index = 0; index < self.internalScrollView.subviews.count; index++) {
                UIImageView *eachImageView = self.internalScrollView.subviews[index];
                eachImageView.frame = CGRectMake(self.imageWidth * index, 0, self.imageWidth, self.imageHeight - offset);
            }
        }
    }
}

#pragma mark - instance method

- (void)updateImage:(UIImage *)image atIndex:(NSInteger)index {
    if (index < self.imageCount) {
        UIImageView *imageView = self.internalScrollView.subviews[index];
        imageView.image = image;
    }
    else {
        NSLog(@"Image Not Update. Index Out of Count");
    }
}

#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame andContentTopView:(UIView *)view andImages:(NSArray<UIImage *> *)images {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 初始化值, 與從外部紀錄內容
        self.topView = view;
        
        // 設定多圖片捲動 scrollview
        self.internalScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.internalScrollView.delegate = self;
        self.internalScrollView.pagingEnabled = YES;
        self.internalScrollView.clipsToBounds = YES;
        self.internalScrollView.showsVerticalScrollIndicator = NO;
        self.internalScrollView.showsHorizontalScrollIndicator = NO;
        for (NSInteger index = 0; index < images.count; index++) {
            CGRect newFrame = CGRectMake(self.imageWidth * index, 0, self.imageWidth, self.imageHeight);
            UIImageView *newImageView = [[UIImageView alloc] initWithFrame:newFrame];
            newImageView.image = images[index];
            newImageView.contentMode = UIViewContentModeScaleAspectFill;
            newImageView.clipsToBounds = NO;
            [self.internalScrollView addSubview:newImageView];
        }
        self.internalScrollView.contentSize = CGSizeMake(self.imageWidth * images.count, self.imageHeight);
        [self addSubview:self.internalScrollView];
        
        // 如果圖片多餘一張, 放置 pageControl
        if (images.count > 1) {
            self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.internalScrollView.frame) - 20.0f, self.imageWidth, 20.0f)];
            self.pageControl.userInteractionEnabled = NO;
            self.pageControl.numberOfPages = images.count;
            self.pageControl.currentPage = 0;
            self.pageControl.backgroundColor = [UIColor clearColor];
            [self addSubview:self.pageControl];
            
            // 用 autolayout 設定置中置底
            self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[pageControl(%.0f)]-0-|", CGRectGetWidth(self.pageControl.frame)] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"pageControl" : self.pageControl }]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[pageControl(%.0f)]-0-|", CGRectGetHeight(self.pageControl.frame)] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"pageControl" : self.pageControl }]];
        }
    }
    return self;
}

// 小心 ios8 會 crash 的問題
- (void)dealloc {
    self.internalScrollView.delegate = nil;
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

- (void)setTapped:(void (^)(NSInteger index))tapped {
    objc_setAssociatedObject(self, @selector(tapped), tapped, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(NSInteger index))tapped {
    return objc_getAssociatedObject(self, _cmd);
}

@end

@implementation UIScrollView (TwitterCover)

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.twitterCoverView setNeedsLayout];
}

#pragma mark - private instance methods

- (void)onTwitterCoverTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    void (^tapped)(NSInteger index) = [self tapped];
    if (tapped) {
        tapped(self.twitterCoverView.currentIndex);
    }
}

#pragma mark - instance methods

- (void)addTwitterCoverWithImage:(UIImage *)image withImageSize:(CGSize)imageSize onTapped:(void (^)(void))tapped {
    [self addTwitterCoverWithImage:image withImageSize:imageSize withTopView:nil onTapped:tapped];
}

- (void)addTwitterCoverWithImage:(UIImage *)image withImageSize:(CGSize)imageSize withTopView:(UIView *)topView onTapped:(void (^)(void))tapped {
    [self addTwitterCoverWithImages:@[image] withImageSize:imageSize withTopView:topView onTapped: ^(NSInteger index) {
        if (tapped) {
            tapped();
        }
    }];
}

- (void)addTwitterCoverWithImages:(NSArray<UIImage *> *)images withImageSize:(CGSize)imageSize onTapped:(void (^)(NSInteger index))tapped {
    [self addTwitterCoverWithImages:images withImageSize:imageSize withTopView:nil onTapped:tapped];
}

- (void)addTwitterCoverWithImages:(NSArray<UIImage *> *)images withImageSize:(CGSize)imageSize withTopView:(UIView *)topView onTapped:(void (^)(NSInteger index))tapped {
    
    NSAssert(self.twitterCoverView == nil, @"Avoid Call addTwitterCoverWithImages:withImageSize:withTopView:onTapped: twice.\n Use updateTwitterCoverWithImage:atIndex: Instead");
    
    [self setTapped:tapped];
    
    CHTwitterCoverView *view = [[CHTwitterCoverView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(topView.bounds), imageSize.width, imageSize.height) andContentTopView:topView andImages:images];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    view.scrollView = self;
    
    // 加上點擊手勢
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTwitterCoverTapped:)];
    [view addGestureRecognizer:tapGestureRecognizer];
    [self addSubview:view];
    self.twitterCoverView = view;
    
    // 設定 topview
    if (topView) {
        [self addSubview:topView];
    }
    
    // KVO
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)updateTwitterCoverWithImage:(UIImage *)image atIndex:(NSInteger)index {
    [self.twitterCoverView updateImage:image atIndex:index];
}

#pragma mark - life cycle

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.twitterCoverView && !newSuperview) {
        [self removeObserver:self forKeyPath:@"contentOffset"];
    }
}

@end
