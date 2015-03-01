//
//  manualBoardViewController.h
//  Sudoku Design
//
//  Created by Feng Li on 2/15/15.
//  Copyright (c) 2015 Feng LI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cell.h"

@interface manualBoardViewController : UIViewController
{
    cell *cells[9][9];
    BOOL flag;
}

@property (weak, nonatomic) IBOutlet UIImageView *inputBG;
@property (weak, nonatomic) IBOutlet UIButton *btnValidate;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnShowSolution;

@property (assign) int EditX;
@property (assign) int EditY;

- (IBAction)validation:(id)sender;
- (IBAction)InputNum:(id)sender;

- (IBAction)reStart:(id)sender;
- (IBAction)goBack:(id)sender;

- (IBAction)showSolution:(id)sender;
@end
