//
//  LANewCustomKeyboard.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 08/06/15.
//
//



#import "LANewCustomKeyboard.h"

//New file by siddhi infosoft

@implementation LANewCustomKeyboard

- (id)initWithDelegate:(id)delg
{
    LOG_FUNCTION_START
    self = [super init];
    if(self)
    {
//        NSLog(@"%@",[UIFont fontNamesForFamilyName]);
        
        BOOL isIpad = NO;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            isIpad = YES;
        }
        
        self.view = [[UIView alloc]init];
        self.delegate = delg;
        if (isIpad) {
            [[NSBundle mainBundle] loadNibNamed:@"LANewCustomKeyboard_iPad" owner:self options:nil];
        }else {
            if (self.view.frame.size.width==414) {
                [[NSBundle mainBundle] loadNibNamed:@"LANewCustomKeyboard_iPhone6Plus" owner:self options:nil];
            }else if (self.view.frame.size.width==375) {
                [[NSBundle mainBundle] loadNibNamed:@"LANewCustomKeyboard_iPhone6" owner:self options:nil];
            }
            else{
                [[NSBundle mainBundle] loadNibNamed:@"LANewCustomKeyboard" owner:self options:nil];
            }
        }
        
        if(isIpad)
        {
            int h = New_KEYBOARD_HEIGHT_IPAD;
            self.view.frame = CGRectMake(0, [[UIScreen mainScreen]bounds].size.height-h-65, KEYBOARD_WIDTH_IPAD, h);
        }
        else
        {
            int h = 266;
            self.view.frame = CGRectMake(0, [[UIScreen mainScreen]bounds].size.height-h, KEYBOARD_WIDTH, h);
        }
        self.view.backgroundColor = keyBoardBackgroundColor;
        alphabetView.hidden = YES;
//        self.menuArray = [[NSArray alloc]initWithObjects:@"Basic Math",@"Pre-Algebra", @"Algebra",@"Trignometry",@"Precalculus",@"Calculus",@"Statistics",@"Finite Math",@"Linear Algebra",@"Chemistry", nil];

        self.menuArray = [[NSArray alloc]initWithObjects:@"Basic Math",@"Pre-Algebra", @"Algebra",@"Trigonometry",@"Precalculus",@"Calculus",@"Statistics",@"Finite Math", nil];

        /*
        self.subMenus = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [[NSArray alloc]initWithObjects:@"gte",@"divide",@"parenthesis",@"fraction",@"exponent",@"squareroot",@"area_rectangle",@"volume_box",@"point",@"scientific", nil],@"Basic Math",
                         [[NSArray alloc]initWithObjects:@"gte",@"divide",@"parenthesis",@"fraction",@"exponent",@"squareroot",@"area_rectangle",@"volume_box",@"point",@"scientific", nil],@"Pre-Algebra",
                         [[NSArray alloc]initWithObjects:@"gte",@"pi",@"parenthesis",@"fraction",@"exponent",@"squareroot",@"point",@"matrix",@"fx",@"log", nil],@"Algebra",
                         [[NSArray alloc]initWithObjects:@"gte",@"pi",@"parenthesis",@"fraction",@"exponent",@"squareroot",@"right_triangle",@"fx",@"log",@"sin",@"cos",@"tan",@"sec",@"csc",@"cot", nil],@"Trignometry",
                         [[NSArray alloc]initWithObjects:@"gte",@"pi",@"parenthesis",@"fraction",@"exponent",@"squareroot",@"matrix",@"limit",@"series",@"right_triangle",@"fx",@"log",@"sin",@"cos",@"tan",@"sec",@"csc",@"cot", nil],@"Precalculus",
                         [[NSArray alloc]initWithObjects:@"gte",@"pi",@"parenthesis",@"fraction",@"exponent",@"squareroot",@"limit",@"series",@"integral2_new",@"fx",@"log",@"sin",@"cos",@"tan",@"sec",@"csc",@"cot", nil],@"Calculus",
                         [[NSArray alloc]initWithObjects:@"gte",@"factorial",@"alpha",@"xbar",@"parenthesis",@"fraction",@"exponent",@"squareroot",@"p",@"stat_table2", nil],@"Statistics",
                         [[NSArray alloc]initWithObjects:@"gte",@"pi",@"parenthesis",@"fraction",@"exponent",@"squareroot",@"matrix",@"p",@"stat_table2",@"fx",@"log",nil],@"Finite Math",
                         [[NSArray alloc]initWithObjects:@"gte",@"parenthesis",@"brack_curly",@"fraction",@"exponent",@"squareroot",@"matrix",@"log", nil],@"Linear Algebra",
                         [[NSArray alloc]initWithObjects:@"aerrow",@"parenthesis",@"fraction",@"exponent",@"squareroot",@"expo_p_big_ipad1",@"log", nil],@"Chemistry", nil];*/
        self.subMenus = [[NSDictionary alloc]initWithObjectsAndKeys:
//                         [[NSArray alloc]initWithObjects:@"gte",@"divide",@"fraction",@"exponent",@"squareroot",@"point",@"scientific", nil],@"Basic Math",
                         [[NSArray alloc]initWithObjects:@"gte",@"pi",@"fraction",@"exponent",@"squareroot",@"absolute", nil],@"Basic Math",  //@"point" removed 06-01-2016 from second last position
//                         [[NSArray alloc]initWithObjects:@"gte",@"divide",@"fraction",@"exponent",@"squareroot",@"point",@"scientific", nil],@"Pre-Algebra",
                         [[NSArray alloc]initWithObjects:@"gte",@"pi",@"fraction",@"exponent",@"squareroot",@"absolute", nil],@"Pre-Algebra",  //@"point" removed 06-01-2016 from second last position
                         [[NSArray alloc]initWithObjects:@"gte",@"pi",@"fraction",@"exponent",@"squareroot",@"log",@"absolute", nil],@"Algebra", //@"point" removed 06-01-2016 from fourth position from last  //@"fx" removed 07-01-2016 from fifth position
                         [[NSArray alloc]initWithObjects:@"gte",@"pi",@"fraction",@"exponent",@"squareroot",@"log",@"sin",@"cos",@"tan",@"sec",@"csc",@"cot",@"absolute", nil],@"Trigonometry",  //@"fx" removed 07-01-2016 from sixth position
                         [[NSArray alloc]initWithObjects:@"gte",@"pi",@"fraction",@"exponent",@"squareroot",@"limit",@"series",@"log",@"sin",@"cos",@"tan",@"sec",@"csc",@"cot",@"absolute", nil],@"Precalculus", //@"fx" removed 07-01-2016 from eight position
                         [[NSArray alloc]initWithObjects:@"gte",@"pi",@"fraction",@"exponent",@"squareroot",@"limit",@"series",@"integral2_new",@"log",@"sin",@"cos",@"tan",@"sec",@"csc",@"cot",@"absolute", nil],@"Calculus",  //@"fx" removed 07-01-2016 from ninth position
                         [[NSArray alloc]initWithObjects:@"gte",@"factorial",@"alpha",@"xbar",@"fraction",@"exponent",@"squareroot",@"p",@"absolute", nil],@"Statistics",
                         [[NSArray alloc]initWithObjects:@"gte",@"pi",@"fraction",@"exponent",@"squareroot",@"p",@"log",@"absolute",nil],@"Finite Math",  //@"fx" removed 07-01-2016 from seventh position
                         [[NSArray alloc]initWithObjects:@"gte",@"fraction",@"exponent",@"squareroot",@"log", nil],@"Linear Algebra",
                         [[NSArray alloc]initWithObjects:@"aerrow",@"fraction",@"exponent",@"squareroot",@"expo_p_big_ipad1",@"log", nil],@"Chemistry", nil];
        

        self.subMenusOptions = [[NSDictionary alloc]initWithObjectsAndKeys:
                         // Basic Math
                         [[NSArray alloc]initWithObjects:@"gte_ipad",@"lte_ipad",@"gt_ipad",@"lt_ipad", nil],@"Basic Math & gte",
                         [[NSArray alloc]initWithObjects:@"parcent_ipad",@"pi_ipad", nil],@"Basic Math & pi",
                         [[NSArray alloc]initWithObjects:@"round_brackets_ipad",@"sq_brackets_ipad",@"absolute_ipad",nil],@"Basic Math & parenthesis",
//                         [[NSArray alloc]initWithObjects:@"fraction_ipad",@"mixed_number_ipad", nil],@"Basic Math & fraction",
//                                [[NSArray alloc]initWithObjects:@"fraction_ipad", nil],@"Basic Math & fraction",
                         [[NSArray alloc]initWithObjects:@"squareroot_big_ipad",@"nroot_ipad", nil],@"Basic Math & squareroot",
                         [[NSArray alloc]initWithObjects:@"area_rectangle_ipad",@"area_circle_ipad",@"area_triangle_ipad",@"area_parallelogram_ipad",@"area_trapezoid_ipad",nil],@"Basic Math & area_rectangle",
                         [[NSArray alloc]initWithObjects:@"volume_box_ipad",@"volume_sphere_ipad",@"volume_cone_ipad",@"volume_cylinder_ipad",@"volume_pyramid_ipad", nil],@"Basic Math & volume_box",
                                
                                // Pre-Algebra
                         [[NSArray alloc]initWithObjects:@"gte_ipad",@"lte_ipad",@"gt_ipad",@"lt_ipad", nil],@"Pre-Algebra & gte",
                         [[NSArray alloc]initWithObjects:@"parcent_ipad",@"pi_ipad", nil],@"Pre-Algebra & pi",
                         [[NSArray alloc]initWithObjects:@"round_brackets_ipad",@"sq_brackets_ipad",@"absolute_ipad",nil],@"Pre-Algebra & parenthesis",
//                         [[NSArray alloc]initWithObjects:@"fraction_ipad",@"mixed_number_ipad", nil],@"Pre-Algebra & fraction",

//                        [[NSArray alloc]initWithObjects:@"fraction_ipad", nil],@"Pre-Algebra & fraction",
                        [[NSArray alloc]initWithObjects:@"exponent_ipad",@"exponent_down_ipad",nil],@"Pre-Algebra & exponent",
                         [[NSArray alloc]initWithObjects:@"squareroot_big_ipad",@"nroot_ipad", nil],@"Pre-Algebra & squareroot",
                         [[NSArray alloc]initWithObjects:@"area_rectangle_ipad",@"area_circle_ipad",@"area_triangle_ipad",@"area_parallelogram_ipad",@"area_trapezoid_ipad",nil],@"Pre-Algebra & area_rectangle",
                         [[NSArray alloc]initWithObjects:@"volume_box_ipad",@"volume_sphere_ipad",@"volume_cone_ipad",@"volume_cylinder_ipad",@"volume_pyramid_ipad", nil],@"Pre-Algebra & volume_box",

                                // Algebra options
                                [[NSArray alloc]initWithObjects:@"gte_ipad",@"lte_ipad",@"gt_ipad",@"lt_ipad",@"union_ipad",@"intersection_ipad", nil],@"Algebra & gte",
//                                [[NSArray alloc]initWithObjects:@"fx_ipad",@"piecewise_ipad",@"stat_table1_ipad", nil],@"Algebra & fx",
//                                [[NSArray alloc]initWithObjects:@"fx_ipad", nil],@"Algebra & fx",
                                [[NSArray alloc]initWithObjects:@"log_ipad",@"ln_ipad",@"logn_ipad", nil],@"Algebra & log",
                                [[NSArray alloc]initWithObjects:@"round_brackets_ipad",@"sq_brackets_ipad",@"absolute_ipad",nil],@"Algebra & parenthesis",
//                                [[NSArray alloc]initWithObjects:@"pi_ipad",@"e_ipad",@"i_ipad",@"divide_ipad",@"parcent_ipad",@"infinity_ipad",@"factorial_ipad",nil],@"Algebra & pi",
                                [[NSArray alloc]initWithObjects:@"pi_ipad",@"e_ipad",@"i_ipad",@"parcent_ipad",@"factorial_ipad", @"infinity_ipad", nil],@"Algebra & pi",
//                                [[NSArray alloc]initWithObjects:@"fraction_ipad",@"mixed_number_ipad", nil],@"Algebra & fraction",
//                                [[NSArray alloc]initWithObjects:@"fraction_ipad", nil],@"Algebra & fraction",
                                [[NSArray alloc]initWithObjects:@"exponent_ipad",@"exponent_down_ipad",nil],@"Algebra & exponent",
                                [[NSArray alloc]initWithObjects:@"squareroot_big_ipad",@"nroot_ipad", nil],@"Algebra & squareroot",

                                // Trigonometry options
                                [[NSArray alloc]initWithObjects:@"gte_ipad",@"lte_ipad",@"gt_ipad",@"lt_ipad", nil],@"Trigonometry & gte",
                                [[NSArray alloc]initWithObjects:@"log_ipad",@"ln_ipad",@"logn_ipad", nil],@"Trigonometry & log",
                                [[NSArray alloc]initWithObjects:@"pi_ipad",@"degree_ipad",@"theta_ipad",@"e_ipad",@"i_ipad",@"infinity_ipad",@"factorial_ipad",nil],@"Trigonometry & pi",
                                [[NSArray alloc]initWithObjects:@"round_brackets_ipad",@"sq_brackets_ipad",@"absolute_ipad",nil],@"Trigonometry & parenthesis",
                                [[NSArray alloc]initWithObjects:@"exponent_ipad",@"exponent_down_ipad",nil],@"Trigonometry & exponent",
                                [[NSArray alloc]initWithObjects:@"squareroot_big_ipad",@"nroot_ipad", nil],@"Trigonometry & squareroot",

                                // Precalculus options
                                [[NSArray alloc]initWithObjects:@"gte_ipad",@"lte_ipad",@"gt_ipad",@"lt_ipad", nil],@"Precalculus & gte",
                                [[NSArray alloc]initWithObjects:@"log_ipad",@"ln_ipad",@"logn_ipad", nil],@"Precalculus & log",
//                                [[NSArray alloc]initWithObjects:@"pi_ipad",@"degree_ipad",@"theta_ipad",@"e_ipad",@"i_ipad",@"infinity_ipad",nil],@"Precalculus & pi",
                                [[NSArray alloc]initWithObjects:@"pi_ipad",@"degree_ipad",@"theta_ipad",@"e_ipad",@"i_ipad",@"infinity_ipad",@"factorial_ipad", nil],@"Precalculus & pi",
                                [[NSArray alloc]initWithObjects:@"round_brackets_ipad",@"sq_brackets_ipad",@"absolute_ipad",nil],@"Precalculus & parenthesis",
                                [[NSArray alloc]initWithObjects:@"exponent_ipad",@"exponent_down_ipad",nil],@"Precalculus & exponent",
                                [[NSArray alloc]initWithObjects:@"squareroot_big_ipad",@"nroot_ipad", nil],@"Precalculus & squareroot",

                                // Calculus options
                                [[NSArray alloc]initWithObjects:@"gte_ipad",@"lte_ipad",@"gt_ipad",@"lt_ipad", nil],@"Calculus & gte",
//                                [[NSArray alloc]initWithObjects:@"pi_ipad",@"theta_ipad",@"e_ipad",@"i_ipad",@"infinity_ipad",nil],@"Calculus & pi",
                                [[NSArray alloc]initWithObjects:@"pi_ipad",@"theta_ipad",@"e_ipad",@"i_ipad",@"infinity_ipad",@"factorial_ipad",@"degree_ipad", nil],@"Calculus & pi",
                                [[NSArray alloc]initWithObjects:@"log_ipad",@"ln_ipad",@"logn_ipad", nil],@"Calculus & log",
                                [[NSArray alloc]initWithObjects:@"round_brackets_ipad",@"sq_brackets_ipad",@"absolute_ipad",nil],@"Calculus & parenthesis",
                                [[NSArray alloc]initWithObjects:@"exponent_ipad",@"exponent_down_ipad",nil],@"Calculus & exponent",
                                [[NSArray alloc]initWithObjects:@"squareroot_big_ipad",@"nroot_ipad", nil],@"Calculus & squareroot",
                                [[NSArray alloc]initWithObjects:@"integral2_ipad",@"integral2_box_ipad", nil],@"Calculus & integral2_new",
                                
                                
                                // Statistics options
                                [[NSArray alloc]initWithObjects:@"gte_ipad",@"lte_ipad",@"gt_ipad",@"lt_ipad", nil],@"Statistics & gte",
                                [[NSArray alloc]initWithObjects:@"alpha_ipad",@"mu_ipad",@"sigma_ipad", nil],@"Statistics & alpha",
                                [[NSArray alloc]initWithObjects:@"xbar_ipad",@"muxb_ipad",@"sigmaxb_ipad", nil],@"Statistics & xbar",
                                [[NSArray alloc]initWithObjects:@"round_brackets_ipad",@"sq_brackets_ipad",@"absolute_ipad",nil],@"Statistics & parenthesis",
                                [[NSArray alloc]initWithObjects:@"exponent_ipad",@"exponent_down_ipad",nil],@"Statistics & exponent",
                                [[NSArray alloc]initWithObjects:@"squareroot_big_ipad",@"nroot_ipad", nil],@"Statistics & squareroot",
                                [[NSArray alloc]initWithObjects:@"p_ipad",@"c_ipad", nil],@"Statistics & p",
                                
                                // Finite Math
                                [[NSArray alloc]initWithObjects:@"gte_ipad",@"lte_ipad",@"gt_ipad",@"lt_ipad", nil],@"Finite Math & gte",
                                [[NSArray alloc]initWithObjects:@"log_ipad",@"ln_ipad",@"logn_ipad", nil],@"Finite Math & log",
                                [[NSArray alloc]initWithObjects:@"pi_ipad",@"e_ipad",@"i_ipad",@"alpha_ipad",@"mu_ipad",@"sigma_ipad",@"xbar_ipad",@"muxb_ipad",@"sigmaxb_ipad",nil],@"Finite Math & pi",
                                [[NSArray alloc]initWithObjects:@"round_brackets_ipad",@"sq_brackets_ipad",@"absolute_ipad",nil],@"Finite Math & parenthesis",
                                [[NSArray alloc]initWithObjects:@"exponent_ipad",@"exponent_down_ipad",nil],@"Finite Math & exponent",
                                [[NSArray alloc]initWithObjects:@"squareroot_big_ipad",@"nroot_ipad", nil],@"Finite Math & squareroot",
                                [[NSArray alloc]initWithObjects:@"p_ipad",@"c_ipad", nil],@"Finite Math & p",
                                
                                // Linear Algebra
                                [[NSArray alloc]initWithObjects:@"gte_ipad",@"lte_ipad",@"gt_ipad",@"lt_ipad", nil],@"Linear Algebra & gte",
                                [[NSArray alloc]initWithObjects:@"log_ipad",@"ln_ipad",@"logn_ipad", nil],@"Linear Algebra & log",
                                
                                [[NSArray alloc]initWithObjects:@"round_brackets_ipad",@"sq_brackets_ipad",@"absolute_ipad",nil],@"Linear Algebra & parenthesis",
                                [[NSArray alloc]initWithObjects:@"exponent_ipad",@"exponent_down_ipad",nil],@"Linear Algebra & exponent",
                                [[NSArray alloc]initWithObjects:@"squareroot_big_ipad",@"nroot_ipad", nil],@"Linear Algebra & squareroot",
                                
                                // Chemistry
                                [[NSArray alloc]initWithObjects:@"gte_ipad",@"lte_ipad",@"gt_ipad",@"lt_ipad", nil],@"Chemistry & gte",
                                [[NSArray alloc]initWithObjects:@"log_ipad",@"ln_ipad",@"logn_ipad", nil],@"Chemistry & log",
                                [[NSArray alloc]initWithObjects:@"round_brackets_ipad",@"sq_brackets_ipad",@"absolute_ipad",nil],@"Chemistry & parenthesis",
                                [[NSArray alloc]initWithObjects:@"exponent_ipad",@"exponent_down_ipad",nil],@"Chemistry & exponent",
                                [[NSArray alloc]initWithObjects:@"squareroot_big_ipad",@"nroot_ipad", nil],@"Chemistry & squareroot",
                                [[NSArray alloc]initWithObjects:@"expo_p_big_ipad",@"expo_m_big_ipad", nil],@"Chemistry & expo_p_big_ipad1",
                                
                                //Common
                                
                                [[NSArray alloc]initWithObjects:@"sin",@"arcsin",@"sinn",@"sinh", nil],@"sin",
                                [[NSArray alloc]initWithObjects:@"cos",@"arccos",@"cosn",@"cosh",  nil],@"cos",
                                [[NSArray alloc]initWithObjects:@"tan",@"arctan",@"tann",@"tanh", nil],@"tan",
                                [[NSArray alloc]initWithObjects:@"sec",@"arcsec",@"secn",@"sech",  nil],@"sec",
                                [[NSArray alloc]initWithObjects:@"csc",@"arccsc",@"cscn",@"csch",  nil],@"csc",
                                [[NSArray alloc]initWithObjects:@"cot",@"arccot",@"cotn",@"coth", nil],@"cot",
                                nil];
        
        
        
        self.subMenuScroll.showsHorizontalScrollIndicator = NO;
        self.subMenuScroll.showsVerticalScrollIndicator = NO;
        
        self.mainMenuScroll.showsHorizontalScrollIndicator = NO;
        self.mainMenuScroll.showsVerticalScrollIndicator = NO;
        self.subMenuScroll.backgroundColor = keyBoardBackgroundColor;
        
        [self setupMainMenu:nil];
        self.isOptionMenuOpened = FALSE;
        
        // changed 06-02-2016
        self.mainMenuScroll.userInteractionEnabled = YES;
//        self.mainMenuScroll.exclusiveTouch = YES;
//        self.mainMenuScroll.canCancelContentTouches=NO;
//        self.mainMenuScroll.delaysContentTouches=YES;
        //
        
    }
    return self;
}
- (IBAction)changeKeyboard:(id)sender
{
    UIButton *btn=  sender;
    if (btn.tag==digit_keypad)
    {
        self.digitView.hidden = TRUE;
        self.alphabetView.hidden = FALSE;
    }
    else if(btn.tag==alpha_keypad)
    {
        self.digitView.hidden = FALSE;
        self.alphabetView.hidden = TRUE;
        
        for (UIView *btn_view in self.alphabetView.subviews) {
            if ([btn_view isKindOfClass:[UIButton class]]) {
                UIButton *b = (UIButton*)btn_view;
                b.selected  =FALSE;
            }
        }
        
    }
//    [self.delegate performSelector:@selector(changeKeyboard:) withObject:sender];
}

- (IBAction)otherButtonClicked:(id)sender
{
    [self.delegate performSelector:@selector(otherButtonClicked:) withObject:sender];
}
- (IBAction)mainMenuScrollClicked:(id)sender
{
    UIButton *btn = sender;
    int contentMove = 40;
    
    BOOL isIpad = NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        isIpad = YES;
    }
    
    if (isIpad) {
        contentMove = 80;
    }
    CGPoint newContentOffset;
    switch (btn.tag) {
        case main_menu_left:
        {
            if (self.mainMenuScroll.contentOffset.x>contentMove)
            {
                newContentOffset = CGPointMake(self.mainMenuScroll.contentOffset.x-contentMove, self.mainMenuScroll.contentOffset.y);
//                self.mainMenuScroll.contentOffset = CGPointMake(self.mainMenuScroll.contentOffset.x-contentMove, self.mainMenuScroll.contentOffset.y);
            }
            else
            {
                newContentOffset = CGPointMake(0, self.mainMenuScroll.contentOffset.y);

//                self.mainMenuScroll.contentOffset = CGPointMake(0, self.mainMenuScroll.contentOffset.y);
                
            }
            NSLog(@"main menu scroll left");
            break;
        }
        case main_menu_right:
        {
            
            if (self.mainMenuScroll.contentOffset.x<self.mainMenuScroll.contentSize.width-self.mainMenuScroll.frame.size.width)
            {
//                self.mainMenuScroll.contentOffset = CGPointMake(self.mainMenuScroll.contentOffset.x+contentMove, self.mainMenuScroll.contentOffset.y);
                newContentOffset = CGPointMake(self.mainMenuScroll.contentOffset.x+contentMove, self.mainMenuScroll.contentOffset.y);
            }
            else
            {
//                self.mainMenuScroll.contentOffset = CGPointMake(self.mainMenuScroll.contentSize.width-self.mainMenuScroll.frame.size.width, self.mainMenuScroll.contentOffset.y);
                
                newContentOffset = CGPointMake(self.mainMenuScroll.contentSize.width-self.mainMenuScroll.frame.size.width, self.mainMenuScroll.contentOffset.y);
            }
            
            NSLog(@"main menu scroll right");
            break;
        }
        default:
            break;
    }
    [self.mainMenuScroll setContentOffset:newContentOffset animated:YES];
//    [self.delegate performSelector:@selector(mainMenuScrollClicked:) withObject:sender];
}
- (IBAction)subMenuScrollClicked:(id)sender
{
    UIButton *btn = sender;
    int contentMove = 40;
    BOOL isIpad = NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        isIpad = YES;
    }
    
    if (isIpad) {
        contentMove = 80;
    }
    CGPoint newContentOffset;
    switch (btn.tag) {
        case sub_menu_left:
        {
            if (self.subMenuScroll.contentOffset.x>contentMove) {
//                self.subMenuScroll.contentOffset = CGPointMake(self.subMenuScroll.contentOffset.x-contentMove, self.subMenuScroll.contentOffset.y);
                newContentOffset = CGPointMake(self.subMenuScroll.contentOffset.x-contentMove, self.subMenuScroll.contentOffset.y);
            }
            else
            {
//                self.subMenuScroll.contentOffset = CGPointMake(0, self.subMenuScroll.contentOffset.y);
                newContentOffset = CGPointMake(0, self.subMenuScroll.contentOffset.y);;
                
            }
            break;
        }
        case sub_menu_right:
        {
            if (self.subMenuScroll.contentOffset.x<self.subMenuScroll.contentSize.width-self.subMenuScroll.frame.size.width)
            {
//                self.subMenuScroll.contentOffset = CGPointMake(self.subMenuScroll.contentOffset.x+contentMove, self.subMenuScroll.contentOffset.y);
                newContentOffset = CGPointMake(self.subMenuScroll.contentOffset.x+contentMove, self.subMenuScroll.contentOffset.y);
            }
            else
            {
//                self.subMenuScroll.contentOffset = CGPointMake(self.subMenuScroll.contentSize.width-self.subMenuScroll.frame.size.width, self.subMenuScroll.contentOffset.y);
                newContentOffset = CGPointMake(self.subMenuScroll.contentSize.width-self.subMenuScroll.frame.size.width, self.subMenuScroll.contentOffset.y);
                
            }
            NSLog(@"sub menu scroll right");
            
            break;
        }
        default:
            break;
    }
    [self.subMenuScroll setContentOffset:newContentOffset animated:YES];
//    [self.delegate performSelector:@selector(subMenuScrollClicked:) withObject:sender];
}

// changed 05-02-2016
/*
-(BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = [touches anyObject];
    // Coordinates
    CGPoint point = [touch locationInView:self.mainMenuScroll];
    
    // One tap, forward
    if(touch.tapCount == 1){
        // for each subview
        for(UIView* overlayView in self.mainMenuScroll.subviews)
        {
            // Forward to my subclasss only
            if([overlayView isKindOfClass:[UIButton class]])
            {
                // translate coordinate
                CGPoint newPoint = [touch locationInView:overlayView];
                //NSLog(@"%@",NSStringFromCGPoint(newPoint));
                
                BOOL isInside = [overlayView pointInside:newPoint withEvent:event];
                //if subview is hit
                if(isInside)
                {
//                    Forwarding
                    [overlayView touchesEnded:touches withEvent:event];
                    break;
                }
            }
        }
        
    }
}
 */
//

- (void)mainMenuButtonClicked:(id)sender
{
    NSLog(@"main menu clicked");
    
    UIButton *btn; // = sender;
    // changed 05-02-2016
    if ([sender isKindOfClass:[UIButton class]])
    {
        btn = sender;
    }
    else
    {
        UITapGestureRecognizer *t = (UITapGestureRecognizer *)sender;
        int tagT =(int)t.view.tag;
        
        for (UIView *v in self.mainMenuScroll.subviews)
        {
            if ([v isKindOfClass:[UIButton class]])
            {
                UIButton *btnT = (UIButton *)v;
                if (btnT.tag==tagT) {
                    btn = btnT;
                    break;
                }
            }
        }
    }
    //
    
    if (btn.selected)
    {
        return;
    }
    for (UIView *v in self.mainMenuScroll.subviews) { // changed 05-02-2016
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *b = (UIButton*)v;
            b.selected = FALSE;
            b.backgroundColor = [UIColor clearColor];
        }
    }
    
    btn.selected = TRUE;
    btn.backgroundColor = keySelectionColor;
    
    NSString *subArray_key = [self.menuArray objectAtIndex:btn.tag];
    NSArray *subArray;
    subArray = [self.subMenus valueForKey:[self.menuArray objectAtIndex:btn.tag]];
    NSLog(@"%@",subArray);
    NSArray *menuImagesFor = [[NSArray alloc]initWithObjects:@"Basic Math",@"Pre-Algebra",@"Algebra",@"Trigonometry",@"Precalculus",@"Calculus",@"Statistics",@"Finite Math",@"Linear Algebra",@"Chemistry", nil];
    
//    [[NSArray alloc]initWithObjects:@"Basic Math",@"Pre-Algebra",@"Algebra",@"Trignometry",@"Precalculus",@"Calculus",@"Statistics",@"Finite Math",@"Linear Algebra",@"Chemistry", nil]
    NSArray *downArrowException = [[NSArray alloc]initWithObjects:@"point",@"scientific", nil];
    
    if (![btn.accessibilityIdentifier isEqualToString:@"initial"]) {
        
        [UIView animateWithDuration:.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.subMenuScroll.frame  = CGRectMake(self.subMenuScroll.frame.origin.x,self.subMenuScroll.frame.origin.y-self.subMenuScroll.frame.size.height, self.subMenuScroll.frame.size.width,self.subMenuScroll.frame.size.height);
            
        } completion:^(BOOL finished) {
            [self hideOptionMenu];
            [self.subMenuScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            int x;
            int btn_height = self.subMenuScroll.frame.size.height-7; // changed 21-01-2016
            int btn_width = 110;
            int imageSet = 10;
            btn_width = 90;
            for (int i = 0; i<subArray.count; i++) {
                if (i==0)
                {
                    x = 5;
                }
                
                UIImageView *imgview1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Q.png"]];
                UIImage *img;
                if (i<subArray.count && [menuImagesFor containsObject:subArray_key])
                {
                    NSLog(@"%@",[subArray objectAtIndex:i]);
                    img = [UIImage imageNamed:[subArray objectAtIndex:i]];
                    imgview1.image = img;
                    imgview1.frame = CGRectMake(x, 3, img.size.width, btn_height);
                    if ([downArrowException containsObject:[subArray objectAtIndex:i]])
                    {
                        imgview1.frame = CGRectMake(x, 3, img.size.width+20, btn_height);
                    }
                }
                else
                {
                    imgview1.frame = CGRectMake(x, 3, btn_width/2, btn_height);
                    imgview1.frame = CGRectMake(x, 3, btn_width-(btn_width/3), btn_height);
                }
                
                imgview1.backgroundColor = [UIColor clearColor];
                imgview1.contentMode = UIViewContentModeScaleAspectFit;
                [self.subMenuScroll addSubview:imgview1];
                
                UIImage *img1;
                UIImageView *arrow_img;
                UIButton *sender_btn = btn; // changed 05-02-2016
                NSString *str = [NSString stringWithFormat:@"%@ & %@",sender_btn.titleLabel.text,[subArray objectAtIndex:i]];
                NSLog(@"%@",[self.subMenusOptions valueForKey:str]);
                NSLog(@"%@",[self.subMenusOptions valueForKey:[subArray objectAtIndex:i]]);
                if ([self.subMenusOptions valueForKey:str]||[self.subMenusOptions valueForKey:[subArray objectAtIndex:i]]) {
                    arrow_img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downaerrow"]];
                    img1 = [UIImage imageNamed:@"downaerrow"];
                    if (img!=nil)
                    {
                        arrow_img.frame = CGRectMake(x+img.size.width, 3, img1.size.width, btn_height);
                    }
                    else
                    {
                        arrow_img.frame = CGRectMake(x+btn_width/2, 3, btn_width/2, btn_height);
                        arrow_img.frame = CGRectMake(x+btn_width-(btn_width/3), 3, btn_width/3, btn_height);
                    }
                    arrow_img.backgroundColor = [UIColor clearColor];
                    arrow_img.contentMode = UIViewContentModeScaleAspectFit;
                    [self.subMenuScroll addSubview:arrow_img];
                }
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(x, 3, btn_width, btn_height);
                if (![menuImagesFor containsObject:subArray_key])
                {
                    [btn setTitle:[subArray objectAtIndex:i] forState:UIControlStateNormal];
                }
                else
                {
                    //                    btn.frame = CGRectMake(x, 0, img.size.width+img1.size.width+5, btn_height);
                    btn.frame = CGRectMake(x, 3, imgview1.frame.size.width+arrow_img.frame.size.width+5, btn_height);
                    
                }
                btn.tag = i ;
                
                
                
                if ([self.subMenusOptions valueForKey:str]||[self.subMenusOptions valueForKey:[subArray objectAtIndex:i]])
                {
                    NSLog(@"%@",[self.subMenusOptions valueForKey:str]);
                    
                    if ([self.subMenusOptions valueForKey:str])
                    {
                        btn.accessibilityIdentifier = [NSString stringWithFormat:@"%@ & %@",sender_btn.titleLabel.text,[subArray objectAtIndex:i]];
                    }
                    if ([self.subMenusOptions valueForKey:[subArray objectAtIndex:i]])
                    {
                        btn.accessibilityIdentifier = [NSString stringWithFormat:@"%@",[subArray objectAtIndex:i]];
                    }
                    NSLog(@"%@",btn.accessibilityIdentifier);
                    
                }
                else
                {
                    btn.accessibilityIdentifier = [NSString stringWithFormat:@"%@",[subArray objectAtIndex:i]];
                }
                [btn addTarget:self action:@selector(subMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//                btn.layer.borderWidth = 1;
//                btn.layer.borderColor = [UIColor blackColor].CGColor;
//                btn.layer.cornerRadius = 5;
//                btn.clipsToBounds  =YES;
                
                [self.subMenuScroll addSubview:btn];
                x = x + btn.frame.size.width+1;
                
            }
            self.subMenuScroll.contentSize = CGSizeMake(x, self.subMenuScroll.frame.size.height);
            if (self.subMenuScroll.contentSize.width>self.subMenuScroll.frame.size.width) {
                self.btn_sub_left.hidden = FALSE;
                self.btn_sub_right.hidden = FALSE;
            }
            else
            {
                self.btn_sub_left.hidden = TRUE;
                self.btn_sub_right.hidden = TRUE;
                
            }
            [UIView animateWithDuration:.25 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.subMenuScroll.frame  = CGRectMake(self.subMenuScroll.frame.origin.x, self.subMenuScroll.frame.origin.y+self.subMenuScroll.frame.size.height, self.subMenuScroll.frame.size.width,self.subMenuScroll.frame.size.height);
                
            } completion:^(BOOL finished) {
                
            }];
            
        }];
        
    }
    else
    {
        [self.subMenuScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        btn.accessibilityIdentifier = @"";
        int x;
        int btn_height = self.subMenuScroll.frame.size.height-7;
        int btn_width = 110;
        int imageSet = 10;
        btn_width = 90;
        for (int i = 0; i<subArray.count; i++) {
            if (i==0)
            {
                x = 5;
            }
            
            UIImageView *imgview1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Q.png"]];
            UIImage *img;
            if (i<imageSet && [menuImagesFor containsObject:subArray_key])
            {
                img = [UIImage imageNamed:[subArray objectAtIndex:i]];
                imgview1.image = img;
                imgview1.frame = CGRectMake(x, 3, img.size.width, btn_height);
                if ([downArrowException containsObject:[subArray objectAtIndex:i]])
                {
                    imgview1.frame = CGRectMake(x, 3, img.size.width+20, btn_height);
                }
            }
            else
            {
                imgview1.frame = CGRectMake(x, 3, btn_width/2, btn_height);
                imgview1.frame = CGRectMake(x, 3, btn_width-(btn_width/3), btn_height);
            }
            
            imgview1.backgroundColor = [UIColor clearColor];
            imgview1.contentMode = UIViewContentModeScaleAspectFit;
            [self.subMenuScroll addSubview:imgview1];
            
            UIImage *img1;
            UIImageView *arrow_img;
            UIButton *sender_btn = btn; // changed 05-02-2016
            NSString *str = [NSString stringWithFormat:@"%@ & %@",sender_btn.titleLabel.text,[subArray objectAtIndex:i]];
            NSLog(@"%@",[self.subMenusOptions valueForKey:str]);
            
            if ([self.subMenusOptions valueForKey:str]) {
                //            if (![downArrowException containsObject:[subArray objectAtIndex:i]]) {
                arrow_img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downaerrow"]];
                img1 = [UIImage imageNamed:@"downaerrow"];
                if (img!=nil)
                {
                    arrow_img.frame = CGRectMake(x+img.size.width, 3, img1.size.width, btn_height);
                }
                else
                {
                    arrow_img.frame = CGRectMake(x+btn_width/2, 3, btn_width/2, btn_height);
                    arrow_img.frame = CGRectMake(x+btn_width-(btn_width/3), 3, btn_width/3, btn_height);
                }
                arrow_img.backgroundColor = [UIColor clearColor];
                arrow_img.contentMode = UIViewContentModeScaleAspectFit;
                [self.subMenuScroll addSubview:arrow_img];
            }
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(x, 3, btn_width, btn_height);
            if (![menuImagesFor containsObject:subArray_key])
            {
                [btn setTitle:[subArray objectAtIndex:i] forState:UIControlStateNormal];
            }
            else
            {
                btn.frame = CGRectMake(x, 3, imgview1.frame.size.width+arrow_img.frame.size.width+5, btn_height);
            }
            btn.tag = i ;
            [btn addTarget:self action:@selector(subMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.accessibilityIdentifier = [NSString stringWithFormat:@"%@ & %@",sender_btn.titleLabel.text,[subArray objectAtIndex:i]];
            NSLog(@"%@",btn.accessibilityIdentifier);
            
            [self.subMenuScroll addSubview:btn];
            x = x + btn.frame.size.width+1;
            
        }
        self.subMenuScroll.contentSize = CGSizeMake(x, self.subMenuScroll.frame.size.height);
        if (self.subMenuScroll.contentSize.width>self.subMenuScroll.frame.size.width) {
            self.btn_sub_left.hidden = FALSE;
            self.btn_sub_right.hidden = FALSE;
        }
        else
        {
            self.btn_sub_left.hidden = TRUE;
            self.btn_sub_right.hidden = TRUE;
            
        }
    }
}
-(void)hideOptionMenu
{
    UIView *removeoptionsView = [self.view viewWithTag:9999];
    [UIView animateWithDuration:.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.isOptionMenuOpened = FALSE;
        removeoptionsView.frame = CGRectMake(removeoptionsView.frame.origin.x, removeoptionsView.frame.origin.y, removeoptionsView.frame.size.width, 0);
        
    } completion:^(BOOL finished) {
        [removeoptionsView removeFromSuperview];
    }];
}
- (void)subMenuButtonClicked:(UIButton*)sender
{
    [UIView animateWithDuration:.25 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if ([self.view viewWithTag:9999]!=nil)
        {
            self.isOptionMenuOpened = FALSE;

            UIView *removeoptionsView = [self.view viewWithTag:9999];
            removeoptionsView.frame = CGRectMake(removeoptionsView.frame.origin.x, removeoptionsView.frame.origin.y, removeoptionsView.frame.size.width, 0);
        }
        
    } completion:^(BOOL finished) {
        UIView *removeoptionsView = [self.view viewWithTag:9999];
        [removeoptionsView removeFromSuperview];
        self.isOptionMenuOpened = TRUE;

        NSLog(@"%@",sender.accessibilityIdentifier);
        NSLog(@"%@",[self.subMenusOptions valueForKey:sender.accessibilityIdentifier]);
        NSArray *options_array = [self.subMenusOptions valueForKey:sender.accessibilityIdentifier];
        UIView *optionsView;
        UIView *container;
        if (options_array.count>0) {
            
            optionsView = [[UIView alloc]initWithFrame:self.alphabetView.frame];
            optionsView.tag = 9999;
            optionsView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:optionsView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideOptionMenu)];
            tap.numberOfTapsRequired = 1;
            [optionsView addGestureRecognizer:tap];

            UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, optionsView.frame.size.width, optionsView.frame.size.height)];
            container.backgroundColor = [UIColor whiteColor];
            container.tag = 99999;
            [optionsView addSubview:container];
            BOOL isIpad = NO;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
                isIpad = YES;
            }
            
            int x = 5;
            int y = 5;
            int h= (isIpad?80:55);  // changed 08-02-2016 // changed iphone font 80 to 55
            int w= (isIpad?80:55);  // changed 08-02-2016 // changed iphone font 80 to 55
            for (int i=0;i<options_array.count;i++)
            {
                if (x+w>optionsView.frame.size.width) { // changed 08-02-2016 // changed x+80 to x+w
                    x = 5;
                    y = y + h +10;
                }
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(x, y, w, h);
                if ([UIImage imageNamed:[options_array objectAtIndex:i]]!=nil&&![[options_array objectAtIndex:i] isEqualToString:@"sin"]&&![[options_array objectAtIndex:i] isEqualToString:@"cos"]&&![[options_array objectAtIndex:i] isEqualToString:@"tan"]&&![[options_array objectAtIndex:i] isEqualToString:@"cot"]&&![[options_array objectAtIndex:i] isEqualToString:@"csc"]&&![[options_array objectAtIndex:i] isEqualToString:@"sec"])
                {
                    [btn setImage:[UIImage imageNamed:[options_array objectAtIndex:i]] forState:UIControlStateNormal];
                }
                else
                {
                    
                    UIFont *font = [UIFont boldSystemFontOfSize:25];
                    
                    if ([[options_array objectAtIndex:i] isEqualToString:@"sinn"]||[[options_array objectAtIndex:i] isEqualToString:@"cosn"]||[[options_array objectAtIndex:i] isEqualToString:@"tann"]||[[options_array objectAtIndex:i] isEqualToString:@"cotn"]||[[options_array objectAtIndex:i] isEqualToString:@"cscn"]||[[options_array objectAtIndex:i] isEqualToString:@"secn"]) {
                        //cotn,cscn,secn
                        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[options_array objectAtIndex:i]
                                                                                                             attributes:@{NSFontAttributeName: font}];
                        [attributedString setAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                                                          , NSBaselineOffsetAttributeName : @10} range:NSMakeRange(3, 1)];
                        
                        [btn setAttributedTitle:attributedString forState:UIControlStateNormal];
                        btn.titleLabel.attributedText = attributedString;
                        
                    }
                    else
                    {
                        [btn setTitle:[options_array objectAtIndex:i] forState:UIControlStateNormal];
                    }
                    
                    [btn setTitle:[options_array objectAtIndex:i] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
                    
                }
                btn.accessibilityIdentifier = [options_array objectAtIndex:i];
                [btn addTarget:self action:@selector(pushMenuItem:) forControlEvents:UIControlEventTouchUpInside];
//                btn.layer.borderWidth = 1;
//                btn.layer.borderColor = [UIColor grayColor].CGColor;
//                btn.layer.cornerRadius = 5;
//                btn.clipsToBounds  =YES;

                [container addSubview:btn];
                x = x + w + 10;
            }
            y = y + h + 10;
            
            container.layer.borderWidth = 2;
            container.layer.borderColor = [UIColor grayColor].CGColor;
            container.layer.cornerRadius = 2;
            container.clipsToBounds  =YES;
            
            container.frame = CGRectMake(container.frame.origin.x, container.frame.origin.y, container.frame.size.width, y);
            
            NSLog(@"%@",container.subviews);
            NSLog(@"%@",self.mainMenuScroll);
        }
        else
        {
            NSLog(@"%@",INTERSECTION_ascii);
            NSLog(@"sender.accessibilityIdentifier : %@",sender.accessibilityIdentifier);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([sender.accessibilityIdentifier isEqualToString:@"Basic Math & exponent"]||[sender.accessibilityIdentifier isEqualToString:@"exponent"]) {
                btn.accessibilityIdentifier = @"exponent_ipad";
            }
            if ([sender.accessibilityIdentifier isEqualToString:@"Basic Math & scientific"]||[sender.accessibilityIdentifier isEqualToString:@"Pre-Algebra & scientific"])
            {
                btn.accessibilityIdentifier = @"tenexponent_ipad";
            }
            if ([sender.accessibilityIdentifier isEqualToString:@"Basic Math & point"] || [sender.accessibilityIdentifier isEqualToString:@"Pre-Algebra & point"] || [sender.accessibilityIdentifier isEqualToString:@"Algebra & point"] ||[sender.accessibilityIdentifier isEqualToString:@"point"])
            {
                btn.accessibilityIdentifier = @"point_ipad";
            }
            if ([sender.accessibilityIdentifier isEqualToString:@"series"])
            {
                btn.accessibilityIdentifier = @"series_ipad";
            }
            if ([sender.accessibilityIdentifier isEqualToString:@"Basic Math & fraction"]||[sender.accessibilityIdentifier isEqualToString:@"Pre-Algebra & fraction"]||[sender.accessibilityIdentifier isEqualToString:@"Algebra & fraction"]||[sender.accessibilityIdentifier isEqualToString:@"Chemistry & fraction"]||[sender.accessibilityIdentifier isEqualToString:@"Linear Algebra & fraction"]||[sender.accessibilityIdentifier isEqualToString:@"Finite Math & fraction"]||[sender.accessibilityIdentifier isEqualToString:@"Statistics & fraction"]||[sender.accessibilityIdentifier isEqualToString:@"Calculus & fraction"]||[sender.accessibilityIdentifier isEqualToString:@"Precalculus & fraction"]||[sender.accessibilityIdentifier isEqualToString:@"Trigonometry & fraction"]||[sender.accessibilityIdentifier isEqualToString:@"fraction"])
            {
                btn.accessibilityIdentifier = @"fraction_ipad";
            }
            if ([sender.accessibilityIdentifier isEqualToString:@"Basic Math & absolute"]||[sender.accessibilityIdentifier isEqualToString:@"Pre-Algebra & absolute"]||[sender.accessibilityIdentifier isEqualToString:@"Algebra & absolute"]||[sender.accessibilityIdentifier isEqualToString:@"Chemistry & absolute"]||[sender.accessibilityIdentifier isEqualToString:@"Linear Algebra & absolute"]||[sender.accessibilityIdentifier isEqualToString:@"Finite Math & absolute"]||[sender.accessibilityIdentifier isEqualToString:@"Statistics & absolute"]||[sender.accessibilityIdentifier isEqualToString:@"Calculus & absolute"]||[sender.accessibilityIdentifier isEqualToString:@"Precalculus & absolute"]||[sender.accessibilityIdentifier isEqualToString:@"Trigonometry & absolute"]||[sender.accessibilityIdentifier isEqualToString:@"absolute"])
            {
                btn.accessibilityIdentifier = @"absolute_ipad";
            }
            if ([sender.accessibilityIdentifier isEqualToString:@"limit"])
            {
                btn.accessibilityIdentifier = @"limit_ipad";
            }
            if ([sender.accessibilityIdentifier isEqualToString:@"fx"])
            {
                btn.accessibilityIdentifier = @"fx_ipad";
            }
            //TODO:31-7-2015
            if ([sender.accessibilityIdentifier isEqualToString:@"aerrow"])
            {
                btn.accessibilityIdentifier = @"aerrow_ipad";
            }
            if ([sender.accessibilityIdentifier isEqualToString:@"factorial"])
            {
                btn.accessibilityIdentifier = @"factorial_ipad";
            }
            
            [self pushMenuItem:btn];
            
            
        }
        [UIView animateWithDuration:.25 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (options_array.count>0)
            {
                container.frame = CGRectMake(container.frame.origin.x, container.frame.origin.y, container.frame.size.width, container.frame.size.height);
            }
            
        } completion:^(BOOL finished) {
        }];
        
    }];
}
- (void)pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
    [self.delegate performSelector:@selector(pushMenuItem:) withObject:sender];
}
-(IBAction)setupMainMenu:(id)sender
{
    int x;
    int btn_height = self.mainMenuScroll.frame.size.height;
    
    /*
    // changed 05-02-2016
    viewButton = [[UIView alloc] init];
    viewButton.frame=CGRectMake(0, 0, self.mainMenuScroll.frame.size.width, self.mainMenuScroll.frame.size.height);
    viewButton.backgroundColor=[UIColor clearColor];
    [self.mainMenuScroll addSubview:viewButton];
    */
    
    UIButton *btn1;
    for (int i = 0; i<self.menuArray.count;i++)
    {
        if (i==0)
        {
            x = 5;
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[self.menuArray objectAtIndex:i] forState:UIControlStateNormal];
        BOOL isIpad = NO;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            isIpad = YES;
        }
        if (isIpad)
        {
            NSLog(@"%@",[UIFont fontNamesForFamilyName:@"Arial"]);
            btn.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:24.5];
        }
        NSString *someString = [self.menuArray objectAtIndex:i];
        UIFont *yourFont =  btn.titleLabel.font;
        CGSize stringBoundingBox = [someString sizeWithFont:yourFont];
        NSLog(@"%f",stringBoundingBox.width);
        NSLog(@"%f",stringBoundingBox.height);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, 0, stringBoundingBox.width+15, btn_height);
        //        [btn setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.3]];
        [btn addTarget:self action:@selector(mainMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i ;
        btn.userInteractionEnabled=YES; // changed 06-02-2016
        [self.mainMenuScroll addSubview:btn]; // changed 05-02-2016
        
        // changed 06-02-2016
        
//        NSString *someString = [self.menuArray objectAtIndex:i];
//        UIFont *yourFont =  btn.titleLabel.font;
//        CGSize stringBoundingBox = [someString sizeWithFont:yourFont];
//        UILabel * lblText = [[UILabel alloc] init];
//        lblText.frame=CGRectMake(x, 0, stringBoundingBox.width+15, btn_height);
        
//        self.mainMenuScroll.accessibilityActivationPoint=CGPointMake(btn.frame.size.width,btn.frame.size.height);
        // changed 05-02-2016
        /*
        UIImageView *imgViewTemp = [[UIImageView alloc] init];
        imgViewTemp.frame=btn.frame;
        imgViewTemp.backgroundColor=[UIColor clearColor];
        imgViewTemp.tag=btn.tag;
        imgViewTemp.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainMenuButtonClicked:)];
                tap.numberOfTapsRequired = 1;
//        tap.cancelsTouchesInView=YES;
        tap.view.tag=btn.tag;
        [imgViewTemp addGestureRecognizer:tap];
        
        [self.mainMenuScroll addSubview:imgViewTemp];
        */
        //
       
        if (i==0)
        {
            btn1 = btn;
        }
        NSLog(@"%@",btn);
        x = x + btn.frame.size.width+1;
    }
    btn1.accessibilityIdentifier = @"initial";
    [self mainMenuButtonClicked:btn1];
    self.mainMenuScroll.contentSize = CGSizeMake(x, self.mainMenuScroll.frame.size.height);

}

// changed 06-02-2016

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self.mainMenuScroll)
    {
        if (scrollView.contentOffset.x<0) {
            scrollView.contentOffset=CGPointMake(0, scrollView.contentOffset.y);
        }
        
        if (scrollView.contentOffset.x<scrollView.contentSize.width-scrollView.frame.size.width)
        {
            
        }else{
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width-scrollView.frame.size.width, scrollView.contentOffset.y);
        }
        
        [self.view bringSubviewToFront:self.mainMenuScroll];
        self.mainMenuScroll.scrollEnabled = YES;
    }
    
}



// changed 06-02-2016

@end
