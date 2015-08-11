## TwitterCover ##

TwitterCover is a parallax top view with real time blur effect to any UIScrollView, inspired by Twitter for iOS.

Completely created using UIKit framework.

Easy to drop into your project.

## Modify by DaidoujiChen ##
針對自己使用上的需求, 修改了幾個部分, 首先, 把 code 的封裝與架構做了一些調整, 目前只剩下

`````
- (void)addTwitterCoverWithImage:(UIImage *)image withImageSize:(CGSize)imageSize;
- (void)addTwitterCoverWithImage:(UIImage *)image withImageSize:(CGSize)imageSize withTopView:(UIView *)topView;
`````

兩個 `public method` 可以 call, 也不再需要 call remove 把 view 移除, 並且可由外部控制圖片的大小, 而不是吃寫死的 `#define` 值. 第二, 拿掉了下拉時候會帶模糊的效果. 第三, 新增了上滑的時候, 圖片不是被整個直接推上去, 看起來是被關起來的效果.

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

