//
//  SigmaView.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

#import <Foundation/Foundation.h>
//New file by siddhi infosoft
@interface SigmaView : NSObject<UITextFieldDelegate>
{
    UIView *view;
//    UIView *upview;
    UIView *downview;
}
@property(nonatomic ,retain)UIView *view;
@property(nonatomic ,retain)UITextField *txt;
@property(nonatomic ,retain)UITextField *txt1;
@property(nonatomic ,retain)UITextField *txt2;
@property(nonatomic ,retain) UILabel *lbl;
@property(nonatomic ,retain) UILabel *lblStart;
@property(nonatomic ,retain) UILabel *lblEnd;

@property(nonatomic ,retain)id delegate;
//- (void)textFieldSelected:(UITextField *)textField;

//- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg withOptionString:(NSString*)option;
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg withOptionString:(NSString*)option fontSize:(int)size andColor:(UIColor*)color;

@end
