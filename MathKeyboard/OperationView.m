//
//  OperationView.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

#import "math_constant.h"
#import <QuartzCore/QuartzCore.h>
//New file by siddhi infosoft

static CGFloat const part1 = 0.12;  // tiny diagonal will be 12% of the height of the text frame
static CGFloat const part2 = 0.35;  // medium sized diagonal will be 35% of the height of the text frame


@implementation OperationView
@synthesize downview;

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
        
        [[NSBundle mainBundle] loadNibNamed:@"OperationView" owner:self options:nil];
        
        
        self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, 60, viewFrame.size.height);
        self.view.backgroundColor = [UIColor clearColor];
        
        downview = [[UIView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height/2)/2, self.view.frame.size.width, (self.view.frame.size.height/2))];
        downview.backgroundColor = [UIColor clearColor];
        downview.accessibilityIdentifier = textField_container;
        [self.view addSubview:downview];
        
        self.txt1 = [[UITextField alloc]initWithFrame:CGRectMake(17, 0, downview.frame.size.width-17, downview.frame.size.height)];
        self.txt1.delegate = self.delegate;
        self.txt1.borderStyle = UITextBorderStyleNone;
        self.txt1.tintColor = tint_Color;
        self.txt1.tag = 1;
        self.txt1.accessibilityIdentifier = textField_identifier;
        self.txt1.accessibilityHint = sqrt_textField_hint;
        self.txt1.font = isIpad?math_font1:math_font1_iphone; // [UIFont fontWithName:math_font_name size:math_font_size];
        self.txt1.textAlignment = NSTextAlignmentLeft;
        self.txt1.textColor = color;
        [downview addSubview:self.txt1];
        
        [self addSquareRootTo:self.txt1 withColor:color];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sqrtTextFieldUpdates:) name:sqrt_textField_update object:nil];
    }
    return self;
}
- (void)sqrtTextFieldUpdates:(NSNotification *)notification withColor:(UIColor*)clr
{
    [layer removeFromSuperlayer];
    [self addSquareRootTo:self.txt1 withColor:clr];
}
- (void)addSquareRootTo:(UITextField *)label withColor:(UIColor*)clr
{
    
    CGSize size;
    
    if ([@"123456" respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary *attributes = @{NSFontAttributeName : label.font};
        
        size = [@"1234" sizeWithAttributes:attributes];
        
    }
    else
    {
        size = [@"1234" sizeWithFont:label.font];
    }
    if (size.width>self.view.frame.size.width) {
        size.width = label.frame.size.width;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // it's going to seem strange, but it's probably easier to draw the square root size
    // right to left, so let's start at the top right of the text frame
    
    [path moveToPoint:CGPointMake(label.frame.origin.x + size.width, label.frame.origin.y)];
    
    // move to the top left
    
    CGPoint point = CGPointMake(label.frame.origin.x, label.frame.origin.y);
    [path addLineToPoint:point];
    
    // now draw the big diagonal line down to the bottom of the text frame (at 15 degrees)
    
    point.y += size.height+5;
    point.x -= sinf(15 * M_PI / 180) * size.height;
    [path addLineToPoint:point];
    
    // now draw the medium sized diagonal back up (at 30 degrees)
    
    point.y -= size.height * part2;
    point.x -= sinf(30 * M_PI / 180) * size.height * part2;
    [path addLineToPoint:point];
    
    // now draw the tiny diagonal back down (again, at 30 degrees)
    
    point.y += size.height * part1;
    point.x -= sinf(30 * M_PI / 180) * size.height * part1;
    [path addLineToPoint:point];
    
    // now add the whole path to our view
    
    layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = [[UIColor blackColor] CGColor];
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.strokeColor = [UIColor blackColor].CGColor;
    [downview.layer addSublayer:layer];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate performSelector:@selector(textFieldSelected:) withObject:textField];
    return NO;
}
@end
