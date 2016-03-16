//
//  PermutationOrCombinationView.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 14/07/15.
//
//

#import "math_constant.h"

@implementation PermutationOrCombinationView
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg permOrComb:(int)permOrComb andColor:(UIColor*)color
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
        
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, 160, viewFrame.size.height);  // change 140 to 100
        self.view.backgroundColor = [UIColor grayColor];
        
        
        
        sideView = [[UIView alloc]initWithFrame:CGRectMake(2, self.view.frame.size.height/2, 35, self.view.frame.size.height/2)];
        sideView.backgroundColor = [UIColor clearColor];
        sideView.accessibilityIdentifier = textField_container;
        [self.view addSubview:sideView];
        
        self.txt = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, sideView.frame.size.width, sideView.frame.size.height)];
        self.txt.delegate = self.delegate;
        self.txt.tag = 1;
        self.txt.accessibilityIdentifier = textField_identifier;
        self.txt.borderStyle = UITextBorderStyleNone;
        self.txt.tintColor = tint_Color;
        self.txt.font = isIpad?math_script_font:math_script_font_iphone;
        self.txt.textAlignment = NSTextAlignmentRight;
        self.txt.textColor = color;
        [sideView addSubview:self.txt];
        
        
        upview = [[UIView alloc]initWithFrame:CGRectMake(62, self.view.frame.size.height/2, 35, self.view.frame.size.height/2)];
        upview.accessibilityIdentifier = textField_container;
        upview.backgroundColor = [UIColor clearColor];
        [self.view addSubview:upview];
        
        self.txt1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, upview.frame.size.width, upview.frame.size.height)];
        self.txt1.delegate = self.delegate;
        self.txt1.tag = 2;
        self.txt1.borderStyle = UITextBorderStyleNone;
        self.txt1.tintColor = tint_Color;
        self.txt1.accessibilityIdentifier = textField_identifier;
        self.txt1.font = isIpad?math_script_font:math_script_font_iphone; // [UIFont fontWithName:math_font_name size:math_font_size];
        self.txt1.textAlignment = NSTextAlignmentLeft;
        self.txt1.textColor = color;
        [upview addSubview:self.txt1];
        
        UILabel *lbl_arrow = [[UILabel alloc]initWithFrame:CGRectMake(sideView.frame.origin.x+sideView.frame.size.width+1, 10, upview.frame.origin.x-(sideView.frame.origin.x+sideView.frame.size.width+1)-1, self.view.frame.size.height/2)];
        self.view.accessibilityHint = [NSString stringWithFormat:@"%d",permOrComb];
        switch (permOrComb)
        {
            case permutation:
            {
                lbl_arrow.text = @"P";
                break;
            }
            case combination:
            {
                lbl_arrow.text = @"C";
                break;
            }
            default:
                break;
        }
        lbl_arrow.textAlignment = NSTextAlignmentCenter;
        lbl_arrow.textColor =[UIColor blackColor];
        lbl_arrow.backgroundColor = [UIColor clearColor];
        lbl_arrow.font = isIpad?math_font3:math_font3_iphone;
        lbl_arrow.textColor = color;
        [self.view addSubview:lbl_arrow];
        
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, upview.frame.origin.x+upview.frame.size.width+2, self.view.frame.size.height);
    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate performSelector:@selector(textFieldSelected:) withObject:textField];
    return NO;
}
@end
