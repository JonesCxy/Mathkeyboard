//
//  OperationView1.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

//New file by siddhi infosoft

typedef enum : NSUInteger {
    op_plus=1,
    op_minus,
    op_devide,
    op_multiplication,
    op_graterthan,
    op_graterthanEqual,
    op_lessthan,
    op_lessthanEqual,
    op_equal,
    op_percentage,
    op_pie,
    op_union,
    op_intersection,
    op_arrow,//TODO:31-7-2015
    op_xbar,//TODO:31-7-2015
    op_sigma_xbar,//TODO:31-7-2015
    op_mu_xbar,//TODO:31-7-2015
    op_infinity,
    op_factorial
} opration_tag;
#import <Foundation/Foundation.h>
@interface OperationView1 : NSObject<UITextFieldDelegate>
{
    UIView *view;
    UIView *upview;
    UIView *downview;
    UIView *line;
}
@property(nonatomic ,retain)UIView *view;
@property(nonatomic ,retain)UITextField *txt1;
@property(nonatomic ,retain)id delegate;
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg withOpearationTag:(int)op_tag andColor:(UIColor*)color;
- (void)textFieldSelected:(UITextField *)textField;
@end
