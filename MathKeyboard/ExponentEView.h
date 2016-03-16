//
//  ExponentEView.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 08/07/15.
//
//

#import <Foundation/Foundation.h>
//New file by siddhi infosoft
@interface ExponentEView : NSObject<UITextFieldDelegate>
{
    UIView *view;
    UIView *upview;
    UIView *downview;
    UIView *line;
}
@property(nonatomic ,retain)UIView *view;
@property(nonatomic ,retain)UITextField *txt;
@property(nonatomic ,retain)id delegate;
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg withOptionString:(NSString*)option andColor:(UIColor*)color;
- (void)textFieldSelected:(UITextField *)textField;

@end
