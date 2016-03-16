//
//  AvenirBoxView.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 14/07/15.
//
//

#import <Foundation/Foundation.h>
//New file by siddhi infosoft
@interface AvenirBoxView : NSObject<UITextFieldDelegate>
{
    UIView *view;
    UIView *sideView;
    UIView *sideView1;
    UIView *sideView2;
    UIView *upview;
    UIView *line;
    
}
@property(nonatomic ,retain)UIView *view;
@property(nonatomic ,retain)id delegate;
@property(nonatomic ,retain)UITextField *txt;
@property(nonatomic ,retain)UITextField *txt1;
@property(nonatomic ,retain)UITextField *txt2;
@property(nonatomic ,retain)UITextField *txt3;

- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg andColor:(UIColor*)color;
- (void)textFieldSelected:(UITextField *)textField;

@end
