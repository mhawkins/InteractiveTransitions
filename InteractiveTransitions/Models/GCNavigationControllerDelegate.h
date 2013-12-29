//
//  GCNavigationControllerDelegate.h
//  InteractiveTransitions
//
//  Created by Matt Hawkins on 12/15/13.
//  Copyright (c) 2013 Matt Hawkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCPinchInteractiveTransitionObject.h"

@interface GCNavigationControllerDelegate : NSObject<UINavigationControllerDelegate>

@property(readonly,nonatomic,strong) GCPinchInteractiveTransitionObject *interactivePinchTransitionObject;

@end
