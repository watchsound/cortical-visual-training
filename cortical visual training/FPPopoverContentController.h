//
//  FPPopoverContentController.h
//  r9
//
//  Created by Hanning Ni on 10/12/13.
//  Copyright (c) 2013 Hanning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FPPopoverContentControllerDelegate;

@interface FPPopoverContentController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray*  itemList;
    IBOutlet UITableView*  itemListTable;
    
    CGFloat rowWidth;
    CGFloat rowHeight;
    __unsafe_unretained id <FPPopoverContentControllerDelegate> tableSelectionDelegate;
}

@property (retain) NSMutableArray*  itemList;
@property (assign) id <FPPopoverContentControllerDelegate> tableSelectionDelegate;
@property (retain)  UITableView*  itemListTable;

@property (assign) CGFloat rowWidth;
@property (assign) CGFloat rowHeight;

-(void)loadTable;
-(void)setup:(NSMutableArray*)items;

@end

@protocol FPPopoverContentControllerDelegate
@required
- (void)rowSelected:(id)option ;
@end

