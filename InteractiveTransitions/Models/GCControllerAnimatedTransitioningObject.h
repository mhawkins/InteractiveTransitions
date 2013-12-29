//
//  GCControllerAnimatedTransitioningObject.h
//  InteractiveTransitions
//
//  Created by Matt Hawkins on 12/15/13.
//  Copyright (c) 2013 Matt Hawkins. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GCControllerAnimatedTransitioningObjectDirection) {
    FORWARD_ANIMATED_DIRECTION = 0,
    REVERSE_ANIMATED_DIRECTION = 1
};

@interface GCControllerAnimatedTransitioningObject : NSObject<UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign) GCControllerAnimatedTransitioningObjectDirection direction;

@end
