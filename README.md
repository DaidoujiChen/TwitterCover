## TwitterCover ##

TwitterCover is a parallax top view with real time blur effect to any UIScrollView, inspired by Twitter for iOS.

Completely created using UIKit framework.

Easy to drop into your project.

## Modify by DaidoujiChen ##
針對自己使用上的需求, 修改了幾個部分, 首先, 把 code 的封裝與架構做了一些調整, 目前只剩下

`````
- (void)addTwitterCoverWithImage:(UIImage *)image withImageSize:(CGSize)imageSize onTapped:(void (^)(void))tapped;
- (void)addTwitterCoverWithImage:(UIImage *)image withImageSize:(CGSize)imageSize withTopView:(UIView *)topView onTapped:(void (^)(void))tapped;
- (void)addTwitterCoverWithImages:(NSArray<UIImage *> *)images withImageSize:(CGSize)imageSize onTapped:(void (^)(NSInteger index))tapped;
- (void)addTwitterCoverWithImages:(NSArray<UIImage *> *)images withImageSize:(CGSize)imageSize withTopView:(UIView *)topView onTapped:(void (^)(NSInteger index))tapped;
- (void)updateTwitterCoverWithImage:(UIImage *)image atIndex:(NSInteger)index;
`````

新增五個 `Instance Method` 可以調用, 放置單張或是多張的圖片.

## Requirements ##

TwitterCover requires Xcode 5, targeting either iOS 5.0 and above, ARC-enabled.


## How to use ##
	
Drag UIScrollView+TwitterCover.h amd UIScrollView+TwitterCover.m files to your project. 

No other frameworks required.

    #import "UIScrollView+TwitterCover.h"

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView addTwitterCoverWithImage:[UIImage imageNamed:@"cover.png"]];  

## How it looks ##

![TwitterCover] (https://raw.githubusercontent.com/DaidoujiChen/TwitterCover/master/TwitterCover.gif)


## Lincense ##

`TwitterCover` is available under the MIT license. See the LICENSE file for more info.

