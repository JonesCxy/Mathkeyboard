//
//  ExponentView.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 04/07/15.
//
//

#import <Foundation/Foundation.h>
//New file by siddhi infosoft
@interface ExponentView : NSObject<UITextFieldDelegate>
{
    UIView *view;
    UIView *upview;
    UIView *downview;
    UIView *line;
}
@property(nonatomic ,retain)UIView *view;
@property(nonatomic ,retain)UITextField *txt;
@property(nonatomic ,retain)UITextField *txt1;
@property(nonatomic ,retain)id delegate;
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg andColor:(UIColor*)color;
- (void)textFieldSelected:(UITextField *)textField;

@end
