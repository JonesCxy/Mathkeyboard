//
//  TrigonometricView.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

#import "math_constant.h"
//New file by siddhi infosoft
@implementation TrigonometricView

- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg withOptionString:(NSString*)option andColor:(UIColor*)color
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
        [[NSBundle mainBundle] loadNibNamed:@"TrigonometricView" owner:self options:nil];
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, 80, viewFrame.size.height);
        self.view.backgroundColor = [UIColor clearColor];
        
        upview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        upview.backgroundColor = [UIColor clearColor];
        upview.accessibilityIdentifier = textField_container;
        [self.view addSubview:upview];
        
        self.lblFirst = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width-25, upview.frame.size.height-10)];
        NSLog(@"%@",[UIFont fontNamesForFamilyName:@"Times New Roman"]);
        self.lblFirst.font =  isIpad?math_font1:math_font1_iphone; // [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:30.0f];
        self.lblFirst.text = option;
        self.lblFirst.textAlignment = NSTextAlignmentCenter;
        self.lblFirst.textColor = color;
        [upview addSubview:self.lblFirst];
        
        CGSize constraintSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
        CGSize labelSize = [self.lblFirst.text sizeWithFont:self.lblFirst.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.lblFirst.frame=CGRectMake(self.lblFirst.frame.origin.x, (upview.frame.size.height-labelSize.height)/2, labelSize.width, labelSize.height);
        
        
        self.lblStart = [[UILabel alloc] init];
        self.lblStart.frame=CGRectMake(self.lblFirst.frame.origin.x+self.lblFirst.frame.size.width+2, 0, 8, upview.frame.size.height);
        self.lblStart.font=isIpad?math_font3:math_font3_iphone;
        self.lblStart.backgroundColor=[UIColor clearColor];
        self.lblStart.text=@"(";
        self.lblStart.textColor = color;
        [upview addSubview:self.lblStart];
        
        constraintSize = CGSizeMake(self.lblStart.frame.size.width, MAXFLOAT);
        labelSize = [self.lblStart.text sizeWithFont:self.lblStart.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.lblStart.frame=CGRectMake(self.lblStart.frame.origin.x, ((upview.frame.size.height-labelSize.height)/2)-2, labelSize.width, labelSize.height);
        
        
        self.txt = [[UITextField alloc]initWithFrame:CGRectMake(self.lblStart.frame.origin.x+self.lblStart.frame.size.width, self.view.frame.size.height/2-((self.view.frame.size.height/2)/2), 25, self.view.frame.size.height/2)];
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
        
        
        self.lblEnd = [[UILabel alloc] init];
        self.lblEnd.frame=CGRectMake(self.txt.frame.origin.x+self.txt.frame.size.width+3, 0, 8, upview.frame.size.height);
        self.lblEnd.font=isIpad?math_font3:math_font3_iphone;
        self.lblEnd.backgroundColor=[UIColor clearColor];
        self.lblEnd.text=@")";
        self.lblEnd.textColor = color;
        [upview addSubview:self.lblEnd];
        
        constraintSize = CGSizeMake(self.lblEnd.frame.size.width, MAXFLOAT);
        labelSize = [self.lblEnd.text sizeWithFont:self.lblEnd.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.lblEnd.frame=CGRectMake(self.lblEnd.frame.origin.x, ((upview.frame.size.height-labelSize.height)/2)-2, labelSize.width, labelSize.height);
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, self.lblEnd.frame.origin.x+self.lblEnd.frame.size.width+3, viewFrame.size.height);
        
        upview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

        
    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate performSelector:@selector(textFieldSelected:) withObject:textField];
    return NO;
}
@end
