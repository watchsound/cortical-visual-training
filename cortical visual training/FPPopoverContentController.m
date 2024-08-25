//
//  FPPopoverContentController.m
//  r9
//
//  Created by Hanning Ni on 10/12/13.
//  Copyright (c) 2013 Hanning. All rights reserved.
//

#import "FPPopoverContentController.h"
#import "Option.h" 

@interface FPPopoverContentController ()

@end

@implementation FPPopoverContentController

@synthesize itemList;
@synthesize tableSelectionDelegate;
@synthesize itemListTable;
@synthesize rowWidth;
@synthesize rowHeight;

const CGFloat ROW_HEIGHT = 50;
const CGFloat MAX_TABLE_HEIGHT = 350;
const CGFloat ROW_WIDTH = 220;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rowWidth = ROW_WIDTH;
        rowHeight = ROW_HEIGHT;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup:(NSMutableArray*)items{
    self.itemList = items;
    CGFloat height = rowHeight * [itemList count];
    if ( height > MAX_TABLE_HEIGHT )
        height = MAX_TABLE_HEIGHT;
    self.view.frame = CGRectMake( self.view.frame.origin.x, self.view.frame.origin.y, rowWidth, height);
}

-(void)loadTable{
    [itemListTable reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return itemList == nil ? 0 : [itemList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ROW_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSObject* row  = (NSObject*)[itemList objectAtIndex:indexPath.row];
    cell.textLabel.text = [row description];
    cell.textLabel.adjustsFontSizeToFitWidth = TRUE;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    if ( [row class] == [Option class]){
        Option* o = (Option*)row;
        cell.textLabel.text = o.description;
        cell.imageView.image = o.image;
//        
//        menuCell.icon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
//        menuCell.icon.text = [NSString fontAwesomeIconStringForEnum:menuItem.image];
//        
        
    }
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableSelectionDelegate ){
        id row =  [itemList objectAtIndex:indexPath.row];
        [tableSelectionDelegate rowSelected:row];
    }
}



@end

