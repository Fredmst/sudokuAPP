//
//  manualBoardViewController.m
//  Sudoku Design
//
//  Created by Feng Li on 2/15/15.
//  Copyright (c) 2015 Feng LI. All rights reserved.
//

#define SQUAREWIDTH 375 //九宫图的宽高
#define CELLWIDTH_5 30//每个小格子的宽高 4/4s/5/5s
#define CELLWIDTH_6 36  //6
#define CELLWIDTH_6P 40  //6plus

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#import "manualBoardViewController.h"

@interface manualBoardViewController ()

@end

@implementation manualBoardViewController
@synthesize EditX;
@synthesize EditY;
@synthesize inputBG;
@synthesize btnValidate;
@synthesize btnBack;
@synthesize btnDelete;
@synthesize btnShowSolution;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    btnShowSolution.enabled=NO;
    // btnDelete.enabled=NO;
    EditX=-1;
    EditY=-1;
  /*  CGRect screenBound=[[UIScreen mainScreen]bounds];
    CGSize screenSize=screenBound.size;
    CGFloat screenWidth=screenSize.width*[[UIScreen mainScreen]scale];
    CGFloat screenHeight=screenSize.height*[[UIScreen mainScreen]scale];
    NSLog(@"%d,times, %d",screenWidth,screenHeight);
  */  
   
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
-(void)viewDidAppear:(BOOL)animated
{
    for (int i=0;i<9; i++)
    {
        for (int j=0; j<9; j++)
        {
            //4/4s
            if (IS_IPHONE_4_OR_LESS) {
                cells[i][j] = [[cell alloc]initWithFrame:CGRectMake(20+(CELLWIDTH_5+2)*i+1*(i/3),65+j*(CELLWIDTH_5)+(j/3)*1,CELLWIDTH_5,CELLWIDTH_5)];
            }
            //5/5s
            else if (IS_IPHONE_5)
            {
                cells[i][j] = [[cell alloc]initWithFrame:CGRectMake(20+(CELLWIDTH_5+2)*i+1*(i/3),75+j*(CELLWIDTH_5+7)+(j/3)*8,CELLWIDTH_5,CELLWIDTH_5+6)];
            }
            //6
            else if (IS_IPHONE_6)
            {
                cells[i][j] = [[cell alloc]initWithFrame:CGRectMake(20+(CELLWIDTH_6+2)*i+1*(i/3),82+j*(CELLWIDTH_6+12)+(j/3)*6,CELLWIDTH_6,CELLWIDTH_6+9)];
            }
            //6plus
            else if (IS_IPHONE_6P)
            {
                cells[i][j] = [[cell alloc]initWithFrame:CGRectMake(23+(CELLWIDTH_6P+1)*i+2*(i/3),90+j*(CELLWIDTH_6P+16)+(j/3)*2,CELLWIDTH_6P,CELLWIDTH_6P+9)];
            }
            else
            {
                UIAlertView *msgAlert=[[UIAlertView alloc] initWithTitle:@"Your device is not supported!" message:@"There may be some displaying problem! Sorry about that" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [msgAlert show];
                cells[i][j] = [[cell alloc]initWithFrame:CGRectMake(23+(CELLWIDTH_6P+1)*i+2*(i/3),90+j*(CELLWIDTH_6P+16)+(j/3)*2,CELLWIDTH_6P,CELLWIDTH_6P+9)];
            }
            cells[i][j].x = i;
            cells[i][j].y = j;
            cells[i][j].isBlank=YES;
            cells[i][j].userValue=0;
            
            [cells[i][j] setTitle:[NSString stringWithFormat:@" "] forState: UIControlStateNormal];

            [cells[i][j] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cells[i][j] addTarget:self action:@selector(CellButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:cells[i][j]];
        }
    }
}
-(void)CellButtonTouchUpInside:(id)sender
{
    if ([(cell *)sender isBlank]==YES)
    {
        if (EditX!=-1 && EditY!=-1) {
            [cells[EditX][EditY] setBackgroundColor:[UIColor clearColor]];
        }
        EditX = ((cell*)sender).x;
        EditY = ((cell*)sender).y;
        [cells[EditX][EditY] setBackgroundColor:[UIColor colorWithRed:(float)(216.0/255.0) green:(float)(234.0/255.0) blue:(float)(255.0/255.0) alpha:1.0]];
        return;
    }
}

- (IBAction)validation:(id)sender {
    // validation=[[ValidationAndSolution alloc]init];
    if ([self checkEmpty] && [self isValidBoard]) {
        if ([self validate]) {
            flag=true;
            btnShowSolution.enabled=YES;
            
            UIAlertView *msgAlert=[[UIAlertView alloc] initWithTitle:@"Good!" message:@"It's a valid Sudoku! You can continue to work on it!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [msgAlert show];
        }
        else
        {
            UIAlertView *errAlert=[[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"It's NOT a valid Sudoku which violates the sudoku rules. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errAlert show];
            
        }
    }
    else
    {
        UIAlertView *emptyAlert=[[UIAlertView alloc] initWithTitle:@"Error Detected!" message:@"The grid is empty or the board violates the sudoku rules!." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emptyAlert show];
    }
}
-(BOOL)checkEmpty
{
    for (int i=0;i<9; i++)
    {
        for (int j=0; j<9; j++)
        {
            if (cells[i][j].userValue!=0) {
                return true;
            }
        }
    }
    return false;
}

- (IBAction)showSolution:(id)sender {
    if ([self checkEmpty]) {
        if (flag==true || [self validate]) {
            [self paint];
            btnValidate.enabled=NO;
            btnBack.enabled=YES;
            btnDelete.enabled=NO;
            btnShowSolution.enabled=NO;
        }
    }
    
}

-(void)paint
{
    for (int i=0;i<9; i++)
    {
        for (int j=0; j<9; j++)
        {
            
            cells[i][j].isBlank=NO;
            [cells[i][j] setTitle:[NSString stringWithFormat:@"%i",cells[i][j].value] forState: UIControlStateNormal];
            [cells[i][j] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cells[i][j] addTarget:self action:@selector(CellButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:cells[i][j]];
        }
    }
    
}

- (IBAction)reStart:(id)sender {
    for (int i=0;i<9; i++)
    {
        for (int j=0; j<9; j++)
        {
            cells[i][j].isBlank=YES;
            cells[i][j].value=0;
            cells[i][j].userValue=0;
            
            [cells[i][j] setTitle:[NSString stringWithFormat:@" "] forState:UIControlStateNormal];
            [cells[i][j] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cells[i][j] addTarget:self action:@selector(CellButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:cells[i][j]];
        }
    }
    btnDelete.enabled=YES;
    btnValidate.enabled=YES;
}

- (IBAction)goBack:(id)sender {
    for (int i=0;i<9; i++)
    {
        for (int j=0; j<9; j++)
        {
            cells[i][j].isBlank=YES;
            cells[i][j].value=cells[i][j].userValue;
            if (cells[i][j].userValue==0)
            {
                [cells[i][j] setTitle:[NSString stringWithFormat:@" "] forState:UIControlStateNormal];
            }
            else
            {
                [cells[i][j] setTitle:[NSString stringWithFormat:@"%d",cells[i][j].userValue] forState:UIControlStateNormal];
            }
            
            [cells[i][j] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cells[i][j] addTarget:self action:@selector(CellButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:cells[i][j]];
        }
    }
    btnShowSolution.enabled=NO;
    btnBack.enabled=NO;
    btnValidate.enabled=YES;
    btnBack.enabled=YES;
    btnDelete.enabled=YES;
}
//put value in the cell
- (IBAction)InputNum:(id)sender {
    
    int num=((UIButton *)sender).tag;
    if (EditX==-1 && EditY==-1)
    {
        return;
    }
    cells[EditX][EditY].userValue=num;
    cells[EditX][EditY].value=num;
    cells[EditX][EditY].titleLabel.font=[UIFont systemFontOfSize:19];
    if (num==0)
    {
        [cells[EditX][EditY] setTitle:[NSString stringWithFormat:@" "] forState:UIControlStateNormal];
    }
    else
    {
        [cells[EditX][EditY] setTitle:[NSString stringWithFormat:@"%d",cells[EditX][EditY].userValue] forState:UIControlStateNormal];
    }
    [cells[EditX][EditY] setBackgroundColor:[UIColor clearColor]];
    [cells[EditX][EditY] setTitleColor:[UIColor colorWithRed:(float)(23.0/255.0) green:(float)(106.0/255.0) blue:(float)(165.0/255.0) alpha:1.0] forState:UIControlStateNormal];
    //cells[EditX][EditY].isBlank=NO;
    //btnDelete.enabled=YES;
}

-(BOOL)isValidX:(int)x Y:(int)y
{
    int temp=cells[x][y].value;
    cells[x][y].value=0;
    for (int i=0;i<9;i++)
    {
        if (cells[i][y].value==temp) {
            return false;
        }
    }
    for (int j=0; j<9; j++) {
        if (cells[x][j].value==temp) {
            return false;
        }
    }
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            if (cells[(x/3)*3+i][(y/3)*3+j].value==temp) {
                return false;
            }
        }
    }
    cells[x][y].value=temp;
    return true;
}
-(BOOL)isValid2X:(int)x Y:(int)y
{
    int temp=cells[x][y].userValue;
    cells[x][y].userValue=0;
    for (int i=0;i<9;i++)
    {
        if (cells[i][y].userValue==temp) {
            return false;
        }
    }
    for (int j=0; j<9; j++) {
        if (cells[x][j].userValue==temp) {
            return false;
        }
    }
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            if (cells[(x/3)*3+i][(y/3)*3+j].userValue==temp) {
                return false;
            }
        }
    }
    cells[x][y].userValue=temp;
    return true;
}
-(BOOL)isValidBoard
{
    for(int i=0;i<9;i++)
    {
        for(int j=0;j<9;j++)
        {
            if (cells[i][j].userValue!=0)
            {
                if (![self isValid2X:i Y:j])
                {
                    return false;
                }
                
            }
        }
    }
    return true;
}

-(BOOL)validate
{
    for(int i=0;i<9;i++)
    {
        for(int j=0;j<9;j++)
        {
            //int temp=cells[i][j].value;
            
            if (cells[i][j].value==0)
            {
                for (int k=1;k<10;k++)
                {
                    cells[i][j].value=k;
                    if ([self isValidX:i Y:j]){
                        if ([self validate]) {
                            return true;
                        }
                    }
                    cells[i][j].value=0;
                    
                }
                return false;
            }
            else
            {
                if (![self isValidX:i Y:j])
                {
                    return false;
                }
                
            }
        }
    }
    return true;
}
@end
