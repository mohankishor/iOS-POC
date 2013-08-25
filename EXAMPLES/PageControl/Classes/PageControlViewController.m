#import "PageControlViewController.h"

@implementation PageControlViewController

- (void)pageDidChange {
	NSInteger page = _pageControl.currentPage;
//	self.view.backgroundColor = [UIColor colorWithRed:(page % 2)
//												green:(page % 3)
//												 blue:(page == 0 ? 1 : 0)
//												alpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	_pageControl.dotColor = [UIColor blueColor];
	_pageControl.numberOfPages = 6;
	[_pageControl addTarget:self
					 action:@selector(pageDidChange)
		   forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	[_pageControl release];
	_pageControl = nil;
}

@end
