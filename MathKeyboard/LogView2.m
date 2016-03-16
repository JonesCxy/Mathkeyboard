//
//  LogView2.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

#import "math_constant.h"
//New file by siddhi infosoft
@implementation LogView2

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
        
        [[NSBundle mainBundle] loadNibNamed:@"LogView2" owner:self options:nil];
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, 80, viewFrame.size.height);
        self.view.backgroundColor = [UIColor clearColor];
        
        downview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        downview.backgroundColor = [UIColor clearColor];
        downview.accessibilityIdentifier = textField_container;
        [self.view addSubview:downview];
        
        self.lbl = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, self.view.frame.size.width, self.view.frame.size.height)];
        NSLog(@"%@",[UIFont fontNamesForFamilyName:@"Times New Roman"]);
        self.lbl.font = isIpad?math_font1:math_font1_iphone;
        self.lbl.text = option;
        self.lbl.textAlignment = NSTextAlignmentCenter;
        self.lbl.textColor = color;
        [downview addSubview:self.lbl];
        
        CGSize constraintSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
        CGSize labelSize = [self.lbl.text sizeWithFont:self.lbl.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.lbl.frame=CGRectMake(self.lbl.frame.origin.x, (self.view.frame.size.height-labelSize.height)/2, labelSize.width, labelSize.height);
        
        
        
        self.txt = [[UITextField alloc]initWithFrame:CGRectMake(self.lbl.frame.origin.x+self.lbl.frame.size.width+2, self.view.frame.size.height/2, 25, self.view.frame.size.height/2)];
        self.txt.delegate = self.delegate;
        self.txt.tag = 1;
        self.txt.tintColor = tint_Color;
        self.txt.borderStyle = UITextBorderStyleNone;
        self.txt.accessibilityIdentifier = textField_identifier;
        self.txt.accessibilityLabel = textField_custom_width;//17-8-2015
        self.txt.font = [UIFont systemFontOfSize:15.0];  
        self.txt.textAlignment = NSTextAlignmentCenter;
        self.txt.textColor = color;
        [downview addSubview:self.txt];
        
        
        self.lblStart = [[UILabel alloc] init];
        self.lblStart.frame=CGRectMake(self.txt.frame.origin.x+self.txt.frame.size.width+1, 0, 8, self.view.frame.size.height);
        self.lblStart.font=isIpad?math_font3:math_font3_iphone;
        self.lblStart.backgroundColor=[UIColor clearColor];
        self.lblStart.text=@"(";
        self.lblStart.textColor = color;
        [downview addSubview:self.lblStart];
        
        constraintSize = CGSizeMake(self.lblStart.frame.size.width, MAXFLOAT);
        labelSize = [self.lblStart.text sizeWithFont:self.lblStart.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.lblStart.frame=CGRectMake(self.lblStart.frame.origin.x, ((self.view.frame.size.height-labelSize.height)/2)-2, labelSize.width, labelSize.height);
        
        
        self.txt1 = [[UITextField alloc]initWithFrame:CGRectMake(self.lblStart.frame.origin.x+self.lblStart.frame.size.width, self.view.frame.size.height/2-((self.view.frame.size.height/2)/2), 25, self.view.frame.size.height/2)];
        self.txt1.delegate = self.delegate;
        self.txt1.borderStyle = UITextBorderStyleNone;
        self.txt1.tag = 2;
        self.txt1.accessibilityIdentifier = textField_identifier;
        self.txt1.accessibilityLabel = textField_custom_width;//17-8-2015
        self.txt1.tintColor = tint_Color;
        self.txt1.font =  isIpad?math_font1:math_font1_iphone ; // [UIFont fontWithName:math_font_name size:math_font_size];
        self.txt1.textAlignment = NSTextAlignmentCenter;
        self.txt1.textColor = color;
        [downview addSubview:self.txt1];
        
        
        self.lblEnd = [[UILabel alloc] init];
        self.lblEnd.frame=CGRectMake(self.txt1.frame.origin.x+self.txt1.frame.size.width+3, 0, 8, self.view.frame.size.height);
        self.lblEnd.font=isIpad?math_font3:math_font3_iphone;
        self.lblEnd.backgroundColor=[UIColor clearColor];
        self.lblEnd.text=@")";
        self.lblEnd.textColor = color;
        [downview addSubview:self.lblEnd];
        
        constraintSize = CGSizeMake(self.lblEnd.frame.size.width, MAXFLOAT);
        labelSize = [self.lblEnd.text sizeWithFont:self.lblEnd.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.lblEnd.frame=CGRectMake(self.lblEnd.frame.origin.x, ((self.view.frame.size.height-labelSize.height)/2)-2, labelSize.width, labelSize.height);
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, self.lblEnd.frame.origin.x+self.lblEnd.frame.size.width+3, viewFrame.size.height);
        
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
