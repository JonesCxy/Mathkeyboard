//
//  MixedNumberView.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

#import "math_constant.h"
//New file by siddhi infosoft

#define part 2

@implementation MixedNumberView
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
        
        sideView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, (self.view.frame.size.width/part)-7, self.view.frame.size.height-(self.view.frame.size.height/3))];
        sideView.backgroundColor = [UIColor clearColor];
        sideView.accessibilityIdentifier = textField_container;
        sideView.center = CGPointMake(sideView.center.x, self.view.frame.size.height/2);
        [self.view addSubview:sideView];
        
        self.txt = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, sideView.frame.size.width, sideView.frame.size.height)];
        self.txt.delegate = self.delegate;
        self.txt.tag = 1;
        self.txt.accessibilityIdentifier = textField_identifier;
        self.txt.accessibilityLabel = textField_custom_width;
        self.txt.borderStyle = UITextBorderStyleNone;
        self.txt.tintColor = tint_Color;
        self.txt.font = isIpad?math_font1:math_font1_iphone; 
        self.txt.textAlignment = NSTextAlignmentLeft;
        self.txt.textColor = color;
        [sideView addSubview:self.txt];
        
        
        upview = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/part)+1, 1, self.view.frame.size.width-(self.view.frame.size.width/part)-2, (self.view.frame.size.height/2)-2)];
        upview.accessibilityIdentifier = textField_container;
        upview.backgroundColor = [UIColor clearColor];
        [self.view addSubview:upview];
        
        self.txt1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, upview.frame.size.width, upview.frame.size.height)];
        self.txt1.delegate = self.delegate;
        self.txt1.tag = 2;
        self.txt1.borderStyle = UITextBorderStyleNone;
        self.txt1.tintColor = tint_Color;
        self.txt1.accessibilityIdentifier = textField_identifier;
        self.txt1.font = isIpad?math_font1:math_font1_iphone; // [UIFont fontWithName:math_font_name size:math_font_size];
        self.txt1.textAlignment = NSTextAlignmentCenter;
        self.txt1.textColor = color;
        [upview addSubview:self.txt1];

        
        line = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/part)+1, 0, self.view.frame.size.width-(self.view.frame.size.width/part)-2, 1)];
        line.backgroundColor = [UIColor blackColor];
        line.backgroundColor = color;
        line.center = CGPointMake(line.center.x, self.view.frame.size.height/2);
        [self.view addSubview:line];
        
        downview = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/part)+1, (self.view.frame.size.height/2)+1, self.view.frame.size.width-(self.view.frame.size.width/part)-2, (self.view.frame.size.height/2)-2)];
        downview.backgroundColor = [UIColor clearColor];
        downview.accessibilityIdentifier = textField_container;

        [self.view addSubview:downview];
        
        self.txt2 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, downview.frame.size.width, downview.frame.size.height)];
        self.txt2.delegate = self.delegate;
        self.txt2.tintColor = tint_Color;
        self.txt2.tag = 3;
        self.txt2.accessibilityIdentifier = textField_identifier;
        self.txt2.borderStyle = UITextBorderStyleNone;
        self.txt2.font = isIpad?math_font1:math_font1_iphone;  // [UIFont fontWithName:math_font_name size:math_font_size];
        self.txt2.textAlignment = NSTextAlignmentCenter;
        self.txt2.textColor = color;
        [downview addSubview:self.txt2];

    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate performSelector:@selector(textFieldSelected:) withObject:textField];
    return NO;
}
@end
