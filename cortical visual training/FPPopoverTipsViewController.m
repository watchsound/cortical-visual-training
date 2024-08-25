//
//  FPPopoverTipsViewController.m
//  r9
//
//  Created by Hanning Ni on 9/25/15.
//  Copyright (c) 2015 Hanning. All rights reserved.
//

#import "FPPopoverTipsViewController.h" 

@interface FPPopoverTipsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

- (IBAction)dismissButtonClicked:(id)sender;
@end



@implementation FPPopoverTipsViewController

@synthesize tips;
@synthesize  tipsId;
@synthesize tableSelectionDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tipContentLabel.text = self.tips;
    self.dismissButton.titleLabel.text = @"取消";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismissButtonClicked:(id)sender {
    if( self.tableSelectionDelegate ){
      [self.tableSelectionDelegate rowSelected:nil];
    }
}
@end
