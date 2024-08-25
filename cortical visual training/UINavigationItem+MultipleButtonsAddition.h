//
//  UINavigationItem+MultipleButtonsAddition.h
//  ChocVR
//
//  Created by Hanning Ni on 11/2/15.
//  Copyright (c) 2015 ChocVR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (MultipleButtonsAddition)


@property (nonatomic, strong) IBOutletCollection(UIBarButtonItem) NSArray* rightBarButtonItemsCollection;
@property (nonatomic, strong) IBOutletCollection(UIBarButtonItem) NSArray* leftBarButtonItemsCollection;


@end
