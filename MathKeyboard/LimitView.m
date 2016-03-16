//
//  LimitView.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 13/07/15.
//
//


#import "math_constant.h"
//New file by siddhi infosoft

#define part 2

@implementation LimitView
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
        
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y+5, 160, viewFrame.size.height-(5*2));  // change 140 to 100
        self.view.backgroundColor = [UIColor grayColor];
        
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, 75, (self.view.frame.size.height/2)-4)];
        lbl.text = @"lim";
        lbl.textColor =[UIColor blackColor];
        lbl.textColor = color;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = isIpad?math_font3:math_font3_iphone;
        [self.view addSubview:lbl];
        
        sideView = [[UIView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2, 30, self.view.frame.size.height/2)];
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
        self.txt.textAlignment = NSTextAlignmentCenter;
        self.txt.textColor = color;
        [sideView addSubview:self.txt];
        
        
        upview = [[UIView alloc]initWithFrame:CGRectMake(54, self.view.frame.size.height/2, 30, self.view.frame.size.height/2)];
        upview.accessibilityIdentifier = textField_container;
        upview.backgroundColor = [UIColor clearColor];
        [self.view addSubview:upview];
        
        self.txt1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, upview.frame.size.width, upview.frame.size.height)];
        self.txt1.delegate = self.delegate;
        self.txt1.tag = 2;
        self.txt1.borderStyle = UITextBorderStyleNone;
        self.txt1.tintColor = tint_Color;
        self.txt1.accessibilityIdentifier = textField_identifier;
        self.txt1.font = isIpad?math_script_font:math_script_font_iphone;
        self.txt1.textAlignment = NSTextAlignmentCenter;
        self.txt1.textColor = color;
        [upview addSubview:self.txt1];
        
        UILabel *lbl_arrow = [[UILabel alloc]initWithFrame:CGRectMake(sideView.frame.origin.x+sideView.frame.size.width, self.view.frame.size.height/2, upview.frame.origin.x-(sideView.frame.origin.x+sideView.frame.size.width), self.view.frame.size.height/2)];
        lbl_arrow.text = rightArrow_ascii; //@"-->";//TODO:31-7-2015
        lbl_arrow.textAlignment = NSTextAlignmentCenter;
        lbl_arrow.textColor =[UIColor blackColor];
        lbl_arrow.backgroundColor = [UIColor clearColor];
        lbl_arrow.font = [UIFont systemFontOfSize:15.0f];
        lbl_arrow.textColor = color;
        [self.view addSubview:lbl_arrow];
        
//        line = [[UIView alloc]initWithFrame:CGRectMake(sideView.frame.origin.x+sideView.frame.size.width+1, 0, upview.frame.origin.x-(sideView.frame.origin.x+sideView.frame.size.width+1)-1, 1)];
//        line.backgroundColor = [UIColor blackColor];
//        line.center = CGPointMake(line.center.x, sideView.frame.origin.y+sideView.frame.size.height/2);
//        [self.view addSubview:line];
        
        downview = [[UIView alloc]initWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width-15, 0, 40,(self.view.frame.size.height/2)-2)];
        downview.backgroundColor = [UIColor clearColor];
        downview.accessibilityIdentifier = textField_container;
        
        [self.view addSubview:downview];
        
        self.txt2 = [[UITextField alloc]initWithFrame:CGRectMake(0, 2, downview.frame.size.width, downview.frame.size.height-2)];
        self.txt2.delegate = self.delegate;
        self.txt2.tintColor = tint_Color;
        self.txt2.tag = 3;
        self.txt2.accessibilityIdentifier = textField_identifier;
        self.txt2.borderStyle = UITextBorderStyleNone;
        self.txt2.font = isIpad?math_font1:math_font1_iphone;  // [UIFont fontWithName:math_font_name size:math_font_size];
        self.txt2.textAlignment = NSTextAlignmentLeft;
        self.txt2.textColor = color;
        [downview addSubview:self.txt2];
        
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, downview.frame.origin.x+downview.frame.size.width+2, self.view.frame.size.height);
    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate performSelector:@selector(textFieldSelected:) withObject:textField];
    return NO;
}
@end
