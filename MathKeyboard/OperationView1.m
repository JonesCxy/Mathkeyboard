//
//  OperationView1.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

#import "math_constant.h"
//New file by siddhi infosoft

@implementation OperationView1
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg withOpearationTag:(int)op_tag andColor:(UIColor*)color
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
        
        [[NSBundle mainBundle] loadNibNamed:@"OperationView1" owner:self options:nil];
        

        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, 50, viewFrame.size.height);
        self.view.backgroundColor = [UIColor clearColor];
        
        
        downview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        downview.backgroundColor = [UIColor clearColor];
        downview.accessibilityIdentifier = textField_container;
        [self.view addSubview:downview];

        self.txt1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, downview.frame.size.width, downview.frame.size.height)];
        self.txt1.delegate = self.delegate;
        self.txt1.tag = 1;
        self.txt1.borderStyle = UITextBorderStyleNone;
        self.txt1.font = [UIFont boldSystemFontOfSize:25];
        self.txt1.accessibilityIdentifier = textField_identifier;
        switch (op_tag) {
            case op_plus:
                    self.txt1.text=@"+";
                break;
            case op_multiplication:
                self.txt1.text=multiplication_ascii;
                break;
            case op_minus:
                self.txt1.text=negative_ascii;
                break;
            case op_devide:
                self.txt1.text=@"÷";
                break;
            case op_graterthan:
                self.txt1.text=@">";
                break;
            case op_graterthanEqual:
                self.txt1.text=@"≥";
                break;
            case op_lessthan:
                self.txt1.text=@"<";
                break;
            case op_lessthanEqual:
                self.txt1.text=@"≤";
                break;
            case op_equal:
                self.txt1.text=@"=";
                break;
            case op_percentage:
                self.txt1.text=@"%";
                self.txt1.font = [UIFont boldSystemFontOfSize:18];
                break;
            case op_pie:
                self.txt1.text=@"π";
                self.txt1.font = [UIFont systemFontOfSize:30];
                break;
            case op_union:
                self.txt1.text=UNION_ascii;
                self.txt1.font = [UIFont systemFontOfSize:30];
                break;
            case op_intersection:
                self.txt1.text=INTERSECTION_ascii;
                self.txt1.font = [UIFont systemFontOfSize:30];
                break;
            case op_arrow:
                self.txt1.text=rightArrow_ascii;//TODO:31-7-2015
                self.txt1.font = [UIFont systemFontOfSize:20];
                break;
            case op_xbar:
                self.txt1.text=xbar_ascii;//TODO:31-7-2015
                self.txt1.font = [UIFont systemFontOfSize:20];
                break;
            case op_sigma_xbar:
                self.txt1.text=sigma_xbar_ascii;//TODO:31-7-2015
                self.txt1.font = [UIFont systemFontOfSize:20];
                break;
            case op_mu_xbar:
                self.txt1.text=mu_xbar_ascii;//TODO:31-7-2015
                self.txt1.font = [UIFont systemFontOfSize:20];
                break;
            case op_infinity:
                self.txt1.text=@"∞";//TODO:20-11-2015
                self.txt1.font = [UIFont systemFontOfSize:36];
                break;
            case op_factorial:
                self.txt1.text=@"!";// changed today 09-12-2015
                self.txt1.font = [UIFont systemFontOfSize:36];
                break;
                
            default:
                break;
        }
        
//        txt1.font = [UIFont fontWithName:math_font_name size:50];
//        self.txt1.font = [UIFont boldSystemFontOfSize:40];

        self.txt1.textAlignment = NSTextAlignmentLeft;
        self.txt1.userInteractionEnabled=YES;
        self.txt1.tag = op_tag;
        self.txt1.textColor=[UIColor blackColor];
        self.txt1.tintColor = [UIColor blackColor];
        self.txt1.textColor = color;
        [downview addSubview:self.txt1];
//        downview.backgroundColor = [UIColor purpleColor];
        
        //Changes start on 1-7-2015
        
        NSString *str = self.txt1.text;
        NSLog(@"%@",self.txt1.text);
        self.txt1.text = [NSString stringWithFormat:@"%@%@",str,str];
        NSLog(@"%@",self.txt1.text);
        
        [self setSizeForTextfield:self.txt1];
        downview.frame = CGRectMake(downview.frame.origin.x, downview.frame.origin.y, self.txt1.frame.origin.x+self.txt1.frame.size.width, self.view.frame.size.height);

        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, downview.frame.size.width, viewFrame.size.height);

        self.txt1.text = [NSString stringWithFormat:@"%@",str];
        NSLog(@"%@",self.txt1.text);
        self.txt1.textAlignment = NSTextAlignmentCenter;
        //Changes end on 1-7-2015
    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate performSelector:@selector(textFieldSelected:) withObject:textField];
    return NO;
}
//Added on 1-7-2015
-(void)setSizeForTextfield:(UITextField*)txt;
{
    NSString *valueString = txt.text;
    CGSize newSize = [valueString sizeWithFont: [UIFont fontWithName: txt.font.fontName size: txt.font.pointSize] ];
    
    // assign new size
    CGRect textFrame = txt. frame;
    textFrame.size  = newSize;
    txt.frame = CGRectMake(txt.frame.origin.x, txt.frame.origin.y, newSize.width+extra_textfield_space, txt.frame.size.height);
    
}
@end
