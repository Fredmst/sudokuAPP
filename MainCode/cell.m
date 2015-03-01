//
//  cell.m
//  Sudoku Design
//
//  Created by Feng Li on 2/15/15.
//  Copyright (c) 2015 Feng LI. All rights reserved.
//

#import "cell.h"

@implementation cell
@synthesize x;
@synthesize y;
@synthesize value;
@synthesize userValue;
@synthesize isBlank;

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        x=0;
        y=0;
        value=0;
        userValue=0;
        isBlank=YES;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
