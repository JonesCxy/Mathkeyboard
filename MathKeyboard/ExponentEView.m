//
//  ExponentEView.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 08/07/15.
//
//

#import "ExponentEView.h"

@implementation ExponentEView
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg withOptionString:(NSString*)option andColor:(UIColor*)color
{
//    LOG_FUNCTION_START
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
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, 45, viewFrame.size.height);
        self.view.backgroundColor = [UIColor clearColor];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height/3)-10, self.view.frame.size.width-25, self.view.frame.size.height-(self.view.frame.size.height/3)-2)];
        NSLog(@"%@",[UIFont fontNamesForFamilyName:@"Times New Roman"]);
        lbl.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:30.0f];
        lbl.text = option;
        lbl.textColor = color;
        lbl.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lbl];

        
        downview = [[UIView alloc]initWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width, 0, 25, self.view.frame.size.height/2)];
        downview.backgroundColor = [UIColor clearColor];
        downview.accessibilityIdentifier = textField_container;
        [self.view addSubview:downview];
        
        
        
        self.txt = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, downview.frame.size.width, downview.frame.size.height)];
        self.txt.delegate = self.delegate;
        self.txt.tag = 1;
        self.txt.tintColor = tint_Color;
        self.txt.borderStyle = UITextBorderStyleNone;
        self.txt.accessibilityIdentifier = textField_identifier;
        self.txt.font = isIpad?math_script_font:math_script_font_iphone;
        self.txt.textAlignment = NSTextAlignmentLeft;
        self.txt.textColor = color;
        [downview addSubview:self.txt];
        
        
        
    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate performSelector:@selector(textFieldSelected:) withObject:textField];
    return NO;
}
@end
