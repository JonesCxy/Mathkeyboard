//
//  ExponentDownView.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 06/07/15.
//
//

#import "ExponentDownView.h"

@implementation ExponentDownView
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
        
        [[NSBundle mainBundle] loadNibNamed:@"ExponentView" owner:self options:nil];
        
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, 80, viewFrame.size.height);
        self.view.backgroundColor = [UIColor clearColor];
        
        upview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width-35, self.view.frame.size.height-(self.view.frame.size.height/3)-2)];
        upview.backgroundColor = [UIColor clearColor];
        upview.accessibilityIdentifier = textField_container;
        [self.view addSubview:upview];
        
        self.txt = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, upview.frame.size.width, upview.frame.size.height)];
        self.txt.delegate = self.delegate;
        self.txt.borderStyle = UITextBorderStyleNone;
        self.txt.tag = 1;
        self.txt.accessibilityIdentifier = textField_identifier;
        self.txt.accessibilityLabel = textField_custom_width;//17-8-2015
        self.txt.tintColor = tint_Color;
        self.txt.font =  isIpad?math_font2:math_font2_iphone ; // [UIFont fontWithName:math_font_name size:math_font_size];
        self.txt.textAlignment = NSTextAlignmentCenter;
        self.txt.textColor = color;
        [upview addSubview:self.txt];
        
        downview = [[UIView alloc]initWithFrame:CGRectMake(45, (self.view.frame.size.height/2)-3, 35, self.view.frame.size.height/2)];
        downview.backgroundColor = [UIColor clearColor];
        downview.accessibilityIdentifier = textField_container;
        [self.view addSubview:downview];
        
        self.txt1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, downview.frame.size.width, downview.frame.size.height)];
        self.txt1.delegate = self.delegate;
        self.txt1.tag = 2;
        self.txt1.tintColor = tint_Color;
        self.txt1.borderStyle = UITextBorderStyleNone;
        self.txt1.accessibilityIdentifier = textField_identifier;
        self.txt1.accessibilityLabel = textField_custom_width;//17-8-2015
        self.txt1.font = isIpad?math_script_font:math_script_font_iphone;
        self.txt1.textAlignment = NSTextAlignmentLeft;
        self.txt1.textColor = color;
        [downview addSubview:self.txt1];
        
        
        
    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate performSelector:@selector(textFieldSelected:) withObject:textField];
    return NO;
}

@end
