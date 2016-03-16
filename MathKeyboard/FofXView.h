//
//  FofXView.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 13/07/15.
//
//

#import <Foundation/Foundation.h>
//New file by siddhi infosoft

@interface FofXView : NSObject<UITextFieldDelegate>
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
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg andColor:(UIColor*)color;
- (void)textFieldSelected:(UITextField *)textField;

@end
