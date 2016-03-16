//
//  MixedNumberView.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

#import <Foundation/Foundation.h>
//New file by siddhi infosoft
@interface MixedNumberView : NSObject<UITextFieldDelegate>
{
    UIView *view;
    UIView *sideView;
    UIView *upview;
    UIView *downview;
    UIView *line;

}
@property(nonatomic ,retain)UIView *view;
@property(nonatomic ,retain)id delegate;
@property(nonatomic ,retain)UITextField *txt;
@property(nonatomic ,retain)UITextField *txt1;
@property(nonatomic ,retain)UITextField *txt2;
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg andColor:(UIColor*)color;
- (void)textFieldSelected:(UITextField *)textField;
@end
