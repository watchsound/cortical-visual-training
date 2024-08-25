//
//  FPPopoverTipsViewController.h
//  r9
//
//  Created by Hanning Ni on 9/25/15.
//  Copyright (c) 2015 Hanning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverContentController.h"

@interface FPPopoverTipsViewController : UIViewController{
    NSString* tips;
    NSString* tipsId;
    __unsafe_unretained id <FPPopoverContentControllerDelegate> tableSelectionDelegate;
}

@property (retain) NSString* tips;
@property (retain) NSString* tipsId;

@property (assign) id <FPPopoverContentControllerDelegate> tableSelectionDelegate;

@end
