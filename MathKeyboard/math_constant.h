//
//  math_constant.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 16/06/15.
//
//

#ifndef MathFriendzy_math_constant_h
#define MathFriendzy_math_constant_h

//New file by siddhi infosoft

#import "FractionView.h"
#import "MixedNumberView.h"
#import "OperationView.h"
#import "OperationView1.h"
#import "SquareRoot2View.h"
#import "ExponentView.h"
#import "ExponentEView.h"
#import "ExponentDownView.h"
#import "TenExponentView.h"
#import "PointView.h"
#import "ParenthesisView.h"
#import "TrigonometricView.h"
#import "TrigonometricView2.h"
#import "LogView.h"
#import "LogView2.h"
#import "SigmaView.h"
#import "LimitView.h"
#import "FofXView.h"
#import "PermutationOrCombinationView.h"
#import "AvenirView.h"
#import "AvenirBoxView.h"
#import "ExponentPMView.h"
#import "AbsoluteView.h"
#import "UIView+UIView_Expanded.h"

//#import "LAGlobal.h"

#define squreRoot_ascii @"\u221A"
#define rightArrow_ascii @"\u279E" //@"\u279D"//TODO:31-7-2015
#define INTERSECTION_ascii @"\u2229"
#define UNION_ascii @"\u222A"
#define PIE_ascii @"π"
#define Theta @"ø"
#define degree_ascii1 @"\u00B0F"
#define degree_ascii2 @"\u00B0C"
#define degree_ascii3 @"°"
#define degree_ascii @"\u00B0"
#define sigma_ascii @"\u2211"
#define avenir_ascii @"\u222B"
#define multiplication_ascii @"\u00D7"
#define negative_ascii @"\u2212"
#define nsquareroot_ascii @"\u221A"


#define sigma_ascii @"\u2211"
#define alpha_ascii @"\u03B1"
#define mu_ascii @"\u00B5"
#define sigma_alpha_ascii @"\u03C3"

#define xbar_ascii @"x\u0305"
#define mu_xbar_ascii @"\u00B5"xbar_ascii
#define sigma_xbar_ascii @"\u03C3"xbar_ascii



#define math_font_size 30
#define space_between_view 2
#define extra_textfield_space 3
#define math_font_name @"Arial"


//Changes on 3-9-2015
/*
 
 #define isIpad?math_font1:math_font1_iphone [UIFont systemFontOfSize:22.0f]
 #define isIpad?math_font2:math_font2_iphone [UIFont systemFontOfSize:18.0f]
 #define isIpad?math_font3:math_font3_iphone [UIFont systemFontOfSize:26.0f]

 */

#define math_font1 [UIFont systemFontOfSize:20.0f]
#define math_font2 [UIFont systemFontOfSize:20.0f]
#define math_font3 [UIFont systemFontOfSize:24.0f]
#define math_font4 [UIFont systemFontOfSize:14.0f]

#define math_script_font [UIFont systemFontOfSize:15.0]

// ---------  iPhone Font  --------------
#define math_font1_iphone [UIFont systemFontOfSize:17.0f]
#define math_font2_iphone [UIFont systemFontOfSize:17.0f]
#define math_font3_iphone [UIFont systemFontOfSize:20.0f]
#define math_font4_iphone [UIFont systemFontOfSize:14.0f]

#define math_script_font_iphone [UIFont systemFontOfSize:11.0f]

#define math_font_size_iphone 25

// --------------------------------------

//#define isIpad?math_script_font:math_script_font_iphone [UIFont systemFontOfSize:14.0]


#define tint_Color [[UIColor blueColor] colorWithAlphaComponent:0.5f]

#define box_back_color [[UIColor greenColor] colorWithAlphaComponent:0.2];

#define textField_identifier @"custom"
#define textField_container @"txt_container"
#define sqrt_textField_hint @"sqrt"
#define sqrt_view_id @"sqrtView"
#define point_view_id @"pointView"
#define parenthesis_view_id @"parenthesisView"
#define absolute_view_id @"absoluteView"
#define nsqrt_view_id @"nsqrtView"
#define fraction_view_id @"fractionView"
#define mixedFraction_view_id @"mixedFractionView"
#define operation_view_id @"operationView"
#define exponent_view_id @"exponentView"
#define exponent_e_view_id @"exponent_e_View"
#define exponent_theta_view_id @"exponent_theta_View"
#define exponent_i_view_id @"exponent_i_View"
#define down_exponent_view_id @"exponentdownView"
#define plus_exponent_view_id @"ExponentPView"
#define minus_exponent_view_id @"ExponentMView"
#define tenexponent_view_id @"tenExponentView"
#define limit_view_id @"limitView"
#define fx_view_id @"fxView"
#define permutation_view_id @"permutationView"
#define combination_view_id @"combinationView"

#define avenir_view_id @"avenirView"
#define avenirBox_view_id @"avenirBoxView"


#define precalculus_sigma_id @"precalculus_sigma_view"

#define alpha_view_id @"alphaview"
#define mu_view_id @"muview"
#define sigma_view_id @"sigmaview"


#define trigonometric_log_id @"trigonometric_log_view"
#define trigonometric_ln_id @"trigonometric_ln_view"
#define trigonometric_logn_id @"trigonometric_logn_view"

#define trigonometric_sin_id @"trigonometric_sin_view"
#define trigonometric_arcsin_id @"trigonometric_arcsin_view"
#define trigonometric_sinn_id @"trigonometric_sinn_view"
#define trigonometric_sinh_id @"trigonometric_sinh_view"

#define trigonometric_cos_id @"trigonometric_cos_view"
#define trigonometric_arccos_id @"trigonometric_arccos_view"
#define trigonometric_cosn_id @"trigonometric_cosn_view"
#define trigonometric_cosh_id @"trigonometric_cosh_view"

#define trigonometric_tan_id @"trigonometric_tan_view"
#define trigonometric_arctan_id @"trigonometric_arctan_view"
#define trigonometric_tann_id @"trigonometric_tann_view"
#define trigonometric_tanh_id @"trigonometric_tanh_view"

#define trigonometric_sec_id @"trigonometric_sec_view"
#define trigonometric_arcsec_id @"trigonometric_arcsec_view"
#define trigonometric_secn_id @"trigonometric_secn_view"
#define trigonometric_sech_id @"trigonometric_sech_view"

#define trigonometric_csc_id @"trigonometric_csc_view"
#define trigonometric_arccsc_id @"trigonometric_arccsc_view"
#define trigonometric_cscn_id @"trigonometric_cscn_view"
#define trigonometric_csch_id @"trigonometric_csch_view"

#define trigonometric_cot_id @"trigonometric_cot_view"
#define trigonometric_arccot_id @"trigonometric_arccot_view"
#define trigonometric_cotn_id @"trigonometric_cotn_view"
#define trigonometric_coth_id @"trigonometric_coth_view"


#define eq_seprator @"@"
#define val_seprator @"#"

#define sqrt_textField_update @"update_textField_sqrt"


#define operation_plus @"op_plus"
#define operation_minus @"op_minus"
#define operation_equal @"op_equal"
#define operation_multiplication @"op_multi"
#define operation_devide @"op_divide"
#define operation_union @"op_union"
#define operation_intersection @"op_intersection"
#define operation_pie @"op_pi"
#define operation_factorial @"op_factorial"//
#define operation_percentage @"op_percentage"
#define operation_rarrow @"op_rarrow"
#define operation_xbar @"op_xbar"
#define operation_infinity @"op_infinity"
#define operation_muxbar @"op_muxbar"
#define operation_sigmaxbar @"op_sigmaxbar"
#define operation_grtthanorequal @"op_goe"
#define operation_lessthanorequal @"op_loe"
#define operation_grtthan @"op_grthan"
#define operation_lessthan @"op_lethan"
#define operation_degree @"op_degree"


#define str_sqrt @"sqrt#"
#define str_nsqrt @"nsqrt#"
#define str_fraction @"fraction#"
#define str_mixed_fraction @"mfraction#"
#define str_operation @"op#"
#define str_general_text @"text#"
#define str_exponent @"expo#"
#define str_exponent_e @"expo_e#"
#define str_exponent_theta @"expo_theta#"
#define str_exponent_i @"expo_i#"
#define str_point @"point#"
#define str_parenthesis @"parenthesis#"
#define str_absolute @"absolute#"
#define str_downexponent @"downexpo#"
#define str_plusexponent @"plusexpo#"
#define str_minusexponent @"minusexpo#"
#define str_tenexponent @"tenexpo#"
#define str_permutation @"permutation#"
#define str_combination @"combination#"
#define str_avenirBox @"avenirBox#"
#define str_fx @"fx#"
#define str_limit @"limit#"

#define str_avenir @"avenir#"

#define str_alpha @"alpha#"
#define str_mu @"mu#"
#define str_sigma @"sigma#"

#define str_precalculus_sigma @"precalculus_sigma#"

#define str_trigonometric_log @"trigo_log#"
#define str_trigonometric_ln @"trigo_ln#"
#define str_trigonometric_logn @"trigo_logn#"

#define str_trigonometric_sin @"trigo_sin#"
#define str_trigonometric_arcsin @"trigo_arcsin#"
#define str_trigonometric_sinn @"trigo_sinn#"
#define str_trigonometric_sinh @"trigo_sinh#"

#define str_trigonometric_cos @"trigo_cos#"
#define str_trigonometric_arccos @"trigo_arccos#"
#define str_trigonometric_cosn @"trigo_cosn#"
#define str_trigonometric_cosh @"trigo_cosh#"


#define str_trigonometric_tan @"trigo_tan#"
#define str_trigonometric_arctan @"trigo_arctan#"
#define str_trigonometric_tann @"trigo_tann#"
#define str_trigonometric_tanh @"trigo_tanh#"


#define str_trigonometric_sec @"trigo_sec#"
#define str_trigonometric_arcsec @"trigo_arcsec#"
#define str_trigonometric_secn @"trigo_secn#"
#define str_trigonometric_sech @"trigo_sech#"


#define str_trigonometric_csc @"trigo_csc#"
#define str_trigonometric_arccsc @"trigo_arccsc#"
#define str_trigonometric_cscn @"trigo_cscn#"
#define str_trigonometric_csch @"trigo_csch#"

#define str_trigonometric_cot @"trigo_cot#"
#define str_trigonometric_arccot @"trigo_arccot#"
#define str_trigonometric_cotn @"trigo_cotn#"
#define str_trigonometric_coth @"trigo_coth#"


#define textField_custom_width @"custom_width"
#define textField_fixed_height_view @"fixed_height"
#define placeholder_text_workarea @"Explain or solve the problem"
#define placeholder_text_tutorarea @"Create a formula and send it to your tutor"

//BOOL isIpad;
#define LOG_FUNCTION_START // NSLog(@"%s --> Start", __FUNCTION__);

#endif
