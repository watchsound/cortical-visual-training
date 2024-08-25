//
//  UINavigationItem+MultipleButtonsAddition.m
//  ChocVR
//
//  Created by Hanning Ni on 11/2/15.
//  Copyright (c) 2015 ChocVR. All rights reserved.
//

#import "UINavigationItem+MultipleButtonsAddition.h"

@implementation UINavigationItem (MultipleButtonsAddition)


- (void) setRightBarButtonItemsCollection:(NSArray *)rightBarButtonItemsCollection {
    self.rightBarButtonItems = [rightBarButtonItemsCollection sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

- (void) setLeftBarButtonItemsCollection:(NSArray *)leftBarButtonItemsCollection {
    self.leftBarButtonItems = [leftBarButtonItemsCollection sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

- (NSArray*) rightBarButtonItemsCollection {
    return self.rightBarButtonItems;
}

- (NSArray*) leftBarButtonItemsCollection {
    return self.leftBarButtonItems;
}


@end
