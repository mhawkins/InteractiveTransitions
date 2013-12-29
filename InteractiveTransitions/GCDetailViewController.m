//
//  GCDetailViewController.m
//  InteractiveTransitions
//
//  Created by Matt Hawkins on 12/15/13.
//  Copyright (c) 2013 Matt Hawkins. All rights reserved.
//

#import "GCDetailViewController.h"
#import "GCPinchInteractiveTransitionObject.h"
#import "GCNavigationControllerDelegate.h"
#import "UIViewController+GCInteractiveNavigationHelpers.h"

@interface GCDetailViewController ()
- (void)configureView;
@end

@implementation GCDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self gc_wireUpTransitionObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)wireUpTransitionObject
//{
////    id<UIViewControllerAnimatedTransitioning> animatedTransitioning =
////    [self.navigationController.delegate navigationController:self.navigationController
////                             animationControllerForOperation:UINavigationControllerOperationPop
////                                          fromViewController:self
////                                            toViewController:nil];
////    
////    id<UIViewControllerInteractiveTransitioning> interactiveTransitioning =
////    [self.navigationController.delegate navigationController:self.navigationController
////                 interactionControllerForAnimationController:animatedTransitioning];
//    GCNavigationControllerDelegate *navControllerDelegate = (GCNavigationControllerDelegate *)self.navigationController.delegate;
//    
//    
//    GCPinchInteractiveTransitionObject *pinchTransition = navControllerDelegate.interactivePinchTransitionObject; //(GCPinchInteractiveTransitionObject *)interactiveTransitioning;
//    [pinchTransition attachToViewController:self];
//}

@end
