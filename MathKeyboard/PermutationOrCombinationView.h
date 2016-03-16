//
//  PermutationOrCombinationView.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 14/07/15.
//
//

#define permutation 1
#define combination 2

#import <Foundation/Foundation.h>

@interface PermutationOrCombinationView : NSObject<UITextFieldDelegate>
{
    UIView *view;
    UIView *sideView;
    UIView *upview;
    UIView *line;
    
}
@property(nonatomic ,retain)UIView *view;
@property(nonatomic ,retain)id delegate;
@property(nonatomic ,retain)UITextField *txt;
@property(nonatomic ,retain)UITextField *txt1;
- (id)initWithFrame:(CGRect)viewFrame andDelegate:(id)delg permOrComb:(int)permOrComb andColor:(UIColor*)color;
- (void)textFieldSelected:(UITextField *)textField;


@end
