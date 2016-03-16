//
//  myCustomScrollView.m
//  MathFriendzy
//
//  Created by Viren Zalavadia on 06/02/16.
//
//

#import "myCustomScrollView.h"

@implementation myCustomScrollView


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
    }
    return self;
}

/*
-(BOOL)touchesShouldCancelInContentView:(UIView *)view1
{
    return ![view1 isKindOfClass:[UISlider class]];
}
*/

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:UIButton.class]) {
        return YES;
    }
    
    return [super touchesShouldCancelInContentView:view];
}

/*
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    NSLog(@"touchesShouldCancelInContentView");
    
    if (view.tag == 0 || view.tag == 1 || view.tag == 2 || view.tag == 3 || view.tag == 4 || view.tag == 5 || view.tag == 6 || view.tag == 7 || view.tag == 8 )
        return NO;
    else
        return YES;
}
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
