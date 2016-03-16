//
//  PointView.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

#import "math_constant.h"
//New file by siddhi infosoft
@implementation PointView
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

        [[NSBundle mainBundle] loadNibNamed:@"PointView" owner:self options:nil];
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, 101, viewFrame.size.height);
        self.view.backgroundColor = [UIColor clearColor];
        
        upview = [[UIView alloc]initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, self.view.frame.size.height)];
        upview.backgroundColor = [UIColor clearColor];
        upview.accessibilityIdentifier = textField_container;
        [self.view addSubview:upview];
        
        lblFirst = [[UILabel alloc] init];
        lblFirst.frame=CGRectMake(0, 0, 10, self.view.frame.size.height-5);
        lblFirst.font=isIpad?math_font3:math_font3_iphone;
        lblFirst.backgroundColor=[UIColor clearColor];
        lblFirst.text=@"(";
        lblFirst.textColor = color;
        [upview addSubview:lblFirst];

        self.txt = [[UITextField alloc]initWithFrame:CGRectMake(lblFirst.frame.origin.x+lblFirst.frame.size.width, self.view.frame.size.height/2-((self.view.frame.size.height/2)/2), 35, self.view.frame.size.height/2)];
        self.txt.delegate = self.delegate;
        self.txt.borderStyle = UITextBorderStyleNone;
        self.txt.tag = 1;
        self.txt.accessibilityIdentifier = textField_identifier;
        self.txt.accessibilityLabel = textField_custom_width;//17-8-2015
        self.txt.tintColor = tint_Color;
        self.txt.font =  isIpad?math_font1:math_font1_iphone ; // [UIFont fontWithName:math_font_name size:math_font_size];
        self.txt.textAlignment = NSTextAlignmentCenter;
        self.txt.textColor = color;
        [upview addSubview:self.txt];
        
        lblComma = [[UILabel alloc] init];
        lblComma.frame=CGRectMake(self.txt.frame.origin.x+self.txt.frame.size.width+3, 5, 8, upview.frame.size.height-10);
        lblComma.font=isIpad?math_font3:math_font3_iphone;
        lblComma.backgroundColor=[UIColor clearColor];
        lblComma.text=@",";
        lblComma.textColor = color;
        [upview addSubview:lblComma];
        
        self.txt1 = [[UITextField alloc]initWithFrame:CGRectMake(lblComma.frame.origin.x+lblComma.frame.size.width, self.view.frame.size.height/2-((self.view.frame.size.height/2)/2), 35, self.view.frame.size.height/2)];
        self.txt1.delegate = self.delegate;
        self.txt1.borderStyle = UITextBorderStyleNone;
        self.txt1.tag = 2;
        self.txt1.accessibilityIdentifier = textField_identifier;
        self.txt1.accessibilityLabel = textField_custom_width;//17-8-2015
        self.txt1.tintColor = tint_Color;
        self.txt1.font =  isIpad?math_font1:math_font1_iphone ; // [UIFont fontWithName:math_font_name size:math_font_size];
        self.txt1.textAlignment = NSTextAlignmentCenter;
        self.txt1.textColor = color;
        [upview addSubview:self.txt1];
        
        lblLast = [[UILabel alloc] init];
        lblLast.frame=CGRectMake(self.txt1.frame.origin.x+self.txt1.frame.size.width+3, 0, 10, self.view.frame.size.height-5);
        lblLast.font=isIpad?math_font3:math_font3_iphone;
        lblLast.backgroundColor=[UIColor clearColor];
        lblLast.text=@")";
        lblLast.textColor = color;
        [upview addSubview:lblLast];
        
    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate performSelector:@selector(textFieldSelected:) withObject:textField];
    return NO;
}
@end
