//
//  OperationView.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

#import <Foundation/Foundation.h>
//New file by siddhi infosoft

@interface OperationView : NSObject<UITextFieldDelegate>
{
    UIView *view;
    UIView *upview;
    UIView *downview;
    UIView *line;
    CAShapeLayer *layer;
    
    
}
@property(nonatomic ,retain)UIView *view;
@property(nonatomic ,retain)UITextField *txt1;
@property(nonatomic ,retain)id delegate;
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg andColor:(UIColor*)color;
- (void)textFieldSelected:(UITextField *)textField;

@property(nonatomic ,retain) UIView *downview;

@end
