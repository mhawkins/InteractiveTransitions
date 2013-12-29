//
//  UIViewController+GCInteractiveNavigationHelpers.h
//  InteractiveTransitions
//
//  Created by Matt Hawkins on 12/29/13.
//  Copyright (c) 2013 Matt Hawkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPinchInteractiveTransitionObject.h"
#import "GCNavigationControllerDelegate.h"

@interface UIViewController (GCInteractiveNavigationHelpers)

-(void)gc_wireUpTransitionObject;

@end
