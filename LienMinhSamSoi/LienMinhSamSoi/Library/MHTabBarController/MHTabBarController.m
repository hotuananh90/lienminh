/*
 * Copyright (c) 2011-2012 Matthijs Hollemans
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHTabBarController.h"
#import "Common.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIStoryboard+Quickly.h"
#import "ViewController.h"
#import "REFrostedViewController.h"
#import "DEMONavigationController.h"
#import "Macro.h"

static const NSInteger TagOffset = 1000;
@interface MHTabBarController()<SWRevealViewControllerDelegate,REFrostedViewControllerDelegate>

@end

@implementation MHTabBarController
{
    
    UIView *contentContainerView;
    UIImageView *indicatorImageView;
    float _tabbarMinWidth;
    BOOL checkRight;
    BOOL checkLeft;
    BOOL checkBtnRight;
    UIWindow *keyWindow;
    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeRight;
}

- (void)viewDidLoad
{
    _tabbarMinWidth = 50;
    checkBtnRight = YES;
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.topItem.title =appLanguage.app_name;
    self.view.backgroundColor = [UIColor whiteColor];
        [self navigationController].navigationBar.titleTextAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil];
    //    self.navigationController.navigationBarHidden = NO;
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    
    float width = self.view.bounds.size.width;
    
    if (self.viewControllers.count>3) {
        width = width*self.viewControllers.count/4;
    }
    
    CGRect rect = CGRectMake(0.0f, 0.0f,SCREEN_WIDTH, self.tabBarHeight);
    
    _tabButtonsContainerView = [[UIScrollView alloc] initWithFrame:rect];
    
    _tabButtonsContainerView.contentSize = CGSizeMake(width, self.tabBarHeight);
    
    _tabButtonsContainerView.backgroundColor = [UIColor whiteColor];
    
    _tabButtonsContainerView.showsHorizontalScrollIndicator = NO;
    
    _tabButtonsContainerView.scrollEnabled = YES;
    
    [self.view addSubview:_tabButtonsContainerView];
    
    
    rect.origin.y = self.tabBarHeight;
    rect.size.height = self.view.bounds.size.height - self.tabBarHeight;
    contentContainerView = [[UIView alloc] initWithFrame:rect];
    contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:contentContainerView];

    self.isLeft = NO;
    
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    [self reloadTabButtons];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"OKa");
}

- (void)tappedRightButton:(UISwipeGestureRecognizer *)recognizer
{
    checkLeft = NO;
    CGPoint point = [recognizer locationInView:[recognizer view]];
    SWRevealViewController *reveal = self.revealViewController;
    if (recognizer.state == UIGestureRecognizerStateEnded){
        
        if (point.y>[self tabBarHeight]) {
            
            if (reveal.frontViewPosition == FrontViewPositionRight) {
                
                SWRevealViewController *reveal = self.revealViewController;
                
                [reveal setFrontViewPosition:FrontViewPositionLeft animated:YES];
                
                self.isLeft = NO;
                
            }
            else{
                if (_selectedIndex<self.viewControllers.count-1 && !self.isLeft) {
                    
                    [self setSelectedIndex:_selectedIndex+1 animated:YES];
                    
                }
                if (_selectedIndex>1 && self.viewControllers.count>=3) {
                    
                    float width = self.view.bounds.size.width;
                    
                    width = width*(_selectedIndex+1)/2;
                    
                    
                    CGRect rect = CGRectMake(0.0f, 0.0f,width, self.tabBarHeight);
                    
                    if (_selectedIndex == 2) {
                        if (checkRight == YES) {
                            [self setSelectedIndex:_selectedIndex-2 animated:YES];
                            checkRight = NO;
                            checkLeft = YES;
                        }else{
                            checkRight = YES;
                        }
                    }else{
                        [_tabButtonsContainerView scrollRectToVisible:rect animated:YES];
                    }
                }
            }
        }
    }
}

- (void)tappedLeftButton:(UISwipeGestureRecognizer *)recognizer
{
    checkRight = NO;
    CGPoint point = [recognizer locationInView:[recognizer view]];
    
    if (recognizer.state == UIGestureRecognizerStateEnded){
        
        if (point.y>[self tabBarHeight]) {
            
            if (_selectedIndex >0) {
                [self setSelectedIndex:_selectedIndex - 1 animated:YES];
                if (_selectedIndex == 0) {
                    checkLeft = YES;
                }
            }
           else if (_selectedIndex==0) {
                //                SWRevealViewController *reveal = self.revealViewController;
                //                [reveal setFrontViewPosition:FrontViewPositionRight animated:YES];
                //                self.isLeft = YES;
                if (checkLeft == YES) {
                    [self setSelectedIndex:_selectedIndex+2 animated:YES];
                    checkLeft = NO;
                    checkRight = YES;
                }else{
                    checkLeft = YES;
                }
            }
            if (_selectedIndex<self.viewControllers.count-3 && self.viewControllers.count>3) {
                
                float width = self.view.bounds.size.width;
                
                width = width*(_selectedIndex+1)/3;
                
                
                CGRect rect = CGRectMake(0.0f, 0.0f,width, self.tabBarHeight);
                
                
                [_tabButtonsContainerView scrollRectToVisible:rect animated:YES];
            }
        }
    }
    
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self layoutTabButtons];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only rotate if all child view controllers agree on the new orientation.
    for (UIViewController *viewController in self.viewControllers)
    {
        if (![viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation])
            return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        _tabButtonsContainerView = nil;
        contentContainerView = nil;
        indicatorImageView = nil;
    }
}

- (void)reloadTabButtons
{
    [self removeTabButtons];
    [self addTabButtons];
    
    // Force redraw of the previously active tab.
    NSUInteger lastIndex = _selectedIndex;
    _selectedIndex = NSNotFound;
    self.selectedIndex = lastIndex;
}

- (void)addTabButtons
{
    NSUInteger index = 0;
    for (UIViewController *viewController in self.viewControllers)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = TagOffset + index;
        if (SCREEN_WIDTH_PORTRAIT>320) {
            button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        }else{
            button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        }
        button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIOffset offset = viewController.tabBarItem.titlePositionAdjustment;
        if (index == 0) {
            button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal-8, 0.0f, 0.0f);
        }else if (index == 3){
            button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal+8, 0.0f, 0.0f);
        }else{
            button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal, 0.0f, 0.0f);
        }
        
        button.imageEdgeInsets = viewController.tabBarItem.imageInsets;
        [button setTitle:viewController.tabBarItem.title forState:UIControlStateNormal];
        [button setImage:viewController.tabBarItem.image forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        [self deselectTabButton:button];
        [_tabButtonsContainerView addSubview:button];
        
        ++index;
    }
    [_tabButtonsContainerView bringSubviewToFront:indicatorImageView];
}

- (void)removeTabButtons
{
    for(UIView* subView in _tabButtonsContainerView.subviews )
    {
        if([subView isKindOfClass:[UIImageView class]]) continue;
        [subView removeFromSuperview];
    }
}

- (void)layoutTabButtons
{
    NSUInteger index = 0;
    NSUInteger count = [self.viewControllers count];
    NSUInteger count2 = count;
    if (count2>4) {
        count2=4;
    }
    float width = floorf(SCREEN_WIDTH / count2)+1;
    width = MAX(width, _tabbarMinWidth);
    _tabButtonsContainerView.contentSize = CGSizeMake(width*[self.viewControllers count], _tabButtonsContainerView.contentSize.height);
    
    CGRect rect = CGRectMake(0.0f, 0.0f, width, self.tabBarHeight);
    
    indicatorImageView.hidden = YES;
    
    NSArray *buttons = [_tabButtonsContainerView subviews];
    for (UIButton *button in buttons)
    {
        if([button isKindOfClass:[UIImageView class]]) continue;
        //rect.size.width = _tabButtonsContainerView.contentSize.width-rect.origin.x;
        float with;
        if (index == 0){
            with = SCREEN_WIDTH_PORTRAIT/3-12;
        }else if (index == 2){
            with = SCREEN_WIDTH_PORTRAIT/3-12;
        }else{
            with = SCREEN_WIDTH_PORTRAIT/3+12;
        }
        rect.size.width = with;
        
        button.frame = rect;
        rect.origin.x += rect.size.width;
        if (index == self.selectedIndex)
            [self centerIndicatorOnButton:button];
        ++index;
    }
}

- (void)centerIndicatorOnButton:(UIButton *)button
{
    CGRect rect = indicatorImageView.frame;
    rect.size.width = button.frame.size.width;
    rect.origin.x = button.center.x - floorf(rect.size.width/2.0f);
    rect.origin.y = self.tabBarHeight - indicatorImageView.frame.size.height;
    indicatorImageView.frame = rect;
    indicatorImageView.hidden = NO;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
    NSAssert([newViewControllers count] >= 2, @"MHTabBarController requires at least two view controllers");
    
    UIViewController *oldSelectedViewController = self.selectedViewController;
    
    // Remove the old child view controllers.
    for (UIViewController *viewController in _viewControllers)
    {
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }
    
    _viewControllers = [newViewControllers copy];
    
    // This follows the same rules as UITabBarController for trying to
    // re-select the previously selected view controller.
    NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
    if (newIndex != NSNotFound)
        _selectedIndex = newIndex;
    else if (newIndex < [_viewControllers count])
        _selectedIndex = newIndex;
    else
        _selectedIndex = 0;
    
    // Add the new child view controllers.
    for (UIViewController *viewController in _viewControllers)
    {
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
    
    if ([self isViewLoaded])
        [self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
    [self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
    NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
    
    if ([self.delegate respondsToSelector:@selector(mh_tabBarController:shouldSelectViewController:atIndex:)])
    {
        UIViewController *toViewController = (self.viewControllers)[newSelectedIndex];
        if (![self.delegate mh_tabBarController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
            return;
    }
    
    if (![self isViewLoaded])
    {
        _selectedIndex = newSelectedIndex;
    }
    else if (_selectedIndex != newSelectedIndex)
    {
        UIViewController *fromViewController;
        UIViewController *toViewController;
        
        if (_selectedIndex != NSNotFound)
        {
            UIButton *fromButton = (UIButton *)[_tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
            [self deselectTabButton:fromButton];
            fromViewController = self.selectedViewController;
        }
        
        NSUInteger oldSelectedIndex = _selectedIndex;
        _selectedIndex = newSelectedIndex;
        
        UIButton *toButton;
        if (_selectedIndex != NSNotFound)
        {
            toButton = (UIButton *)[_tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
            [self selectTabButton:toButton];
            toViewController = self.selectedViewController;
        }
        
        if (toViewController == nil)  // don't animate
        {
            [fromViewController.view removeFromSuperview];
        }
        else if (fromViewController == nil)  // don't animate
        {
            toViewController.view.frame = contentContainerView.bounds;
            [contentContainerView addSubview:toViewController.view];
            [self centerIndicatorOnButton:toButton];
            
            if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
                [self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
        }
        else if (animated)
        {
            CGRect rect = contentContainerView.bounds;
            if (oldSelectedIndex == 0 && newSelectedIndex == 3) {
                if (oldSelectedIndex < newSelectedIndex)
                    rect.origin.x = -rect.size.width;
                else
                    rect.origin.x = rect.size.width;
                
            }else if (oldSelectedIndex == 3 && newSelectedIndex == 0){
                if (oldSelectedIndex < newSelectedIndex)
                    rect.origin.x = -rect.size.width;
                else
                    rect.origin.x = rect.size.width;
            }else{
                if (oldSelectedIndex < newSelectedIndex)
                    rect.origin.x = rect.size.width;
                else
                    rect.origin.x = -rect.size.width;
            }
            toViewController.view.frame = rect;
            _tabButtonsContainerView.userInteractionEnabled = NO;
            swipeRight.enabled = NO;
            swipeLeft.enabled = NO;
            [self transitionFromViewController:fromViewController
                              toViewController:toViewController
                                      duration:0.3f
                                       options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                                    animations:^
             {
                 CGRect rect = fromViewController.view.frame;
                 if (oldSelectedIndex < newSelectedIndex)
                     rect.origin.x = -rect.size.width;
                 else
                     rect.origin.x = rect.size.width;
                 
                 fromViewController.view.frame = rect;
                 toViewController.view.frame = contentContainerView.bounds;
                 [self centerIndicatorOnButton:toButton];
             }
            completion:^(BOOL finished)
             {
                 swipeRight.enabled = YES;
                 swipeLeft.enabled = YES;
                 if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
                     [self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
                 _tabButtonsContainerView.userInteractionEnabled = YES;
             }];
        }
        else  // not animated
        {
            [fromViewController.view removeFromSuperview];
            
            toViewController.view.frame = contentContainerView.bounds;
            [contentContainerView addSubview:toViewController.view];
            [self centerIndicatorOnButton:toButton];
            
            if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
                [self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
        }
    }
}

- (UIViewController *)selectedViewController
{
    if (self.selectedIndex != NSNotFound)
        return (self.viewControllers)[self.selectedIndex];
    else
        return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
    [self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated
{
    NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
    if (index != NSNotFound)
        [self setSelectedIndex:index animated:animated];
}

- (void)tabButtonPressed:(UIButton *)sender
{
    [self setSelectedIndex:sender.tag - TagOffset animated:YES];
}

#pragma mark - Change these methods to customize the look of the buttons

- (void)selectTabButton:(UIButton *)button
{
//    UIImage *image = [[UIImage imageNamed:@"selectTabBart.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
    if(button.tag == 1000){
        UIImage *image = [[UIImage imageNamed:@"img_tabLeft.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }else if (button.tag == 1003){
        UIImage *image = [[UIImage imageNamed:@"img_tabRight.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        UIImage *image = [[UIImage imageNamed:@"img_tabCentrer.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    
}

- (void)deselectTabButton:(UIButton *)button
{

    UIImage *image = [[UIImage imageNamed:@"unSelectTabBar.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    button.layer.shadowRadius = 0;
    button.layer.shadowOpacity = 0;
    button.layer.shadowPath = [[UIBezierPath bezierPathWithRect:button.layer.bounds] CGPath];
}

- (CGFloat)tabBarHeight
{
    return 54.0f;
}

- (CGFloat)tabBarMinWidth
{
    return 100.0;
}

@end

@implementation UIViewController(WorldCupViewController)

-(void)refreshData
{
    NSLog(@"refresh, no sub class implement");
}
-(void)backToRoot{
    NSLog(@"refresh, no sub class implement");
}
@end

