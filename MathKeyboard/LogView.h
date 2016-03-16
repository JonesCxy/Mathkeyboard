//
//  LogView.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

#import <Foundation/Foundation.h>
//New file by siddhi infosoft
@interface LogView : NSObject<UITextFieldDelegate>
{
    UIView *view;
    UIView *upview;
    
}
@property(nonatomic ,retain)UIView *view;
@property(nonatomic ,retain)UITextField *txt;
@property(nonatomic ,retain)id delegate;

@property(nonatomic ,retain) UILabel *lblFirst;
@property(nonatomic ,retain) UILabel *lblStart;
@property(nonatomic ,retain) UILabel *lblEnd;


- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg withOptionString:(NSString*)option andColor:(UIColor*)color;



@end
