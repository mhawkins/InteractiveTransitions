//
//  GCPinchInteractiveTransitionObject.h
//  InteractiveTransitions
//
//  Created by Matt Hawkins on 12/29/13.
//  Copyright (c) 2013 Matt Hawkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCPinchInteractiveTransitionObject : UIPercentDrivenInteractiveTransition

@property(nonatomic,assign) BOOL userInteraction;

-(void)attachToViewController:(UIViewController *)viewController;

@end
