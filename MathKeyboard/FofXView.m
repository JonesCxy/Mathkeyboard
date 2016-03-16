//
//  FofXView.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 13/07/15.
//
//

#import "math_constant.h"

//New file by siddhi infosoft

@implementation FofXView
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg andColor:(UIColor*)color
{
    LOG_FUNCTION_START
    self = [super init];
    if(self)
    {
        
        BOOL isIpad = NO;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            isIpad = YES;
        }
        self.delegate = delg;
        self.view = [[UIView alloc]init];
        
        [[NSBundle mainBundle] loadNibNamed:@"MixedNumberView" owner:self options:nil];
        
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, 100, viewFrame.size.height);  // change 140 to 100
        self.view.backgroundColor = [UIColor grayColor];
        
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, 20, self.view.frame.size.height)];
        lbl.text = @"f(";
        lbl.textColor =[UIColor blackColor];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = color;
        lbl.font = isIpad?math_font3:math_font3_iphone;
        [self.view addSubview:lbl];
        
        sideView = [[UIView alloc]initWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width+1, 0, 35, self.view.frame.size.height)];
        sideView.backgroundColor = [UIColor clearColor];
        sideView.accessibilityIdentifier = textField_container;
        [self.view addSubview:sideView];
        
        self.txt = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, sideView.frame.size.width, sideView.frame.size.height)];
        self.txt.delegate = self.delegate;
        self.txt.tag = 1;
        self.txt.text = @"x";
        self.txt.accessibilityIdentifier = textField_identifier;
        self.txt.accessibilityLabel = textField_custom_width;
        self.txt.borderStyle = UITextBorderStyleNone;
        self.txt.tintColor = tint_Color;
        self.txt.font = isIpad?math_font1:math_font1_iphone; 
        self.txt.textAlignment = NSTextAlignmentCenter;
        self.txt.textColor = color;
        [sideView addSubview:self.txt];
        
        
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(sideView.frame.origin.x+sideView.frame.size.width+1, 0, 8, self.view.frame.size.height)];
        lbl1.text = @")";
        lbl1.textColor =[UIColor blackColor];
        lbl1.textColor = color;
        lbl1.backgroundColor = [UIColor clearColor];
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.font = isIpad?math_font3:math_font3_iphone;
        [self.view addSubview:lbl1];
        
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, lbl1.frame.origin.x+lbl1.frame.size.width+2, self.view.frame.size.height);
    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate performSelector:@selector(textFieldSelected:) withObject:textField];
    return NO;
}
@end
