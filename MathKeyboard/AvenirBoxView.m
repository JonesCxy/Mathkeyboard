//
//  AvenirBoxView.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 14/07/15.
//
//

#import "math_constant.h"
//New file by siddhi infosoft
@implementation AvenirBoxView
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
        
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, 160, viewFrame.size.height);  // change 140 to 100
        self.view.backgroundColor = [UIColor grayColor];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(1, 5, 16, self.view.frame.size.height-10)];
        lbl.text = [NSString stringWithFormat:@"%@",avenir_ascii];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor =[UIColor blackColor];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.font = [UIFont systemFontOfSize:36.0f];
        lbl.textColor = color;
        [self.view addSubview:lbl];
        
        
        sideView1 = [[UIView alloc]initWithFrame:CGRectMake(23, 2, 20, 20)];
        sideView1.backgroundColor = [UIColor clearColor];
        sideView1.accessibilityIdentifier = textField_container;
        [self.view addSubview:sideView1];
        
        self.txt1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, sideView1.frame.size.width, sideView1.frame.size.height)];
        self.txt1.delegate = self.delegate;
        self.txt1.tag = 2;
        self.txt1.accessibilityIdentifier = textField_identifier;
        self.txt1.borderStyle = UITextBorderStyleNone;
        self.txt1.tintColor = tint_Color;
        self.txt1.font = isIpad?math_script_font:math_script_font_iphone;
        self.txt1.textAlignment = NSTextAlignmentLeft;
        self.txt1.textColor = color;
        [sideView1 addSubview:self.txt1];
        
        
        sideView2 = [[UIView alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height-23, 20, 20)];
        sideView2.backgroundColor = [UIColor clearColor];
        sideView2.accessibilityIdentifier = textField_container;
        [self.view addSubview:sideView2];
        
        self.txt = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, sideView2.frame.size.width, sideView2.frame.size.height)];
        self.txt.delegate = self.delegate;
        self.txt.tag = 1;
        self.txt.accessibilityIdentifier = textField_identifier;
        self.txt.borderStyle = UITextBorderStyleNone;
        self.txt.tintColor = tint_Color;
        self.txt.font = isIpad?math_script_font:math_script_font_iphone;
        self.txt.textAlignment = NSTextAlignmentLeft;
        self.txt.textColor = color;
        [sideView2 addSubview:self.txt];
        

        
        
        sideView = [[UIView alloc]initWithFrame:CGRectMake(52, self.view.frame.size.height/2, 35, self.view.frame.size.height/2)];
        sideView.backgroundColor = [UIColor clearColor];
        sideView.accessibilityIdentifier = textField_container;
        sideView.center = CGPointMake(sideView.center.x, self.view.center.y+5);
        [self.view addSubview:sideView];
        
        self.txt2 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, sideView.frame.size.width, sideView.frame.size.height)];
        self.txt2.delegate = self.delegate;
        self.txt2.tag = 3;
        self.txt2.accessibilityIdentifier = textField_identifier;
        self.txt2.borderStyle = UITextBorderStyleNone;
        self.txt2.tintColor = tint_Color;
        self.txt2.font = isIpad?math_font1:math_font1_iphone; 
        self.txt2.textAlignment = NSTextAlignmentLeft;
        [sideView addSubview:self.txt2];
        
        
        upview = [[UIView alloc]initWithFrame:CGRectMake(111, (self.view.frame.size.height/2), 35, self.view.frame.size.height/2)];
        upview.accessibilityIdentifier = textField_container;
        upview.backgroundColor = [UIColor clearColor];
        upview.center = CGPointMake(upview.center.x, self.view.center.y+5);
        [self.view addSubview:upview];
        
        self.txt3 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, upview.frame.size.width, upview.frame.size.height)];
        self.txt3.delegate = self.delegate;
        self.txt3.tag = 4;
        self.txt3.borderStyle = UITextBorderStyleNone;
        self.txt3.tintColor = tint_Color;
        self.txt3.accessibilityIdentifier = textField_identifier;
        self.txt3.font = isIpad?math_font1:math_font1_iphone; // [UIFont fontWithName:math_font_name size:math_font_size];
        self.txt3.textAlignment = NSTextAlignmentLeft;
        [upview addSubview:self.txt3];
        
        UILabel *lbl_arrow = [[UILabel alloc]initWithFrame:CGRectMake(sideView.frame.origin.x+sideView.frame.size.width+1, 10, upview.frame.origin.x-(sideView.frame.origin.x+sideView.frame.size.width+1)-1, self.view.frame.size.height/2)];
        lbl_arrow.text = @"d";
        lbl_arrow.center = CGPointMake(lbl_arrow.center.x, self.view.center.y+5);
        lbl_arrow.textAlignment = NSTextAlignmentCenter;
        lbl_arrow.textColor =[UIColor blackColor];
        lbl_arrow.backgroundColor = [UIColor clearColor];
        lbl_arrow.textColor = color;
        lbl_arrow.font = isIpad?math_font3:math_font3_iphone;
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
