//
//  ParenthesisView.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 15/09/15.
//
//

#import <Foundation/Foundation.h>
//New file by siddhi infosoft
@interface ParenthesisView : NSObject<UITextFieldDelegate>
{
    UIView *view;
    UIView *upview;
    
    UILabel *lblFirst;
    UILabel *lblLast;
    
}
@property(nonatomic ,retain)UIView *view;
@property(nonatomic ,retain)UITextField *txt;

@property(nonatomic ,retain)id delegate;
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg andColor:(UIColor*)color;
- (void)textFieldSelected:(UITextField *)textField;


@end
