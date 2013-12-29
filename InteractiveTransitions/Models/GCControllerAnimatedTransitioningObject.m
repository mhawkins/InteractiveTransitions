//
//  GCControllerAnimatedTransitioningObject.m
//  InteractiveTransitions
//
//  Created by Matt Hawkins on 12/15/13.
//  Copyright (c) 2013 Matt Hawkins. All rights reserved.
//

#import "GCControllerAnimatedTransitioningObject.h"
#import <QuartzCore/QuartzCore.h>

static const NSString * GCLeftImageKey = @"com.greatcoding.leftimagekey";
static const NSString * GCRightImageKey = @"com.greatcoding.rightimagekey";
static const NSTimeInterval FORWARD_ANIMATION_DURATION = 1.0;
static const NSTimeInterval REVERSE_ANIMATION_DURATION = 0.8;
static const CGFloat SCALE_OUT_PERCENTAGE = 0.95;
static const CGFloat FADE_OUT_PERCENTAGE = 0.70;

@interface GCControllerAnimatedTransitioningObject()

@property(nonatomic,copy) NSString *cachedImagesPath;

@end

@implementation GCControllerAnimatedTransitioningObject

-(id)init
{
    self = [super init];
    if(self)
    {
        // Get our library path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryPath = [paths lastObject];
        self.cachedImagesPath = [libraryPath stringByAppendingPathComponent:@"com.greatcoding.gcanimatedtransitionscache"];
        
        // Create the directory if it doesn't exist
        BOOL isDirectory = YES;
        if(![[NSFileManager defaultManager] fileExistsAtPath:self.cachedImagesPath isDirectory:&isDirectory])
        {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:self.cachedImagesPath withIntermediateDirectories:YES attributes:nil error:&error];
            
            if(error)
                NSLog(@"Error creating cached images directory - %@", error.localizedDescription);
        }
    }
    
    return self;
}

-(void)dealloc
{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.cachedImagesPath error:&error];
    
    if(error)
        NSLog(@"Error deleting cached images directory - %@", error.localizedDescription);
}

#pragma mark - UIViewControllerAnimatedTransitioning Methods
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.direction) {
        case REVERSE_ANIMATED_DIRECTION:
            return REVERSE_ANIMATION_DURATION;
            break;
        default:
            return FORWARD_ANIMATION_DURATION;
            break;
    }
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // Get the view we're moving and their container
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // Create a transform for the view that will be moved offscreen with a push or put back on screen with a pop
    CGAffineTransform transform = CGAffineTransformMakeScale(SCALE_OUT_PERCENTAGE, SCALE_OUT_PERCENTAGE);
    
    // Determine which controller to render
    UIViewController *splittableController = nil;
    NSDictionary *imagesDictionary = nil;
    if(self.direction == REVERSE_ANIMATED_DIRECTION)
    {
        splittableController = toController;
        imagesDictionary = [self cachedImagesForViewController:splittableController];
    }
    else
    {
        splittableController = fromController;
        imagesDictionary = [self imagesForViewController:splittableController];
    }
        
    // Get our metrics from the toView
    CGFloat width = CGRectGetWidth(splittableController.view.bounds);
    CGFloat halfWidth = width/2;
    CGFloat height = CGRectGetHeight(splittableController.view.bounds);

    // Get the left image
    UIImage *leftImage = imagesDictionary[GCLeftImageKey];
    
    // Generate a left image view
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:leftImage];
    leftImageView.frame = CGRectMake(0, 0, halfWidth, height);
    leftImageView.layer.shadowOffset = CGSizeMake(2, 0);
    leftImageView.layer.masksToBounds = NO;
    leftImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:leftImageView.layer.bounds].CGPath;
    leftImageView.layer.shadowRadius = 10;
    leftImageView.layer.shadowOpacity = 0.4;
    
    // Get the right image
    UIImage *rightImage = imagesDictionary[GCRightImageKey];
    
    // Get a right image view
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:rightImage];
    rightImageView.frame = CGRectMake(halfWidth, 0, halfWidth, height);
    rightImageView.layer.shadowOffset = CGSizeMake(-2, 0);
    rightImageView.layer.shadowOffset = CGSizeMake(2, 0);
    rightImageView.layer.masksToBounds = NO;
    rightImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:leftImageView.layer.bounds].CGPath;
    rightImageView.layer.shadowRadius = 10;
    rightImageView.layer.shadowOpacity = 0.4;

    // Handle reverse / pop
    if(self.direction == REVERSE_ANIMATED_DIRECTION)
    {
        // Add the to controller to the view hiearchy and hide it
        [containerView insertSubview:toController.view aboveSubview:fromController.view];
        toController.view.alpha = 0.0f;
        
        // Add the left and right image views
        [containerView addSubview:leftImageView];
        leftImageView.transform = CGAffineTransformMakeTranslation(-halfWidth, 0);
        [containerView addSubview:rightImageView];
        rightImageView.transform = CGAffineTransformMakeTranslation(halfWidth, 0);
        
        // Move the two halves back in
        [UIView animateWithDuration:REVERSE_ANIMATION_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             fromController.view.transform = transform;
                             fromController.view.alpha = FADE_OUT_PERCENTAGE;
                             leftImageView.transform = CGAffineTransformIdentity;
                             rightImageView.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             // Remove our left/right shutter views
                             [leftImageView removeFromSuperview];
                             [rightImageView removeFromSuperview];

                             
                             if([transitionContext transitionWasCancelled])
                             {
                                 [transitionContext completeTransition:NO];
                             }
                             else
                             {
                                 // Make our to controller visible
                                 toController.view.alpha = 1.0;
                             
                                 // Remove from view controller from view hierarchy
                                 [fromController.view removeFromSuperview];
                                 
                                 [transitionContext completeTransition:YES];
                             }

                         }
         ];
    }
    else
    {
        // Insert the view behind the current one
        [containerView insertSubview:toController.view belowSubview:fromController.view];
        toController.view.transform = transform;
        toController.view.alpha = FADE_OUT_PERCENTAGE;
        
        // Add the left and right image views
        [containerView addSubview:leftImageView];
        [containerView addSubview:rightImageView];
        
        // Make our from controller transparent
        fromController.view.alpha = 0.0;
        
        // Animate the transition
        [UIView animateWithDuration:FORWARD_ANIMATION_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toController.view.alpha = 1;
                             toController.view.transform = CGAffineTransformIdentity;
                             leftImageView.transform = CGAffineTransformMakeTranslation(-halfWidth, 0);
                             rightImageView.transform = CGAffineTransformMakeTranslation(halfWidth, 0);
                         }
                         completion:^(BOOL finished) {
                             // Remove our left/right shutter views
                             [leftImageView removeFromSuperview];
                             [rightImageView removeFromSuperview];
                             
                             fromController.view.alpha = 1.0;

                             // Complete the transition
                             [transitionContext completeTransition:YES];
                         }
         ];
    }
}

-(NSDictionary *)imagesForViewController:(UIViewController *)viewController
{
    // Create a graphics context for our image
    UIGraphicsBeginImageContext(viewController.view.bounds.size);
    [viewController.view drawViewHierarchyInRect:viewController.view.frame afterScreenUpdates:NO];
    
    // Get the image from the current context
    UIImage *splittableControllerImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End our context
    UIGraphicsEndImageContext();
    
    // Split the image
    CGImageRef splittableControllerImageRef = CGImageRetain(splittableControllerImage.CGImage);
    
    // Get our metrics from the toView
    CGFloat width = CGRectGetWidth(viewController.view.bounds);
    CGFloat halfWidth = width/2;
    CGFloat height = CGRectGetHeight(viewController.view.bounds);
    
    // Get the left image
    CGImageRef leftImageRef = CGImageCreateWithImageInRect(splittableControllerImageRef, CGRectMake(0, 0, halfWidth, height));
    UIImage *leftImage = [[UIImage alloc] initWithCGImage:leftImageRef];
    
    // Generate a left image
    NSString *leftImagePath = [self.cachedImagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%i-left.png", viewController.hash]];
    [UIImagePNGRepresentation(leftImage) writeToFile:leftImagePath atomically:YES];
    
    // Get the right image
    CGImageRef rightImageRef = CGImageCreateWithImageInRect(splittableControllerImageRef, CGRectMake(halfWidth, 0, halfWidth, height));
    UIImage *rightImage = [[UIImage alloc] initWithCGImage:rightImageRef];
    
    // Generate a left image
    NSString *rightImagePath = [self.cachedImagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%i-right.png", viewController.hash]];
    [UIImagePNGRepresentation(rightImage) writeToFile:rightImagePath atomically:YES];
    
    // Cleanup core graphics
    CGImageRelease(leftImageRef);
    CGImageRelease(rightImageRef);
    CGImageRelease(splittableControllerImageRef);
    
    return @{GCLeftImageKey : leftImage, GCRightImageKey : rightImage};
}

-(NSDictionary *)cachedImagesForViewController:(UIViewController *)viewController
{
    // Restore the left image
    NSString *leftImagePath = [self.cachedImagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%i-left.png", viewController.hash]];
    UIImage *leftImage = [UIImage imageWithContentsOfFile:leftImagePath];
 
    // Restore the right image
    NSString *rightImagePath = [self.cachedImagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%i-right.png", viewController.hash]];
    UIImage *rightImage = [UIImage imageWithContentsOfFile:rightImagePath];
    
    return @{GCLeftImageKey : leftImage, GCRightImageKey : rightImage};
}


@end
