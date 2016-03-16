//
//  AbsoluteView.h
//  MathFriendzy
//
//  Created by Vishal Tanna on 20/11/15.
//
//

#import <Foundation/Foundation.h>

@interface AbsoluteView : NSObject<UITextFieldDelegate>
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
