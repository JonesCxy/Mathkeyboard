//
//  SigmaView.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

#import "math_constant.h"
//New file by siddhi infosoft
@implementation SigmaView

- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg withOptionString:(NSString*)option fontSize:(int)size andColor:(UIColor*)color
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
        
        [[NSBundle mainBundle] loadNibNamed:@"SigmaView" owner:self options:nil];
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, 80, viewFrame.size.height);
        self.view.backgroundColor = [UIColor clearColor];
        
        downview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        downview.backgroundColor = [UIColor clearColor];
        downview.accessibilityIdentifier = textField_container;
        [self.view addSubview:downview];
        
        self.lbl = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.lbl.font = [UIFont systemFontOfSize:size];
        self.lbl.text = option;
        self.lbl.textColor = color;
        self.lbl.textAlignment = NSTextAlignmentCenter;
        [downview addSubview:self.lbl];
        
        CGSize constraintSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
        CGSize labelSize = [self.lbl.text sizeWithFont:self.lbl.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.lbl.frame=CGRectMake(self.lbl.frame.origin.x, ((self.view.frame.size.height-labelSize.height)/2)-1, labelSize.width, labelSize.height);
        
        self.txt1 = [[UITextField alloc]initWithFrame:CGRectMake(self.lbl.frame.origin.x+((self.lbl.frame.size.width/2)-((self.lbl.frame.size.width+10)/2)), 2, self.lbl.frame.size.width+10, self.lbl.frame.origin.y-2)];
        self.txt1.delegate = self.delegate;
        self.txt1.tag = 2;
        self.txt1.tintColor = tint_Color;
        self.txt1.borderStyle = UITextBorderStyleNone;
        self.txt1.accessibilityIdentifier = textField_identifier;
        self.txt1.font = [UIFont systemFontOfSize:15.0];
        self.txt1.textAlignment = NSTextAlignmentCenter;
        self.txt1.textColor = color;
        [downview addSubview:self.txt1];
        
        self.txt = [[UITextField alloc]initWithFrame:CGRectMake(self.lbl.frame.origin.x+((self.lbl.frame.size.width/2)-((self.lbl.frame.size.width+10)/2)), self.lbl.frame.origin.y+self.lbl.frame.size.height+2, self.lbl.frame.size.width+10, self.view.frame.size.height-(self.lbl.frame.origin.y+self.lbl.frame.size.height+2))];
        self.txt.delegate = self.delegate;
        self.txt.tag = 1;
        self.txt.tintColor = tint_Color;
        self.txt.borderStyle = UITextBorderStyleNone;
        self.txt.accessibilityIdentifier = textField_identifier;
        self.txt.font = [UIFont systemFontOfSize:15.0];  
        self.txt.textAlignment = NSTextAlignmentCenter;
        self.txt.textColor = color;
        [downview addSubview:self.txt];
        
        self.txt2 = [[UITextField alloc]initWithFrame:CGRectMake(self.txt.frame.origin.x+self.txt.frame.size.width+2, (self.view.frame.size.height-25)/2, 25, 25)];
        self.txt2.delegate = self.delegate;
        self.txt2.tag = 3;
        self.txt2.tintColor = tint_Color;
        self.txt2.borderStyle = UITextBorderStyleNone;
        self.txt2.accessibilityIdentifier = textField_identifier;
        self.txt2.font = isIpad?math_font2:math_font2_iphone;  
        self.txt2.textAlignment = NSTextAlignmentLeft;
        self.txt2.textColor = color;
        [downview addSubview:self.txt2];
        
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, self.txt2.frame.origin.x+self.txt2.frame.size.width+1, viewFrame.size.height);
        downview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate performSelector:@selector(textFieldSelected:) withObject:textField];
    return NO;
}
@end
