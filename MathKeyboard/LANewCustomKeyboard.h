//
//  LANewCustomKeyboard.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 08/06/15.
//
//

#import <Foundation/Foundation.h>
#import "math_constant.h"
//#import "myCustomScrollView.h" // changed 06-02-2016

#define KEYBOARD_HEIGHT 132
#define KEYBOARD_WIDTH  320
#define KEYBOARD_WIDTH_IPAD 768
#define New_KEYBOARD_HEIGHT_IPAD 370
#define digit_keypad 1001
#define alpha_keypad 2001
#define main_menu_left 3001
#define main_menu_right 3002
#define sub_menu_left 4001
#define sub_menu_right 4002
#define keyBoardBackgroundColor [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0]
#define keySelectionColor [UIColor colorWithRed:194/255.0f green:196/255.0f blue:194/255.0f alpha:1.0]


typedef enum{
    k_x = 101,
    k_seven,
    k_eight,
    k_nine,
    k_plus,
    k_o_perenth,
    k_c_perenth,
    k_y,
    k_four,
    k_five,
    k_six,
    k_minus,
    k_cap,
    k_root,
    k_z,
    k_one,
    k_two,
    k_three,
    k_multiplication,
    k_equal,
    k_delete,
    k_dot,
    k_zero,
    k_coma,
    k_devide,
    k_backward,
    k_forward,
    k_negative
} digitKey;

typedef enum{
    alpha_q = 201,
    alpha_w,
    alpha_e,
    alpha_r,
    alpha_t,
    alpha_y,
    alpha_u,
    alpha_i,
    alpha_o,
    alpha_p,
    alpha_a,
    alpha_s,
    alpha_d,
    alpha_f,
    alpha_g,
    alpha_h,
    alpha_j,
    alpha_k,
    alpha_l,
    alpha_caps,
    alpha_z,
    alpha_x,
    alpha_c,
    alpha_v,
    alpha_b,
    alpha_n,
    alpha_m,
    alpha_coma,
    alpha_delete,
    alpha_space,
    alpha_return,
    alpha_close
} alphaKey;

typedef enum{
    basic_math = 0,
    pre_al,
    algebra,
    trignometry,
    precal,
    cal,
    statis,
    finite_ma,
    linear_al,
    chem
} mainMenuBtnIndex;

//New file by siddhi infosoft

@interface LANewCustomKeyboard : NSObject
{
    IBOutlet UIView *alphabetView;
    IBOutlet UIView *digitView;
    IBOutlet UIView *view;

}
@property (weak, nonatomic) IBOutlet UIScrollView *subMenuScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *mainMenuScroll;
@property(nonatomic ,retain)UIView *view;
@property(nonatomic ,retain)UIView *digitView;
@property(nonatomic ,retain)UIView *alphabetView;
@property(nonatomic ,retain)NSArray *menuArray;
@property(nonatomic)BOOL isOptionMenuOpened;
@property(nonatomic ,retain)NSDictionary *subMenus;
@property(nonatomic ,retain)NSDictionary *subMenusOptions;
@property(nonatomic ,retain)id delegate;

@property (weak, nonatomic) IBOutlet UIButton *btn_sub_left;
@property (weak, nonatomic) IBOutlet UIButton *btn_sub_right;


- (id)initWithDelegate:(id)delg;
- (IBAction)changeKeyboard:(id)sender;
-(void)hideOptionMenu;
- (IBAction)mainMenuScrollClicked:(id)sender;
- (IBAction)subMenuScrollClicked:(id)sender;
- (void)mainMenuButtonClicked:(id)sender;
- (void)subMenuButtonClicked:(id)sender;
- (void) pushMenuItem:(id)sender;
- (IBAction)otherButtonClicked:(id)sender;


@end
