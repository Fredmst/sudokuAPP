//
//  cell.h
//  Sudoku Design
//
//  Created by Feng Li on 2/15/15.
//  Copyright (c) 2015 Feng LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cell : UIButton
{
    int x;
    int y;
    int value;
    int userValue;
    BOOL isBlank;
    
}
@property(assign) int x;
@property(assign) int y;
@property(assign) int value;
@property(assign) int userValue;
@property(assign) BOOL isBlank;

@end
