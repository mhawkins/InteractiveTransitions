//
//  GCPinchInteractiveTransitionObject.m
//  InteractiveTransitions
//
//  Created by Matt Hawkins on 12/29/13.
//  Copyright (c) 2013 Matt Hawkins. All rights reserved.
//

#import "GCPinchInteractiveTransitionObject.h"

@interface GCPinchInteractiveTransitionObject()

@property(nonatomic,assign) BOOL completeTransition;
@property(nonatomic,assign) CGFloat initialScale;
@property(nonatomic,strong) UIViewController *viewController;
@property(nonatomic,strong) UIPinchGestureRecognizer *pinchGesture;

@end

@implementation GCPinchInteractiveTransitionObject

-(void)attachToViewController:(UIViewController *)viewController
{
    self.viewController = viewController;
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureUpdated:)];
    [self.viewController.view addGestureRecognizer:self.pinchGesture];
}

-(void)pinchGestureUpdated:(UIPinchGestureRecognizer *)pinchGesture
{
    switch (pinchGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.initialScale = pinchGesture.scale;
            self.userInteraction = YES;
            [self.viewController.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:
        {
            // Calculate percentage with 100% being both fingers touching
            CGFloat percentage = (self.initialScale - pinchGesture.scale) / self.initialScale;
            percentage = MIN(percentage, 1.0);
            percentage = MAX(0.0, percentage);
            
            // We want at least halfway there to complete
            const CGFloat threshold = 0.5;
            self.completeTransition = (percentage >= threshold);
            
            // Update the transition
            [self updateInteractiveTransition:percentage];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.userInteraction = NO;
            if(pinchGesture.state == UIGestureRecognizerStateCancelled || !self.completeTransition)
            {
                [self cancelInteractiveTransition];
            }
            else
            {
                [self finishInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

-(CGFloat)completionSpeed
{
    CGFloat speed = (1.0 - self.percentComplete);
    return speed;
}
                         

@end
