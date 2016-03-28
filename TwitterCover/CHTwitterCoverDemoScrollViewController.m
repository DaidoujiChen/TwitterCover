//
//  CHTwitterCoverDemoScrollViewController.m
//  TwitterCover
//
//  Created by hangchen on 1/29/14.
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

#import "CHTwitterCoverDemoScrollViewController.h"
#import "UIScrollView+TwitterCover.h"

#define imageSize CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 200)

@interface CHTwitterCoverDemoScrollViewController ()

@end

@implementation CHTwitterCoverDemoScrollViewController
{
    UIScrollView *scrollView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        }
        self.title = @"UIScrollview+TwitterCover";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 600)];
    [scrollView addTwitterCoverWithImages:@[[UIImage imageNamed:@"cover.png"], [UIImage imageNamed:@"cover.png"], [UIImage imageNamed:@"cover.png"]] withImageSize:imageSize onTapped: ^(NSInteger index) {
        NSLog(@"Tapped at Index %td", index);
    }];
    [self.view addSubview:scrollView];
    
    // simulate async replace image1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://c1.cdn.goumin.com/cms/petschool/day_151023/20151023_a5c159b.jpg"]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        [NSThread sleepForTimeInterval:5.0f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView updateTwitterCoverWithImage:image atIndex:1];
        });
    });
    
    // simulate async replace image2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.petfinder.com/wp-content/uploads/2012/11/140272627-grooming-needs-senior-cat-632x475.jpg"]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        [NSThread sleepForTimeInterval:10.0f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView updateTwitterCoverWithImage:image atIndex:2];
        });
    });
    
    [scrollView addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, imageSize.height, self.view.bounds.size.width - 40, 600 - imageSize.height)];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:22];
        label.text = @"TwitterCover is a parallax top view with real time blur effect to any UIScrollView, inspired by Twitter for iOS.\n\nCompletely created using UIKit framework.\n\nEasy to drop into your project.\n\nYou can add this feature to your own project, TwitterCover is easy-to-use.";
        label;
    })];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
