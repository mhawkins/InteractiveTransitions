//
//  GCNavigationControllerDelegate.m
//  InteractiveTransitions
//
//  Created by Matt Hawkins on 12/15/13.
//  Copyright (c) 2013 Matt Hawkins. All rights reserved.
//

#import "GCNavigationControllerDelegate.h"
#import "GCControllerAnimatedTransitioningObject.h"
#import "GCPinchInteractiveTransitionObject.h"

@interface GCNavigationControllerDelegate()

@property(nonatomic,strong) GCControllerAnimatedTransitioningObject *transitioningObject;
@property(nonatomic,strong) GCPinchInteractiveTransitionObject *interactivePinchTransitionObject;

@end

@implementation GCNavigationControllerDelegate

-(id)init
{
    self = [super init];
    if(self)
    {
        NSLog(@"initializing %@", self);
    }
    return  self;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    switch (operation) {
        case UINavigationControllerOperationPush:
            self.transitioningObject.direction = FORWARD_ANIMATED_DIRECTION;
            break;
        case UINavigationControllerOperationPop:
            self.transitioningObject.direction = REVERSE_ANIMATED_DIRECTION;
            break;
        default:
            break;
    }
    
    return self.transitioningObject;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                        interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    // Only the detail page can have an interactive transition in this demo
    if(animationController == self.transitioningObject && self.transitioningObject.direction == REVERSE_ANIMATED_DIRECTION)
    {
        return self.interactivePinchTransitionObject;
    }
    
    return nil;
}

#pragma mark - Properties
-(GCControllerAnimatedTransitioningObject *)transitioningObject
{
    if(!_transitioningObject)
    {
        _transitioningObject = [[GCControllerAnimatedTransitioningObject alloc] init];
    }
    
    return _transitioningObject;
}

-(GCPinchInteractiveTransitionObject *)interactivePinchTransitionObject
{
    if(!_interactivePinchTransitionObject)
    {
        _interactivePinchTransitionObject = [[GCPinchInteractiveTransitionObject alloc] init];
    }
    
    return _interactivePinchTransitionObject;
}

@end
