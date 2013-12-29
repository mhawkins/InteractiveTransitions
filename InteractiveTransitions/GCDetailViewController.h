//
//  GCDetailViewController.h
//  InteractiveTransitions
//
//  Created by Matt Hawkins on 12/15/13.
//  Copyright (c) 2013 Matt Hawkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
