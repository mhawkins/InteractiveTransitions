//
//  UIViewController+GCInteractiveNavigationHelpers.m
//  InteractiveTransitions
//
//  Created by Matt Hawkins on 12/29/13.
//  Copyright (c) 2013 Matt Hawkins. All rights reserved.
//

#import "UIViewController+GCInteractiveNavigationHelpers.h"


@implementation UIViewController (GCInteractiveNavigationHelpers)

-(void)gc_wireUpTransitionObject
{

    // If the delegate is our custom delegate
    if(self.navigationController.delegate && [self.navigationController.delegate isKindOfClass:[GCNavigationControllerDelegate class]])
    {
        // Cast it
        GCNavigationControllerDelegate *navControllerDelegate = (GCNavigationControllerDelegate *)self.navigationController.delegate;
        
        // Get the pinch transition object and wire up the current view controller
        GCPinchInteractiveTransitionObject *pinchTransition = navControllerDelegate.interactivePinchTransitionObject;
        [pinchTransition attachToViewController:self];

    }
    
    
}

@end
