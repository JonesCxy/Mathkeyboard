//
//  ParenthesisView.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 15/09/15.
//
//

#import "ParenthesisView.h"

@implementation ParenthesisView
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
        
        lblLast = [[UILabel alloc] init];
        lblLast.frame=CGRectMake(self.txt.frame.origin.x+self.txt.frame.size.width+3, 0, 10, self.view.frame.size.height-5);
        lblLast.font=isIpad?math_font3:math_font3_iphone;
        lblLast.backgroundColor=[UIColor clearColor];
        lblLast.text=@")";
        lblLast.textColor = color;
        [upview addSubview:lblLast];
        
        upview.frame = CGRectMake(upview.frame.origin.x, upview.frame.origin.y, lblLast.frame.origin.x+lblLast.frame.size.width, upview.frame.size.height);
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, upview.frame.origin.x+upview.frame.size.width, self.view.frame.size.height);
    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate performSelector:@selector(textFieldSelected:) withObject:textField];
    return NO;
}
@end
