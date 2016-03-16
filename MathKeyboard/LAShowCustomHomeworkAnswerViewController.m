//
//  LAShowCustomHomeworkAnswerViewController.m
//  MathFriendzyDummies
//
//  Created by Gaurav Rajput on 2014-08-22.
//  Copyright (c) 2014 Gaurav Rajput. All rights reserved.
//

#import "LAShowCustomHomeworkAnswerViewController.h"

#import "LAStudentCustomAnswerCell.h"
#import "LAGlobal.h"
#import "LACustomHomeworkQuestion.h"

static CGFloat const part1 = 0.12;  // tiny diagonal will be 12% of the height of the text frame   // siddhi
static CGFloat const part2 = 0.35;  // medium sized diagonal will be 35% of the height of the text frame  // siddhi

NSString *answerCellIdentifier       = @"answerCell" ;

#define STUDENT_TEMP_MSG_PREFIX    @"Student&&&"
#define TEACHER_TEMP_MSG_PREFIX    @"Teacher&&&"
#define EXTRA_MSG_TO_REMOVE        @"&&&"
#define MESSAGE_SEPARATOR          @"$$$"

@interface LAShowCustomHomeworkAnswerViewController ()
{
//    LAResourceSearch *_resourceSearch;  // 14-03-2016
    BOOL             _isResourceAdded;
//    LAResourceNetworkHandler *_networkHandler; // 14-03-2016
    BOOL willRequestForTutor;
    BOOL isEditing;  // siddhi
    short numOfImageUploadRequestsSend;     //If there is both work image and question image need to send on server then, When we get response for both uploads then will duplicate the work area. If we do it on any one then may be other image will not copied to fixed work area by then.
}

@property (retain,nonatomic) IBOutlet UITableView *mainTableView ;
@property(strong,nonatomic) NSIndexPath           *shownMenuCellIndexPath ;
@property (weak, nonatomic) IBOutlet UIButton *btnViewResources;

@end

@implementation LAShowCustomHomeworkAnswerViewController

short senderTagWhenPlusPressed;
NSMutableArray *tempQuestionsArr;

@synthesize tableDataSource, isEditable, studentName, hwGrade, hwDate, isTeacherView, playerAnswers, hwTitle, selectedHwId, numOfProblems,  customHomeworkId; // 14-03-2014 remove playerInfo, tempScoreInfo

- (id)init{
    
    if (!isIpad) {
        self = [super initWithNibName:@"LAShowCustomHomeworkAnswerViewController_iPhone" bundle:nil];

    }else{
        self = [super initWithNibName:@"LAShowCustomHomeworkAnswerViewController_iPad" bundle:nil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)backButtonClicked
{
    
}


//Add photo changes
-(IBAction)viewHomeworkSheetsBtnClicked:(id)sender
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // the page height is calculated by taking the overall size of the UIWebView scrollView content size
    
    // then dividing it by the number of pages Core Graphics reported for the PDF file being shown
    
    CGFloat contentHeight = pdfWebView.scrollView.contentSize.height;
    
    CGFloat pdfPageHeight = contentHeight / pdfPageCounter;
    
    
    // also calculate what half the screen height is. no sense in doing this multiple times.
    
    CGFloat halfScreenHeight = (pdfWebView.frame.size.height / 2);
    
    // to calculate the page number, first get how far the user has scrolled
    
    float verticalContentOffset = pdfWebView.scrollView.contentOffset.y;
    
    
    // next add the halfScreenHeight then divide the result by the guesstimated pdfPageHeight
    
    pdfPageNumber = ceilf((verticalContentOffset + halfScreenHeight) / pdfPageHeight);
}

-(void)loadPdfInWebview
{
    
}

- (UIImage *)cropImageWithRect:(CGRect)cropRect{
    
    
    return nil;
}

-(IBAction)selectOrCutPhotoBtnClicked:(UIButton *)sender
{
    
}

-(UIImage *)getImageFromCurrentPageInPdf
{
        return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isIpad = NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        isIpad = YES;
    }
    
    numOfImageUploadRequestsSend = 0;
    willRequestForTutor = NO;   //If student will call the request tutor feature then it will true;
    
    shouldSaveOnBack = NO;              //If user visits the work area to see the correct answers then it will true and will save on back button, so student can't cheat.
    isCalledFromCalculateBtn = NO;
    currentRowSelected = -1;
    //// // // //if(LOGS_ON) NSLog(@"playerAnswers %@", playerAnswers); LACustomHwStudentAnswer
    workAreaSavedIndexes = [[NSMutableIndexSet alloc] init];
    
    
    if(self.isTeacherView)
    {
        btnViewSheets.hidden = YES;
        
//        _lblTeacherName.text    = [lang.mfLblStudentsName addColon];
        _lblTeacherNameVal.text = self.studentName;
        //btnSubmit.hidden = YES;
        //[btnSubmit setTitle:lang.lblSendNotes forState:UIControlStateNormal];
        
        //if(self.playerAnswers.count == 0)
            btnSubmit.hidden = YES;
        
        
        tempQuestionsArr = [[NSMutableArray alloc] initWithArray:self.tableDataSource];
        
    }
    else
    {
        btnCounterInfo.hidden = YES;
        btnSortQuestions.hidden = YES;
        
        seeAnswerView.hidden = YES;
        
        if(self.isEditable == NO)
           btnSubmit.hidden = YES;
        
    }
    
    if([self.playerAnswers count] > 0 && [self.playerAnswers count] < [self.tableDataSource count])
        [self.playerAnswers removeAllObjects];
    
    [self reorderAnswersOfStudent];
    
    
    lblFullColor.backgroundColor = [UIColor whiteColor];
    if(!self.isTeacherView)
    {
        lblViewAnswerColor.hidden = YES;
        lblStudentViewAnswer.hidden = YES;
    }
    
    self.playerAnswers = [[NSMutableArray alloc] init];
    if([self.playerAnswers count] == 0)
    {
        for (int i=0 ; i<10 ; i++ )
        {
            LACustomHwStudentAnswer *studAnswer = [[LACustomHwStudentAnswer alloc] init];
            //        studAnswer.questionNum              = question.questionNum;
            studAnswer.answersGiven             = [[NSMutableArray alloc] init];
            studAnswer.equationStep             = [[NSMutableArray alloc] init];//siddhi infosoft
            studAnswer.fixed_equationStep       = [[NSMutableArray alloc] init];//siddhi infosoft
            studAnswer.isAnswerGivenCorrect     = 0;
            studAnswer.workImageName            = [[NSString alloc] init];
            studAnswer.teacherCreditGiven       = [[NSString alloc] initWithFormat:@"%d", LATeacherCreditNone];
            studAnswer.isWorkAreaPublic         = 1;
            studAnswer.questionImage            = @"";
            
            studAnswer.workAreaMessage          = @"";
            studAnswer.fwaQuestionImage         = @"";
            studAnswer.fwaWorkAreaMessage       = @"";
            studAnswer.fwaWorkImageName         = @"";
            
            [self.playerAnswers addObject:studAnswer];
        }
    }
    
    _lblGradeVal.text       = [NSString stringWithFormat:@"%d", self.hwGrade];
    _lblDueDateVal.text     = self.hwDate;
    _lblUnitMeasureMsg.text = self.hwTitle;
    
    new_keypad = [[LANewCustomKeyboard alloc]initWithDelegate:self];
    new_keypad.isOptionMenuOpened = FALSE;
    new_keypad.view.frame=CGRectMake(new_keypad.view.frame.origin.x, new_keypad.view.frame.origin.y, self.view.frame.size.width-new_keypad.view.frame.origin.x-10, new_keypad.view.frame.size.height);
    UIButton *button = (UIButton *)[new_keypad.alphabetView viewWithTag:231];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.enabled=NO;
    
    UIButton *button1 = (UIButton *)[new_keypad.digitView viewWithTag:231];
    [button1 setTitle:@"" forState:UIControlStateNormal];
    button1.enabled=NO;
    
    
    senderTagWhenPlusPressed = -1;
    tempNotesAddedToAnswers  = [[NSMutableIndexSet alloc] init];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.frame=CGRectZero;
    lblTitle.font=[UIFont systemFontOfSize:22.0f];
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.text=[@"MathKeyboard" capitalizedString];
    lblTitle.textAlignment=NSTextAlignmentCenter;
    lblTitle.textColor=[UIColor blackColor];
    [lblTitle sizeToFit];
    self.navigationItem.titleView=lblTitle;
    
}

-(void)hideCustomMathKeypad
{
    [self.view endEditing:YES];
}

-(void)updateScoreAndCredits
{
   
}

-(void)reorderAnswersOfStudent
{
    
}


- (void)viewWillAppear:(BOOL)animated
{
    isEditing =FALSE; // Siddhi
    isFromKeyboardHide=YES; // siddhi
    
    if (!isIpad) /* iphone*/ {
        [_mainTableView registerNib:[UINib nibWithNibName:@"LAStudentCustomAnswerCell_iPhone" bundle:nil] forCellReuseIdentifier:answerCellIdentifier];
    }else{
        
        [_mainTableView registerNib:[UINib nibWithNibName:@"LAStudentCustomAnswerCell_iPad" bundle:nil] forCellReuseIdentifier:answerCellIdentifier];
        
    }
    [_mainTableView reloadData];
    
    [self addNotificationsToReceiveFromWorkArea];
    
    if(self.isTeacherView)
        [self updateScoreAndCredits];
    
    if(!self.isTeacherView)
        [self setGotHelpForQuestionAfterTutorSessionCreated];

    if(_isResourceAdded) {
        self.btnViewResources.hidden = NO;
    }
    else {
        self.btnViewResources.hidden = YES;
    }
    
    //Siddhi infosoft start
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

//custom homework changes //  code strat by siddhi
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSLog(@"keyboard show");
    isEditing = TRUE;
    isFromKeyboardHide=YES;
    LOG_FUNCTION_START
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    if(isIpad)
    {
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height/3.5), 0.0);
        } else {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width/5), 0.0);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height/2), 0.0);
        } else {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width/2), 0.0);
        }
    }
    
    _mainTableView.contentInset = contentInsets;
    _mainTableView.scrollIndicatorInsets = contentInsets;
    [_mainTableView scrollToRowAtIndexPath:self.shownMenuCellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSLog(@"keyboard hide");
    isEditing =FALSE;
    
    LOG_FUNCTION_START
    
    isFromKeyboardHide = NO;
    _mainTableView.contentInset = UIEdgeInsetsZero;
    _mainTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}
//  code end by siddhi

-(void)addNotificationsToReceiveFromWorkArea
{
}

//Will check to see if need to set got help status for the question.
-(void)setGotHelpForQuestionAfterTutorSessionCreated
{
}

-(void)updateWorkImgName:(NSNotification *)notifInfo
{
    //NSLog(@"currentRowSelected %d", currentRowSelected);
    if(currentRowSelected >= 0)
    {
        [tempNotesAddedToAnswers addIndex:currentRowSelected];      //will save on back if teacher make any changes to the work area.
        //[self saveImageOnServer:[[self.playerAnswers objectAtIndex:index] workImageName]];
        [self saveImageOnServer:[notifInfo object]];
        
        if(self.isTeacherView == NO)        //If student is viewing and changes something on the work area screen then data will save on server on tap "Back" button.
        {
            shouldSaveOnBack = YES;
        }
    }
}

-(void)updateWorkText:(NSNotification *)notifInfo
{
    //NSLog(@"text num %d", currentRowSelected);
    if(currentRowSelected >= 0)
    {
        if([notifInfo object] != nil)
        {
//            [[self.playerAnswers objectAtIndex:currentRowSelected] setWorkAreaMessage:[notifInfo object]];
            [tempNotesAddedToAnswers addIndex:currentRowSelected];
        }
        if([notifInfo userInfo] != nil)
        {
        }
        
        if(self.isTeacherView == NO)        //If student is viewing and changes something on the work area screen then data will save on server on tap "Back" button.
        {
            shouldSaveOnBack = YES;
        }
    }
}

//Add photo changes
-(void)questionImageChanged:(NSNotification *)notifInfo
{
    if(currentRowSelected >= 0)
    {
//        // // // //if(LOGS_ON) NSLog(@"image save on server==question image is chnaged then currentRowSelected");
        if([notifInfo object] != nil)
        {
//             // // // //if(LOGS_ON) NSLog(@"image save on server==question image is chnaged then [notifInfo object]");
            shouldSaveOnBack = YES;
           
        }
    }
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_QUES_IMG_ADDED object:nil];
}

-(void)saveQuestionImageOnServer:(NSString *)imgName
{

}


-(void)sendNotesToServerByTeacher
{
}


-(IBAction)submitBtnClicked:(id)sender
{
    
}

//This will called if student yet not answered any problem and go to get help from tutor.
-(void)saveAnswersToServerFromToturAreaScreen
{
    
}


-(void)saveAnswersToServer  //changes done by siddhi infosoft
{
    
}

//Chnages end by siddhi infosoft

-(void)saveWorkAreaImages
{
    
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (self.shownMenuCellIndexPath != nil) {
        LAStudentCustomAnswerCell *cell = (LAStudentCustomAnswerCell*)[_mainTableView cellForRowAtIndexPath:self.shownMenuCellIndexPath];
        [cell.editMenu removeFromSuperview];
        cell.editMenu = nil ;
        self.shownMenuCellIndexPath = nil ;
    }else
    {
    }
}

#pragma mark - UITableView datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath//added by siddhi infosoft
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    short int sections = 1 ;
    return sections ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LACustomHomeworkQuestion *qs = [self.tableDataSource objectAtIndex:indexPath.row];
    LAStudentCustomAnswerCell * cell = nil;
    //Changes start by siddhi infosoft
    
    
    if (1 > 0)
    {
        cell = (LAStudentCustomAnswerCell*)[_mainTableView dequeueReusableCellWithIdentifier:answerCellIdentifier forIndexPath:indexPath] ;
        
        [cell initializeWithOwner:self type:LAStudentCustomAnswerCellEquationType];
        [cell.updateScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.btnEdit addTarget:self action:@selector(onTapEdit:) forControlEvents:UIControlEventTouchUpInside];
        if (1 > 0)
        {
            NSMutableArray *studCorrectAnswers = [[NSMutableArray alloc] init];
           
            
            studCorrectAnswers = [[self.playerAnswers objectAtIndex:indexPath.row] answersGiven];
            LACustomHwStudentAnswer *obj = [self.playerAnswers objectAtIndex:indexPath.row];
            
            cell.txtMeasurementUnit.text    = @"";
            cell.txtStudentAnswer.text      = @"";
            cell.txtMeasurementUnitLeft.text = @"";
            
            NSString *str = [studCorrectAnswers firstObject];
            if (str.length>0)
            {
                if([str componentsSeparatedByString:senderSeprator].count>1)//12-8-2015
                {
                    str = [[str componentsSeparatedByString:senderSeprator] objectAtIndex:1];//12-8-2015
                }
                else
                {
                    str = [[str componentsSeparatedByString:senderSeprator] lastObject];//12-8-2015
                }
                
                str = [self convertStringWithoutOprator:str];
                
                str = [str stringByReplacingOccurrencesOfString:@"   " withString:@" "];
                str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
                
                NSLog(@"StringWithoutOperator is %@", str);
                
                [self updateViewWithEquationString:str andScrollview:cell.updateScroll Tag:(int)indexPath.row];
            }
            else
            {
                UITextField *updateTextField1 = [[UITextField alloc]initWithFrame:CGRectMake(1, 0, cell.updateScroll.frame.size.width-2, cell.updateScroll.frame.size.height)];
                updateTextField1.inputView =new_keypad.view;
                updateTextField1.accessibilityIdentifier = @"test";
                updateTextField1.delegate = self;
                updateTextField1.tag = 51;
                updateTextField1.font = isIpad?math_font1:math_font1_iphone;
                updateTextField1.tintColor = tint_Color;
                updateTextField1.backgroundColor = [UIColor clearColor];
                [cell.updateScroll addSubview:updateTextField1];
                [cell.updateScroll bringSubviewToFront:updateTextField1];
                
                // ------------------- When Answer On Work Area --------------
                
                
            }
        }
        cell.updateScroll.layer.borderColor = [UIColor blackColor].CGColor;
        cell.updateScroll.layer.borderWidth = 1;
        
        cell.txtEQuestionNum.text        = qs.questionNum ;
        
        cell.btnEdit.tag = indexPath.row ;
        if ((indexPath.row == self.shownMenuCellIndexPath.row) && self.shownMenuCellIndexPath != nil) {
//            // // // //if(LOGS_ON) NSLog(@"Equal path : %ld %ld  ",(long)indexPath.row,(long)self.shownMenuCellIndexPath.row);
            if (cell.editMenu == nil) {
            }
        }else{
        }
        
        if (qs.measurementUnit.length>0)
        {
            // changed 03-02-2016
            CGSize constraintSize = CGSizeMake(MAXFLOAT, cell.lblmeasurementUnit.frame.size.height);
            CGSize size = [qs.measurementUnit sizeWithFont:cell.lblmeasurementUnit.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            //            cell.lblmeasurementUnit.backgroundColor=[UIColor redColor];
            //
            
            int calculateLabelSize = cell.btnPlus.frame.origin.x-cell.updateScroll.frame.size.width-cell.updateScroll.frame.origin.x;
            
            if (calculateLabelSize<size.width)
            {
                cell.updateScroll.frame=CGRectMake(cell.updateScroll.frame.origin.x,cell.updateScroll.frame.origin.y, cell.btnPlus.frame.origin.x-size.width-cell.updateScroll.frame.origin.x-5-1, cell.updateScroll.frame.size.height);
                
                cell.lblmeasurementUnit.frame=CGRectMake(cell.updateScroll.frame.origin.x+cell.updateScroll.frame.size.width+3, cell.lblmeasurementUnit.frame.origin.y, size.width+1, cell.lblmeasurementUnit.frame.size.height);
            }
            else
            {
                cell.updateScroll.frame=CGRectMake(cell.updateScroll.frame.origin.x, cell.updateScroll.frame.origin.y, cell.updateScroll.frame.size.width, cell.updateScroll.frame.size.height);
                cell.lblmeasurementUnit.frame=CGRectMake(cell.updateScroll.frame.origin.x+cell.updateScroll.frame.size.width, cell.lblmeasurementUnit.frame.origin.y, cell.btnPlus.frame.origin.x-cell.updateScroll.frame.size.width-cell.updateScroll.frame.origin.x, cell.lblmeasurementUnit.frame.size.height);
            }
            
            cell.lblmeasurementUnit.text=qs.measurementUnit;
            cell.lblmeasurementUnit.hidden=NO;
        }
        else{
            cell.lblmeasurementUnit.hidden=YES;
        }
        
        [cell.updateScroll setShowsHorizontalScrollIndicator:NO];
        
    }//Changes end by siddhi infosoft
    [cell setEditable:self.isEditable];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    [cell.btnEdit setBackgroundImage:[UIImage imageNamed:@"blue_edit_icon"] forState:UIControlStateNormal];
    
    //If there is some input either from tutor or teacher then will show green icon to student.
    if ([[self.playerAnswers objectAtIndex:indexPath.row] opponentInput] || [[self.playerAnswers objectAtIndex:indexPath.row] workInput])
        [cell.btnEdit setBackgroundImage:[UIImage imageNamed:@"green_bar_ipad"] forState:UIControlStateNormal];
    
    //if(self.isTeacherView == NO)
    {
        cell.btnEdit.hidden = NO;
        if([[self.playerAnswers objectAtIndex:indexPath.row] answersGiven].count > 0)
        {
            if(self.isTeacherView)
            {
                if([[self.playerAnswers objectAtIndex:indexPath.row] workImageName] == nil || [[self.playerAnswers objectAtIndex:indexPath.row] workImageName].length == 0)
                {
                    //cell.btnEdit.hidden = YES;
                }
                else if([[self.playerAnswers objectAtIndex:indexPath.row] wasAnswerWrongFirstTime] == 1)
                {
                    //[cell.btnEdit setBackgroundImage:[UIImage imageNamed:@"red_edit_icon"] forState:UIControlStateNormal];
                }
            }
            else if(self.isTeacherView == NO)               //To show red work area image for student too.
            {
                if([[self.playerAnswers objectAtIndex:indexPath.row] wasAnswerWrongFirstTime] == 1)
                {
                    //[cell.btnEdit setBackgroundImage:[UIImage imageNamed:@"red_edit_icon"] forState:UIControlStateNormal];
                }
            }
            
        }
        else if([[self.playerAnswers objectAtIndex:indexPath.row] answersGiven].count == 0)
        {
            if(self.isTeacherView)
            {
                cell.btnEdit.hidden = YES;
            }
            else
            {
            }
        }
    }
    
    //If need to show both wrong and correct answers to teacher.
    if(self.isTeacherView)
    {
        if(tempIndexesForAnswers.count > 0)
        {
            if([tempIndexesForAnswers containsIndex:indexPath.row])
            {
                cell.contentView.backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    
    
    //IF blank answer was saved for the question then will show white background for that not red color.
    if([[[self.playerAnswers objectAtIndex:indexPath.row] answersGiven] count] == 1)
    {
        //        if([[[[self.playerAnswers objectAtIndex:indexPath.row] answersGiven] objectAtIndex:0] isEqualToString:@""] && ([[[self.playerAnswers objectAtIndex:indexPath.row] teacherCreditGiven] integerValue] == LATeacherCreditNone))
        //            cell.contentView.backgroundColor = [UIColor clearColor]; // changed siddhi
        if ([[[[self.playerAnswers objectAtIndex:indexPath.row] answersGiven] objectAtIndex:0] isEqualToString:@""])
        {
            if (qs.isAnswerAvailable) {
                cell.contentView.backgroundColor = [UIColor clearColor];
            }
        }
        
    }
    
    
    if([[[self.playerAnswers objectAtIndex:indexPath.row] answersGiven] count] == 0)
        cell.contentView.backgroundColor = [UIColor clearColor];
    
    //To show yellow row to teacher if student has viewed the correct answer.
    if(self.isTeacherView)
    {
        if([[self.playerAnswers objectAtIndex:indexPath.row] wasAnswerWrongFirstTime] == 1 && [[self.playerAnswers objectAtIndex:indexPath.row] isAnswerGivenCorrect] && [[[self.playerAnswers objectAtIndex:indexPath.row] teacherCreditGiven] integerValue] == LATeacherGivenFullCredit)
        {
//            cell.contentView.backgroundColor = SEEN_ANSWER_COLOR;
        }
    }
    
    cell.btnPlus.tag = indexPath.row;
    [cell.btnPlus addTarget:self action:@selector(onTapPlus:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.isTeacherView == NO)
    {
        cell.btnCounterStudents.hidden = YES;
        cell.btnPlus.hidden = YES;
        //if(customHwDetails.shouldShowAnswers && self.playerAnswers.count > 0 && [[self.playerAnswers objectAtIndex:indexPath.row] answersGiven].count > 0 && customHwDetails.willHwPlayFirstTime == NO)
    }
    else if(self.isTeacherView == YES)
    {
        cell.btnPlus.hidden = YES;
        
        float fontSize = 15.0;
        if(isIpad)
            fontSize = 22.0;
        
        NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize], NSFontAttributeName, [UIColor greenColor], NSForegroundColorAttributeName, nil];
        // Create the attributed string (text + attributes)
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d\n", qs.correctAttemptedStudentsCounter] attributes:subAttrs];
        [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", qs.wrongAttemptedStudentsCounter] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize], NSFontAttributeName, [UIColor redColor], NSForegroundColorAttributeName, nil]]];
        
        cell.btnCounterStudents.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        // you probably want to center it
        cell.btnCounterStudents.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
        //[cell.btnCounterStudents setTitle: @"1\n2" forState: UIControlStateNormal];
        
        [cell.btnCounterStudents setAttributedTitle:attributedText forState:UIControlStateNormal];
        
        //To show the plus button for the teacher when student had answered the questions at least once.
        //if(self.playerAnswers.count > 0 && [[self.playerAnswers objectAtIndex:indexPath.row] answersGiven].count > 0)
        //{
        //   cell.btnPlus.hidden = NO;
        //}
    }
    
    cell.txtEQuestionNum.text=[NSString stringWithFormat:@"%d",(int)indexPath.row+1];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell ;
}

-(void)updateAnswerForSingleAnswerCellWithStudentAnswer:(LACustomHwStudentAnswer*)studAns andQuestion:(LACustomHomeworkQuestion*)qs
{
    NSString *finalSTR = [NSString stringWithFormat:@"%@",[studAns.answersGiven objectAtIndex:0]];
    
    finalSTR = [self convertStringWithOprator:finalSTR];
    
    
    NSString *checkstring=@"";
    //    NSLog(@"%@",qs.correctAnswers);
    BOOL isOldHomework = TRUE;
    
    NSString *tmp_check = [qs.correctAnswers objectAtIndex:0];
    
    if (tmp_check.length>0)
    {
        NSArray *a = [tmp_check componentsSeparatedByString:eq_seprator];
        if (a.count>2)
        {
            isOldHomework = FALSE;
        }
        else
        {
            NSArray *a1 = [tmp_check componentsSeparatedByString:val_seprator];
            if (a1.count>1)
            {
                isOldHomework = FALSE;
            }
        }
    }
//    // // // //if(LOGS_ON)NSLog(@"%@",finalSTR);
//    // // // //if(LOGS_ON)NSLog(@"%@",qs.correctAnswers);
    
    NSRange range = [finalSTR rangeOfString:STUDENT_TEMP_MSG_PREFIX];//12-9-2015
    NSRange range1 = [finalSTR rangeOfString:TEACHER_TEMP_MSG_PREFIX];//12-9-2015
    if (range.length != 0)
    {
        finalSTR = [finalSTR stringByReplacingOccurrencesOfString:STUDENT_TEMP_MSG_PREFIX withString:@""];
    }
    else if(range1.length != 0)
    {
        finalSTR = [finalSTR stringByReplacingOccurrencesOfString:TEACHER_TEMP_MSG_PREFIX withString:@""];
    }
//    // // // //if(LOGS_ON)NSLog(@"%@",finalSTR);
//    // // // //if(LOGS_ON)NSLog(@"%@",qs.correctAnswers);
//    
    
    if (isOldHomework)
    {
//        // // // //if(LOGS_ON)NSLog(@"%@",[self changeFinalStringtoCompareStringForOldHomework:finalSTR]);
        checkstring = [self changeFinalStringtoCompareStringForOldHomework:finalSTR];
        if (checkstring.length>0 && qs!=nil)
        {
            
            if(studAns.answersGiven.count > 0)
                [studAns.answersGiven removeLastObject];
            if(finalSTR.length > 0)
            {
                studAns.answersGiven             = [NSMutableArray arrayWithObject:finalSTR] ;
            }
            
            if (qs.isAnswerAvailable)
            {
                
                
                NSString *tmp_check = [qs.correctAnswers objectAtIndex:0];
                if ([tmp_check isEqualToString:checkstring])
                {
                    studAns.isAnswerGivenCorrect     = TRUE;
                }
                else
                {
                    studAns.isAnswerGivenCorrect     = FALSE;
                }
                
                if(studAns.isAnswerGivenCorrect)
                {
                    // changed 03-02-2016 comment below code
                    studAns.teacherCreditGiven       = [NSString stringWithFormat:@"%d", LATeacherGivenFullCredit];
                    
                    if(studAns.gotHelpFromOthers)//if(studAnswer.haveSeenAnswer || studAnswer.wasAnswerWrongFirstTime || studAnswer.gotHelpFromOthers)
                    {
                        studAns.teacherCreditGiven = [NSString stringWithFormat:@"%d", LATeacherGivenHalfCredit];
                    }
                }else
                    studAns.teacherCreditGiven = [NSString stringWithFormat:@"%d", LATeacherGivenNoCredit];
            }
            //self.workImageName              = [dict objectForKey:@"workImage"];
//            // // // //if(LOGS_ON) NSLog(@"studAnswer.answersGiven %@", studAns.answersGiven);
            
        }
    }
    else
    {
        if (finalSTR.length>0 && qs!=nil)
        {
            
            if(studAns.answersGiven.count > 0)
                [studAns.answersGiven removeLastObject];
            if(finalSTR.length > 0 || ([self isValidEquationFromString:finalSTR]))
            {
                NSArray *array = [finalSTR componentsSeparatedByString:eq_seprator];
                if (array.count>1)
                {
                    
                }
                else
                {
                    
                    array = [finalSTR componentsSeparatedByString:val_seprator];
                    if (![[array objectAtIndex:0] isEqualToString:@"text"])
                    {
                        
                    }
                    else
                    {
                        //                        finalSTR = [array lastObject];//18-8-2015
                    }
                    
                    
                }
                studAns.answersGiven             = [NSMutableArray arrayWithObject:finalSTR] ;
            }
            
            NSString *originalString = [studAns.answersGiven firstObject];
            NSArray *a = [originalString componentsSeparatedByString:eq_seprator];
            NSMutableArray *operationArray =[[NSMutableArray alloc]init];
            for (NSString*str in a)
            {
                if ([self checkString:@"op#" inmainstring:str]) {
                    [operationArray addObject:str];
                }
            }
//            // // // //if(LOGS_ON)NSLog(@"%@",operationArray);
            BOOL checkReverceString = YES;
            for (NSString*str in operationArray)
            {
                if ([self checkString:@"op#+" inmainstring:str]||[self checkString:@"op#x" inmainstring:str]||[self checkString:@"op#=" inmainstring:str]) {
                }
                else if ([self checkString:@"op#op_plus" inmainstring:str]||[self checkString:@"op#op_multi" inmainstring:str]||[self checkString:@"op#op_equal" inmainstring:str]) {
                }
                else
                {
                    checkReverceString = NO;
                    break;
                }
            }
            
#warning structure change in - math_hw_custom_answers - table
#warning structure change in - math_hw_custom_results_details - table
            
            NSArray* reversedArray = [[a reverseObjectEnumerator] allObjects];
            NSString *reverseString = [reversedArray componentsJoinedByString:eq_seprator];
            
            // added by siddhi
            
            if (qs.correctAnswers.count>0)
            {
                NSString *strT=[qs.correctAnswers objectAtIndex:0];
                if ([strT length]>=4) {
                    NSString *trimmedString=[strT substringFromIndex:MAX((int)[strT length]-4, 0)]; //in case string is less than 4 characters long.
                    NSString *strOp=@"@";
                    if ([[trimmedString lowercaseString] isEqualToString:[NSString stringWithFormat:@"%@op#",strOp]]) {
                        strT = [strT substringToIndex:[strT length] - 4];
                        [qs.correctAnswers replaceObjectAtIndex:0 withObject:strT];
                    }
                }
            }
            // added by siddhi
            
            // compare - or negative same as op_mus
            reverseString = [reverseString stringByReplacingOccurrencesOfString:@"-" withString:@"op_minus"];
            //
            
            
            if (qs.isAnswerAvailable)
            {
                if(studAns.isAnswerGivenCorrect)
                {
                    // changed 03-02-2016 comment below code
                    studAns.teacherCreditGiven       = [NSString stringWithFormat:@"%d", LATeacherGivenFullCredit];
                    
                    if(studAns.gotHelpFromOthers)//if(studAnswer.haveSeenAnswer || studAnswer.wasAnswerWrongFirstTime || studAnswer.gotHelpFromOthers)
                    {
                        studAns.teacherCreditGiven = [NSString stringWithFormat:@"%d", LATeacherGivenHalfCredit];
                    }
                    //
                }
                else
                {
                    studAns.teacherCreditGiven = [NSString stringWithFormat:@"%d", LATeacherGivenNoCredit];
                }
            }
            
        }
    }
    
    
}


-(NSString *)getStringFromArr:(NSArray*)givenArr
{
    LOG_FUNCTION_START
    NSMutableString *resStr = nil;
    if([givenArr count] > 0)
    {
        for(NSString *item in givenArr)
        {
            if(resStr == nil)
                resStr = [[NSMutableString alloc]initWithString:item];
            else
                [resStr appendFormat:@",%@",item];
        }
        return resStr;
    }
    return nil;
}


-(BOOL)isBothArraysHavingSameStringObjects:(NSArray *)tempStrArr1 otherArr:(NSArray *)tempStrArr2
{
    tempStrArr1 = [tempStrArr1 sortedArrayUsingSelector:@selector(compare:)];
    tempStrArr2 = [tempStrArr2 sortedArrayUsingSelector:@selector(compare:)];
    
    // changes start siddhi
    NSString *strCompare1 = [[[self getStringFromArr:tempStrArr1] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    strCompare1 = [strCompare1 stringByReplacingOccurrencesOfString:@"-" withString:@"op_minus"];
    
    NSString *strCompare2 = [[[self getStringFromArr:tempStrArr2] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    strCompare2 = [strCompare2 stringByReplacingOccurrencesOfString:@"-" withString:@"op_minus"];
    
    if([strCompare1 isEqualToString:strCompare2])
    { return YES;}
    // changes end siddhi
    /*
     if([[Utitilty getStringFromArr:tempStrArr1] isEqualToString:[Utitilty getStringFromArr:tempStrArr2]])
     return YES;*/
    return NO;
}

// Code start siddhi
-(void)showAlertForAnswerOnWorkArea:(UITapGestureRecognizer*)sender
{
}
// Code end siddhi

-(IBAction)counterInfoBtnClicked:(id)sender
{
}

-(IBAction)sortQuestionsListByCorrectAnswersAttemptedByStudents:(UIButton *)sender
{
    sender.selected = !sender.selected;
    NSSortDescriptor *sortByDateDescriptor = nil;
    sortByDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"correctAttemptedStudentsCounter" ascending:sender.selected];
    [self.tableDataSource sortUsingDescriptors:[NSArray arrayWithObjects:sortByDateDescriptor, nil]];
    
    [self reorderAnswersOfStudent];
    [_mainTableView reloadData];
}


-(void)saveImageOnServer:(NSString *)imgName
{
}


-(void)onTapPlus:(UIButton *)sender
{
    
}


#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSLog(@"accessibilityIdentifier is %@",textField.accessibilityIdentifier);
    if (([textField.accessibilityIdentifier isEqualToString:textField_identifier]||[textField.accessibilityIdentifier isEqualToString:@"test"]))
    {
        if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
        {
            [new_keypad hideOptionMenu];//Added by Siddhi infosoft
        }
        activeTextfield = textField;
        
        // changed today 18-12-2015
        if ([activeTextfield.text isEqualToString:@"+"] || [activeTextfield.text isEqualToString:negative_ascii] || [activeTextfield.text isEqualToString:multiplication_ascii] || [activeTextfield.text isEqualToString:@"÷"] || [activeTextfield.text isEqualToString:@">"] || [activeTextfield.text isEqualToString:@"≥"] ||
            [activeTextfield.text isEqualToString:@"<"] || [activeTextfield.text isEqualToString:@"≤"] || [activeTextfield.text isEqualToString:@"="] || [activeTextfield.text isEqualToString:@"%"] ||[activeTextfield.text isEqualToString:@"π"] || [activeTextfield.text isEqualToString:UNION_ascii]||
            [activeTextfield.text isEqualToString:INTERSECTION_ascii] || [activeTextfield.text isEqualToString:rightArrow_ascii] || [activeTextfield.text isEqualToString:xbar_ascii] || [activeTextfield.text isEqualToString:sigma_xbar_ascii] || [activeTextfield.text isEqualToString:mu_xbar_ascii] || [activeTextfield.text isEqualToString:@"∞"] || [activeTextfield.text isEqualToString:@"!"])
        {
            activeTextfield.backgroundColor = [UIColor clearColor];
        }else{
            //            NSLog(@"%@",activeTextfield.accessibilityIdentifier);
            if ([textField.accessibilityIdentifier isEqualToString:@"test"]) {
                activeTextfield.backgroundColor = [UIColor clearColor];
            }else{
                activeTextfield.backgroundColor = box_back_color;
            }
        }
        //
        
        updateView.hidden=NO;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=alpha_keypad;
        [new_keypad changeKeyboard:btn]; // added 01-08-2015
        
        return YES;
    }
    
    if (textField.tag == 21) {
        //[self.view endEditing:YES];
        
        // MARK: Invoke custom keypad.
//        textField.inputView = keypad.view;
//        keypad.txtFieldInvoked = textField;
        
        textField.inputView=new_keypad.view;//Added by Siddhi infosoft
        activeTextfield = textField;//Added by Siddhi infosoft
        updateView.hidden=NO;
        
        return YES;
    }
   
    return NO;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    LAStudentCustomAnswerCell *cell = (LAStudentCustomAnswerCell *)[self superViewOfType:[LAStudentCustomAnswerCell class] forView:textField];
    if (cell) {
        NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
        currentTxtFieldRowNum = indexPath.row;
    }
}

-(NSString*)getFinalStringFromScrollView:(UIScrollView*)scroll
{
    NSString *eq_str =  @"";
    
    NSString *str =  @"";
    
    // // // //if(LOGS_ON)NSLog(@"%@",scroll.subviews);
    for (int i=0; i<scroll.subviews.count; i++)
    {
        UIView *v = [[scroll subviews]objectAtIndex:i];
        str = @"";
        if ([v.accessibilityLabel isEqualToString:sqrt_view_id]||[v.accessibilityLabel isEqualToString:permutation_view_id] ||[v.accessibilityLabel isEqualToString:minus_exponent_view_id]||[v.accessibilityLabel isEqualToString:plus_exponent_view_id]|| [v.accessibilityLabel isEqualToString:avenir_view_id] || [v.accessibilityLabel isEqualToString:avenirBox_view_id] ||[v.accessibilityLabel isEqualToString:combination_view_id]||[v.accessibilityLabel isEqualToString:fraction_view_id]||[v.accessibilityLabel isEqualToString:mixedFraction_view_id]||[v.accessibilityLabel isEqualToString:limit_view_id]||[v.accessibilityLabel isEqualToString:fx_view_id] || [v.accessibilityLabel isEqualToString:nsqrt_view_id]|| [v.accessibilityLabel isEqualToString:exponent_view_id]|| [v.accessibilityLabel isEqualToString:down_exponent_view_id]|| [v.accessibilityLabel isEqualToString:tenexponent_view_id]|| [v.accessibilityLabel isEqualToString:point_view_id]|| [v.accessibilityLabel isEqualToString:parenthesis_view_id] ||[v.accessibilityLabel isEqualToString:absolute_view_id] || [v.accessibilityLabel isEqualToString:precalculus_sigma_id] || [v.accessibilityLabel isEqualToString:exponent_i_view_id]|| [v.accessibilityLabel isEqualToString:exponent_e_view_id] || [v.accessibilityLabel isEqualToString:alpha_view_id] || [v.accessibilityLabel isEqualToString:mu_view_id] || [v.accessibilityLabel isEqualToString:sigma_view_id] || [v.accessibilityLabel isEqualToString:exponent_theta_view_id] || [v.accessibilityLabel isEqualToString:trigonometric_ln_id] || [v.accessibilityLabel isEqualToString:trigonometric_log_id] || [v.accessibilityLabel isEqualToString:trigonometric_logn_id] || [v.accessibilityLabel isEqualToString:trigonometric_sin_id] || [v.accessibilityLabel isEqualToString:trigonometric_arcsin_id] || [v.accessibilityLabel isEqualToString:trigonometric_sinh_id] || [v.accessibilityLabel isEqualToString:trigonometric_cos_id] || [v.accessibilityLabel isEqualToString:trigonometric_arccos_id] || [v.accessibilityLabel isEqualToString:trigonometric_cosh_id] || [v.accessibilityLabel isEqualToString:trigonometric_tan_id] || [v.accessibilityLabel isEqualToString:trigonometric_arctan_id] || [v.accessibilityLabel isEqualToString:trigonometric_tanh_id] || [v.accessibilityLabel isEqualToString:trigonometric_sec_id] || [v.accessibilityLabel isEqualToString:trigonometric_arcsec_id] || [v.accessibilityLabel isEqualToString:trigonometric_sech_id] || [v.accessibilityLabel isEqualToString:trigonometric_csc_id] || [v.accessibilityLabel isEqualToString:trigonometric_arccsc_id] || [v.accessibilityLabel isEqualToString:trigonometric_csch_id]  || [v.accessibilityLabel isEqualToString:trigonometric_cot_id] || [v.accessibilityLabel isEqualToString:trigonometric_arccot_id] || [v.accessibilityLabel isEqualToString:trigonometric_coth_id] || [v.accessibilityLabel isEqualToString:trigonometric_sinn_id] || [v.accessibilityLabel isEqualToString:trigonometric_cosn_id] || [v.accessibilityLabel isEqualToString:trigonometric_tann_id] || [v.accessibilityLabel isEqualToString:trigonometric_secn_id] || [v.accessibilityLabel isEqualToString:trigonometric_cscn_id] || [v.accessibilityLabel isEqualToString:trigonometric_cotn_id] )
        {
            if ([v.accessibilityLabel isEqualToString:sqrt_view_id])
            {
//                // // // //if(LOGS_ON)NSLog(@"this is sqrt view");
                str = [str stringByAppendingString:str_sqrt];
                
            }
            if ([v.accessibilityLabel isEqualToString:nsqrt_view_id])
            {
//                // // // //if(LOGS_ON)NSLog(@"this is nsqrt view");
                str = [str stringByAppendingString:str_nsqrt];
            }
            if ([v.accessibilityLabel isEqualToString:exponent_e_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is nsqrt view");
                str = [str stringByAppendingString:str_exponent_e];
            }
            if ([v.accessibilityLabel isEqualToString:alpha_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is alpha view");
                str = [str stringByAppendingString:str_alpha];
            }
            if ([v.accessibilityLabel isEqualToString:mu_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is mu view");
                str = [str stringByAppendingString:str_mu];
            }
            if ([v.accessibilityLabel isEqualToString:sigma_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is sigma view");
                str = [str stringByAppendingString:str_sigma];
            }
            if ([v.accessibilityLabel isEqualToString:permutation_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is fraction View");
                str = [str stringByAppendingString:str_permutation];
            }
            if ([v.accessibilityLabel isEqualToString:combination_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is fraction View");
                str = [str stringByAppendingString:str_combination];
            }
            
            if ([v.accessibilityLabel isEqualToString:exponent_theta_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is theta view");
                str = [str stringByAppendingString:str_exponent_theta];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_log_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is log view");
                str = [str stringByAppendingString:str_trigonometric_log];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_ln_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is ln view");
                str = [str stringByAppendingString:str_trigonometric_ln];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_logn_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is logn view");
                str = [str stringByAppendingString:str_trigonometric_logn];
            }
            if ([v.accessibilityLabel isEqualToString:exponent_i_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is nsqrt view");
                str = [str stringByAppendingString:str_exponent_i];
            }
            if ([v.accessibilityLabel isEqualToString:exponent_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is nsqrt view");
                str = [str stringByAppendingString:str_exponent];
            }
            if ([v.accessibilityLabel isEqualToString:minus_exponent_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is nsqrt view");
                str = [str stringByAppendingString:str_minusexponent];
            }
            if ([v.accessibilityLabel isEqualToString:plus_exponent_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is nsqrt view");
                str = [str stringByAppendingString:str_plusexponent];
            }
            if ([v.accessibilityLabel isEqualToString:down_exponent_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is nsqrt view");
                str = [str stringByAppendingString:str_downexponent];
            }
            if ([v.accessibilityLabel isEqualToString:tenexponent_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is nsqrt view");
                str = [str stringByAppendingString:str_tenexponent];
            }
            if ([v.accessibilityLabel isEqualToString:point_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is nsqrt view");
                str = [str stringByAppendingString:str_point];
            }
            if ([v.accessibilityLabel isEqualToString:parenthesis_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is nsqrt view");
                str = [str stringByAppendingString:str_parenthesis];
            }
            if ([v.accessibilityLabel isEqualToString:absolute_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is absolute view");
                str = [str stringByAppendingString:str_absolute];
            }
            if ([v.accessibilityLabel isEqualToString:precalculus_sigma_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is sigma view");
                str = [str stringByAppendingString:str_precalculus_sigma];
            }
            if ([v.accessibilityLabel isEqualToString:fraction_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is fraction View");
                str = [str stringByAppendingString:str_fraction];
            }
            if ([v.accessibilityLabel isEqualToString:mixedFraction_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is fraction View");
                str = [str stringByAppendingString:str_mixed_fraction];
            }
            if ([v.accessibilityLabel isEqualToString:limit_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is fraction View");
                str = [str stringByAppendingString:str_limit];
            }
            if ([v.accessibilityLabel isEqualToString:fx_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is fraction View");
                str = [str stringByAppendingString:str_fx];
            }
            if ([v.accessibilityLabel isEqualToString:avenir_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is fraction View");
                str = [str stringByAppendingString:str_avenir];
            }
            if ([v.accessibilityLabel isEqualToString:avenirBox_view_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is avenirBox View");
                str = [str stringByAppendingString:str_avenirBox];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_sin_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is sin view");
                str = [str stringByAppendingString:str_trigonometric_sin];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_arcsin_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is arcsin view");
                str = [str stringByAppendingString:str_trigonometric_arcsin];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_sinh_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is sinh view");
                str = [str stringByAppendingString:str_trigonometric_sinh];
            }
            
            if ([v.accessibilityLabel isEqualToString:trigonometric_cos_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is cos view");
                str = [str stringByAppendingString:str_trigonometric_cos];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_arccos_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is arccos view");
                str = [str stringByAppendingString:str_trigonometric_arccos];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_cosh_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is cosh view");
                str = [str stringByAppendingString:str_trigonometric_cosh];
            }
            
            if ([v.accessibilityLabel isEqualToString:trigonometric_tan_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is tan view");
                str = [str stringByAppendingString:str_trigonometric_tan];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_arctan_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is arctan view");
                str = [str stringByAppendingString:str_trigonometric_arctan];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_tanh_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is tanh view");
                str = [str stringByAppendingString:str_trigonometric_tanh];
            }
            
            if ([v.accessibilityLabel isEqualToString:trigonometric_sec_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is sec view");
                str = [str stringByAppendingString:str_trigonometric_sec];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_arcsec_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is arcsec view");
                str = [str stringByAppendingString:str_trigonometric_arcsec];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_sech_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is sech view");
                str = [str stringByAppendingString:str_trigonometric_sech];
            }
            
            if ([v.accessibilityLabel isEqualToString:trigonometric_csc_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is csc view");
                str = [str stringByAppendingString:str_trigonometric_csc];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_arccsc_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is arccsc view");
                str = [str stringByAppendingString:str_trigonometric_arccsc];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_csch_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is csch view");
                str = [str stringByAppendingString:str_trigonometric_csch];
            }
            
            if ([v.accessibilityLabel isEqualToString:trigonometric_cot_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is cot view");
                str = [str stringByAppendingString:str_trigonometric_cot];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_arccot_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is arccot view");
                str = [str stringByAppendingString:str_trigonometric_arccot];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_coth_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is coth view");
                str = [str stringByAppendingString:str_trigonometric_coth];
            }
            
            if ([v.accessibilityLabel isEqualToString:trigonometric_sinn_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is sinn view");
                str = [str stringByAppendingString:str_trigonometric_sinn];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_cosn_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is cosn view");
                str = [str stringByAppendingString:str_trigonometric_cosn];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_tann_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is tann view");
                str = [str stringByAppendingString:str_trigonometric_tann];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_secn_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is secn view");
                str = [str stringByAppendingString:str_trigonometric_secn];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_cscn_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is cscn view");
                str = [str stringByAppendingString:str_trigonometric_cscn];
            }
            if ([v.accessibilityLabel isEqualToString:trigonometric_cotn_id])
            {
                // // // //if(LOGS_ON)NSLog(@"this is cotn view");
                str = [str stringByAppendingString:str_trigonometric_cotn];
            }
            
            str = [str stringByAppendingString:[self getStringFromView:v]];
            // // // //if(LOGS_ON)NSLog(@"%@",str);
            if (eq_str.length>0) {
                eq_str = [eq_str stringByAppendingFormat:@"%@%@",eq_seprator,str];
            }
            else
            {
                eq_str = str;
            }
            // // // //if(LOGS_ON)NSLog(@"equation : %@",eq_str);
        }
        if ([v.accessibilityLabel  isEqualToString:operation_view_id])
        {
            str = [self getOperationStringFromView:v];
            // // // //if(LOGS_ON)NSLog(@"%@",str);
            
            // new changes siddhi  --> on which answer at last added op# text
            if (eq_str.length>0) {
                if (![str isEqualToString:@"op#"]){
                    eq_str = [eq_str stringByAppendingFormat:@"%@%@",eq_seprator,str];
                }
            }
            else
            {
                if ([str isEqualToString:@"op#"]){
                    eq_str = @"";
                }else{
                    eq_str =str;
                }
            }
            // new changes siddhi
            
            // // // //if(LOGS_ON)NSLog(@"equation : %@",eq_str);
        }
        if ([v.accessibilityIdentifier  isEqualToString:@"test"])
        {
            UITextField *t = (UITextField*)v;
            NSString *trimmedString = [t.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            
            if (trimmedString.length>0) {
                str = [str stringByAppendingString:str_general_text];
                str = [str stringByAppendingString:trimmedString];
                if (eq_str.length>0) {
                    eq_str = [eq_str stringByAppendingFormat:@"%@%@",eq_seprator,str];
                }
                else
                {
                    eq_str = str;
                }
            }
        }
    }
    // // // //if(LOGS_ON)NSLog(@"%@",[eq_str componentsSeparatedByString:@"@"]);
    
    return eq_str;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return NO ;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //siddhi infosoft start
    // [manage offset for keyboard hide]
    if (textField.text.length>0)
    {
        if ([textField.accessibilityIdentifier isEqualToString:textField_identifier]) {
            textField.backgroundColor = [UIColor clearColor];
        }
        
    }
    else
    {
        if ([textField.accessibilityIdentifier isEqualToString:textField_identifier]) {
            textField.backgroundColor = box_back_color;
        }
    }
    //siddhi infosoft end
    
    LAStudentCustomAnswerCell *cell = (LAStudentCustomAnswerCell *)[self superViewOfType:[LAStudentCustomAnswerCell class] forView:textField];
    LACustomHomeworkQuestion *qs = nil ;
    qs = [self.tableDataSource objectAtIndex:currentTxtFieldRowNum];
    
    if (cell.cellType == LAStudentCustomAnswerCellSingleAnswerType)
    {
        if([self.playerAnswers count] > 0)
        {
            LACustomHwStudentAnswer *studAnswer = [self.playerAnswers objectAtIndex:currentTxtFieldRowNum];
            
            if(studAnswer.answersGiven.count > 0)
                [studAnswer.answersGiven removeLastObject];
            if(textField.text.length > 0)
                studAnswer.answersGiven             = [NSMutableArray arrayWithObject:textField.text] ;
            
        }
        //
    } //siddhi infosoft - Start
    if (cell.cellType == LAStudentCustomAnswerCellEquationType)
    {
        
        NSString *finalSTR = [self getFinalStringFromScrollView:cell.updateScroll];
        
        // // // //if(LOGS_ON)NSLog(@"%@",finalSTR);
        if([self.playerAnswers count] > 0)
        {
            LACustomHwStudentAnswer *studAnswer = [self.playerAnswers objectAtIndex:currentTxtFieldRowNum];
            if(studAnswer.answersGiven.count > 0)
                [studAnswer.answersGiven removeLastObject];
            //            if(textField.text.length > 0 || ([self isValidEquationFromString:finalSTR])) //changed 04-02-2016 add below condition
            if(finalSTR.length>0)
            {
                NSArray *array = [finalSTR componentsSeparatedByString:eq_seprator];
                if (array.count>1)
                {
                    
                }
                else
                {
                    
                    array = [finalSTR componentsSeparatedByString:val_seprator];
                    if (![[array objectAtIndex:0] isEqualToString:@"text"])
                    {
                        
                    }
                    else
                    {
                        //                        finalSTR = [array lastObject];//18-8-2015
                    }
                    
                    
                }
                studAnswer.answersGiven             = [NSMutableArray arrayWithObject:finalSTR] ;
            }
            
        }//siddhi infosoft - End
    }
}

- (UIView*)superViewOfType:(Class)class forView:(UIView*)view
{
    while (![view isKindOfClass:class] && view != nil) {
        view = [view superview];
        //        // // // //if(LOGS_ON) NSLog(@"View --- %@",view);
    }
    //TODO: add assertion to warn user about superview.
    return view ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - code started by siddhi infosoft -


- (void)textFieldSelected:(UITextField *)textField
{
    activeTextfield = textField;
}
-(void)updateEquation:(NSNotification *)notifInfo
{
    
}


-(NSString *)convertStringWithOprator:(NSString *)str
{
    NSString *strFinal = str;
    
    strFinal = [strFinal stringByReplacingOccurrencesOfString:@"≥" withString:operation_grtthanorequal];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:@"=" withString:operation_equal];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:@"<" withString:operation_lessthan];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:@">" withString:operation_grtthan];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:@"≤" withString:operation_lessthanorequal];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:@"+" withString:operation_plus];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:negative_ascii withString:operation_minus];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:multiplication_ascii withString:operation_multiplication];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:@"÷" withString:operation_devide];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:@"%" withString:operation_percentage];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:UNION_ascii withString:operation_union];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:INTERSECTION_ascii withString:operation_intersection];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:@"π" withString:operation_pie];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:@"∞" withString:operation_infinity];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:@"!" withString:operation_factorial];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:degree_ascii withString:operation_degree];
    //    strFinal = [strFinal stringByReplacingOccurrencesOfString:negative_ascii withString:@""];
    
    // changed 05-01-2016
    strFinal = [strFinal stringByReplacingOccurrencesOfString:sigma_xbar_ascii withString:operation_sigmaxbar];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:mu_xbar_ascii withString:operation_muxbar];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:xbar_ascii withString:operation_xbar];
    //
    
    return strFinal;
}


- (BOOL)checkString:(NSString*)other inmainstring:(NSString *)str {
    NSRange range = [str rangeOfString:other];
    return range.length != 0;
}
-(NSString*)changeFinalStringtoCompareStringForOldHomework:(NSString*)final_str;
{
    NSString *eq_str =  @"";
    
    
    NSArray *a = [final_str componentsSeparatedByString:eq_seprator];
    NSLog(@"%@",a);
    for (int i=0; i<a.count; i++)
    {
        NSString *str = [a objectAtIndex:i];
        if (str.length>0) {
            NSArray *temp = [str componentsSeparatedByString:val_seprator];
            if (temp.count>=2)//18-11-2015
            {
                eq_str = [NSString stringWithFormat:@"%@%@",eq_str,[temp objectAtIndex:1]];
            }
        }
    }
    NSLog(@"%@",eq_str);
    return eq_str;
    
}
-(BOOL)isValidEquationFromString:(NSString*)answer
{
    BOOL isValid = TRUE;
    // // // //if(LOGS_ON)NSLog(@"%@",answer);
    // // // //if(LOGS_ON)NSLog(@"%@",[answer componentsSeparatedByString:eq_seprator]);
    for (NSString *str_eq in [answer componentsSeparatedByString:eq_seprator])
    {
        // // // //if(LOGS_ON)NSLog(@"%@",str_eq);
        int i=0;
        for (NSString *str_val in [str_eq componentsSeparatedByString:val_seprator])
        {
            // // // //if(LOGS_ON)NSLog(@"%@",str_val);
            if (i>0 && str_val.length<1)
            {
                isValid = FALSE;
                break;
            }
            i++;
        }
    }
    if (answer.length<1) {
        isValid = FALSE;
    }
    return isValid;
    
    if (isValid==FALSE)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Operation Invalid" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}


-(NSString*)getStringFromView:(UIView*)op_view
{
    NSString *str = @"";
    int txt_start = 0;
    for (UIView *txt_v in op_view.subviews)
    {
        if ([txt_v.accessibilityIdentifier isEqualToString:textField_container])
        {
            
            for (UITextView *tf_v in txt_v.subviews)
            {
                if ([tf_v isKindOfClass:[UITextField class]])
                {
                    UITextField *tf = (UITextField*)tf_v;
                    // // // //if(LOGS_ON)NSLog(@"%@",tf.text);
                    if (txt_start==0) {
                        str = [str stringByAppendingFormat:@"%@",tf.text];
                        txt_start++;
                    }
                    else
                    {
                        str = [str stringByAppendingFormat:@"%@%@",val_seprator,tf.text];
                    }
                }
            }
        }
    }
    return str;
}
-(void)updateTextfieldWidth:(UITextField*)txt
{
    if (![txt.accessibilityIdentifier isEqualToString:@"test"]&&txt.text.length>0)
    {
        [self textFieldDidChange:txt];
    }
    else if ([txt.accessibilityIdentifier isEqualToString:@"test"]&&txt.text.length>1)
    {
        [self getXpositionAfterUpdatingTestTextfield:txt];
    }
}
-(void)textFieldDidChange:(UITextField*)sender
{
    
    [self getXpositionAfterUpdatingTextfieldAndItsSuperView:sender];
    return;
}

-(void)getXpositionAfterUpdatingTestTextfield:(UITextField*)sender
{
    // // // //if(LOGS_ON)NSLog(@"getXpositionAfterUpdatingTestTextfield : \n%@\n\n",sender.text);
    float x = sender.frame.origin.x+sender.frame.size.width;
    // // // //if(LOGS_ON)NSLog(@"old x position : %f",x);
    float senderOldX = 0;
    float senderNewX = 0;
    float oldH = 0;
    float oldY = 0;
    sender.textAlignment = NSTextAlignmentCenter;
    // // // //if(LOGS_ON)NSLog(@"%f",sender.frame.size.width);
    CGSize bestsize = [sender sizeThatFits:sender.frame.size];
    // // // //if(LOGS_ON)NSLog(@"%f",bestsize.width);
    
    LAStudentCustomAnswerCell *cell = (LAStudentCustomAnswerCell *)[self superViewOfType:[LAStudentCustomAnswerCell class] forView:activeTextfield];
    
    UIView *nextV = (UIView*)[cell.updateScroll viewWithTag:activeTextfield.tag+2];
    
    
    if (sender.text.length>=1&&nextV!=nil)
    {
        //        NSLog(@"%@",sender.accessibilityIdentifier);
        
        oldH = sender.frame.size.height;
        oldY =sender.frame.origin.y;
        senderOldX = sender.frame.origin.x+sender.frame.size.width;
        [sender sizeToFit];
        senderNewX = sender.frame.origin.x+sender.frame.size.width;
        
        // changed 23-12-2015   // Before just else condition is there. New Condition is added for negative
        NSString *strTemp = [sender.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if ([strTemp isEqualToString:@"+"] || [strTemp isEqualToString:negative_ascii] || [strTemp isEqualToString:multiplication_ascii] || [strTemp isEqualToString:@"÷"] || [strTemp isEqualToString:@">"] || [strTemp isEqualToString:@"≥"] || [strTemp isEqualToString:@"<"] || [strTemp isEqualToString:@"≤"] || [strTemp isEqualToString:@"="] || [strTemp isEqualToString:@"%"] ||[strTemp isEqualToString:@"π"] || [strTemp isEqualToString:UNION_ascii]|| [strTemp isEqualToString:INTERSECTION_ascii] || [strTemp isEqualToString:rightArrow_ascii] || [strTemp isEqualToString:xbar_ascii] || [strTemp isEqualToString:sigma_xbar_ascii] || [strTemp isEqualToString:mu_xbar_ascii] || [strTemp isEqualToString:@"∞"] || [strTemp isEqualToString:@"!"] || [strTemp isEqualToString:@" "])
        {
            //            sender.text = [NSString stringWithFormat:@" %@ ",strTemp];  // changed 06-01-2016
            
            NSDictionary *attributes = @{NSFontAttributeName : sender.font};
            CGSize size1 = [sender.text sizeWithAttributes:attributes];
            sender.frame=CGRectMake(sender.frame.origin.x, oldY, size1.width+8, oldH);
            sender.textAlignment=NSTextAlignmentCenter;  // changed 05-02-2016 center to right
        }
        else if (strTemp.length==0) {
            sender.frame = CGRectMake(sender.frame.origin.x, oldY, sender.frame.size.width, oldH);
        }
        else{
            //            sender.frame = CGRectMake(sender.frame.origin.x, oldY, bestsize.width, oldH);
            
            // changed 01-01-2016  before just above line there
            NSLog(@"\nsender:=%d\n",(int)sender.tag);
            if (sender.text.length==1)
            {
                NSDictionary *attributes = @{NSFontAttributeName : sender.font};
                CGSize size1 = [sender.text sizeWithAttributes:attributes];
                sender.frame=CGRectMake(sender.frame.origin.x, oldY, size1.width+8, oldH);
                
                // changed 01-02-2016
                if (sender.tag==50 || sender.tag==51)
                {
                    // changed 02-02-2016 remove !isIpad if condition
                    if (sender.frame.origin.x>0)
                    {
                        senderOldX=senderOldX-sender.frame.origin.x; // changed 03-02-2016
                        sender.frame=CGRectMake(0, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height);
                        x=senderOldX; // changed 03-02-2016
                    }
                    
                    sender.textAlignment=NSTextAlignmentRight; // changed 03-02-2016
                }
                else
                {
                    sender.textAlignment=NSTextAlignmentRight;
                }
                sender.backgroundColor=[UIColor clearColor];
            }
            else{
                sender.frame = CGRectMake(sender.frame.origin.x, oldY, bestsize.width, oldH);  // changed 31-12-2015 sender.frame.size.width+18 to bestsize.width
                sender.textAlignment=NSTextAlignmentRight;
                
                // comment 03-02-2016
                
                //
            }
            //            sender.backgroundColor=[UIColor redColor];
        }
    }
    else
    {
        sender.textAlignment = NSTextAlignmentLeft;
        if ([sender.accessibilityIdentifier  isEqualToString:@"test"])
        {
            UIView *viewLastTag = (UIView *)[cell.updateScroll.subviews objectAtIndex:cell.updateScroll.subviews.count-1]; // changed 19-01-2016
            
            if (sender.frame.origin.x+sender.frame.size.width<cell.updateScroll.frame.size.width)
            {
                sender.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, cell.updateScroll.frame.size.width-sender.frame.origin.x, sender.frame.size.height);
                sender.textAlignment = NSTextAlignmentLeft;
                //                sender.backgroundColor =[UIColor blueColor];
                
            }
            
            // changed 19-01-2016
            if (viewLastTag.tag==sender.tag)
            {
                if (sender.frame.origin.x+bestsize.width>cell.updateScroll.frame.size.width)
                {
                    CGRect rectT = sender.frame;
                    [sender sizeToFit];
                    sender.frame=CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.width+10, rectT.size.height); // changed 20-01-2016 +10 is added in sender width because last textbox left side shipping
                    
                    if (rectT.size.width>sender.frame.size.width) {
                        sender.frame=CGRectMake(sender.frame.origin.x, sender.frame.origin.y, rectT.size.width, sender.frame.size.height);
                    }
                    sender.textAlignment = NSTextAlignmentLeft;
                    cell.updateScroll.contentSize=CGSizeMake(sender.frame.origin.x+sender.frame.size.width, cell.updateScroll.contentSize.height);
                    
                    cell.updateScroll.contentOffset = CGPointMake(cell.updateScroll.contentSize.width-cell.updateScroll.frame.size.width, cell.updateScroll.contentOffset.y);
                    //                    x = sender.frame.origin.x+sender.frame.size.width;
                }
            }
            //
        }
    }
    float newX = sender.frame.origin.x+sender.frame.size.width;
    
    NSLog(@"\nnewX:=%f x:=%f diff:=%f",newX,x,newX-x);
    
    // // // //if(LOGS_ON)NSLog(@"new x position : %f",newX);
    if (x<newX)
    {
        if (cell)
        {
            float diff = newX - x;
            [self updateScroll:cell.updateScroll AndfromView:sender withSpaceDifference:diff isDelete:FALSE];
            
            // changed 03-02-2016 // changed 04-02-2016
            if (sender.text.length<=2)  // comment (sender.tag==50 || sender.tag==51) &&
            {
                UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                if (sender.text.length==2)
                {
                    btn1.tag=k_forward;
                    [self forwardOrBackwordClicked:btn1];
                    btn1.tag=k_backward;
                    [self forwardOrBackwordClicked:btn1];
                    btn1=nil;
                }
                else
                {
                    btn1.tag=k_backward;
                    [self forwardOrBackwordClicked:btn1];
                    btn1.tag=k_forward;
                    [self forwardOrBackwordClicked:btn1];
                    btn1=nil;
                }
                
            }
        }
    }
    else if (x>newX)
    {
        LAStudentCustomAnswerCell *cell = (LAStudentCustomAnswerCell *)[self superViewOfType:[LAStudentCustomAnswerCell class] forView:activeTextfield];
        if (cell)
        {
            // // // //if(LOGS_ON)NSLog(@"%f",x);
            // // // //if(LOGS_ON)NSLog(@"%f",newX);
            float diff = x-newX;
            [self updateScroll:cell.updateScroll AndfromView:sender withSpaceDifference:diff isDelete:TRUE];
            
            // changed 03-02-2016  // changed 04-02-2016  remove if condition because hide last character when delete
            //            if (sender.tag==50 || sender.tag==51)
            {
                UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                btn1.tag=k_forward;
                [self forwardOrBackwordClicked:btn1];
                btn1.tag=k_backward;
                [self forwardOrBackwordClicked:btn1];
                btn1=nil;
            }
        }
        
    }
    
}


-(void)getXpositionAfterUpdatingTextfieldAndItsSuperView:(UITextField*)sender
{
    // // // //if(LOGS_ON)NSLog(@"getXpositionAfterUpdatingTextfieldAndItsSuperView : \n%@\n\n",sender.text);
    float x = sender.superview.superview.frame.origin.x+sender.superview.superview.frame.size.width;
    // // // //if(LOGS_ON)NSLog(@"old x position : %f",x);
    float senderOldX = 0;
    float senderNewX = 0;
    if (sender.text.length>2) // changed 22-12-2015  // changed 2 from 3 length
    {
        float oldH = sender.frame.size.height;
        senderOldX = sender.frame.origin.x+sender.frame.size.width;
        [sender sizeToFit];
        sender.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.width+8, oldH);
        senderNewX = sender.frame.origin.x+sender.frame.size.width;
    }
    else if ([sender.accessibilityLabel isEqualToString:textField_custom_width] && sender.text.length>0)
    {
        float oldH = sender.frame.size.height;
        senderOldX = sender.frame.origin.x+sender.frame.size.width;
        //        if ([sender.superview.superview.accessibilityLabel  isEqualToString:operation_view_id]) {
        //
        //        }
        //        else
        //        {
        [sender sizeToFit];
        sender.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.width+8, oldH);
        //        }
        
        senderNewX = sender.frame.origin.x+sender.frame.size.width;
    }
    CGFloat fixed_h;//18-8-2015
    if ([sender.superview.accessibilityLabel isEqualToString:textField_fixed_height_view])//18-8-2015
    {
        fixed_h = sender.superview.frame.size.height;//18-8-2015
    }
    
    
    ///// 13-01-2016 ////////
    
    if ([sender.superview.superview.accessibilityLabel isEqualToString:fraction_view_id])
    {
        int widthLineForFraction=0;
        for (UIView *v in sender.superview.superview.subviews)
        {
            if ([v isKindOfClass:[UIView class]])
            {
                if ([v.accessibilityIdentifier isEqualToString:textField_container])
                {
                    for (UIView *v1 in v.subviews)
                    {
                        if ([v1 isKindOfClass:[UITextField class]])
                        {
                            UITextField *t = (UITextField *)v1;
                            // changed 26-01-2016
                            CGSize size = [t sizeThatFits:t.frame.size];
                            if (widthLineForFraction<=size.width)
                            {
                                widthLineForFraction=(int)size.width+8;
                                t.frame=CGRectMake(0, t.frame.origin.y, widthLineForFraction, t.frame.size.height);
                            }
                            else
                            {
                                t.frame=CGRectMake(0, t.frame.origin.y, widthLineForFraction, t.frame.size.height);
                            }
                            
                            if (widthLineForFraction<50) {
                                widthLineForFraction=50;
                                t.frame=CGRectMake(0, t.frame.origin.y, 50, t.frame.size.height);
                            }
                            //
                           
                        }
                    }
                }
            }
        }
        
        for (UIView *v in sender.superview.superview.subviews)
        {
            if ([v.accessibilityIdentifier isEqualToString:textField_container])
            {
                for (UIView *v1 in v.subviews)
                {
                    if ([v1 isKindOfClass:[UITextField class]])
                    {
                        UITextField *t = (UITextField *)v1;
                        //                        NSDictionary *attributes = @{NSFontAttributeName : t.font};
                        //                        CGSize size = [t.text sizeWithAttributes:attributes];
                        if (t.frame.size.width<=widthLineForFraction) {
                            v.frame=CGRectMake(0, v.frame.origin.y, widthLineForFraction, v.frame.size.height);
                            t.frame=CGRectMake(0, t.frame.origin.y, widthLineForFraction, t.frame.size.height); // changed 26-01-2016
                        }
                    }
                }
            }
            
            if ([v isKindOfClass:[UIView class]])
            {
                if (v.frame.size.height==1)
                {
                    v.frame=CGRectMake(v.frame.origin.x, v.frame.origin.y, widthLineForFraction, v.frame.size.height);
                    //                    break;
                }
            }
        }
    }
    
    // changed 22-12-2015
    
    if ([sender.superview.superview.accessibilityLabel isEqualToString:nsqrt_view_id])
    {
        for (UIView *v in sender.superview.superview.subviews)
        {
            if ([v isKindOfClass:[UIView class]])
            {
                if ([v.accessibilityIdentifier isEqualToString:textField_container])
                {
                    for (UIView *v1 in v.subviews)
                    {
                        if ([v1 isKindOfClass:[UITextField class]])
                        {
                            UITextField *t = (UITextField *)v1;
                            if (t.tag==2 && sender.superview.tag==101) {
                                [self addSquareRootTo:t withColor:t.textColor DView:sender.superview];
                                break;
                            }else if (t.tag==1){ // changed 05-01-2016
                                t.textAlignment=NSTextAlignmentRight;
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    if ([sender.superview.superview.accessibilityLabel isEqualToString:sqrt_view_id])
    {
        for (UIView *v in sender.superview.subviews)
        {
            if ([v isKindOfClass:[UITextField class]])
            {
                UITextField *t = (UITextField *)v;
                [self addSquareRootToSingle:t withColor:t.textColor DView:sender.superview];
                break;
            }
            
        }
    }
    
    // changed 31-12-2015
    
    if ([sender.superview.superview.accessibilityLabel isEqualToString:precalculus_sigma_id])
    {
        int widthLineForFraction=0;
        for (UIView *v in sender.superview.superview.subviews)
        {
            if ([v isKindOfClass:[UIView class]])
            {
                if ([v.accessibilityIdentifier isEqualToString:textField_container])
                {
                    for (UIView *v1 in v.subviews)
                    {
                        if ([v1 isKindOfClass:[UITextField class]])
                        {
                            UITextField *t = (UITextField *)v1;
                            if (widthLineForFraction<=t.frame.size.width && t.tag!=3) {
                                widthLineForFraction=(int)t.frame.size.width;
                                t.frame=CGRectMake(0, t.frame.origin.y, t.frame.size.width, t.frame.size.height); //changed 06-01-2016
                            }
                        }
                    }
                }
            }
        }
        
        for (UIView *v in sender.superview.superview.subviews)
        {
            if ([v.accessibilityIdentifier isEqualToString:textField_container])
            {
                for (UIView *v1 in v.subviews)
                {
                    if ([v1 isKindOfClass:[UITextField class]])
                    {
                        UITextField *t = (UITextField *)v1;
                        if (t.frame.size.width<=widthLineForFraction && t.tag!=3) {
                            t.frame=CGRectMake((widthLineForFraction-t.frame.size.width)/2, t.frame.origin.y, t.frame.size.width, t.frame.size.height);
                        }
                        else if (t.tag==3){
                            t.frame=CGRectMake(widthLineForFraction+2, t.frame.origin.y, t.frame.size.width, t.frame.size.height);
                        }
                        
                        if ((t.tag==1 || t.tag==2) && t.frame.origin.x<0) {
                            t.frame=CGRectMake(0, t.frame.origin.y, t.frame.size.width, t.frame.size.height);
                        }
                    }
                    
                    if ([v1 isKindOfClass:[UILabel class]])
                    {
                        UILabel *t = (UILabel *)v1;
                        if (t.frame.size.width<=widthLineForFraction) {
                            t.frame=CGRectMake((widthLineForFraction-t.frame.size.width)/2, t.frame.origin.y, t.frame.size.width, t.frame.size.height);
                        }
                    }
                }
            }
        }
    }
    // Changed 13-01-2016    // changes position
    [sender.superview resizeToFitSubviews];
    if ([sender.superview.accessibilityLabel isEqualToString:textField_fixed_height_view])//18-8-2015
    {
        sender.superview.frame = CGRectMake(sender.superview.frame.origin.x, sender.superview.frame.origin.y, sender.superview.frame.size.width, fixed_h);//18-8-2015
    }
    //////////////
    
    UIView *mySuperview = sender.superview.superview;
    UIView *compareView = sender.superview;
    // // // //if(LOGS_ON)NSLog(@"%@",[mySuperview subviews]);
    BOOL isFirst = TRUE;
    int diff = 0;
    float newX = 0;
    if (mySuperview.subviews.count>1)
    {
        for (int i=0; i<[[mySuperview subviews] count]; i++)
        {
            UIView *sub = [[mySuperview subviews] objectAtIndex:i];
            if (sub.frame.origin.x!=compareView.frame.origin.x && compareView.frame.origin.x<sub.frame.origin.x && senderOldX!=senderNewX)
            {
                if (isFirst)
                {
                    isFirst = FALSE;
                    //                diff = compareView.frame.origin.x+compareView.frame.size.width-sub.frame.origin.x;
                    diff = senderNewX-senderOldX;
                }
                // // // //if(LOGS_ON)NSLog(@"suviews : %@",sub);
                // // // //if(LOGS_ON)NSLog(@"%d",diff);
                sub.frame = CGRectMake(sub.frame.origin.x+diff, sub.frame.origin.y, sub.frame.size.width, sub.frame.size.height);
            }
            
        }
        [sender.superview.superview resizeToFitSubviews];
        newX = sender.superview.superview.frame.origin.x+sender.superview.superview.frame.size.width;
        // // // //if(LOGS_ON)NSLog(@"new x position : %f",newX);
    }
    else
    {
        // // // //if(LOGS_ON)NSLog(@"%@",[compareView subviews]);//17-8-2015
        
        for (int i=0; i<[[compareView subviews] count]; i++)
        {
            UIView *sub = [[compareView subviews] objectAtIndex:i];
            if (sub.frame.origin.x!=sender.frame.origin.x && sender.frame.origin.x<sub.frame.origin.x && senderOldX!=senderNewX)
            {
                if (isFirst)
                {
                    isFirst = FALSE;
                    //                diff = compareView.frame.origin.x+compareView.frame.size.width-sub.frame.origin.x;
                    diff = senderNewX-senderOldX;
                }
                // // // //if(LOGS_ON)NSLog(@"suviews : %@",sub);
                // // // //if(LOGS_ON)NSLog(@"%d",diff);
                sub.frame = CGRectMake(sub.frame.origin.x+diff, sub.frame.origin.y, sub.frame.size.width, sub.frame.size.height);
            }
            
        }
        [sender.superview resizeToFitSubviews];
        [sender.superview.superview resizeToFitSubviews];
        newX = sender.superview.superview.frame.origin.x+sender.superview.superview.frame.size.width;
        // // // //if(LOGS_ON)NSLog(@"new x position : %f",newX);
    }
    
    if (x<newX)
    {
        LAStudentCustomAnswerCell *cell = (LAStudentCustomAnswerCell *)[self superViewOfType:[LAStudentCustomAnswerCell class] forView:sender]; // changed 18-01-2016  activeTextfield to sender
        //        LAStudentCustomAnswerCell *cell = (LAStudentCustomAnswerCell *)[self superViewOfType:[LAStudentCustomAnswerCell class] forView:sender];//18-11-2015
        
        if (cell)
        {
            float diff = newX - x;
            [self updateScroll:cell.updateScroll AndfromView:sender.superview.superview withSpaceDifference:diff isDelete:FALSE];
            
        }
    }
    else if (x>newX)
    {
        LAStudentCustomAnswerCell *cell = (LAStudentCustomAnswerCell *)[self superViewOfType:[LAStudentCustomAnswerCell class] forView:sender];  // changed 18-01-2016  activeTextfield to sender
        //        LAStudentCustomAnswerCell *cell = (LAStudentCustomAnswerCell *)[self superViewOfType:[LAStudentCustomAnswerCell class] forView:sender];//18-11-2015
        if (cell)
        {
            float diff = x-newX;
            [self updateScroll:cell.updateScroll AndfromView:sender.superview.superview withSpaceDifference:diff isDelete:TRUE];
            
        }
    }
    
}

// changed 22-12-2015
#pragma mark - Square root 2

- (void)addSquareRootToSingle:(UITextField *)label withColor:(UIColor*)clr DView:(UIView *)dview
{
    CGSize size;
    
    if ([@"123456" respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary *attributes = @{NSFontAttributeName : label.font};
        
        size = [label.text sizeWithAttributes:attributes];
        
        if (size.width<(isIpad?45:35)) {
            size.width = (isIpad?45:35);
        }else{
            size.width+=10;
        }
    }
    else
    {
        size = [@"1234" sizeWithFont:label.font];
    }
    if (size.width>self.view.frame.size.width) {
        size.width = label.frame.size.width;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // it's going to seem strange, but it's probably easier to draw the square root size
    // right to left, so let's start at the top right of the text frame
    
    [path moveToPoint:CGPointMake(label.frame.origin.x + size.width, label.frame.origin.y)];
    
    // move to the top left
    
    CGPoint point = CGPointMake(label.frame.origin.x, label.frame.origin.y);
    [path addLineToPoint:point];
    
    // now draw the big diagonal line down to the bottom of the text frame (at 15 degrees)
    
    point.y += size.height+5;
    point.x -= sinf(15 * M_PI / 180) * size.height;
    [path addLineToPoint:point];
    
    // now draw the medium sized diagonal back up (at 30 degrees)
    
    point.y -= size.height * part2;
    point.x -= sinf(30 * M_PI / 180) * size.height * part2;
    [path addLineToPoint:point];
    
    // now draw the tiny diagonal back down (again, at 30 degrees)
    
    point.y += size.height * part1;
    point.x -= sinf(30 * M_PI / 180) * size.height * part1;
    [path addLineToPoint:point];
    
    // now add the whole path to our view
    NSLog(@"%@",NSStringFromCGRect(dview.frame));
    /*
     if (layer!=nil) {
     [layer removeFromSuperlayer];
     //        [dview.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
     //        [dview.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
     //        dview.layer.sublayers=nil;
     //        [dview.layer.sublayers removeFromSuperlayer];
     
     //        NSEnumerator *enumerator = [dview.layer.sublayers reverseObjectEnumerator];
     //        for(CAShapeLayer *layer1 in enumerator) {
     //            [layer1 removeFromSuperlayer];
     //        }
     }
     
     layer = [CAShapeLayer layer];
     layer.path = path.CGPath;
     layer.lineWidth = 1.0;
     layer.strokeColor = [[UIColor blackColor] CGColor];
     layer.fillColor = [[UIColor clearColor] CGColor];
     layer.strokeColor = [[UIColor blackColor] CGColor];
     [dview.layer addSublayer:layer];
     
     [dview bringSubviewToFront:label];
     [dview.superview bringSubviewToFront:dview];
     */
    
    // changed 30-12-2015
    
    NSString *strTag = [NSString stringWithFormat:@"%lu",(long)label.tag];
    
    if (dview.layer!=nil) {
        //        [dview.layer setSublayers:nil];
        
        for (CAShapeLayer *layer2 in [dview.layer.sublayers copy])
        {
            if ([[layer2 name] isEqualToString:strTag])
            {
                [layer2 removeFromSuperlayer];
            }
        }
    }
    
    CAShapeLayer *layer1 = [CAShapeLayer layer];
    layer1.path = path.CGPath;
    layer1.lineWidth = 1.0;
    layer1.strokeColor = [[UIColor blackColor] CGColor];
    layer1.fillColor = [[UIColor clearColor] CGColor];
    layer1.strokeColor = [[UIColor blackColor] CGColor];
    layer1.name=strTag;
    [dview.layer addSublayer:layer1];
    
    [dview bringSubviewToFront:label];
    [dview.superview bringSubviewToFront:dview];
}

- (void)addSquareRootTo:(UITextField *)label withColor:(UIColor*)clr DView:(UIView *)dview
{
    CGSize size;
    
    if ([@"123456" respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary *attributes = @{NSFontAttributeName : label.font};
        
        size = [label.text sizeWithAttributes:attributes];
        
        if (size.width<45) {
            size.width = 45;
        }else{
            size.width+=10;
        }
    }
    else
    {
        size = [@"1234" sizeWithFont:label.font];
    }
    if (size.width>self.view.frame.size.width) {
        size.width = label.frame.size.width;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // it's going to seem strange, but it's probably easier to draw the square root size
    // right to left, so let's start at the top right of the text frame
    
    [path moveToPoint:CGPointMake(label.frame.origin.x + size.width, label.frame.origin.y)];
    
    // move to the top left
    
    CGPoint point = CGPointMake(label.frame.origin.x, label.frame.origin.y);
    [path addLineToPoint:point];
    
    // now draw the big diagonal line down to the bottom of the text frame (at 15 degrees)
    
    point.y += size.height+5;
    point.x -= sinf(15 * M_PI / 180) * size.height;
    [path addLineToPoint:point];
    
    // now draw the medium sized diagonal back up (at 30 degrees)
    
    point.y -= size.height * part2;
    point.x -= sinf(30 * M_PI / 180) * size.height * part2;
    [path addLineToPoint:point];
    
    // now draw the tiny diagonal back down (again, at 30 degrees)
    
    point.y += size.height * part1;
    point.x -= sinf(30 * M_PI / 180) * size.height * part1;
    [path addLineToPoint:point];
    
    
    // changed 30-12-2015
    
    NSString *strTag = [NSString stringWithFormat:@"%lu",(long)label.tag];
    
    if (dview.layer!=nil) {
        //        [dview.layer setSublayers:nil];
        
        for (CAShapeLayer *layer2 in [dview.layer.sublayers copy])
        {
            if ([[layer2 name] isEqualToString:strTag])
            {
                [layer2 removeFromSuperlayer];
            }
        }
    }
    
    CAShapeLayer *layer1 = [CAShapeLayer layer];
    layer1.path = path.CGPath;
    layer1.lineWidth = 1.0;
    layer1.strokeColor = [[UIColor blackColor] CGColor];
    layer1.fillColor = [[UIColor clearColor] CGColor];
    layer1.strokeColor = [[UIColor blackColor] CGColor];
    layer1.name=strTag;
    [dview.layer addSublayer:layer1];
    
    [dview bringSubviewToFront:label];
    [dview.superview bringSubviewToFront:dview];
}

#pragma mark -

// changed 04-02-2016
-(void)addTextBoxBetweenTwoViewInWhichBothSideTestTextboxIsNotThere:(UIScrollView *)scroll getView:(UIView *)CurrentView
{
    int viewtag = (int)CurrentView.tag;
    while (viewtag>=50)
    {
        UIView *v = (UIView*)[scroll viewWithTag:viewtag];
        UIView *nextV = (UIView*)[scroll viewWithTag:viewtag+2];
        if (v!=nil)
        {
            if (nextV!=nil)
            {
                if ([v.accessibilityIdentifier  isEqualToString:@"test"] || [nextV.accessibilityIdentifier  isEqualToString:@"test"])
                {
                    
                }
                else
                {
                    UITextField *updateTextField1 = [[UITextField alloc]initWithFrame:CGRectMake(v.frame.origin.x+v.frame.size.width+space_between_view, 0, 5, scroll.frame.size.height)];
                    updateTextField1.inputView =new_keypad.view;
                    updateTextField1.accessibilityIdentifier = @"test";
                    updateTextField1.delegate = self;
                    updateTextField1.tag = v.tag+1;
                    updateTextField1.tintColor = tint_Color;
                    updateTextField1.font = isIpad?math_font1:math_font1_iphone;
                    updateTextField1.backgroundColor = [UIColor clearColor];
                    [scroll addSubview:updateTextField1];
                    
                    [scroll insertSubview:updateTextField1 aboveSubview:v];
                    
                    nextV.frame=CGRectMake(updateTextField1.frame.origin.x+updateTextField1.frame.size.width+space_between_view, nextV.frame.origin.y, nextV.frame.size.width, nextV.frame.size.height);
                    nextV.tag=updateTextField1.tag+1;
                    scroll.contentSize=CGSizeMake(nextV.frame.origin.x+nextV.frame.size.width+5, scroll.frame.size.height);
                    break;
                }
            }
            break;
        }
        else
        {
            viewtag=0;
        }
        
    }
}

-(void)updateScroll:(UIScrollView*)scroll AndfromView:(UIView*)changedView withSpaceDifference:(float)diff isDelete:(BOOL)delete
{
    int viewtag = (int)changedView.tag;
    NSLog(@"%@",scroll.subviews); // changed 01-02-2016
    if (delete)
    {
        while (viewtag>=50)
        {
            UIView *v = (UIView*)[scroll viewWithTag:viewtag+1];
            UIView *nextV = (UIView*)[scroll viewWithTag:viewtag+2];
            if (v!=nil)
            {
                // // // //if(LOGS_ON)NSLog(@"%@",v);
                viewtag = (int)v.tag;
                int x = v.frame.origin.x - ceil(diff);
                v.frame = CGRectMake(x, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
                if ([v isKindOfClass:[UITextField class]]&&nextV==nil)
                {
                    UITextField *t = (UITextField*)v;
                    if ([t.accessibilityIdentifier  isEqualToString:@"test"])
                    {
                        
                        if (t.frame.origin.x+t.frame.size.width<scroll.frame.size.width)
                        {
                            t.frame = CGRectMake(t.frame.origin.x, t.frame.origin.y, scroll.frame.size.width-t.frame.origin.x, t.frame.size.height);
                            t.textAlignment = NSTextAlignmentLeft;
                            //                            t.backgroundColor =[UIColor blueColor];
                            
                        }
                    }
                    
                }
            }
            else
            {
                viewtag=0;
            }
            
        }
    }
    else
    {
        while (viewtag>=50)
        {
            UIView *v = (UIView*)[scroll viewWithTag:viewtag+1];
            UIView *nextV = (UIView*)[scroll viewWithTag:viewtag+2];
            if (v!=nil) {
                // // // //if(LOGS_ON)NSLog(@"%@",v);
                viewtag = (int)v.tag;
                //                NSLog(@"%f",diff);
                //                NSLog(@"%d",(int)roundf(diff));
                //                NSLog(@"%d",(int)ceil(diff));
                //                NSLog(@"%d",(int)floor(diff));
                int x = v.frame.origin.x + ceil(diff);  // changed 28-01-2016 diff to ceil(diff)
                v.frame = CGRectMake(x, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
                if ([v isKindOfClass:[UITextField class]]&&nextV==nil)
                {
                    UITextField *t = (UITextField*)v;
                    if ([t.accessibilityIdentifier  isEqualToString:@"test"])
                    {
                        
                        if (t.frame.origin.x+t.frame.size.width<scroll.frame.size.width)
                        {
                            t.frame = CGRectMake(t.frame.origin.x, t.frame.origin.y, scroll.frame.size.width-t.frame.origin.x, t.frame.size.height);
                            t.textAlignment = NSTextAlignmentLeft;
                            //                            t.backgroundColor =[UIColor blueColor];
                        }
                    }
                }
            }
            else
            {
                viewtag=0;
            }
            
        }
        
    }
    
    NSLog(@"after:=%@",scroll.subviews); // changed 01-02-2016
}
-(BOOL)checkAllFieldsAreBlankOrNotBeforeDeleteForView:(UIView*)view
{
    BOOL allFieldsAreBlank = TRUE;
    
    int tag = 1;
    UIView *v = [view viewWithTag:tag];
    while (v!=nil) {
        if ([v isKindOfClass:[UITextField class]]) {
            UITextField *t = (UITextField*)v;
            if (t.text.length>0) {
                allFieldsAreBlank = FALSE;
                break;
            }
        }
        tag = tag+1;
        v = [view viewWithTag:tag];
    }
    
    return allFieldsAreBlank;
    
}

-(NSString *)convertStringWithoutOprator:(NSString *)str
{
    NSString *strFinal = str;
    
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_grtthanorequal withString:@"≥"];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_equal withString:@"="];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_lessthan withString:@"<"];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_grtthan withString:@">"];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_lessthanorequal withString:@"≤"];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_plus withString:@"+"];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_minus withString:negative_ascii];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_multiplication withString:multiplication_ascii];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_devide withString:@"÷"];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_percentage withString:@"%"];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_union withString:UNION_ascii];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_intersection withString:INTERSECTION_ascii];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_pie withString:@"π"];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_infinity withString:@"∞"];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_factorial withString:@"!"];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_degree withString:degree_ascii];
    
    // changed 05-01-2016
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_sigmaxbar withString:sigma_xbar_ascii];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_muxbar withString:mu_xbar_ascii];
    strFinal = [strFinal stringByReplacingOccurrencesOfString:operation_xbar withString:xbar_ascii];
    //
    
    NSLog(@"Converted String without Operator is %@", strFinal);
    
    return strFinal;
}


//---------   Convert code(string) to Equation   ----------//

-(void)updateViewWithEquationString:(NSString*)strEquation andScrollview:(UIScrollView*)updateView1 Tag:(int)Index
{
    NSArray *eqArray = [strEquation componentsSeparatedByString:eq_seprator];
    for (int i=0; i<eqArray.count; i++)
    {
        NSArray *txtArray;//4-8-2015
        NSString *str_Eq = [eqArray objectAtIndex:i];
        NSArray *valArray = [str_Eq componentsSeparatedByString:val_seprator];
        NSString *func = [NSString stringWithFormat:@"%@#",[valArray objectAtIndex:0]];
        BOOL isTextfieldRequired = FALSE;
        if (i==eqArray.count-1)
        {
            isTextfieldRequired = TRUE;
        }
        id updates;
        if ([func isEqualToString:str_fraction])
        {
            
            updates = [self updateViewWithMenuItem:fraction_view_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_sqrt])
        {
            updates = [self updateViewWithMenuItem:sqrt_view_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_nsqrt])
        {
            updates = [self updateViewWithMenuItem:nsqrt_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_permutation])
        {
            updates = [self updateViewWithMenuItem:permutation_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_avenir])
        {
            updates = [self updateViewWithMenuItem:avenir_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_avenirBox])
        {
            updates = [self updateViewWithMenuItem:avenirBox_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_combination])
        {
            updates = [self updateViewWithMenuItem:combination_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_exponent_e])
        {
            updates = [self updateViewWithMenuItem:exponent_e_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_alpha])
        {
            updates = [self updateViewWithMenuItem:alpha_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_sigma])
        {
            updates = [self updateViewWithMenuItem:sigma_view_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_mu])
        {
            updates = [self updateViewWithMenuItem:mu_view_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_exponent_theta])
        {
            updates = [self updateViewWithMenuItem:exponent_theta_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_trigonometric_log])
        {
            updates = [self updateViewWithMenuItem:trigonometric_log_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_trigonometric_ln])
        {
            updates = [self updateViewWithMenuItem:trigonometric_ln_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_trigonometric_logn])
        {
            updates = [self updateViewWithMenuItem:trigonometric_logn_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_exponent_i])
        {
            updates = [self updateViewWithMenuItem:exponent_i_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_plusexponent])
        {
            updates = [self updateViewWithMenuItem:plus_exponent_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_minusexponent])
        {
            updates = [self updateViewWithMenuItem:minus_exponent_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_exponent])
        {
            updates = [self updateViewWithMenuItem:exponent_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_downexponent])
        {
            updates = [self updateViewWithMenuItem:down_exponent_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_tenexponent])
        {
            updates = [self updateViewWithMenuItem:tenexponent_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_point])
        {
            updates = [self updateViewWithMenuItem:point_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_parenthesis])
        {
            updates = [self updateViewWithMenuItem:parenthesis_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_absolute])
        {
            updates = [self updateViewWithMenuItem:absolute_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_precalculus_sigma])
        {
            updates = [self updateViewWithMenuItem:precalculus_sigma_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_mixed_fraction])
        {
            updates = [self updateViewWithMenuItem:mixedFraction_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_limit])
        {
            updates = [self updateViewWithMenuItem:limit_view_id andUpdateView:updateView1];
            
        }
        else if ([func isEqualToString:str_fx])
        {
            updates = [self updateViewWithMenuItem:fx_view_id andUpdateView:updateView1];
            
        }
        
        else if ([func isEqualToString:str_trigonometric_sin])
        {
            updates = [self updateViewWithMenuItem:trigonometric_sin_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_arcsin])
        {
            updates = [self updateViewWithMenuItem:trigonometric_arcsin_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_sinh])
        {
            updates = [self updateViewWithMenuItem:trigonometric_sinh_id andUpdateView:updateView1];
        }
        
        else if ([func isEqualToString:str_trigonometric_cos])
        {
            updates = [self updateViewWithMenuItem:trigonometric_cos_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_arccos])
        {
            updates = [self updateViewWithMenuItem:trigonometric_arccos_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_cosh])
        {
            updates = [self updateViewWithMenuItem:trigonometric_cosh_id andUpdateView:updateView1];
        }
        
        else if ([func isEqualToString:str_trigonometric_tan])
        {
            updates = [self updateViewWithMenuItem:trigonometric_tan_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_arctan])
        {
            updates = [self updateViewWithMenuItem:trigonometric_arctan_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_tanh])
        {
            updates = [self updateViewWithMenuItem:trigonometric_tanh_id andUpdateView:updateView1];
        }
        
        else if ([func isEqualToString:str_trigonometric_sec])
        {
            updates = [self updateViewWithMenuItem:trigonometric_sec_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_arcsec])
        {
            updates = [self updateViewWithMenuItem:trigonometric_arcsec_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_sech])
        {
            updates = [self updateViewWithMenuItem:trigonometric_sech_id andUpdateView:updateView1];
        }
        
        else if ([func isEqualToString:str_trigonometric_csc])
        {
            updates = [self updateViewWithMenuItem:trigonometric_csc_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_arccsc])
        {
            updates = [self updateViewWithMenuItem:trigonometric_arccsc_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_csch])
        {
            updates = [self updateViewWithMenuItem:trigonometric_csch_id andUpdateView:updateView1];
        }
        
        else if ([func isEqualToString:str_trigonometric_cot])
        {
            updates = [self updateViewWithMenuItem:trigonometric_cot_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_arccot])
        {
            updates = [self updateViewWithMenuItem:trigonometric_arccot_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_coth])
        {
            updates = [self updateViewWithMenuItem:trigonometric_coth_id andUpdateView:updateView1];
        }
        
        else if ([func isEqualToString:str_trigonometric_sinn])
        {
            updates = [self updateViewWithMenuItem:trigonometric_sinn_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_cosn])
        {
            updates = [self updateViewWithMenuItem:trigonometric_cosn_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_tann])
        {
            updates = [self updateViewWithMenuItem:trigonometric_tann_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_secn])
        {
            updates = [self updateViewWithMenuItem:trigonometric_secn_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_cscn])
        {
            updates = [self updateViewWithMenuItem:trigonometric_cscn_id andUpdateView:updateView1];
        }
        else if ([func isEqualToString:str_trigonometric_cotn])
        {
            updates = [self updateViewWithMenuItem:trigonometric_cotn_id andUpdateView:updateView1];
        }
        
        else if ([func isEqualToString:str_operation])
        {
            if (valArray.count<2)
            {
                return;
            }
            /*
             
             --> op_plus
             --> op_minus
             --> op_equal
             --> op_multi
             --> op_divide
             --> op_union
             --> op_intersection
             --> op_pi
             --> op_factorial
             --> op_percentage
             --> op_rarrow
             --> op_xbar
             --> op_muxbar
             --> op_sigmaxbar
             --> op_goe
             --> op_loe
             --> op_grthan
             --> op_lethan
             
             
             
             */
            
            if ([[valArray objectAtIndex:1] isEqualToString:operation_plus])//required Changes here siddhi infosoft
            {
                updates = [self updateViewWithMenuItem:[NSString stringWithFormat:@"%d",k_plus] andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_minus])
            {
                updates = [self updateViewWithMenuItem:[NSString stringWithFormat:@"%d",k_minus] andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_multiplication])
            {
                updates = [self updateViewWithMenuItem:[NSString stringWithFormat:@"%d",k_multiplication] andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_devide])
            {
                updates = [self updateViewWithMenuItem:[NSString stringWithFormat:@"%d",k_devide] andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_grtthanorequal])
            {
                
                updates = [self updateViewWithMenuItem:@"gte_ipad" andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_grtthan])
            {
                
                updates = [self updateViewWithMenuItem:@"gt_ipad" andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_lessthan])
            {
                
                updates = [self updateViewWithMenuItem:@"lt_ipad" andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_lessthanorequal])
            {
                
                updates = [self updateViewWithMenuItem:@"lte_ipad" andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_equal])
            {
                
                updates = [self updateViewWithMenuItem:@"equal_ipad" andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_percentage])
            {
                
                updates = [self updateViewWithMenuItem:@"parcent_ipad" andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_union])
            {
                
                updates = [self updateViewWithMenuItem:@"union_ipad" andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_intersection])
            {
                
                updates = [self updateViewWithMenuItem:@"intersection_ipad" andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_rarrow])
            {
                
                updates = [self updateViewWithMenuItem:@"aerrow_ipad" andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_xbar])
            {
                
                updates = [self updateViewWithMenuItem:@"xbar_ipad" andUpdateView:updateView1];
            }//infinity_ipad
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_infinity])
            {
                
                updates = [self updateViewWithMenuItem:@"infinity_ipad" andUpdateView:updateView1];
            }//infinity_ipad
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_muxbar])
            {
                
                updates = [self updateViewWithMenuItem:@"muxb_ipad" andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_sigmaxbar])
            {
                
                updates = [self updateViewWithMenuItem:@"sigmaxb_ipad" andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_pie])
            {
                
                updates = [self updateViewWithMenuItem:@"pi_ipad" andUpdateView:updateView1];
            }
            else if ([[valArray objectAtIndex:1] isEqualToString:operation_factorial])
            {
                
                updates = [self updateViewWithMenuItem:@"factorial_ipad" andUpdateView:updateView1];
            }
            
            if (i==eqArray.count-1)
            {
                isTextfieldRequired = TRUE;
            }
            
        }
        else if ([func isEqualToString:str_general_text]||valArray.count==1)
        {
            isTextfieldRequired = FALSE;
            updates = [self updateViewWithMenuItem:str_general_text andUpdateView:updateView1];
        }
        
        
        if ([func isEqualToString:str_fraction])
        {
            
            FractionView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            fr.txt1.text = [valArray objectAtIndex:2];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_combination]||[func isEqualToString:str_permutation])
        {
            // // // //if(LOGS_ON)NSLog(@"Mixed");
            PermutationOrCombinationView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            fr.txt1.text = [valArray objectAtIndex:2];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            fr.txt.font=isIpad?math_script_font:math_script_font_iphone;
            fr.txt1.font=isIpad?math_script_font:math_script_font_iphone;
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1,nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_avenir])
        {
            // // // //if(LOGS_ON)NSLog(@"Mixed");
            AvenirView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            fr.txt1.text = [valArray objectAtIndex:2];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            
            fr.txt.font=isIpad?math_font2:math_font2_iphone;
            fr.txt1.font=isIpad?math_font2:math_font2_iphone;
            
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1, nil];//4-8-2015
            
            
        }
        else if ([func isEqualToString:str_avenirBox])
        {
            // // // //if(LOGS_ON)NSLog(@"Mixed");
            AvenirBoxView *fr = updates;
            if (valArray.count>=2) {
                fr.txt1.text = [valArray objectAtIndex:1];
            }
            if (valArray.count>=3) {
                fr.txt.text = [valArray objectAtIndex:2];
            }
            if (valArray.count>=4) {
                fr.txt2.text = [valArray objectAtIndex:3];
            }
            if (valArray.count>=5) {
                fr.txt3.text = [valArray objectAtIndex:4];
            }
            
            
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt2.text.length>0)
            {
                fr.txt2.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt3.text.length>0)
            {
                fr.txt3.backgroundColor = [UIColor clearColor];
            }
            fr.txt.font=isIpad?math_script_font:math_script_font_iphone;
            fr.txt1.font=isIpad?math_script_font:math_script_font_iphone;
            fr.txt2.font=isIpad?math_font2:math_font2_iphone;
            fr.txt3.font=isIpad?math_font2:math_font2_iphone;
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1,fr.txt2,fr.txt3, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_mixed_fraction])
        {
            
            MixedNumberView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            fr.txt1.text = [valArray objectAtIndex:2];
            fr.txt2.text = [valArray objectAtIndex:3];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt2.text.length>0)
            {
                fr.txt2.backgroundColor = [UIColor clearColor];
            }
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1,fr.txt2, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_limit])
        {
            
            LimitView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            fr.txt1.text = [valArray objectAtIndex:2];
            fr.txt2.text = [valArray objectAtIndex:3];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt2.text.length>0)
            {
                fr.txt2.backgroundColor = [UIColor clearColor];
            }
            fr.txt.font=isIpad?math_script_font:math_script_font_iphone;
            fr.txt1.font=isIpad?math_script_font:math_script_font_iphone;
            fr.txt2.font=isIpad?math_font3:math_font3_iphone;
            
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1,fr.txt2, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_fx])
        {
            
            FofXView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            txtArray = [[NSArray alloc]initWithObjects:fr.txt, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_sqrt])
        {
            
            OperationView *fr = updates;
            fr.txt1.text = [valArray objectAtIndex:1];
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            txtArray = [[NSArray alloc]initWithObjects:fr.txt1, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_exponent_e])
        {
            
            ExponentEView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            fr.txt.font=isIpad?math_script_font:math_script_font_iphone;
            txtArray = [[NSArray alloc]initWithObjects:fr.txt, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_alpha] || [func isEqualToString:str_mu] || [func isEqualToString:str_sigma])
        {
            
            ExponentEView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            fr.txt.font=isIpad?math_script_font:math_script_font_iphone;
            txtArray = [[NSArray alloc]initWithObjects:fr.txt, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_exponent_theta])
        {
            
            ExponentEView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            fr.txt.font=isIpad?math_script_font:math_script_font_iphone;
            txtArray = [[NSArray alloc]initWithObjects:fr.txt, nil];//4-8-2015
            
        }
        
        else if ([func isEqualToString:str_exponent_i])
        {
            
            ExponentEView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            fr.txt.font=isIpad?math_script_font:math_script_font_iphone;
            txtArray = [[NSArray alloc]initWithObjects:fr.txt, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_plusexponent]||[func isEqualToString:str_minusexponent])
        {
            ExponentPMView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            txtArray = [[NSArray alloc]initWithObjects:fr.txt, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_trigonometric_log] || [func isEqualToString:str_trigonometric_ln])
        {
            
            LogView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            txtArray = [[NSArray alloc]initWithObjects:fr.txt, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_trigonometric_logn])
        {
            
            LogView2 *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            fr.txt1.text = [valArray objectAtIndex:2];
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1, nil];//4-8-2015
            
        }
        
        else if ([func isEqualToString:str_nsqrt])
        {
            SquareRoot2View *fr = updates;
            fr.txt2.text = [valArray objectAtIndex:1];
            fr.txt1.text = [valArray objectAtIndex:2];
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt2.text.length>0)
            {
                fr.txt2.backgroundColor = [UIColor clearColor];
            }
            fr.txt1.font=isIpad?math_font2:math_font2_iphone;
            fr.txt2.font=isIpad?math_script_font:math_script_font_iphone;
            
            txtArray = [[NSArray alloc]initWithObjects:fr.txt1,fr.txt2, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_exponent])
        {
            ExponentView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            fr.txt1.text = [valArray objectAtIndex:2];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            fr.txt.font=isIpad?math_font2:math_font2_iphone;
            fr.txt1.font=isIpad?math_script_font:math_script_font_iphone;
            
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_downexponent])
        {
            ExponentDownView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            fr.txt1.text = [valArray objectAtIndex:2];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            fr.txt.font=isIpad?math_font2:math_font2_iphone;
            fr.txt1.font=isIpad?math_script_font:math_script_font_iphone;
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_tenexponent])
        {
            
            TenExponentView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            fr.txt1.text = [valArray objectAtIndex:2];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            fr.txt.font=isIpad?math_font2:math_font2_iphone;
            fr.txt1.font=isIpad?math_script_font:math_script_font_iphone;
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_point])
        {
            
            PointView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            fr.txt1.text = [valArray objectAtIndex:2];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1, nil];//4-8-2015
            
        }
        else if ([func isEqualToString:str_parenthesis])
        {
            ParenthesisView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            txtArray = [[NSArray alloc]initWithObjects:fr.txt, nil];//15-9-2015
            
        }
        else if ([func isEqualToString:str_absolute])
        {
            AbsoluteView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            txtArray = [[NSArray alloc]initWithObjects:fr.txt, nil];//15-9-2015
            
        }
        else if ([func isEqualToString:str_precalculus_sigma])
        {
            
            SigmaView *fr = updates;
            fr.txt1.text = [valArray objectAtIndex:1];
            fr.txt.text = [valArray objectAtIndex:2];
            fr.txt2.text = [valArray objectAtIndex:3];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt2.text.length>0)
            {
                fr.txt2.backgroundColor = [UIColor clearColor];
            }
            
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1,fr.txt2, nil];
            
        }
        
        else if ([func isEqualToString:str_trigonometric_sin] || [func isEqualToString:str_trigonometric_arcsin] || [func isEqualToString:str_trigonometric_sinh] || [func isEqualToString:str_trigonometric_cos] || [func isEqualToString:str_trigonometric_arccos] || [func isEqualToString:str_trigonometric_cosh] || [func isEqualToString:str_trigonometric_tan] || [func isEqualToString:str_trigonometric_arctan] || [func isEqualToString:str_trigonometric_tanh] || [func isEqualToString:str_trigonometric_sec] || [func isEqualToString:str_trigonometric_arcsec] || [func isEqualToString:str_trigonometric_sech] || [func isEqualToString:str_trigonometric_csc] || [func isEqualToString:str_trigonometric_arccsc] || [func isEqualToString:str_trigonometric_csch] || [func isEqualToString:str_trigonometric_cot] || [func isEqualToString:str_trigonometric_arccot] || [func isEqualToString:str_trigonometric_coth] )
        {
            
            TrigonometricView *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            
            txtArray = [[NSArray alloc]initWithObjects:fr.txt, nil];
            
        }
        else if ([func isEqualToString:str_trigonometric_sin] || [func isEqualToString:str_trigonometric_sinn] || [func isEqualToString:str_trigonometric_cosn] || [func isEqualToString:str_trigonometric_tann] || [func isEqualToString:str_trigonometric_secn] || [func isEqualToString:str_trigonometric_cscn] || [func isEqualToString:str_trigonometric_cotn])
        {
            TrigonometricView2 *fr = updates;
            fr.txt.text = [valArray objectAtIndex:1];
            fr.txt1.text = [valArray objectAtIndex:2];
            if (fr.txt1.text.length>0)
            {
                fr.txt1.backgroundColor = [UIColor clearColor];
            }
            if (fr.txt.text.length>0)
            {
                fr.txt.backgroundColor = [UIColor clearColor];
            }
            txtArray = [[NSArray alloc]initWithObjects:fr.txt,fr.txt1, nil];
            
            
        }
        
        else if ([func isEqualToString:str_general_text]||valArray.count==1)
        {
            UITextField *txt = updates;
            txt.text = [valArray lastObject];
            
            if (i==eqArray.count-1) {
                int width = txt.frame.size.width;
                if (txt.frame.origin.x+width+5<updateView1.frame.size.width) {
                    width =updateView1.frame.size.width-txt.frame.origin.x;
                    txt.frame = CGRectMake(txt.frame.origin.x, txt.frame.origin.y, width, txt.frame.size.height);
                }
                else
                {
                    txt.frame = CGRectMake(txt.frame.origin.x, txt.frame.origin.y, width, txt.frame.size.height);
                    
                }
                
            }
            
            if (valArray.count>1&&i<=(eqArray.count-2)&&eqArray.count>=2)
            {
                [self setSizeForTextfield:txt];
            }
            
        }
        for (UITextField *txt in txtArray)
        {
            [self updateTextfieldWidth:txt];
        }
        if (isTextfieldRequired)
        {
            if (i==eqArray.count-1)
            {
                // changed 04-02-2016 add because add test box between two view
                // comment 06-02-2016
                
                BOOL isLastViewText;
                //            int lastTag,x;
                UITextField *txt;
                int x = 5;
                int width = 0;
                long lastTag = 50;
                
                for (UIView *v in updateView1.subviews)
                {
                    // // // //if(LOGS_ON)NSLog(@"%ld",(long)v.tag);
                    isLastViewText=NO;
                    if (v.tag>=lastTag)
                    {
                        lastTag=v.tag;
                        x = v.frame.origin.x+v.frame.size.width+space_between_view;
                    }
                    if (lastTag>=0)
                    {
                        lastTag++;
                    }
                    if ([v.accessibilityIdentifier isEqualToString:@"test"]) {
                        x = 5;
                        txt = (UITextField*)v;
                        
                        if (txt.tag>=50) {  // changed 24-12-2015 before (txt.text.length>0&&txt.tag>=50)
                            x = txt.frame.origin.x+txt.frame.size.width+space_between_view;
                        }
                        isLastViewText=YES;
                    }
                }
                
                UITextField *updateTextField1;
                if (!isLastViewText)
                {
                    // changed 13-01-2016
                    
                    if (updateView1.subviews.count==1)
                    {
                        UIView *getView = (UIView *)[[updateView1.subviews objectAtIndex:0] viewWithTag:50];
                        CGRect rectT = getView.frame;
                        
                        updateTextField1 = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, 5, updateView1.frame.size.height)];
                        updateTextField1.inputView =new_keypad.view;
                        updateTextField1.accessibilityIdentifier = @"test";
                        updateTextField1.delegate = self;
                        updateTextField1.tag = 50;
                        updateTextField1.font = isIpad?math_font1:math_font1_iphone;
                        updateTextField1.backgroundColor = [UIColor clearColor]; //changed 13-01-2016
                        [updateView1 addSubview:updateTextField1];
                        
                        getView.frame=CGRectMake(updateTextField1.frame.origin.x+updateTextField1.frame.size.width+space_between_view, rectT.origin.y, rectT.size.width, rectT.size.height);
                        getView.tag=updateTextField1.tag+1;
                        
                        updateView1.contentSize=CGSizeMake(getView.frame.origin.x+getView.frame.size.width+5, updateView1.frame.size.height);
                        
                        [updateView1 exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
                    }
                    else
                    {
                        UIView *viewLastGot = (UIView *)[updateView1.subviews objectAtIndex:updateView1.subviews.count-1];
                        
                        updateTextField1 = [[UITextField alloc]initWithFrame:CGRectMake(viewLastGot.frame.origin.x+space_between_view, 0, 5, updateView1.frame.size.height)];
                        updateTextField1.inputView =new_keypad.view;
                        updateTextField1.accessibilityIdentifier = @"test";
                        updateTextField1.delegate = self;
                        updateTextField1.tag = viewLastGot.tag;
                        updateTextField1.font = isIpad?math_font1:math_font1_iphone;
                        updateTextField1.backgroundColor = [UIColor clearColor];
                        [updateView1 addSubview:updateTextField1];
                        
                        [updateView1 exchangeSubviewAtIndex:updateView1.subviews.count-1 withSubviewAtIndex:updateView1.subviews.count-2];
                        
                        viewLastGot.tag=updateTextField1.tag+1;
                        viewLastGot.frame=CGRectMake(updateTextField1.frame.origin.x+updateTextField1.frame.size.width+space_between_view, viewLastGot.frame.origin.y, viewLastGot.frame.size.width, viewLastGot.frame.size.height);
                        
                        updateView1.contentSize=CGSizeMake(updateTextField1.frame.origin.x+updateTextField1.frame.size.width+5, updateView1.frame.size.height);
                    }
                }
                
                ///
                
                id updates1 = [self updateViewWithMenuItem:str_general_text andUpdateView:updateView1];
                UITextField *txt1 = updates1;
                if (txt1.frame.origin.x+txt1.frame.size.width<updateView1.frame.size.width)
                {
                    int width = updateView1.frame.size.width-txt1.frame.origin.x;
                    txt1.frame = CGRectMake(txt1.frame.origin.x, txt1.frame.origin.y, width, txt1.frame.size.height);
                }
                // // // //if(LOGS_ON)NSLog(@"%@",txt1.text);
                // // // //if(LOGS_ON)NSLog(@"%@",txt1);
            }
            else
            {
                [self updateViewWithMenuItem:str_general_text andUpdateView:updateView1];
            }
            
        }
        else // changed 24-12-2015
        {
            BOOL isLastViewText;
            //            int lastTag,x;
            UITextField *txt;
            int x = 5;
            int width = 5;
            long lastTag = 50;
            
            for (UIView *v in updateView1.subviews)
            {
                // // // //if(LOGS_ON)NSLog(@"%ld",(long)v.tag);
                isLastViewText=NO;
                if (v.tag>=lastTag)
                {
                    lastTag=v.tag;
                    x = v.frame.origin.x+v.frame.size.width+space_between_view;
                }
                if (lastTag>=0)
                {
                    lastTag++;
                }
                if ([v.accessibilityIdentifier isEqualToString:@"test"]) {
                    x = 5;
                    txt = (UITextField*)v;
                    
                    if (txt.tag>=50) {  // changed 24-12-2015 before (txt.text.length>0&&txt.tag>=50)
                        x = txt.frame.origin.x+txt.frame.size.width+space_between_view;
                    }
                    isLastViewText=YES;
                }
            }
            
            UITextField *updateTextField1;
            if (!isLastViewText)
            {
                // changed 13-01-2016
                
                if (updateView1.subviews.count==1)
                {
                    UIView *getView = (UIView *)[[updateView1.subviews objectAtIndex:0] viewWithTag:50];
                    CGRect rectT = getView.frame;
                    
                    updateTextField1 = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, 5, updateView1.frame.size.height)];
                    updateTextField1.inputView =new_keypad.view;
                    updateTextField1.accessibilityIdentifier = @"test";
                    updateTextField1.delegate = self;
                    updateTextField1.tag = 50;
                    updateTextField1.tintColor = tint_Color;
                    updateTextField1.font = isIpad?math_font1:math_font1_iphone;
                    updateTextField1.backgroundColor = [UIColor clearColor]; //changed 13-01-2016
                    [updateView1 addSubview:updateTextField1];
                    
                    getView.frame=CGRectMake(updateTextField1.frame.origin.x+updateTextField1.frame.size.width+space_between_view, rectT.origin.y, rectT.size.width, rectT.size.height);
                    getView.tag=updateTextField1.tag+1;
                    
                    updateView1.contentSize=CGSizeMake(getView.frame.origin.x+getView.frame.size.width+5, updateView1.frame.size.height);
                    
                    [updateView1 exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
                }
                else
                {
                    updateTextField1 = [[UITextField alloc]initWithFrame:CGRectMake(x+width+space_between_view, 0, 5, updateView1.frame.size.height)];
                    updateTextField1.inputView =new_keypad.view;
                    updateTextField1.accessibilityIdentifier = @"test";
                    updateTextField1.delegate = self;
                    updateTextField1.tag = lastTag;
                    updateTextField1.tintColor = tint_Color;
                    updateTextField1.font = isIpad?math_font1:math_font1_iphone;
                    updateTextField1.backgroundColor = [UIColor clearColor];
                    [updateView1 addSubview:updateTextField1];
                    
                    updateView1.contentSize=CGSizeMake(updateTextField1.frame.origin.x+updateTextField1.frame.size.width+5, updateView1.frame.size.height);
                }
            }
        }
        
    }
    // // // //if(LOGS_ON)NSLog(@"%@",[strEquation componentsSeparatedByString:@"@"]);
}


//-----------   Sub-method which convert specific string to perticular Equation   -----------//

- (id)updateViewWithMenuItem:(NSString*)str_menu andUpdateView:(UIScrollView*)scroll
{
    int x = 5;
    int width = 80;
    long lastTag = 50;
    UITextField *txt;
    UIScrollView *updateScroll = scroll;
    id objReturn;
    for (UIView *v in updateScroll.subviews)
    {
        // // // //if(LOGS_ON)NSLog(@"%ld",(long)v.tag);
        if ([v isKindOfClass:[UIImageView class]])
        {
            [v removeFromSuperview];
        }
    }
    
    for (UIView *v in updateScroll.subviews)
    {
        // // // //if(LOGS_ON)NSLog(@"%ld",(long)v.tag);
        if (v.tag>=lastTag)
        {
            lastTag=v.tag;
            x = v.frame.origin.x+v.frame.size.width+space_between_view;
        }
        if (lastTag>=0)
        {
            lastTag++;
        }
        if ([v.accessibilityIdentifier isEqualToString:@"test"]) {
            x = 5;
            txt = (UITextField*)v;
            
            if (txt.tag>=50) {  // changed 24-12-2015 before (txt.text.length>0&&txt.tag>=50)
                x = txt.frame.origin.x+txt.frame.size.width+space_between_view;
            }
        }
    }
    
    
    CGRect viewFrame = CGRectMake(x, 0, width, updateScroll.frame.size.height);
    UIColor *myColor = [UIColor blackColor];
    if ([fraction_view_id isEqualToString:str_menu])
    {
        FractionView *fv = [[FractionView alloc]initWithFrame:viewFrame andDelegate:self andColor:myColor];
        fv.view.tag = lastTag;
        fv.txt.inputView =new_keypad.view;
        fv.txt1.inputView =new_keypad.view;
        fv.view.accessibilityLabel = fraction_view_id;
        [updateScroll addSubview:fv.view];
        objReturn = fv;
        
        fv.view.backgroundColor=[UIColor clearColor];
    }
    else if ([combination_view_id isEqualToString:str_menu]||[permutation_view_id isEqualToString:str_menu])
    {
        PermutationOrCombinationView *mv;
        if ([combination_view_id isEqualToString:str_menu]) {
            
            mv = [[PermutationOrCombinationView alloc]initWithFrame:viewFrame  andDelegate:self permOrComb:combination andColor:myColor];
            
        }
        else
        {
            mv = [[PermutationOrCombinationView alloc]initWithFrame:viewFrame  andDelegate:self permOrComb:permutation andColor:myColor];
        }
        mv.view.accessibilityLabel = str_menu;
        mv.view.tag = lastTag;
        mv.txt.inputView =new_keypad.view;
        mv.txt1.inputView =new_keypad.view;
        
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt1.font=isIpad?math_script_font:math_script_font_iphone;
        
        mv.txt.backgroundColor = box_back_color;
        mv.txt1.backgroundColor = box_back_color;
        mv.view.backgroundColor = [UIColor clearColor];
        
        [updateScroll addSubview:mv.view];
        objReturn = mv;
    }
    else if ([avenir_view_id isEqualToString:str_menu])
    {
        AvenirView *mv = [[AvenirView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.txt.inputView =new_keypad.view;
        mv.txt1.inputView =new_keypad.view;
        mv.view.backgroundColor = [UIColor clearColor];
        mv.view.accessibilityLabel = str_menu;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        mv.view.tag = lastTag;
        objReturn = mv;
        
        
        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt1.font=isIpad?math_font2:math_font2_iphone;
        
        mv.txt.backgroundColor = [UIColor clearColor];
        mv.txt1.backgroundColor = [UIColor clearColor];
        
    }
    else if ([avenirBox_view_id isEqualToString:str_menu])
    {
        AvenirBoxView *mv = [[AvenirBoxView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.txt.inputView =new_keypad.view;
        mv.txt1.inputView =new_keypad.view;
        mv.txt2.inputView =new_keypad.view;
        mv.txt3.inputView =new_keypad.view;
        mv.view.backgroundColor = [UIColor clearColor];
        mv.view.accessibilityLabel = str_menu;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        mv.view.tag = lastTag;
        objReturn = mv;
        
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt1.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt2.font=isIpad?math_font2:math_font2_iphone;
        mv.txt3.font=isIpad?math_font2:math_font2_iphone;
        
        mv.txt.backgroundColor = [UIColor clearColor];
        mv.txt1.backgroundColor = [UIColor clearColor];
        mv.txt2.backgroundColor = [UIColor clearColor];
        mv.txt3.backgroundColor = [UIColor clearColor];
    }
    else if ([mixedFraction_view_id isEqualToString:str_menu])
    {
        MixedNumberView *mv = [[MixedNumberView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.txt.inputView =new_keypad.view;
        mv.txt1.inputView =new_keypad.view;
        mv.txt2.inputView =new_keypad.view;
        mv.view.backgroundColor = [UIColor clearColor];
        mv.view.accessibilityLabel = mixedFraction_view_id;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        mv.view.tag = lastTag;
        objReturn = mv;
        
        mv.txt.backgroundColor = [UIColor clearColor];
        mv.txt1.backgroundColor = [UIColor clearColor];
        mv.txt2.backgroundColor = [UIColor clearColor];
        
    }
    else if ([limit_view_id isEqualToString:str_menu])
    {
        LimitView *mv = [[LimitView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.txt.inputView =new_keypad.view;
        mv.txt1.inputView =new_keypad.view;
        mv.txt2.inputView =new_keypad.view;
        mv.view.backgroundColor = [UIColor clearColor];
        mv.view.accessibilityLabel = str_menu;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        mv.view.tag = lastTag;
        objReturn = mv;
        
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt1.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt2.font=isIpad?math_font3:math_font3_iphone;
        
        
        mv.txt.backgroundColor = [UIColor clearColor];
        mv.txt1.backgroundColor = [UIColor clearColor];
        mv.txt2.backgroundColor = [UIColor clearColor];
        
    }
    else if ([fx_view_id isEqualToString:str_menu])
    {
        FofXView *mv = [[FofXView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.txt.inputView =new_keypad.view;
        mv.view.backgroundColor = [UIColor clearColor];
        mv.view.accessibilityLabel = str_menu;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        mv.view.tag = lastTag;
        objReturn = mv;
        
        mv.txt.backgroundColor = [UIColor clearColor];
        
    }
    else if ([sqrt_view_id isEqualToString:str_menu])
    {
        OperationView *mv = [[OperationView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = sqrt_view_id;
        mv.txt1.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        objReturn = mv;
        
        mv.view.backgroundColor=[UIColor clearColor];
    }
    else if ([nsqrt_view_id isEqualToString:str_menu])
    {
        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        SquareRoot2View *mv = [[SquareRoot2View alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = nsqrt_view_id;
        mv.view.backgroundColor=[UIColor clearColor];
        mv.txt1.inputView =new_keypad.view;
        mv.txt2.inputView =new_keypad.view;
        mv.txt1.font=isIpad?math_font2:math_font2_iphone;
        mv.txt2.font=isIpad?math_script_font:math_script_font_iphone;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        mv.txt1.font=isIpad?math_font2:math_font2_iphone;
        mv.txt2.font=isIpad?math_script_font:math_script_font_iphone;
    }
    else if ([exponent_e_view_id isEqualToString:str_menu])
    {
        ExponentEView *mv =[[ExponentEView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"e" andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
        //        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([alpha_view_id isEqualToString:str_menu] || [mu_view_id isEqualToString:str_menu] || [sigma_view_id isEqualToString:str_menu])
    {
        ExponentEView *mv;
        
        if ([alpha_view_id isEqualToString:str_menu]) {
            mv =[[ExponentEView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:alpha_ascii andColor:myColor];
        }
        else if ([mu_view_id isEqualToString:str_menu]) {
            mv =[[ExponentEView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:mu_ascii andColor:myColor];
        }
        else if ([sigma_view_id isEqualToString:str_menu]) {
            mv =[[ExponentEView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:sigma_alpha_ascii andColor:myColor];
        }
        
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
        //        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt.backgroundColor = box_back_color;
    }
    
    else if ([exponent_theta_view_id isEqualToString:str_menu])
    {
        ExponentEView *mv =[[ExponentEView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"ø" andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([trigonometric_log_id isEqualToString:str_menu] || [trigonometric_ln_id isEqualToString:str_menu])
    {
        LogView *mv;
        if ([trigonometric_log_id isEqualToString:str_menu]) {
            mv=[[LogView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"log" andColor:myColor];
        }else if ([trigonometric_ln_id isEqualToString:str_menu]) {
            mv=[[LogView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"ln" andColor:myColor];
        }
        
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([trigonometric_logn_id isEqualToString:str_menu] )
    {
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        LogView2 *mv = [[LogView2 alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"log" andColor:myColor];
        
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
        mv.txt1.font=isIpad?math_font2:math_font2_iphone;
        mv.txt.font=isIpad?math_font4:math_font4_iphone;
        
        mv.txt1.backgroundColor = box_back_color;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([exponent_i_view_id isEqualToString:str_menu])
    {
        ExponentEView *mv =[[ExponentEView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"i" andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.txt.inputView =new_keypad.view;
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
        //        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([plus_exponent_view_id isEqualToString:str_menu]||[minus_exponent_view_id isEqualToString:str_menu])
    {
        ExponentPMView *mv;
        if ([plus_exponent_view_id isEqualToString:str_menu]) {
            mv = [[ExponentPMView alloc]initWithFrame:viewFrame  andDelegate:self andOptions:ExponentPM_plus andColor:myColor];
        }
        else
        {
            mv = [[ExponentPMView alloc]initWithFrame:viewFrame  andDelegate:self andOptions:ExponentPM_minus andColor:myColor];
        }
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        mv.view.userInteractionEnabled = FALSE;
        objReturn = mv;
        
        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
    }
    else if ([exponent_view_id isEqualToString:str_menu])
    {
        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        ExponentView *mv = [[ExponentView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.view.backgroundColor=[UIColor clearColor];
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        
        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt1.font=isIpad?math_script_font:math_script_font_iphone;
        
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
    }
    else if ([down_exponent_view_id isEqualToString:str_menu])
    {
        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        ExponentDownView *mv = [[ExponentDownView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.view.backgroundColor=[UIColor clearColor];
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt1.font=isIpad?math_script_font:math_script_font_iphone;
    }
    else if ([tenexponent_view_id isEqualToString:str_menu])
    {
        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        TenExponentView *mv = [[TenExponentView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.view.backgroundColor=[UIColor clearColor];
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        
        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt1.font=isIpad?math_script_font:math_script_font_iphone;
        
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
    }
    else if ([point_view_id isEqualToString:str_menu])
    {
        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        PointView *mv = [[PointView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.view.backgroundColor=[UIColor clearColor];
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
    }
    else if ([parenthesis_view_id isEqualToString:str_menu])
    {
        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        ParenthesisView *mv = [[ParenthesisView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.view.backgroundColor=[UIColor clearColor];
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
    }
    else if ([absolute_view_id isEqualToString:str_menu])
    {
        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        AbsoluteView *mv = [[AbsoluteView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.view.backgroundColor=[UIColor clearColor];
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
    }
    else if ([precalculus_sigma_id isEqualToString:str_menu])
    {
        viewFrame = CGRectMake(x, 0, width, updateScroll.frame.size.height);
        SigmaView *mv = [[SigmaView alloc] initWithFrame:viewFrame andDelegate:self withOptionString:sigma_ascii fontSize:16.0 andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.view.backgroundColor=[UIColor clearColor];
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        mv.txt2.inputView =new_keypad.view;
        
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
    }
    else if ([trigonometric_sin_id isEqualToString:str_menu] || [trigonometric_arcsin_id isEqualToString:str_menu] || [trigonometric_sinh_id isEqualToString:str_menu] || [trigonometric_cos_id isEqualToString:str_menu] || [trigonometric_arccos_id isEqualToString:str_menu] || [trigonometric_cosh_id isEqualToString:str_menu] || [trigonometric_tan_id isEqualToString:str_menu] || [trigonometric_arctan_id isEqualToString:str_menu] || [trigonometric_tanh_id isEqualToString:str_menu]  || [trigonometric_sec_id isEqualToString:str_menu] || [trigonometric_arcsec_id isEqualToString:str_menu] || [trigonometric_sech_id isEqualToString:str_menu] || [trigonometric_csc_id isEqualToString:str_menu] || [trigonometric_arccsc_id isEqualToString:str_menu] || [trigonometric_csch_id isEqualToString:str_menu]  || [trigonometric_cot_id isEqualToString:str_menu] || [trigonometric_arccot_id isEqualToString:str_menu] || [trigonometric_coth_id isEqualToString:str_menu])
    {
        TrigonometricView *mv;
        if ([trigonometric_sin_id isEqualToString:str_menu]) {
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"sin" andColor:myColor];
        }else if ([trigonometric_arcsin_id isEqualToString:str_menu]){
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"arcsin" andColor:myColor];
        }else if ([trigonometric_sinh_id isEqualToString:str_menu]){
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"sinh" andColor:myColor];
        }else if ([trigonometric_cos_id isEqualToString:str_menu]) {
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"cos" andColor:myColor];
        }else if ([trigonometric_arccos_id isEqualToString:str_menu]){
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"arccos" andColor:myColor];
        }else if ([trigonometric_cosh_id isEqualToString:str_menu]){
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"cosh" andColor:myColor];
        }else if ([trigonometric_tan_id isEqualToString:str_menu]) {
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"tan" andColor:myColor];
        }else if ([trigonometric_arctan_id isEqualToString:str_menu]){
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"arctan" andColor:myColor];
        }else if ([trigonometric_tanh_id isEqualToString:str_menu]){
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"tanh" andColor:myColor];
        }else if ([trigonometric_sec_id isEqualToString:str_menu]) {
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"sec" andColor:myColor];
        }else if ([trigonometric_arcsec_id isEqualToString:str_menu]){
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"arcsec" andColor:myColor];
        }else if ([trigonometric_sech_id isEqualToString:str_menu]){
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"sech" andColor:myColor];
        }else if ([trigonometric_csc_id isEqualToString:str_menu]) {
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"csc" andColor:myColor];
        }else if ([trigonometric_arccsc_id isEqualToString:str_menu]){
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"arccsc" andColor:myColor];
        }else if ([trigonometric_csch_id isEqualToString:str_menu]){
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"csch" andColor:myColor];
        }else if ([trigonometric_cot_id isEqualToString:str_menu]) {
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"cot" andColor:myColor];
        }else if ([trigonometric_arccot_id isEqualToString:str_menu]){
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"arccot" andColor:myColor];
        }else if ([trigonometric_coth_id isEqualToString:str_menu]){
            mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"coth" andColor:myColor];
        }
        
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([trigonometric_sinn_id isEqualToString:str_menu] || [trigonometric_cosn_id isEqualToString:str_menu] || [trigonometric_tann_id isEqualToString:str_menu] || [trigonometric_secn_id isEqualToString:str_menu] || [trigonometric_cscn_id isEqualToString:str_menu] || [trigonometric_cotn_id isEqualToString:str_menu])
    {
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        TrigonometricView2 *mv;
        
        if ([trigonometric_sinn_id isEqualToString:str_menu]) {
            mv = [[TrigonometricView2 alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"sin" andColor:myColor];//@"sinn"
        }
        else if ([trigonometric_cosn_id isEqualToString:str_menu]) {
            mv = [[TrigonometricView2 alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"cos" andColor:myColor];//@"cosn"
        }
        else if ([trigonometric_tann_id isEqualToString:str_menu]) {
            mv = [[TrigonometricView2 alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"tan" andColor:myColor];//@"tann"
        }
        else if ([trigonometric_secn_id isEqualToString:str_menu]) {
            mv = [[TrigonometricView2 alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"sec" andColor:myColor];//@"secn"
        }
        else if ([trigonometric_cscn_id isEqualToString:str_menu]) {
            mv = [[TrigonometricView2 alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"csc" andColor:myColor];//@"cscn"
        }
        else if ([trigonometric_cotn_id isEqualToString:str_menu]) {
            mv = [[TrigonometricView2 alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"cot" andColor:myColor];//@"cotn"
        }
        
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = str_menu;
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        objReturn = mv;
        
        //        mv.txt1.font=isIpad?math_font2:math_font2_iphone;
        mv.txt.font=[UIFont systemFontOfSize:15.0];
        
        mv.txt1.backgroundColor = box_back_color;
        mv.txt.backgroundColor = box_back_color;
    }
    
    else if ([str_general_text isEqualToString:str_menu])
    {
        UITextField *updateTextField1 = [[UITextField alloc]initWithFrame:viewFrame];
        updateTextField1.inputView =new_keypad.view;
        updateTextField1.accessibilityIdentifier = @"test";
        updateTextField1.delegate = self;
        updateTextField1.tag = lastTag;
        updateTextField1.tintColor = tint_Color;
        updateTextField1.font = isIpad?math_font1:math_font1_iphone;
        updateTextField1.backgroundColor = [UIColor clearColor];
        [updateScroll addSubview:updateTextField1];
        objReturn = updateTextField1;
    }
    else if ([str_menu integerValue]==k_plus||[str_menu integerValue]==k_minus||[str_menu integerValue]==k_multiplication||[str_menu integerValue]==k_devide||[@"gte_ipad" isEqualToString:str_menu]||[@"lte_ipad" isEqualToString:str_menu]||[@"gt_ipad" isEqualToString:str_menu]||[@"lt_ipad" isEqualToString:str_menu]||[@"equal_ipad" isEqualToString:str_menu]||[@"divide_ipad" isEqualToString:str_menu]||[@"parcent_ipad" isEqualToString:str_menu]||[@"pi_ipad" isEqualToString:str_menu]||[@"intersection_ipad" isEqualToString:str_menu]||[@"union_ipad" isEqualToString:str_menu]||[@"aerrow_ipad" isEqualToString:str_menu]||[@"xbar_ipad" isEqualToString:str_menu]||[@"muxb_ipad" isEqualToString:str_menu]||[@"infinity_ipad" isEqualToString:str_menu]||[@"sigmaxb_ipad" isEqualToString:str_menu] || [@"factorial_ipad" isEqualToString:str_menu])
    {
        
        OperationView1 *mv;
        if ([@"gte_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_graterthanEqual andColor:myColor];
        }
        else if ([@"equal_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_equal andColor:myColor];
            
        }
        else if ([@"lt_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_lessthan andColor:myColor];
            
        }
        else if ([@"gt_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_graterthan andColor:myColor];
            
        }
        else if ([@"lte_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_lessthanEqual andColor:myColor];
            
        }
        else if ([@"divide_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_devide andColor:myColor];
            
        }
        else if ([@"parcent_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_percentage andColor:myColor];
            
        }
        else if ([@"union_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_union andColor:myColor];
            
        }
        else if ([@"intersection_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_intersection andColor:myColor];
            
        }
        else if ([@"pi_ipad" isEqualToString:str_menu])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_pie andColor:myColor];
            
        }
        else if ([@"aerrow_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_arrow andColor:myColor];
            
        }
        else if ([@"xbar_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_xbar andColor:myColor];
            //            return nil;
        }
        else if ([@"infinity_ipad" isEqualToString:str_menu])
        {
            
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_infinity andColor:myColor];
        }//infinity_ipad
        else if ([@"muxb_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_mu_xbar andColor:myColor];
            //            return nil;
            
        }
        else if ([@"sigmaxb_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_sigma_xbar andColor:myColor];
            //            return nil;
            
        }
        else if ([@"factorial_ipad" isEqualToString:str_menu])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_factorial andColor:myColor];
        }
        else
        {
            switch ([str_menu integerValue]) {
                case k_plus:
                    mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_plus andColor:myColor];
                    break;
                case k_minus:
                    mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_minus andColor:myColor];
                    break;
                case k_multiplication:
                    mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_multiplication andColor:myColor];
                    break;
                case k_devide:
                    mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_devide andColor:myColor];
                    break;
                default:
                    break;
            }
        }
        
        if (mv!=nil)
        {
            mv.view.accessibilityLabel = operation_view_id;
            mv.view.tag = lastTag;
            mv.txt1.inputView = new_keypad.view;
            [updateScroll addSubview:mv.view];
            
        }
        objReturn = mv;
    }
    
    updateScroll.contentSize=CGSizeMake(x+width+5, updateScroll.frame.size.height);
    return objReturn;
}
-(void)setSizeForTextfield:(UITextField*)txt;
{
    NSString *valueString = txt.text;
    CGSize newSize = [valueString sizeWithFont: [UIFont fontWithName: txt.font.fontName size: txt.font.pointSize] ]; // changed 06-01-2016
    
    //    NSDictionary *attributes = @{NSFontAttributeName : txt.font};
    //    CGSize newSize = [txt.text sizeWithAttributes:attributes];
    
    // assign new size
    CGRect textFrame = txt.frame;
    textFrame.size  = newSize;
    txt.frame = CGRectMake(txt.frame.origin.x, txt.frame.origin.y, newSize.width+extra_textfield_space, txt.frame.size.height);
    if ([txt.accessibilityIdentifier isEqualToString:@"test"])
    {
        txt.textAlignment = NSTextAlignmentCenter;
    }
    
}
-(void)updateSubviewFramesAndManageTagAfterDeleteViewForScrollView:(UIScrollView*)new_scroll
{
    // // // //if(LOGS_ON)NSLog(@"%@",new_scroll.subviews);
    int lastTag = 50;
    CGRect lastFrame = CGRectZero;//11-9-2015;
    UIView *lastView=nil;
    for (int i=0; i<new_scroll.subviews.count; i++) // changed 18-01-2016 count to count-1
    {
        UIView *v =  [new_scroll.subviews objectAtIndex:i];
        
        /*  24-12-2015
         if ([v isKindOfClass:[UITextField class]]&&[lastView isKindOfClass:[UITextField class]]&&[v.accessibilityIdentifier isEqualToString:@"test"]&&[lastView.accessibilityIdentifier isEqualToString:@"test"])
         {
         // // // //if(LOGS_ON)NSLog(@"%@",new_scroll.subviews);
         
         UITextField *txt = (UITextField*)lastView;
         UITextField *txt1 = (UITextField*)v;
         txt.text = [NSString stringWithFormat:@"%@%@",txt.text,txt1.text];
         int oldY = txt.frame.origin.y;
         int oldHeight = txt.frame.size.height;
         [txt sizeToFit];
         txt.frame = CGRectMake(txt.frame.origin.x, oldY, txt.frame.size.width+6, oldHeight);
         [txt1 removeFromSuperview];
         [txt becomeFirstResponder];
         
         lastFrame = txt.frame;
         // // // //if(LOGS_ON)NSLog(@"%@",new_scroll.subviews);
         i--;
         }
         else
         {*/
        if (v.tag-lastTag>1)
        {
            v.tag = lastTag+1;
            // // // //if(LOGS_ON)NSLog(@"lastFrame X: %f",lastFrame.origin.x);
            // // // //if(LOGS_ON)NSLog(@"lastFrame y: %f",lastFrame.origin.y);
            // // // //if(LOGS_ON)NSLog(@"lastFrame width: %f",lastFrame.size.width);
            // // // //if(LOGS_ON)NSLog(@"lastFrame height: %f",lastFrame.size.height);
            v.frame = CGRectMake(lastFrame.origin.x+lastFrame.size.width+space_between_view, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
            if (i==new_scroll.subviews.count-1) // changed 18-01-2016  -1 to -2
            {
                if ([v isKindOfClass:[UITextField class]]&&[v.accessibilityIdentifier isEqualToString:@"test"])
                {
                    UITextField *updateTextField1 = (UITextField*)v;
                    if (updateTextField1.frame.origin.x+updateTextField1.frame.size.width<new_scroll.frame.size.width)
                    {
                        int width1 = new_scroll.frame.size.width - updateTextField1.frame.origin.x;
                        updateTextField1.frame = CGRectMake(updateTextField1.frame.origin.x, updateTextField1.frame.origin.y, width1, updateTextField1.frame.size.height);
                        updateTextField1.textAlignment=NSTextAlignmentLeft;
                    }
                }
                
            }// changed 18-01-2016 else condition is added before just two line else is there after this mention text
            else
            {
                lastFrame = v.frame;
                lastTag = (int)v.tag;
            }
        }
        else
        {
            lastTag = (int)v.tag;
            lastFrame = v.frame;
        }
        lastView = v;
        //        }  // changed 24-12-2015
        
    }
    // // // //if(LOGS_ON)NSLog(@"%@",new_scroll.subviews);
    new_scroll.contentSize = CGSizeMake(lastFrame.origin.x+lastFrame.size.width+space_between_view, new_scroll.frame.size.height);
}
-(void)manageTagForNilViewInScrollView:(UIScrollView*)new_scroll
{
    int lastTag = 51;
    for (int i=0; i<new_scroll.subviews.count; i++)
    {
        UIView *v =  [new_scroll.subviews objectAtIndex:i];
        v.tag = lastTag+1;
        lastTag = (int)v.tag;
        if (i==0)
        {
            if ([v isKindOfClass:[UITextField class]]&&[v.accessibilityIdentifier isEqualToString:@"test"])
            {
                UITextField *updateTextField1 = (UITextField*)v;
                activeTextfield = updateTextField1;
                [activeTextfield becomeFirstResponder];
            }
            else if ([v isKindOfClass:[UIView class]]&& [v.accessibilityLabel isEqualToString:operation_view_id])
            {
                for (int i=0;i<v.subviews.count;i++)
                {
                    UIView *t = [v.subviews objectAtIndex:i];
                    // // // //if(LOGS_ON)NSLog(@"%@",t);
                    if ([t isKindOfClass:[UITextField class]])
                    {
                        UITextField *tx = (UITextField*)t;
                        tx.inputView = new_keypad.view;
                        [tx becomeFirstResponder];
                        break;
                    }
                    else if([t isKindOfClass:[UIView class]]&&[t.accessibilityIdentifier isEqualToString:textField_container])
                    {
                        for (int j=0;j<t.subviews.count;j++)
                        {
                            UIView *t1 = [t.subviews objectAtIndex:j];
                            // // // //if(LOGS_ON)NSLog(@"%@",t1);
                            if ([t1 isKindOfClass:[UITextField class]])
                            {
                                UITextField *tx = (UITextField*)t1;
                                tx.inputView = new_keypad.view;
                                //                                tx.textAlignment = NSTextAlignmentJustified;
                                [tx becomeFirstResponder];
                                break;
                            }
                        }
                    }
                    
                }
            }
            else
            {
                UIView *nv = [v viewWithTag:1];
                if ([nv isKindOfClass:[UITextField class]])
                {
                    [nv becomeFirstResponder];
                }
            }
            
            
        }
    }
}
- (void)deleteClicked:(id)sender
{
    UIButton *btn = sender;
    UIScrollView *updateScroll;
    BOOL isOperationViewDeleted = FALSE;
    LAStudentCustomAnswerCell *cell = (LAStudentCustomAnswerCell *)[self superViewOfType:[LAStudentCustomAnswerCell class] forView:activeTextfield];
    if (cell)
    {
        updateScroll = cell.updateScroll;
    }
    
    for (UIView *v in updateScroll.subviews)
    {
        // // // //if(LOGS_ON)NSLog(@"%ld",(long)v.tag);
        
        if ([v isKindOfClass:[UIImageView class]])
        {
            [v removeFromSuperview];
        }
    }
    
    // // // //if(LOGS_ON)NSLog(@"%@",updateScroll.subviews);
    UIView *V;
    if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
    {
        V = [updateScroll viewWithTag:activeTextfield.tag-1];
        if ([updateScroll viewWithTag:activeTextfield.tag+1]!=nil) {
            [activeTextfield removeFromSuperview];
        }
    }
    else
    {
        V = (UIView *)[self superViewOfType:[UIView class] forActiveTextField:activeTextfield];
        if (activeTextfield.tag<=1)
        {
            NSUInteger myTag = V.tag;
            // // // //if(LOGS_ON)NSLog(@"%@",V);
            if ([V isKindOfClass:[UIView class]]&& [V.accessibilityLabel isEqualToString:operation_view_id])//18-8-2015
            {
                isOperationViewDeleted = TRUE;//18-8-2015
            }
            //            [self checkAllFieldsAreBlankOrNotBeforeDeleteForView:V];
            if ([self checkAllFieldsAreBlankOrNotBeforeDeleteForView:V])
            {
                // changed 19-01-2016
                if ([[[updateScroll viewWithTag:myTag-1] accessibilityIdentifier] isEqualToString:@"test"])
                {
                    if ([[[updateScroll viewWithTag:myTag+1] accessibilityIdentifier] isEqualToString:@"test"])
                    {
                        UITextField * setActive = (UITextField*) [updateScroll viewWithTag:myTag-1];
                        
                        UITextField *vRemoveLastActive = (UITextField *)[updateScroll viewWithTag:myTag+1];
                        
                        if (vRemoveLastActive.text.length==0)
                        {
                            int widthExtend=0;
                            if (updateScroll.contentSize.width>updateScroll.frame.size.width)
                            {
                                setActive.frame=CGRectMake(setActive.frame.origin.x, setActive.frame.origin.y, updateScroll.contentSize.width-(setActive.frame.origin.x+setActive.frame.size.width), setActive.frame.size.height);
                            }
                            else
                            {
                                widthExtend = updateScroll.frame.size.width-setActive.frame.origin.x;
                                if (widthExtend>0) {
                                    setActive.frame=CGRectMake(setActive.frame.origin.x, setActive.frame.origin.y, widthExtend, setActive.frame.size.height);
                                }else{
                                    setActive.frame=CGRectMake(setActive.frame.origin.x, setActive.frame.origin.y, setActive.frame.size.width, setActive.frame.size.height);
                                }
                            }
                            
                            setActive.textAlignment=NSTextAlignmentLeft;
                            
                            updateScroll.contentSize=CGSizeMake(setActive.frame.origin.x+setActive.frame.size.width+space_between_view, updateScroll.contentSize.height);
                            [vRemoveLastActive removeFromSuperview];
                            
                        }
                    }
                }
                ////
                
                [V removeFromSuperview];
                V = nil;
                V = [updateScroll viewWithTag:myTag-1];
                
            }
            else
            {
                // changed 31-12-2015
                UIButton *btn1 = (UIButton *)btn;
                int tag_btn = (int)btn.tag;
                btn1.tag=k_backward;
                [self forwardOrBackwordClicked:btn1];
                btn1.tag=tag_btn;
                //
                return;
            }
            
        }
        else if ([V isKindOfClass:[UIView class]]&& [V.accessibilityLabel isEqualToString:operation_view_id])
        {
            NSUInteger myTag = V.tag;
            // // // //if(LOGS_ON)NSLog(@"%@",V);
            
            if ([self checkAllFieldsAreBlankOrNotBeforeDeleteForView:V])
            {
                [V removeFromSuperview];
                V = nil;
                V = [updateScroll viewWithTag:myTag-1];
                isOperationViewDeleted = TRUE;
                activeTextfield = nil;
            }
            else
            {
                // changed 31-12-2015
                UIButton *btn1 = (UIButton *)btn;
                int tag_btn = (int)btn.tag;
                btn1.tag=k_backward;
                [self forwardOrBackwordClicked:btn1];
                btn1.tag=tag_btn;
                //
                return;
            }
            
        }
    }
    // // // //if(LOGS_ON)NSLog(@"%@",V);
    // // // //if(LOGS_ON)NSLog(@"%ld",(long)activeTextfield.tag);
    
    if (V==nil)
    {
        [self manageTagForNilViewInScrollView:updateScroll];
        return;
    }
    
    if (activeTextfield.tag>1&&![activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
    {
        UIView *newView = [V viewWithTag:activeTextfield.tag-1];
        if (newView!=nil&&[newView isKindOfClass:[UITextField class]]) {
            activeTextfield = (UITextField*)newView;
            [activeTextfield becomeFirstResponder];
            return;//11-9-2015
            if (activeTextfield.text.length>0)
            {
                activeTextfield.text = [activeTextfield.text substringToIndex:activeTextfield.text.length-1];
                if (![activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
                {
                    [self textFieldDidChange:activeTextfield];
                }
                else if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"]&&activeTextfield.text.length>=1) // changed 13-01-2016 = is added because between text box size not set when lenght=1
                {
                    [self getXpositionAfterUpdatingTestTextfield:activeTextfield];
                }
            }
            else
            {
                if ([activeTextfield.accessibilityIdentifier isEqualToString:textField_identifier]) {
                    activeTextfield.backgroundColor = box_back_color;//11-9-2015
                }
                [self deleteClicked:btn];
            }
        }
        
    }
    else
    {
        UIView *newv;
        if ([V isKindOfClass:[UIView class]]&& [V.accessibilityLabel isEqualToString:operation_view_id])
        {
            
            
            newv = V;
            for (int i=0;i<newv.subviews.count;i++)
            {
                UIView *t = [newv.subviews objectAtIndex:i];
                // // // //if(LOGS_ON)NSLog(@"%@",t);
                if ([t isKindOfClass:[UITextField class]])
                {
                    UITextField *tx = (UITextField*)t;
                    tx.inputView = new_keypad.view;
                    [tx becomeFirstResponder];
                    break;
                }
                else if([t isKindOfClass:[UIView class]]&&[t.accessibilityIdentifier isEqualToString:textField_container])
                {
                    for (int j=0;j<t.subviews.count;j++)
                    {
                        UIView *t1 = [t.subviews objectAtIndex:j];
                        // // // //if(LOGS_ON)NSLog(@"%@",t1);
                        if ([t1 isKindOfClass:[UITextField class]])
                        {
                            UITextField *tx = (UITextField*)t1;
                            tx.inputView = new_keypad.view;
                            //                            tx.textAlignment = NSTextAlignmentJustified;
                            [tx becomeFirstResponder];
                            break;
                        }
                    }
                }
                
            }
            
            //            [V removeFromSuperview];
            //            isOperationViewDeleted = TRUE;
        }
        else if([V isKindOfClass:[UITextField class]]&& [V.accessibilityLabel isEqualToString:@"Test"])
        {
            
            newv = [updateScroll viewWithTag:V.tag-1];
            [V removeFromSuperview];
        }
        else
        {
            newv =V;
        }
        
        UIView *newVi = nil;
        if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:fraction_view_id])
        {
            newVi = [newv viewWithTag:2];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:mixedFraction_view_id])
        {
            newVi = [newv viewWithTag:3];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:permutation_view_id])
        {
            newVi = [newv viewWithTag:2];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:avenir_view_id])
        {
            newVi = [newv viewWithTag:2];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:avenirBox_view_id])
        {
            newVi = [newv viewWithTag:4];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:combination_view_id])
        {
            newVi = [newv viewWithTag:2];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:limit_view_id])
        {
            newVi = [newv viewWithTag:3];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:fx_view_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:sqrt_view_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:nsqrt_view_id])
        {
            newVi = [newv viewWithTag:2];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:exponent_e_view_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:alpha_view_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:sigma_view_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:mu_view_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:exponent_theta_view_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_log_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_ln_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_logn_id])
        {
            newVi = [newv viewWithTag:2];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:exponent_i_view_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:minus_exponent_view_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:plus_exponent_view_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:exponent_view_id])
        {
            newVi = [newv viewWithTag:2];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:down_exponent_view_id])
        {
            newVi = [newv viewWithTag:2];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:tenexponent_view_id])
        {
            newVi = [newv viewWithTag:2];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:point_view_id])
        {
            newVi = [newv viewWithTag:2];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:parenthesis_view_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:absolute_view_id])
        {
            newVi = [newv viewWithTag:1];
            
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:precalculus_sigma_id])
        {
            newVi = [newv viewWithTag:3];
            
        }
        
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_sin_id])
        {
            newVi = [newv viewWithTag:1];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_arcsin_id])
        {
            newVi = [newv viewWithTag:1];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_sinh_id])
        {
            newVi = [newv viewWithTag:1];
        }
        
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_cos_id])
        {
            newVi = [newv viewWithTag:1];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_arccos_id])
        {
            newVi = [newv viewWithTag:1];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_cosh_id])
        {
            newVi = [newv viewWithTag:1];
        }
        
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_tan_id])
        {
            newVi = [newv viewWithTag:1];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_arctan_id])
        {
            newVi = [newv viewWithTag:1];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_tanh_id])
        {
            newVi = [newv viewWithTag:1];
        }
        
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_sec_id])
        {
            newVi = [newv viewWithTag:1];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_arcsec_id])
        {
            newVi = [newv viewWithTag:1];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_sech_id])
        {
            newVi = [newv viewWithTag:1];
        }
        
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_csc_id])
        {
            newVi = [newv viewWithTag:1];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_arccsc_id])
        {
            newVi = [newv viewWithTag:1];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_csch_id])
        {
            newVi = [newv viewWithTag:1];
        }
        
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_cot_id])
        {
            newVi = [newv viewWithTag:1];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_arccot_id])
        {
            newVi = [newv viewWithTag:1];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_coth_id])
        {
            newVi = [newv viewWithTag:1];
        }
        
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_sinn_id])
        {
            newVi = [newv viewWithTag:2];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_cosn_id])
        {
            newVi = [newv viewWithTag:2];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_tann_id])
        {
            newVi = [newv viewWithTag:2];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_secn_id])
        {
            newVi = [newv viewWithTag:2];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_cscn_id])
        {
            newVi = [newv viewWithTag:2];
        }
        else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_cotn_id])
        {
            newVi = [newv viewWithTag:2];
        }
        
        else if ([newv isKindOfClass:[UITextField class]])
        {
            newVi = newv;
            if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"]) {
                [activeTextfield removeFromSuperview];
                isOperationViewDeleted = FALSE;
            }
        }
        if (newVi!=nil&&[newVi isKindOfClass:[UITextField class]])
        {
            if (isOperationViewDeleted==FALSE)
            {
                activeTextfield = (UITextField*)newVi;
            }
            if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
            {
                [activeTextfield becomeFirstResponder];
            }
            else
            {
                if (activeTextfield.text.length>0&&isOperationViewDeleted==FALSE) {
                    activeTextfield.text = [activeTextfield.text substringToIndex:activeTextfield.text.length-1];
                    if (![activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
                    {
                        [self textFieldDidChange:activeTextfield];
                    }
                    else if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"]&&activeTextfield.text.length>=1) // changed 13-01-2016 = is added because between text box size not set when lenght=1
                    {
                        [self getXpositionAfterUpdatingTestTextfield:activeTextfield];
                    }
                    
                }
                else
                {
                    activeTextfield = (UITextField*)newVi;
                }
                [activeTextfield becomeFirstResponder];
                
            }
            //            activeTextfield.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
            
        }
    }
}
- (UIView*)superViewOfType:(Class)class forActiveTextField:(UITextField*)view
{
    // // // //if(LOGS_ON)NSLog(@"%@",class);
    // // // //if(LOGS_ON)NSLog(@"%@",view);
    UIView *myView = nil;
    LOG_FUNCTION_START
    //&& ![myView.accessibilityIdentifier isEqualToString:textField_container]
    if (myView==nil&& view != nil) {
        myView = [view superview];
    }
    // // // //if(LOGS_ON)NSLog(@"%@",myView.accessibilityIdentifier);
    while ((![myView isKindOfClass:class] && myView != nil) || [myView.accessibilityIdentifier isEqualToString:textField_container])
    {
        if (myView==nil) {
            // // // //if(LOGS_ON)NSLog(@"View --- %@",view);
            myView = [view superview];
        }
        else
        {
            // // // //if(LOGS_ON)NSLog(@"View --- %@",myView);
            myView = [myView superview];
        }
        //        // // // //if(LOGS_ON) // // // //if(LOGS_ON)NSLog(@"View --- %@",view);
    }
    // // // //if(LOGS_ON)NSLog(@"%@",myView);
    //    // // // //if(LOGS_ON)NSLog(@"%hhd",[view isKindOfClass:class]);
    // // // //if(LOGS_ON)NSLog(@"%@",myView.accessibilityIdentifier);
    //TODO: add assertion to warn user about superview.
    return myView ;
}
-(NSString*)getStringFromButtonPress:(UIButton*)btn//27-8-2015
{
    NSString *str = @"";
    
    switch (btn.tag)
    {
        case k_negative:
        {
            str = @"-";
            break;
        }
        case k_coma:
        {
            str = @",";
            break;
        }
        case k_x:
        case alpha_x:
            
            if (btn.selected)
            {
                str = @"X";
            }
            else
            {
                str = @"x";
            }
            break;
        case k_y:
        case alpha_y:
            if (btn.selected)
            {
                str = @"Y";
            }
            else
            {
                str = @"y";
            }
            break;
        case k_z:
        case alpha_z:
            if (btn.selected)
            {
                str = @"Z";
            }
            else
            {
                str = @"z";
            }
            break;
        case alpha_a:
            if (btn.selected)
            {
                str = @"A";
            }
            else
            {
                str = @"a";
            }
            break;
        case alpha_b:
            if (btn.selected)
            {
                str = @"B";
            }
            else
            {
                str = @"b";
            }
            break;
        case alpha_c:
            if (btn.selected)
            {
                str = @"C";
            }
            else
            {
                str = @"c";
            }
            break;
        case alpha_d:
            if (btn.selected)
            {
                str = @"D";
            }
            else
            {
                str = @"d";
            }
            break;
        case alpha_e:
            if (btn.selected)
            {
                str = @"E";
            }
            else
            {
                str = @"e";
            }
            break;
        case alpha_f:
            if (btn.selected)
            {
                str = @"F";
            }
            else
            {
                str = @"f";
            }
            break;
        case alpha_g:
            if (btn.selected)
            {
                str = @"G";
            }
            else
            {
                str = @"g";
            }
            break;
        case alpha_h:
            if (btn.selected)
            {
                str = @"H";
            }
            else
            {
                str = @"h";
            }
            break;
        case alpha_i:
            if (btn.selected)
            {
                str = @"I";
            }
            else
            {
                str = @"i";
            }
            break;
        case alpha_j:
            if (btn.selected)
            {
                str = @"J";
            }
            else
            {
                str = @"j";
            }
            break;
        case alpha_k:
            if (btn.selected)
            {
                str = @"K";
            }
            else
            {
                str = @"k";
            }
            break;
        case alpha_l:
            if (btn.selected)
            {
                str = @"L";
            }
            else
            {
                str = @"l";
            }
            break;
        case alpha_m:
            if (btn.selected)
            {
                str = @"M";
            }
            else
            {
                str = @"m";
            }
            break;
        case alpha_n:
            if (btn.selected)
            {
                str = @"N";
            }
            else
            {
                str = @"n";
            }
            break;
        case alpha_o:
            if (btn.selected)
            {
                str = @"O";
            }
            else
            {
                str = @"o";
            }
            break;
        case alpha_p:
            if (btn.selected)
            {
                str = @"P";
            }
            else
            {
                str = @"p";
            }
            break;
        case alpha_q:
            if (btn.selected)
            {
                str = @"Q";
            }
            else
            {
                str = @"q";
            }
            break;
        case alpha_r:
            if (btn.selected)
            {
                str = @"R";
            }
            else
            {
                str = @"r";
            }
            break;
        case alpha_s:
            if (btn.selected)
            {
                str = @"S";
            }
            else
            {
                str = @"s";
            }
            break;
        case alpha_t:
            if (btn.selected)
            {
                str = @"T";
            }
            else
            {
                str = @"t";
            }
            break;
        case alpha_u:
            if (btn.selected)
            {
                str = @"U";
            }
            else
            {
                str = @"u";
            }
            break;
        case alpha_v:
            if (btn.selected)
            {
                str = @"V";
            }
            else
            {
                str = @"v";
            }
            break;
        case alpha_w:
            if (btn.selected)
            {
                str = @"W";
            }
            else
            {
                str = @"w";
            }
            break;
        case alpha_coma:
            str = @",";
            break;
        case alpha_space:
            str = @" ";
            break;
        case k_one:
            // // // //if(LOGS_ON)NSLog(@"1 pressed");
            str = @"1";
            break;
        case k_two:
            // // //if(LOGS_ON)NSLog(@"2 pressed");
            str = @"2";
            break;
        case k_three:
            // // if(LOGS_ON)NSLog(@"3 pressed");
            str = @"3";
            break;
        case k_four:
            // // if(LOGS_ON)NSLog(@"4 pressed");
            str = @"4";
            break;
        case k_five:
            // // if(LOGS_ON)NSLog(@"5 pressed");
            str = @"5";
            break;
        case k_six:
            // // if(LOGS_ON)NSLog(@"6 pressed");
            str = @"6";
            break;
        case k_seven:
            // // if(LOGS_ON)NSLog(@"7 pressed");
            str = @"7";
            break;
        case k_eight:
            // // if(LOGS_ON)NSLog(@"8 pressed");
            str = @"8";
            break;
        case k_nine:
            // // if(LOGS_ON)NSLog(@"9 pressed");
            str = @"9";
            break;
        case k_zero:
            // // if(LOGS_ON)NSLog(@"0 pressed");
            str = @"0";
            break;
        case k_dot:
            // // if(LOGS_ON)NSLog(@"dot pressed");
            str = @".";
            break;
        case k_c_perenth:
            // // if(LOGS_ON)NSLog(@"right parenthesis pressed");
            str = @")";
            break;
        case k_o_perenth:
            // if(LOGS_ON)NSLog(@"left parenthesis pressed");
            str = @"(";
            break;
            //        case k_equal:
            //            // if(LOGS_ON)NSLog(@"dot pressed");
            //            str = @"=";
            //            break;
        default:
            break;
    }
    return str;
}
-(void)addNewTextfieldBetweenViewWithString:(NSString*)str//27-8-2015
{
    if (str.length<=0) {
        return;
    }
    UIScrollView *updateScroll1 =(UIScrollView*)[self superViewOfType:[UIScrollView class] forActiveTextField:activeTextfield];
    for (UIView *v in updateScroll1.subviews)
    {
        // if(LOGS_ON)NSLog(@"%ld",(long)v.tag);
        
        if ([v isKindOfClass:[UIImageView class]])
        {
            [v removeFromSuperview];
        }
    }
    
    long lastTag = 1;
    UIColor *myColor = [UIColor blackColor];
    //    if (isTeacherViewing)//11-8-2015
    //    {
    //        myColor = TEACHER_WRITING_COLOR;//11-8-2015
    //    }
    for (UIView *v in updateScroll1.subviews)
    {
        if(LOGS_ON)NSLog(@"%ld",(long)v.tag);
        
        if (v.tag>=lastTag)
        {
            lastTag=v.tag;
        }
        if (lastTag>=50)
        {
            lastTag++;
        }
    }
    int activeViewTag = 0;//27-8-2015 - end
    CGRect activeViewFrame = CGRectZero;//27-8-2015 - end
    BOOL isViewBetween = FALSE;//27-8-2015 - end
    UIView *V = (UIView *)[self superViewOfType:[UIView class] forActiveTextField:activeTextfield];
    
    BOOL isOperationViewBlank = TRUE;
    if ([V.accessibilityLabel isEqualToString:operation_view_id])
    {
        for (int i=0;i<V.subviews.count;i++)
        {
            UIView *t = [V.subviews objectAtIndex:i];
            if(LOGS_ON)NSLog(@"%@",t);
            if ([t isKindOfClass:[UITextField class]])
            {
                UITextField *tx = (UITextField*)t;
                tx.inputView = new_keypad.view;
                if (tx.text.length>0) {
                    isOperationViewBlank = FALSE;
                }
                break;
            }
            else if([t isKindOfClass:[UIView class]]&&[t.accessibilityIdentifier isEqualToString:textField_container])
            {
                for (int j=0;j<t.subviews.count;j++)
                {
                    UIView *t1 = [t.subviews objectAtIndex:j];
                    if(LOGS_ON)NSLog(@"%@",t1);
                    if ([t1 isKindOfClass:[UITextField class]])
                    {
                        UITextField *tx = (UITextField*)t1;
                        tx.inputView = new_keypad.view;
                        //                        tx.textAlignment = NSTextAlignmentJustified;
                        if (tx.text.length>0) {
                            isOperationViewBlank = FALSE;
                        }
                        break;
                    }
                }
            }
            
        }
        
        if (lastTag>=50&&V.tag>=50)
        {
            int newViewTag = 0;
            if (isOperationViewBlank)
            {
                newViewTag = (int)V.tag;
            }
            else
            {
                activeViewFrame = V.frame;
                activeViewTag = (int)V.tag;
                newViewTag = activeViewTag+1;
            }
            
            if (activeViewTag<lastTag-1)
                isViewBetween = TRUE;
            
            if (isViewBetween)
            {
                int x = 0;
                int y = 0;
                int width = 80;
                int height = updateScroll1.frame.size.height;
                if (isOperationViewBlank)
                {
                    x = V.frame.origin.x;
                    y = V.frame.origin.y;
                    width = V.frame.size.width;
                    height = V.frame.size.height;
                    [V removeFromSuperview];
                }
                else
                {
                    x = activeViewFrame.origin.x+activeViewFrame.size.width+space_between_view;
                    y = activeViewFrame.origin.y;
                    width = 80;
                    height = updateScroll1.frame.size.height;
                }
                UIView *prevView;
                UIView *nextView;
                if (isOperationViewBlank) {
                    prevView = [updateScroll1 viewWithTag:newViewTag-1];
                    nextView = [updateScroll1 viewWithTag:newViewTag+1];
                }
                else
                {
                    prevView = [updateScroll1 viewWithTag:newViewTag-2];
                    nextView = [updateScroll1 viewWithTag:newViewTag];
                }
                if ([nextView isKindOfClass:[UITextField class]]&&[nextView.accessibilityIdentifier isEqualToString:@"test"])
                {
                    UITextField *t = (UITextField*)nextView;
                    t.text = [NSString stringWithFormat:@"%@%@",str,t.text];
                    activeTextfield = t;
                    [self manageViewAfterAddingViewBetweenTwoViewInScrollView:updateScroll1];
                    [self getXpositionAfterUpdatingTestTextfield:activeTextfield];
                    [activeTextfield becomeFirstResponder];
                }
                //                else if ([prevView isKindOfClass:[UITextField class]]&&[prevView.accessibilityIdentifier isEqualToString:@"test"])
                //                {
                //                    UITextField *t = (UITextField*)prevView;
                //                    t.text = [NSString stringWithFormat:@"%@%@",t.text,str];
                //                    activeTextfield = t;
                //                    [self manageViewAfterAddingViewBetweenTwoViewInScrollView:updateScroll1];
                //                    [self getXpositionAfterUpdatingTestTextfield:activeTextfield];
                //                    [activeTextfield becomeFirstResponder];
                //                }
                else
                {
                    UITextField *updateTextField1 = [[UITextField alloc]init ];
                    updateTextField1.frame = CGRectMake(x, y, width, height);
                    updateTextField1.inputView =new_keypad.view;
                    updateTextField1.accessibilityIdentifier = @"test";
                    updateTextField1.delegate = self;
                    updateTextField1.tag = newViewTag;
                    updateTextField1.tintColor = tint_Color;
                    updateTextField1.font = isIpad?math_font1:math_font1_iphone;
                    updateTextField1.backgroundColor = [UIColor clearColor];
                    updateTextField1.textColor = myColor;//11-8-2015
                    updateTextField1.text = str;
                    [updateScroll1 addSubview:updateTextField1];
                    [updateTextField1 becomeFirstResponder];
                    activeTextfield = updateTextField1;
                    [self manageViewAfterAddingViewBetweenTwoViewInScrollView:updateScroll1];
                    [self getXpositionAfterUpdatingTestTextfield:activeTextfield];
                    [activeTextfield becomeFirstResponder];
                    
                }
            }
        }
    }
}
- (IBAction)otherButtonClicked:(id)sender
{
//    if(LOGS_ON)NSLog(@"key Pressed");
//    if(LOGS_ON)NSLog(@"tag:=   %@",sender);
    
    UIScrollView *updateScroll1 =(UIScrollView*)[self superViewOfType:[UIScrollView class] forActiveTextField:activeTextfield];
    UIButton *btn=  sender;
    
    UIView * V = (UIView *)[self superViewOfType:[UIView class] forActiveTextField:activeTextfield];
    if ([V isKindOfClass:[UIView class]]&& [V.accessibilityLabel isEqualToString:operation_view_id])
    {
        if (![activeTextfield.text isEqualToString:@"="]&&![activeTextfield.text isEqualToString:@"π"]&&![activeTextfield.text isEqualToString:xbar_ascii]&&![activeTextfield.text isEqualToString:mu_xbar_ascii]&&![activeTextfield.text isEqualToString:sigma_xbar_ascii]&&![activeTextfield.text isEqualToString:@"∞"]&&![activeTextfield.text isEqualToString:@"!"])
        {
            /* changed today 10-12-2015
             if (k_plus==btn.tag)
             {
             activeTextfield.text = @"+";
             activeTextfield.tag = op_plus;
             }
             else if (k_minus==btn.tag) {
             activeTextfield.text = @"-";
             activeTextfield.tag = op_minus;
             }
             else if (k_multiplication==btn.tag) {
             activeTextfield.text = @"x";
             activeTextfield.tag = op_multiplication;
             }
             else if (k_devide==btn.tag) {
             activeTextfield.text = @"÷";
             activeTextfield.tag = op_devide;
             
             }
             else*/ if (k_delete==btn.tag || alpha_delete==btn.tag || k_backward==btn.tag || k_forward==btn.tag || alpha_close==btn.tag||k_equal==btn.tag||k_devide==btn.tag||k_multiplication==btn.tag||k_minus==btn.tag||k_plus==btn.tag){
                 //            activeTextfield.text = @"÷";
                 //            activeTextfield.tag = op_devide;
                 
                 //                 NSLog(@"%d",(int)btn.tag);
                 //                 NSLog(@"k_root:=   %d",(int)k_root);
                 //                 NSLog(@"k_delete:= %d",(int)k_delete);
                 //                 NSLog(@"alpha_delete:= %d",(int)alpha_delete);
                 //                 NSLog(@"k_backward:= %d",(int)k_backward);
                 //                 NSLog(@"k_forward:= %d",(int)k_forward);
                 //                 NSLog(@"alpha_close:= %d",(int)alpha_close);
                 //                 NSLog(@"k_equal:= %d",(int)k_equal);
                 //                 NSLog(@"k_devide:= %d",(int)k_devide);
                 //                 NSLog(@"k_multiplication:= %d",(int)k_multiplication);
                 //                 NSLog(@"k_minus:= %d",(int)k_minus);
                 //                 NSLog(@"k_plus:= %d",(int)k_plus);
                 
             }
             else{
                 [self addNewTextfieldBetweenViewWithString:[self getStringFromButtonPress:btn]];//27-8-2015
                 return;
             }
        }
        else if (k_delete==btn.tag || alpha_delete==btn.tag || k_backward==btn.tag || k_forward==btn.tag || alpha_close==btn.tag|| k_equal==btn.tag||k_devide==btn.tag||k_multiplication==btn.tag||k_minus==btn.tag||k_plus==btn.tag){
            //            activeTextfield.text = @"÷";
            //            activeTextfield.tag = op_devide;
        }
        else{
            [self addNewTextfieldBetweenViewWithString:[self getStringFromButtonPress:btn]];//27-8-2015
            return;
        }
    }
    
    NSString *str = @"";
    switch (btn.tag) {
        case k_negative:
        {
            if (activeTextfield.text.length>0)
            {
                // changed 23-12-2015
                UITextRange *selectedRange = [activeTextfield selectedTextRange];
                NSRange range = [self selectedRange:activeTextfield];
                
                int position1 = (int)range.location;
                
                BOOL isGetNegativeSign=NO; // changed 03-02-2016
                
                for (int i=position1-1; i>=0; i--)
                {
                    isGetNegativeSign=YES;
                    
                    NSString *subString = [activeTextfield.text substringWithRange:NSMakeRange(i, 1)];
                    
                    NSMutableString *strMu = [[NSMutableString alloc] initWithString:activeTextfield.text];
                    
                    if ([subString isEqualToString:@"-"])
                    {
                        activeTextfield.text = [activeTextfield.text stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@""];
                        
                        UITextPosition *newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:-1];
                        UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
                        [activeTextfield setSelectedTextRange:newRange];
                        break;
                    }
                    else if ([subString isEqualToString:@" "])
                    {
                        NSString * insertingString = @"-";
                        [strMu insertString:insertingString atIndex:i+1];
                        activeTextfield.text=strMu;
                        
                        UITextPosition *newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:1];
                        UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
                        [activeTextfield setSelectedTextRange:newRange];
                        break;
                    }
                    else if ([subString isEqualToString:@"("] || [subString isEqualToString:@")"])
                    {
                        NSString * insertingString = @"-";
                        [strMu insertString:insertingString atIndex:i+1];
                        activeTextfield.text=strMu;
                        
                        UITextPosition *newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:1];
                        UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
                        [activeTextfield setSelectedTextRange:newRange];
                        break;
                        
                    }
                    else if ([subString isEqualToString:@"+"] || [subString isEqualToString:negative_ascii] || [subString isEqualToString:multiplication_ascii] || [subString isEqualToString:@"÷"] || [subString isEqualToString:@">"] || [subString isEqualToString:@"≥"] ||
                             [subString isEqualToString:@"<"] || [subString isEqualToString:@"≤"] || [subString isEqualToString:@"="] || [subString isEqualToString:@"%"] ||[subString isEqualToString:@"π"] || [subString isEqualToString:UNION_ascii]||
                             [subString isEqualToString:INTERSECTION_ascii] || [subString isEqualToString:rightArrow_ascii] || [subString isEqualToString:xbar_ascii] || [subString isEqualToString:sigma_xbar_ascii] || [subString isEqualToString:mu_xbar_ascii] || [subString isEqualToString:@"∞"] || [subString isEqualToString:@"!"] || [subString isEqualToString:@" "])
                    {
                        NSString * insertingString = @"-";
                        [strMu insertString:insertingString atIndex:i+1];
                        activeTextfield.text=strMu;
                        
                        UITextPosition *newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:1];
                        UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
                        [activeTextfield setSelectedTextRange:newRange];
                        break;
                    }
                    else if (i==0)
                    {
                        NSString * insertingString = @"-";
                        [strMu insertString:insertingString atIndex:i];
                        activeTextfield.text=strMu;
                        
                        UITextPosition *newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:1];
                        UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
                        [activeTextfield setSelectedTextRange:newRange];
                        break;
                    }
                    strMu=nil;  // changed 03-02-2016
                }
                
                // changed 03-02-2016 first position there and text lengh > 0 that time not insert - that's why below condition is addded
                if (!isGetNegativeSign && position1-1<0)
                {
                    NSMutableString *strMu = [[NSMutableString alloc] initWithString:activeTextfield.text];
                    
                    NSString * insertingString = @"-";
                    [strMu insertString:insertingString atIndex:0];
                    activeTextfield.text=strMu;
                    
                    UITextPosition *newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:1];
                    UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
                    [activeTextfield setSelectedTextRange:newRange];
                    
                    strMu=nil;  // changed 03-02-2016
                }
                //
            }
            else
            {
                activeTextfield.text = @"-";
            }
            if (![activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
            {
                [self textFieldDidChange:activeTextfield];
            }
            else if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"]&&activeTextfield.text.length>=1) // changed 13-01-2016 = is added because between text box size not set when lenght=1
            {
                [self getXpositionAfterUpdatingTestTextfield:activeTextfield];
            }
            return;
        }
        case k_coma:
        {
            str = @",";
            break;
        }
        case k_x:
        case alpha_x:
            
            if (btn.selected)
            {
                str = @"X";
            }
            else
            {
                str = @"x";
            }
            break;
        case k_y:
        case alpha_y:
            if (btn.selected)
            {
                str = @"Y";
            }
            else
            {
                str = @"y";
            }
            break;
        case k_z:
        case alpha_z:
            if (btn.selected)
            {
                str = @"Z";
            }
            else
            {
                str = @"z";
            }
            break;
        case alpha_a:
            if (btn.selected)
            {
                str = @"A";
            }
            else
            {
                str = @"a";
            }
            break;
        case alpha_b:
            if (btn.selected)
            {
                str = @"B";
            }
            else
            {
                str = @"b";
            }
            break;
        case alpha_c:
            if (btn.selected)
            {
                str = @"C";
            }
            else
            {
                str = @"c";
            }
            break;
        case alpha_d:
            if (btn.selected)
            {
                str = @"D";
            }
            else
            {
                str = @"d";
            }
            break;
        case alpha_e:
            if (btn.selected)
            {
                str = @"E";
            }
            else
            {
                str = @"e";
            }
            break;
        case alpha_f:
            if (btn.selected)
            {
                str = @"F";
            }
            else
            {
                str = @"f";
            }
            break;
        case alpha_g:
            if (btn.selected)
            {
                str = @"G";
            }
            else
            {
                str = @"g";
            }
            break;
        case alpha_h:
            if (btn.selected)
            {
                str = @"H";
            }
            else
            {
                str = @"h";
            }
            break;
        case alpha_i:
            if (btn.selected)
            {
                str = @"I";
            }
            else
            {
                str = @"i";
            }
            break;
        case alpha_j:
            if (btn.selected)
            {
                str = @"J";
            }
            else
            {
                str = @"j";
            }
            break;
        case alpha_k:
            if (btn.selected)
            {
                str = @"K";
            }
            else
            {
                str = @"k";
            }
            break;
        case alpha_l:
            if (btn.selected)
            {
                str = @"L";
            }
            else
            {
                str = @"l";
            }
            break;
        case alpha_m:
            if (btn.selected)
            {
                str = @"M";
            }
            else
            {
                str = @"m";
            }
            break;
        case alpha_n:
            if (btn.selected)
            {
                str = @"N";
            }
            else
            {
                str = @"n";
            }
            break;
        case alpha_o:
            if (btn.selected)
            {
                str = @"O";
            }
            else
            {
                str = @"o";
            }
            break;
        case alpha_p:
            if (btn.selected)
            {
                str = @"P";
            }
            else
            {
                str = @"p";
            }
            break;
        case alpha_q:
            if (btn.selected)
            {
                str = @"Q";
            }
            else
            {
                str = @"q";
            }
            break;
        case alpha_r:
            if (btn.selected)
            {
                str = @"R";
            }
            else
            {
                str = @"r";
            }
            break;
        case alpha_s:
            if (btn.selected)
            {
                str = @"S";
            }
            else
            {
                str = @"s";
            }
            break;
        case alpha_t:
            if (btn.selected)
            {
                str = @"T";
            }
            else
            {
                str = @"t";
            }
            break;
        case alpha_u:
            if (btn.selected)
            {
                str = @"U";
            }
            else
            {
                str = @"u";
            }
            break;
        case alpha_v:
            if (btn.selected)
            {
                str = @"V";
            }
            else
            {
                str = @"v";
            }
            break;
        case alpha_w:
            if (btn.selected)
            {
                str = @"W";
            }
            else
            {
                str = @"w";
            }
            break;
        case alpha_coma:
            if(LOGS_ON)NSLog(@"coma pressed");
            break;
        case alpha_space:
        {
            // changed today 18-12-2015
            UITextRange *selectedRange = [activeTextfield selectedTextRange];
            
            NSRange range = [self selectedRange:activeTextfield];
            NSString * firstHalfString = [activeTextfield.text substringToIndex:range.location];
            NSString * secondHalfString = [activeTextfield.text substringFromIndex: range.location];
            
            NSString * insertingString = @" ";
            
            activeTextfield.text = [NSString stringWithFormat: @"%@%@%@",
                                    firstHalfString,
                                    insertingString,
                                    secondHalfString];
            range.location += [insertingString length];
            
            UITextPosition *newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:[insertingString length]];
            UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
            [activeTextfield setSelectedTextRange:newRange];
            
//            if(LOGS_ON)NSLog(@"space pressed");
            //
            
            //            activeTextfield.text = [NSString stringWithFormat:@"%@ ",activeTextfield.text];
            
            break;
        }
        case alpha_return:
            
            break;
            if ([activeTextfield.accessibilityIdentifier isEqualToString:textField_identifier]||[activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
            {
                [self hideCustomMathKeypad];
                updateView.hidden=NO;
                //                [self submitAnswerToServerFromString:[self getFinalStringFromView]];
                
            }
            else
            {
                [activeTextfield resignFirstResponder];
                [self hideCustomMathKeypad];
                updateView.hidden=NO;
            }
            
//            if(LOGS_ON)NSLog(@"return pressed");
            break;
            
        case alpha_close:
            if ([activeTextfield.accessibilityIdentifier isEqualToString:textField_identifier]||[activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
            {
                [self hideCustomMathKeypad];
                updateView.hidden=NO;
                //                [self submitAnswerToServerFromString:[self getFinalStringFromView]];
                
            }
            else
            {
                [activeTextfield resignFirstResponder];
                [self hideCustomMathKeypad];
                updateView.hidden=NO;
            }
            
//            if(LOGS_ON)NSLog(@"return pressed");
            break;
        case k_delete:
        case alpha_delete:
        {
            if (activeTextfield.text.length>0)
            {
                BOOL isDeleteCall=NO;
                
                if ([activeTextfield.text isEqualToString:@"+"] || [activeTextfield.text isEqualToString:negative_ascii] || [activeTextfield.text isEqualToString:multiplication_ascii] || [activeTextfield.text isEqualToString:@"÷"] || [activeTextfield.text isEqualToString:@">"] || [activeTextfield.text isEqualToString:@"≥"] ||
                    [activeTextfield.text isEqualToString:@"<"] || [activeTextfield.text isEqualToString:@"≤"] || [activeTextfield.text isEqualToString:@"="] || [activeTextfield.text isEqualToString:@"%"] ||[activeTextfield.text isEqualToString:@"π"] || [activeTextfield.text isEqualToString:UNION_ascii]||
                    [activeTextfield.text isEqualToString:INTERSECTION_ascii] || [activeTextfield.text isEqualToString:rightArrow_ascii] || [activeTextfield.text isEqualToString:xbar_ascii] || [activeTextfield.text isEqualToString:sigma_xbar_ascii] || [activeTextfield.text isEqualToString:mu_xbar_ascii] || [activeTextfield.text isEqualToString:@"∞"] || [activeTextfield.text isEqualToString:@"!"] || [activeTextfield.text isEqualToString:@" "])
                {
                    isDeleteCall=YES;
                }
                [activeTextfield becomeFirstResponder];
                //                activeTextfield.text = [activeTextfield.text substringToIndex:activeTextfield.text.length-1];
                
                // changed today 18-12-2015
                
                if (activeTextfield.text.length>0)
                {
                    UITextRange *selectedRange = [activeTextfield selectedTextRange];
                    
                    NSRange range = [self selectedRange:activeTextfield];
                    NSString * firstHalfString = [activeTextfield.text substringToIndex:range.location];
                    NSString * secondHalfString = [activeTextfield.text substringFromIndex: range.location];
                    
                    int minusCountXbar=0;
                    
                    // changed 07-01-2016
                    // changed 26-01-2016
                    if (firstHalfString.length>=3) // changed activeTextfield.length to firstHalfString.length
                    {
                        NSString *strRemoveLastTwoPosition = [firstHalfString substringToIndex:firstHalfString.length-3];
                        
                        NSString *strT = [firstHalfString stringByReplacingOccurrencesOfString:strRemoveLastTwoPosition withString:@""];
                        
                        // changed 26-01-2016
                        if ([strT isEqualToString:mu_xbar_ascii]) {
                            
                            minusCountXbar=3;
                        }
                        else if ([strT isEqualToString:sigma_xbar_ascii]) {
                            minusCountXbar=3;
                        }
                    }
                    if (firstHalfString.length>=2 && minusCountXbar==0) // changed 26-01-2016
                    {
                        NSString *strRemoveLastTwoPosition = [firstHalfString substringToIndex:firstHalfString.length-2];
                        
                        NSString *strT = [firstHalfString stringByReplacingOccurrencesOfString:strRemoveLastTwoPosition withString:@""];
                        
                        if ([strT isEqualToString:xbar_ascii])
                        {
                            minusCountXbar=2;
                        }
                    }
                    
                    if (range.location!=0)
                    {
                        UITextPosition *newPosition;
                        if (minusCountXbar==0)
                        {
                            activeTextfield.text = [NSString stringWithFormat: @"%@%@",
                                                    [firstHalfString substringToIndex:firstHalfString.length-1],
                                                    secondHalfString];
                            range.location -= 1;
                            newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:-1];
                        }
                        else
                        {
                            activeTextfield.text = [NSString stringWithFormat: @"%@%@",
                                                    [firstHalfString substringToIndex:firstHalfString.length-minusCountXbar],
                                                    secondHalfString];
                            range.location -= minusCountXbar;
                            newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:-minusCountXbar];
                        }
                        
                        
                        UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
                        [activeTextfield setSelectedTextRange:newRange];
                    }
                    else{
                        UIButton *btn1 = (UIButton *)btn;
                        int tag_btn = (int)btn.tag;
                        btn1.tag=k_backward;
                        [self forwardOrBackwordClicked:btn1];
                        btn1.tag=tag_btn;
                        return;
                    }
                }
                //
                /*  comment on 04-02-2016
                 // changed 14-12-2015
                 if (isDeleteCall)
                 {
                 activeTextfield.backgroundColor = [UIColor clearColor];
                 [self deleteClicked:btn];
                 [self updateSubviewFramesAndManageTagAfterDeleteViewForScrollView:updateScroll1];
                 [self findLastTextfieldandManageWidthInScrollview:updateScroll1];
                 }
                 */
                
                if (![activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
                {
                    [self textFieldDidChange:activeTextfield];
                }
                else if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"]&&activeTextfield.text.length>=1) // changed 13-01-2016 = is added because between text box size not set when lenght=1
                {
                    [self getXpositionAfterUpdatingTestTextfield:activeTextfield];
                }
                
            }
            else
            {
                //                NSRange range = [self selectedRange:activeTextfield];
                
                int previousTag=activeTextfield.tag; // changed 04-02-2016
                
                if ([activeTextfield.accessibilityIdentifier isEqualToString:textField_identifier]) {
                    activeTextfield.backgroundColor = box_back_color;//11-9-2015
                }
                [self deleteClicked:btn];
                int currentTag=activeTextfield.tag;  // changed 04-02-2016
                
                // changed 04-02-2016 // comment 06-02-2016
                if (previousTag!=currentTag) {
                    [self addTextBoxBetweenTwoViewInWhichBothSideTestTextboxIsNotThere:updateScroll1 getView:activeTextfield.superview.superview];
                }
                //
                
                [self updateSubviewFramesAndManageTagAfterDeleteViewForScrollView:updateScroll1];
                [self findLastTextfieldandManageWidthInScrollview:updateScroll1];
                
            }
            
//            if(LOGS_ON)NSLog(@"delete pressed");
            break;
        }
        case k_one:
//            if(LOGS_ON)NSLog(@"1 pressed");
            str = @"1";
            break;
        case k_two:
//            if(LOGS_ON)NSLog(@"2 pressed");
            str = @"2";
            break;
        case k_three:
//            if(LOGS_ON)NSLog(@"3 pressed");
            str = @"3";
            break;
        case k_four:
//            if(LOGS_ON)NSLog(@"4 pressed");
            str = @"4";
            break;
        case k_five:
//            if(LOGS_ON)NSLog(@"5 pressed");
            str = @"5";
            break;
        case k_six:
//            if(LOGS_ON)NSLog(@"6 pressed");
            str = @"6";
            break;
        case k_seven:
//            if(LOGS_ON)NSLog(@"7 pressed");
            str = @"7";
            break;
        case k_eight:
//            if(LOGS_ON)NSLog(@"8 pressed");
            str = @"8";
            break;
        case k_nine:
//            if(LOGS_ON)NSLog(@"9 pressed");
            str = @"9";
            break;
        case k_zero:
//            if(LOGS_ON)NSLog(@"0 pressed");
            str = @"0";
            break;
        case k_dot:
//            if(LOGS_ON)NSLog(@"dot pressed");
            str = @".";
            break;
        case k_plus:
        case k_minus:
        case k_multiplication:
        case k_devide:
        case k_root:
        {
            UIView *v= activeTextfield.superview.superview;
//            if(LOGS_ON)NSLog(@"%@",v.accessibilityLabel);
            
            if (btn.tag==k_plus)
            {
                str = @" + ";
                break;
            }
            else if (btn.tag==k_minus)
            {
                str = [NSString stringWithFormat:@" %@ ",negative_ascii];
                break;
            }
            else if (btn.tag==k_multiplication)
            {
                //                str = @" x ";
                str = [NSString stringWithFormat:@" %@ ",multiplication_ascii];
                break;
            }
            else if (btn.tag==k_devide)
            {
                str = @" ÷ ";
                break;
            }
            
            
            break;
        }
        case k_backward:
        case k_forward:
        {
            [self forwardOrBackwordClicked:btn];
            break;
        }
        case k_cap:
        {
            UIButton *btn = (UIButton *)sender;
            btn.accessibilityIdentifier=@"exponent_ipad";
            [self pushMenuItem:btn];
            break;
        }
        case k_o_perenth:
        {
            str = @"(";
            break;
        }
        case k_c_perenth:
        {
            str = @")";
            break;
            //15-9-2015
            UIButton *btn = (UIButton *)sender;
            btn.accessibilityIdentifier=@"parenthesis_ipad";
            [self pushMenuItem:btn];
            break;
        }
        case k_equal:
        {
            UIButton *btn = (UIButton *)sender;
            btn.accessibilityIdentifier=@"equal_ipad";
            [self pushMenuItem:btn];
            break;
        }
        case alpha_caps:
        {
            btn.selected = !btn.selected;
            UIView *v = btn.superview;
            for (UIView *btn_view in v.subviews) {
                if ([btn_view isKindOfClass:[UIButton class]]) {
                    UIButton *b = (UIButton*)btn_view;
                    b.selected  =btn.selected;
                }
            }
        }
            
            break;
        default:
            break;
    }
    if (str.length>0)
    {
//        if(LOGS_ON)NSLog(@"%@ pressed",str);
        //        NSLog(@"%@",updateScroll1.subviews);
        if (btn.tag==k_dot)
        {
            if ([activeTextfield.text rangeOfString:str].location == NSNotFound)
            {
                activeTextfield.text = [activeTextfield.text stringByAppendingString:str];
            }
        }
        else
        {
            // changed today 18-12-2015
            UITextRange *selectedRange = [activeTextfield selectedTextRange];
            
            NSRange range = [self selectedRange:activeTextfield];
            NSString * firstHalfString = [activeTextfield.text substringToIndex:range.location];
            NSString * secondHalfString = [activeTextfield.text substringFromIndex: range.location];
            
            NSString * insertingString = str;
            
            activeTextfield.text = [NSString stringWithFormat: @"%@%@%@",
                                    firstHalfString,
                                    insertingString,
                                    secondHalfString];
            range.location += [insertingString length];
            
            UITextPosition *newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:[insertingString length]];
            UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
            [activeTextfield setSelectedTextRange:newRange];
            
            //            activeTextfield.text = [activeTextfield.text stringByAppendingString:str];
        }
        
        if (![activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
        {
            [self textFieldDidChange:activeTextfield];
        }
        else if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"]&&activeTextfield.text.length>=1) // changed 01-01-2016 = is added because between text box size not set when lenght=1
        {
            [self getXpositionAfterUpdatingTestTextfield:activeTextfield];
        }
        
        // changed 19-01-2016
        
        int LastTagView;
        for (UIView *i in updateScroll1.subviews)
        {
            LastTagView=(int)i.tag;
        }
        // changed 20-01-2016  before just else condition is there
        if (![activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
        {
            UIView *viewActiveFiledContain = (UIView *)activeTextfield.superview.superview;
            UITextField *getLastTextField = (UITextField *)[updateScroll1 viewWithTag:LastTagView];
            if(viewActiveFiledContain.tag == LastTagView-1 && [getLastTextField.text isEqualToString:@""])
            {
                updateScroll1.contentSize = CGSizeMake(viewActiveFiledContain.frame.origin.x+viewActiveFiledContain.frame.size.width, updateScroll1.contentSize.height);
                
                if (updateScroll1.contentSize.width>=updateScroll1.frame.size.width)
                {
                    updateScroll1.contentSize = CGSizeMake(updateScroll1.contentSize.width+20, updateScroll1.contentSize.height);
                    updateScroll1.contentOffset = CGPointMake(updateScroll1.contentSize.width-updateScroll1.frame.size.width, updateScroll1.contentOffset.y);
                }
            }
        }///
        else
        {
            if(activeTextfield.tag == LastTagView)
            {
                if (updateScroll1.contentSize.width>updateScroll1.frame.size.width)
                {
                    updateScroll1.contentOffset = CGPointMake(updateScroll1.contentSize.width-updateScroll1.frame.size.width, updateScroll1.contentOffset.y);
                }
            }
        }
        
        //
    }
}

-(NSString*)getOperationStringFromView:(UIView*)op_view
{
    NSString *str = @"";
//    if(LOGS_ON)NSLog(@"this is operation View");
    str = [str stringByAppendingString:str_operation];
    int txt_start = 0;
    for (UIView *txt_v in op_view.subviews)
    {
        if ([txt_v.accessibilityIdentifier isEqualToString:textField_container])
        {
            
            for (UITextView *tf_v in txt_v.subviews)
            {
                if ([tf_v isKindOfClass:[UITextField class]])
                {
                    UITextField *tf = (UITextField*)tf_v;
//                    if(LOGS_ON)NSLog(@"%@",tf.text);
                    if (txt_start==0) {
                        if ([tf.text isEqualToString:@"+"]) {
                            str = [str stringByAppendingFormat:@"%@",operation_plus];
                        }
                        else if ([tf.text isEqualToString:negative_ascii])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_minus];
                            
                        }
                        else if ([tf.text isEqualToString:multiplication_ascii])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_multiplication];
                            
                        }
                        else if ([tf.text isEqualToString:@"÷"])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_devide];
                            
                        }
                        else if ([tf.text isEqualToString:@"≥"])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_grtthanorequal];
                            
                        }
                        else if ([tf.text isEqualToString:@">"])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_grtthan];
                            
                        }
                        else if ([tf.text isEqualToString:@"<"])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_lessthan];
                            
                        }
                        else if ([tf.text isEqualToString:@"≤"])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_lessthanorequal];
                            
                        }
                        else if ([tf.text isEqualToString:@"="])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_equal];
                            
                        }
                        else if ([tf.text isEqualToString:@"%"])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_percentage];
                            
                        }
                        else if ([tf.text isEqualToString:UNION_ascii])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_union];
                            
                        }
                        else if ([tf.text isEqualToString:INTERSECTION_ascii])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_intersection];
                            
                        }
                        else if ([tf.text isEqualToString:rightArrow_ascii])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_rarrow];
                            
                        }
                        else if ([tf.text isEqualToString:xbar_ascii])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_xbar];
                            
                        }
                        else if ([tf.text isEqualToString:mu_xbar_ascii])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_muxbar];
                            
                        }
                        else if ([tf.text isEqualToString:sigma_xbar_ascii])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_sigmaxbar];
                            
                        }
                        else if ([tf.text isEqualToString:@"π"])
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_pie];
                        }
                        else if ([tf.text isEqualToString:@"∞"]) // changed today 09-12-2015 for infinite
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_infinity];
                        }
                        else if ([tf.text isEqualToString:@"!"]) // changed today 09-12-2015 for infinite
                        {
                            str = [str stringByAppendingFormat:@"%@",operation_factorial];
                        }
                        else
                        {
                            str = [str stringByAppendingFormat:@"%@",tf.text];
                        }
                        
                        txt_start++;
                    }
                    else
                    {
                        str = [str stringByAppendingFormat:@"%@%@",val_seprator,tf.text];
                    }
                    
                    
                }
                
                
            }
            
        }
        
    }
    return str;
}
-(void)findLastTextfieldandManageWidthInScrollview:(UIScrollView*)scroll
{
    int viewTag = 50;
    
    for (UIView *sub in scroll.subviews)
    {
        if (sub.tag>=50)
        {
            viewTag=sub.tag;
            break;
        }
    }
    
    while (viewTag>=50)
    {
        UIView *v = (UIView*)[scroll viewWithTag:viewTag];
        UIView *nextV = (UIView*)[scroll viewWithTag:viewTag+1];
        
        if (v!=nil)
        {
            if(LOGS_ON)NSLog(@"%@",v);
            viewTag = viewTag+1;
            if ([v isKindOfClass:[UITextField class]]&&nextV==nil)
            {
                UITextField *t = (UITextField*)v;
                if ([t.accessibilityIdentifier  isEqualToString:@"test"])
                {
                    if (t.frame.origin.x+t.frame.size.width<scroll.frame.size.width)
                    {
                        t.frame = CGRectMake(t.frame.origin.x, t.frame.origin.y, scroll.frame.size.width-t.frame.origin.x, t.frame.size.height);
                        t.textAlignment = NSTextAlignmentLeft;
                        //                        t.backgroundColor =[UIColor blueColor];
                        
                    }
                }
                
            }
        }
        else
        {
            viewTag=0;
        }
        
    }
}
-(void)manageViewAfterAddingViewBetweenTwoViewInScrollView:(UIScrollView*)new_scroll
{
    if(LOGS_ON)NSLog(@"%@",new_scroll.subviews);
    int lastTag = 50;
    CGRect lastFrame;
    UIView *lastView=nil;
    UIView *vi;
    NSMutableArray *subArray = [[NSMutableArray alloc]init];
    for (int i=(int)new_scroll.subviews.count-1; i>0; i--)
    {
        if (i==(int)new_scroll.subviews.count-1)
        {
            vi =  [new_scroll.subviews objectAtIndex:i];
            [subArray addObject:vi];
        }
        if (i>0)
        {
            UIView *v1 =  [new_scroll.subviews objectAtIndex:i-1];
            if (v1.tag>=vi.tag)
            {
                if(LOGS_ON)NSLog(@"Before Tag change : %@",v1);
                v1.tag=v1.tag+2;
                if(LOGS_ON)NSLog(@"After Tag change :%@",v1);
                [subArray insertObject:v1 atIndex:1];
            }
            else
            {
                [subArray insertObject:v1 atIndex:0];
            }
        }
    }
    if(LOGS_ON)NSLog(@"%@",new_scroll.subviews);
    if(LOGS_ON)NSLog(@"%@",subArray);
    for (int i=0; i<subArray.count; i++)
    {
        UIView *v =  [subArray objectAtIndex:i];
        if (v.tag-lastTag>1)
        {
            if(LOGS_ON)NSLog(@"lastFrame X: %f",lastFrame.origin.x);
            if(LOGS_ON)NSLog(@"lastFrame y: %f",lastFrame.origin.y);
            if(LOGS_ON)NSLog(@"lastFrame width: %f",lastFrame.size.width);
            if(LOGS_ON)NSLog(@"lastFrame height: %f",lastFrame.size.height);
            v.frame = CGRectMake(lastFrame.origin.x+lastFrame.size.width+space_between_view, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
            v.tag = lastTag+1;
            if (i==new_scroll.subviews.count-1)
            {
                if ([v isKindOfClass:[UITextField class]]&&[v.accessibilityIdentifier isEqualToString:@"test"])
                {
                    UITextField *updateTextField1 = (UITextField*)v;
                    if (updateTextField1.frame.origin.x+updateTextField1.frame.size.width<new_scroll.frame.size.width)
                    {
                        int width1 = new_scroll.frame.size.width - updateTextField1.frame.origin.x;
                        updateTextField1.frame = CGRectMake(updateTextField1.frame.origin.x, updateTextField1.frame.origin.y, width1, updateTextField1.frame.size.height);
                        updateTextField1.textAlignment=NSTextAlignmentLeft;
                    }
                }
                
            }
            lastFrame = v.frame;
            lastTag = (int)v.tag;
        }
        else
        {
            lastTag = (int)v.tag;
            lastFrame = v.frame;
        }
        lastView = v;
    }
    if(LOGS_ON)NSLog(@"%@",subArray);
    
    //  ---------------  Changed 05-12-2015  -------------// Add if else condition before only else code is there
    if (subArray.count==0)
    {
        for (UIView *v in new_scroll.subviews)
        {
            if ([v isKindOfClass:[UITextField class]]) {
                UITextField * v1 = (UITextField * )v;
                v1.frame=CGRectMake(0, v1.frame.origin.y, new_scroll.frame.size.width, v1.frame.size.height);
                break;
            }
        }
    }
    else
    {
        [new_scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //  ------------------------------
    
    for (int i = 0; i<subArray.count; i++) {
        UIView *v = [subArray objectAtIndex:i];
        [new_scroll addSubview:v];
    }
    if(LOGS_ON)NSLog(@"%@",new_scroll.subviews);
    new_scroll.contentSize = CGSizeMake(lastFrame.origin.x+lastFrame.size.width+space_between_view, new_scroll.frame.size.height);
}
- (void)pushMenuItem:(id)sender
{
    UIButton *btn = sender;
    
    /*
     if ([@"xbar_ipad" isEqualToString:btn.accessibilityIdentifier])
     {
     return;
     }
     else if ([@"muxb_ipad" isEqualToString:btn.accessibilityIdentifier])
     {
     return;
     }
     else if ([@"sigmaxb_ipad" isEqualToString:btn.accessibilityIdentifier])
     {
     return;
     }
     */
    
//    if(LOGS_ON)NSLog(@"%@", btn.accessibilityIdentifier);
    BOOL isViewAdded = TRUE;
//    if(LOGS_ON)NSLog(@"%@",rightArrow_ascii);
//    if(LOGS_ON)NSLog(@"%@",xbar_ascii);
//    if(LOGS_ON)NSLog(@"%@",sigma_xbar_ascii);
//    if(LOGS_ON)NSLog(@"%@",mu_xbar_ascii);
    
//    if(LOGS_ON)NSLog(@"%@",activeTextfield);
    
    int x = 5;
    int width = 80;
    long lastTag = 50;
    UITextField *txt;
    UIScrollView *updateScroll;
    BOOL isRequireNewTextField = FALSE;
    BOOL isTextFieldFirstResponder = FALSE;
    LAStudentCustomAnswerCell *cell = (LAStudentCustomAnswerCell *)[self superViewOfType:[LAStudentCustomAnswerCell class] forView:activeTextfield];
    if (cell)
    {
        updateScroll = cell.updateScroll;
    }
    for (UIView *v in updateScroll.subviews)
    {
        if(LOGS_ON)NSLog(@"%ld",(long)v.tag);
        
        if ([v isKindOfClass:[UIImageView class]])
        {
            [v removeFromSuperview];
        }
    }
    
    int activeViewTag = 0;//14-8-2015 - end
    CGRect activeViewFrame = CGRectZero;//14-8-2015 - end
    BOOL isViewBetween = FALSE;//14-8-2015 - end
    
    //14-8-2015 - Start
    if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
    {
        activeViewTag = (int)activeTextfield.tag;
        activeViewFrame = activeTextfield.frame;
    }
    else
    {
        UIView * V = (UIView *)[self superViewOfType:[UIView class] forActiveTextField:activeTextfield];
        activeViewTag = (int)V.tag;
        activeViewFrame = V.frame;
        
    }
    //    if (activeTextfield.text.length==0&&btn.tag==k_minus)
    //    {
    //        activeTextfield.text =[NSString stringWithFormat:@"%@-",activeTextfield.text];
    //        return;
    //    }
    //14-8-2015 - end
    
    
    for (UIView *v in updateScroll.subviews)
    {
        if(LOGS_ON)NSLog(@"%ld",(long)v.tag);
        if (v.tag>=lastTag)
        {
            lastTag=v.tag;
            x = v.frame.origin.x+v.frame.size.width+space_between_view;
        }
        if (lastTag>=50)
        {
            lastTag++;
        }
        if ([v.accessibilityIdentifier isEqualToString:@"test"])
        {
            BOOL isTextieldDeleted = FALSE;//14-8-2015
            
            txt = (UITextField*)v;
            //            txt.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
            if (txt.text.length>0)
            {
                x = txt.frame.origin.x;
                [self setSizeForTextfield:txt];
                if (txt.tag<50) {
                    txt.tag = lastTag;
                    lastTag++;
                }
                x = txt.frame.origin.x+txt.frame.size.width+space_between_view;
                isRequireNewTextField= TRUE;
                isTextFieldFirstResponder = TRUE;
            }
            else
            {
                // changed 23-12-2015
                
                x = txt.frame.origin.x;
                [self setSizeForTextfield:txt];
                txt.frame=CGRectMake(txt.frame.origin.x, txt.frame.origin.y, 5, txt.frame.size.height);
                if (txt.tag<50) {
                    txt.tag = lastTag;
                    lastTag++;
                }
                x = txt.frame.origin.x+txt.frame.size.width+space_between_view;
                isRequireNewTextField= TRUE;
                isTextFieldFirstResponder = TRUE;
                
                ///
                
                /*
                 x = 5;
                 isRequireNewTextField= TRUE;
                 isTextFieldFirstResponder = TRUE;
                 if (lastTag>51)
                 {
                 lastTag--;
                 x = txt.frame.origin.x;
                 }
                 
                 // changed 21-12-2015   // add if else condition line before just else condition is there
                 if (btn.tag==k_plus||btn.tag==k_minus||btn.tag==k_multiplication||btn.tag==k_devide||[@"gte_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"lte_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"gt_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"lt_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"equal_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"divide_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"parcent_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"pi_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"union_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"intersection_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"aerrow_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"xbar_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"muxb_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"sigmaxb_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"infinity_ipad" isEqualToString:btn.accessibilityIdentifier] || [@"factorial_ipad" isEqualToString:btn.accessibilityIdentifier])
                 {
                 
                 }else{
                 [v removeFromSuperview];
                 }
                 
                 //                [v removeFromSuperview];
                 isTextieldDeleted = TRUE;//14-8-2015
                 */
            }
            
            if (activeViewTag<lastTag-1&&isTextieldDeleted==FALSE)//14-8-2015 - Start
            {
                isTextFieldFirstResponder = FALSE;
                isRequireNewTextField= FALSE;
            }
            if (activeViewTag<lastTag-1&&isTextieldDeleted==TRUE)//17-8-2015
            {
                isTextFieldFirstResponder = FALSE;//17-8-2015
            }
            //14-8-2015 - end
        }
    }
    
    //14-8-2015 - Start
    if(LOGS_ON)NSLog(@"activeViewTag : %d",activeViewTag);
    
    
    if (activeViewTag<lastTag-1&&(btn.tag==k_plus||btn.tag==k_minus||btn.tag==k_devide||btn.tag==k_multiplication))
    {
        if(LOGS_ON)NSLog(@"Add in between two views");
        x = activeViewFrame.origin.x+activeViewFrame.size.width+space_between_view;
        lastTag = activeViewTag+1;
        isViewBetween = TRUE;
        isTextFieldFirstResponder = TRUE;
    }
    else
    {
        if(LOGS_ON)NSLog(@"Add at last");
        isRequireNewTextField= TRUE;
        isTextFieldFirstResponder = TRUE;
    }
    //14-8-2015 - end
    
    CGRect viewFrame = CGRectMake(x, 0, width, updateScroll.frame.size.height);
    UIColor *myColor = [UIColor blackColor];
    //    expo_p_big_ipad
    //    expo_m_big_ipad
    
    if ([@"fraction_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        FractionView *fv = [[FractionView alloc]initWithFrame:viewFrame andDelegate:self andColor:myColor];
        fv.view.tag = lastTag;
        fv.txt.inputView =new_keypad.view;
        fv.txt1.inputView =new_keypad.view;
        fv.view.accessibilityLabel = fraction_view_id;
        [updateScroll addSubview:fv.view];
        [fv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = fv.view.frame;
        
        fv.txt.backgroundColor = box_back_color;
        fv.txt1.backgroundColor = box_back_color;
    }
    //c_ipad
    //p_ipad
    else if ([@"integral2_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        AvenirView *mv = [[AvenirView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.accessibilityLabel = avenir_view_id;
        mv.view.tag = lastTag;
        mv.txt.inputView =new_keypad.view;
        mv.txt1.inputView =new_keypad.view;
        
        mv.txt.backgroundColor = box_back_color;
        mv.txt1.backgroundColor = box_back_color;
        mv.view.backgroundColor = [UIColor clearColor];
        
        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt1.font=isIpad?math_font2:math_font2_iphone;
        
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        isTextFieldFirstResponder = FALSE;
        [mv.txt becomeFirstResponder];
    }
    else if ([@"integral2_box_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        AvenirBoxView *mv = [[AvenirBoxView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.accessibilityLabel = avenirBox_view_id;
        mv.view.tag = lastTag;
        mv.txt.inputView =new_keypad.view;
        mv.txt1.inputView =new_keypad.view;
        mv.txt2.inputView =new_keypad.view;
        mv.txt3.inputView =new_keypad.view;
        
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt1.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt2.font=isIpad?math_font2:math_font2_iphone;
        mv.txt3.font=isIpad?math_font2:math_font2_iphone;
        
        
        mv.txt.backgroundColor = box_back_color;
        mv.txt1.backgroundColor = box_back_color;
        mv.txt2.backgroundColor = box_back_color;
        mv.txt3.backgroundColor = box_back_color;
        mv.view.backgroundColor = [UIColor clearColor];
        
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        isTextFieldFirstResponder = FALSE;
        [mv.txt becomeFirstResponder];
    }
    
    else if ([@"c_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"p_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        PermutationOrCombinationView *mv;
        if ([@"c_ipad" isEqualToString:btn.accessibilityIdentifier]) {
            
            mv = [[PermutationOrCombinationView alloc]initWithFrame:viewFrame  andDelegate:self permOrComb:combination andColor:myColor];
            mv.view.accessibilityLabel = combination_view_id;
            
        }
        else
        {
            mv = [[PermutationOrCombinationView alloc]initWithFrame:viewFrame  andDelegate:self permOrComb:permutation andColor:myColor];
            mv.view.accessibilityLabel = permutation_view_id;
        }
        mv.view.tag = lastTag;
        mv.txt.inputView =new_keypad.view;
        mv.txt1.inputView =new_keypad.view;
        
        mv.txt.backgroundColor = box_back_color;
        mv.txt1.backgroundColor = box_back_color;
        mv.view.backgroundColor = [UIColor clearColor];
        
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt1.font=isIpad?math_script_font:math_script_font_iphone;
        
        
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        isTextFieldFirstResponder = FALSE;
        [mv.txt becomeFirstResponder];
    }
    else if ([@"mixed_number_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        MixedNumberView *mv = [[MixedNumberView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.txt.inputView =new_keypad.view;
        mv.txt1.inputView =new_keypad.view;
        mv.txt2.inputView =new_keypad.view;
        
        mv.txt.backgroundColor = box_back_color;
        mv.txt1.backgroundColor = box_back_color;
        mv.txt2.backgroundColor = box_back_color;
        mv.view.backgroundColor = [UIColor clearColor];
        
        mv.view.accessibilityLabel = mixedFraction_view_id;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        isTextFieldFirstResponder = FALSE;
        [mv.txt becomeFirstResponder];
    }
    else if ([@"limit_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        LimitView *mv = [[LimitView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.txt.inputView = new_keypad.view;
        mv.txt1.inputView =new_keypad.view;
        mv.txt2.inputView =new_keypad.view;
        
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt1.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt2.font=isIpad?math_font3:math_font3_iphone;
        
        mv.txt.backgroundColor = box_back_color;
        mv.txt1.backgroundColor = box_back_color;
        mv.txt2.backgroundColor = box_back_color;
        mv.view.backgroundColor = [UIColor clearColor];
        
        mv.view.accessibilityLabel = limit_view_id;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        isTextFieldFirstResponder = FALSE;
        [mv.txt becomeFirstResponder];
    }
    else if ([@"fx_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        CGRect rectFx = viewFrame;
        if (rectFx.size.width<=80) {
            rectFx.size.width=100;
        }
        viewFrame=rectFx;
        
        FofXView *mv = [[FofXView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.txt.inputView = new_keypad.view;
        
        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        
        mv.txt.backgroundColor = box_back_color;
        mv.view.backgroundColor = [UIColor clearColor];
        
        mv.view.accessibilityLabel = fx_view_id;
        [updateScroll addSubview:mv.view];
        viewFrame = mv.view.frame;
        isTextFieldFirstResponder = TRUE;
        [mv.txt becomeFirstResponder];
    }
    else if ([@"squareroot_big_ipad" isEqualToString:btn.accessibilityIdentifier]||btn.tag==k_root)
    {
        OperationView *mv = [[OperationView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = sqrt_view_id;
        mv.txt1.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt1 becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        
        mv.txt1.backgroundColor = box_back_color;
    }
    else if ([@"nroot_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        SquareRoot2View *mv = [[SquareRoot2View alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = nsqrt_view_id;
        mv.txt1.inputView =new_keypad.view;
        mv.txt2.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt2 becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        
        mv.txt1.font=isIpad?math_font2:math_font2_iphone;
        mv.txt2.font=isIpad?math_script_font:math_script_font_iphone;
        
        mv.txt1.backgroundColor = box_back_color;
        mv.txt2.backgroundColor = box_back_color;
        
    }/*
      else if ([@"factorial_ipad" isEqualToString:btn.accessibilityIdentifier])
      {
      if (activeTextfield.text.length==0)
      {
      if (isRequireNewTextField)
      {
      [self addNewTextfieldWithXpos:0 isviewBetween:isViewBetween isviewAdded:FALSE isFirstResponder:isTextFieldFirstResponder withViewFrame:viewFrame withWidth:width inScrollview:updateScroll WithReferenceTextfield:txt andTag:lastTag];
      isRequireNewTextField = FALSE;
      }
      return;
      }
      activeTextfield.text = [NSString stringWithFormat:@"%@!",activeTextfield.text];
      if (![activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
      {
      [self textFieldDidChange:activeTextfield];
      }
      else if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"]&&activeTextfield.text.length>1)
      {
      [self getXpositionAfterUpdatingTestTextfield:activeTextfield];
      }
      return;
      }*/
    else if ([@"degree_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        //        viewFrame = CGRectMake(x, 0, 8, updateScroll.frame.size.height);
        if (activeTextfield.text.length==0)
        {
            if (isRequireNewTextField)
            {
                [self addNewTextfieldWithXpos:0 isviewBetween:isViewBetween isviewAdded:FALSE isFirstResponder:isTextFieldFirstResponder withViewFrame:viewFrame withWidth:width inScrollview:updateScroll WithReferenceTextfield:txt andTag:lastTag];
                isRequireNewTextField = FALSE;
            }
            return;
        }
        
        
        // changed today 18-12-2015
        UITextRange *selectedRange = [activeTextfield selectedTextRange];
        
        NSRange range = [self selectedRange:activeTextfield];
        NSString * firstHalfString = [activeTextfield.text substringToIndex:range.location];
        NSString * secondHalfString = [activeTextfield.text substringFromIndex: range.location];
        
        NSString * insertingString = degree_ascii;
        
        activeTextfield.text = [NSString stringWithFormat: @"%@%@%@",
                                firstHalfString,
                                insertingString,
                                secondHalfString];
        range.location += [insertingString length];
        
        UITextPosition *newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:[insertingString length]];
        UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
        [activeTextfield setSelectedTextRange:newRange];
        
        //        activeTextfield.text = [NSString stringWithFormat:@"%@%@",activeTextfield.text,degree_ascii];
        
        if (![activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
        {
            [self textFieldDidChange:activeTextfield];
        }
        else if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"]&&activeTextfield.text.length>1) // changed 13-01-2016 = is added because between text box size not set when lenght=1
        {
            [self getXpositionAfterUpdatingTestTextfield:activeTextfield];
        }
        
        //        CGSize constraintSize = CGSizeMake(MAXFLOAT, activeTextfield.frame.size.height);
        //        CGSize labelSize = [activeTextfield.text sizeWithFont:activeTextfield.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByTruncatingTail];
        //        if (labelSize.width>=activeTextfield.frame.size.width-5)
        //        {
        //            activeTextfield.frame=CGRectMake(activeTextfield.frame.origin.x, activeTextfield.frame.origin.y, labelSize.width+20, activeTextfield.frame.size.height);
        //        }
        
        //        activeTextfield.backgroundColor=[UIColor greenColor];
        //        activeTextfield.adjustsFontSizeToFitWidth=YES;
        
        /*
         if(LOGS_ON)NSLog(@"activeTextfield:= %@",NSStringFromCGRect(activeTextfield.frame));
         CGSize constraintSize = CGSizeMake(MAXFLOAT, activeTextfield.frame.size.height);
         
         if(LOGS_ON)NSLog(@"constraintSize:=    %@",NSStringFromCGSize(constraintSize));
         
         CGSize labelSize = [activeTextfield.text sizeWithFont:activeTextfield.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByTruncatingTail];
         if(LOGS_ON)NSLog(@"labelSize:= %@",NSStringFromCGSize(labelSize));
         
         activeTextfield.textAlignment=NSTextAlignmentLeft;
         
         if(LOGS_ON)NSLog(@"activeTextfield:= %@",NSStringFromCGRect(activeTextfield.frame));
         
         UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, activeTextfield.frame.size.height)];
         activeTextfield.leftView = paddingView;
         activeTextfield.leftViewMode = UITextFieldViewModeAlways;
         */
        
        // changed 25-01-2016
        if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
        {
            [new_keypad hideOptionMenu];//Added by Siddhi infosoft
        }
        
        if(LOGS_ON)NSLog(@"%@",activeTextfield);
        return;
    }
    else if ([@"e_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        ExponentEView *mv =[[ExponentEView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"e" andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = exponent_e_view_id;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"alpha_ipad" isEqualToString:btn.accessibilityIdentifier] || [@"mu_ipad" isEqualToString:btn.accessibilityIdentifier] || [@"sigma_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        ExponentEView *mv;
        
        if ([@"alpha_ipad" isEqualToString:btn.accessibilityIdentifier]) {
            mv =[[ExponentEView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:alpha_ascii andColor:myColor];
            mv.view.accessibilityLabel = alpha_view_id;
        }
        else if ([@"mu_ipad" isEqualToString:btn.accessibilityIdentifier]) {
            mv =[[ExponentEView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:mu_ascii andColor:myColor];
            mv.view.accessibilityLabel = mu_view_id;
        }
        else if ([@"sigma_ipad" isEqualToString:btn.accessibilityIdentifier]) {
            mv =[[ExponentEView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:sigma_alpha_ascii andColor:myColor];
            mv.view.accessibilityLabel = sigma_view_id;
        }
        
        mv.view.tag = lastTag;
        
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt.backgroundColor = box_back_color;
    }
    
    else if ([@"theta_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        ExponentEView *mv =[[ExponentEView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"ø" andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = exponent_theta_view_id;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"log_ipad" isEqualToString:btn.accessibilityIdentifier] || [@"ln_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        LogView *mv;
        if ([@"log_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            mv =[[LogView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"log" andColor:myColor];
            mv.view.accessibilityLabel = trigonometric_log_id;
        }
        else if ([@"ln_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            mv =[[LogView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"ln" andColor:myColor];
            mv.view.accessibilityLabel = trigonometric_ln_id;
        }
        
        mv.view.tag = lastTag;
        
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        
        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"logn_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        LogView2 *mv = [[LogView2 alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"log" andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = trigonometric_logn_id;
        
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt1.font=isIpad?math_font2:math_font2_iphone;
        
        mv.lbl.font=isIpad?math_font2:math_font2_iphone;
        
        mv.txt1.backgroundColor = box_back_color;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"i_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        ExponentEView *mv =[[ExponentEView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:@"i" andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = exponent_i_view_id;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"expo_p_big_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"expo_m_big_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        //    expo_p_big_ipad
        //    expo_m_big_ipad
        
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        
        ExponentPMView *mv;
        if ([@"expo_p_big_ipad" isEqualToString:btn.accessibilityIdentifier]) {
            mv = [[ExponentPMView alloc]initWithFrame:viewFrame  andDelegate:self andOptions:ExponentPM_plus andColor:myColor];
            mv.view.accessibilityLabel = plus_exponent_view_id;
        }
        else
        {
            mv = [[ExponentPMView alloc]initWithFrame:viewFrame  andDelegate:self andOptions:ExponentPM_minus andColor:myColor];
            mv.view.accessibilityLabel = minus_exponent_view_id;
        }
        mv.view.tag = lastTag;
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        
        //        mv.txt1.backgroundColor = box_back_color;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"exponent_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        ExponentView *mv = [[ExponentView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = exponent_view_id;
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        
        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt1.font=isIpad?math_script_font:math_script_font_iphone;
        
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        
        mv.txt1.backgroundColor = box_back_color;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"exponent_down_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        ExponentDownView *mv = [[ExponentDownView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];//ExponentDownView
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = down_exponent_view_id;
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt1.font=isIpad?math_script_font:math_script_font_iphone;
        mv.txt1.backgroundColor = box_back_color;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"tenexponent_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        TenExponentView *mv = [[TenExponentView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = tenexponent_view_id;
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        mv.txt.font=isIpad?math_font2:math_font2_iphone;
        mv.txt1.font=isIpad?math_script_font:math_script_font_iphone;
        
        mv.txt1.backgroundColor = box_back_color;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"point_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        PointView *mv = [[PointView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = point_view_id;
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        
        mv.txt1.backgroundColor = box_back_color;
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"parenthesis_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        ParenthesisView *mv = [[ParenthesisView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = parenthesis_view_id;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"absolute_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        AbsoluteView *mv = [[AbsoluteView alloc]initWithFrame:viewFrame  andDelegate:self andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = absolute_view_id;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"series_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        SigmaView *mv = [[SigmaView alloc] initWithFrame:viewFrame andDelegate:self withOptionString:sigma_ascii fontSize:16.0 andColor:myColor];
        mv.view.tag = lastTag;
        mv.view.accessibilityLabel = precalculus_sigma_id;
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        mv.txt2.inputView =new_keypad.view;
        
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        
        mv.txt1.backgroundColor = box_back_color;
        mv.txt.backgroundColor = box_back_color;
        mv.txt2.backgroundColor = box_back_color;
    }
    else if ([@"sin" isEqualToString:btn.accessibilityIdentifier] || [@"arcsin" isEqualToString:btn.accessibilityIdentifier] || [@"sinh" isEqualToString:btn.accessibilityIdentifier] || [@"cos" isEqualToString:btn.accessibilityIdentifier] || [@"arccos" isEqualToString:btn.accessibilityIdentifier] || [@"cosh" isEqualToString:btn.accessibilityIdentifier] ||  [@"tan" isEqualToString:btn.accessibilityIdentifier] || [@"arctan" isEqualToString:btn.accessibilityIdentifier] || [@"tanh" isEqualToString:btn.accessibilityIdentifier] || [@"sec" isEqualToString:btn.accessibilityIdentifier] || [@"arcsec" isEqualToString:btn.accessibilityIdentifier] || [@"sech" isEqualToString:btn.accessibilityIdentifier] || [@"csc" isEqualToString:btn.accessibilityIdentifier] || [@"arccsc" isEqualToString:btn.accessibilityIdentifier] || [@"csch" isEqualToString:btn.accessibilityIdentifier] || [@"cot" isEqualToString:btn.accessibilityIdentifier] || [@"arccot" isEqualToString:btn.accessibilityIdentifier] || [@"coth" isEqualToString:btn.accessibilityIdentifier])
    {
        TrigonometricView *mv =[[TrigonometricView alloc]initWithFrame:viewFrame andDelegate:self withOptionString:btn.accessibilityIdentifier andColor:myColor];
        mv.view.tag = lastTag;
        
        if ([@"sin" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_sin_id;
        }
        else if ([@"arcsin" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_arcsin_id;
        }
        else if ([@"sinh" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_sinh_id;
        }
        else if ([@"cos" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_cos_id;
        }
        else if ([@"arccos" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_arccos_id;
        }
        else if ([@"cosh" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_cosh_id;
        }
        else if ([@"tan" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_tan_id;
        }
        else if ([@"arctan" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_arctan_id;
        }
        else if ([@"tanh" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_tanh_id;
        }
        else if ([@"sec" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_sec_id;
        }
        else if ([@"arcsec" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_arcsec_id;
        }
        else if ([@"sech" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_sech_id;
        }
        else if ([@"csc" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_csc_id;
        }
        else if ([@"arccsc" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_arccsc_id;
        }
        else if ([@"csch" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_csch_id;
        }
        else if ([@"cot" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_cot_id;
        }
        else if ([@"arccot" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_arccot_id;
        }
        else if ([@"coth" isEqualToString:btn.accessibilityIdentifier]) {
            mv.view.accessibilityLabel = trigonometric_coth_id;
        }
        
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        
        mv.txt.backgroundColor = box_back_color;
    }
    else if ([@"sinn" isEqualToString:btn.accessibilityIdentifier] || [@"cosn" isEqualToString:btn.accessibilityIdentifier] || [@"tann" isEqualToString:btn.accessibilityIdentifier] || [@"secn" isEqualToString:btn.accessibilityIdentifier] || [@"cscn" isEqualToString:btn.accessibilityIdentifier] || [@"cotn" isEqualToString:btn.accessibilityIdentifier])
    {
        //        viewFrame = CGRectMake(x+5, 0, width+5, updateScroll.frame.size.height);
        NSString *str = [btn.accessibilityIdentifier substringToIndex:[btn.accessibilityIdentifier length] - 1];
        
        TrigonometricView2 *mv = [[TrigonometricView2 alloc]initWithFrame:viewFrame andDelegate:self withOptionString:str andColor:myColor];
        mv.view.tag = lastTag;
        
        if ([@"sinn" isEqualToString:btn.accessibilityIdentifier])
        {
            mv.view.accessibilityLabel = trigonometric_sinn_id;
        }
        else if ([@"cosn" isEqualToString:btn.accessibilityIdentifier])
        {
            mv.view.accessibilityLabel = trigonometric_cosn_id;
        }
        else if ([@"tann" isEqualToString:btn.accessibilityIdentifier])
        {
            mv.view.accessibilityLabel = trigonometric_tann_id;
        }
        else if ([@"secn" isEqualToString:btn.accessibilityIdentifier])
        {
            mv.view.accessibilityLabel = trigonometric_secn_id;
        }
        else if ([@"cscn" isEqualToString:btn.accessibilityIdentifier])
        {
            mv.view.accessibilityLabel = trigonometric_cscn_id;
        }
        else if ([@"cotn" isEqualToString:btn.accessibilityIdentifier])
        {
            mv.view.accessibilityLabel = trigonometric_cotn_id;
        }
        
        
        mv.txt1.inputView =new_keypad.view;
        mv.txt.inputView =new_keypad.view;
        [updateScroll addSubview:mv.view];
        [mv.txt becomeFirstResponder];
        isTextFieldFirstResponder = FALSE;
        viewFrame = mv.view.frame;
        
        mv.txt.font=isIpad?math_script_font:math_script_font_iphone;
        
        mv.txt1.backgroundColor = box_back_color;
        mv.txt.backgroundColor = box_back_color;
    }
    
    else if (btn.tag==k_plus||btn.tag==k_minus||btn.tag==k_multiplication||btn.tag==k_devide||[@"gte_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"lte_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"gt_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"lt_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"equal_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"divide_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"parcent_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"pi_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"union_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"intersection_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"aerrow_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"xbar_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"muxb_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"sigmaxb_ipad" isEqualToString:btn.accessibilityIdentifier]||[@"infinity_ipad" isEqualToString:btn.accessibilityIdentifier] || [@"factorial_ipad" isEqualToString:btn.accessibilityIdentifier])
    {
        NSString *str=@"";
        
        OperationView1 *mv;
        //xbar_ipad        //muxb_ipad        //sigmaxb_ipad
        if ([@"gte_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_graterthanEqual andColor:myColor];
            
            str=@"≥";
            // changed 25-01-2016
            if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
            {
                [new_keypad hideOptionMenu];//Added by Siddhi infosoft
            }
        }
        else if ([@"equal_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_equal andColor:myColor];
            str=@"=";
        }
        else if ([@"lt_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_lessthan andColor:myColor];
            str=@"<";
            // changed 25-01-2016
            if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
            {
                [new_keypad hideOptionMenu];//Added by Siddhi infosoft
            }
            
        }
        else if ([@"gt_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_graterthan andColor:myColor];
            
            str= @">";
            // changed 25-01-2016
            if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
            {
                [new_keypad hideOptionMenu];//Added by Siddhi infosoft
            }
        }
        else if ([@"lte_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_lessthanEqual andColor:myColor];
            
            str=@"≤";
            // changed 25-01-2016
            if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
            {
                [new_keypad hideOptionMenu];//Added by Siddhi infosoft
            }
        }
        else if ([@"divide_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_devide andColor:myColor];
            str=@"÷";
            
        }
        else if ([@"parcent_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_percentage andColor:myColor];
            str=@"%";
            // changed 25-01-2016
            if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
            {
                [new_keypad hideOptionMenu];//Added by Siddhi infosoft
            }
        }
        else if ([@"union_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_union andColor:myColor];
            str=UNION_ascii;
        }
        else if ([@"intersection_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_intersection andColor:myColor];
            str=INTERSECTION_ascii;
        }
        else if ([@"pi_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_pie andColor:myColor];
            str=@"π";
            // changed 25-01-2016
            if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
            {
                [new_keypad hideOptionMenu];//Added by Siddhi infosoft
            }
        }
        else if ([@"aerrow_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_arrow andColor:myColor];
            //            str=rightArrow_ascii;
        }
        else if ([@"xbar_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_xbar andColor:myColor];
            str=xbar_ascii; // changed 05-01-2016
            // changed 26-01-2016
            if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
            {
                [new_keypad hideOptionMenu];//Added by Siddhi infosoft
            }
            //            return;
        }
        else if ([@"infinity_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_infinity andColor:myColor];
            str = @"∞";
            // changed 25-01-2016
            if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
            {
                [new_keypad hideOptionMenu];//Added by Siddhi infosoft
            }
        }//infinity_ipad
        else if ([@"muxb_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_mu_xbar andColor:myColor];
            str = mu_xbar_ascii;  // changed 05-01-2016
            
            // changed 26-01-2016
            if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
            {
                [new_keypad hideOptionMenu];//Added by Siddhi infosoft
            }
            //            return;
            
        }
        else if ([@"sigmaxb_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_sigma_xbar andColor:myColor];
            str = sigma_xbar_ascii;  // changed 05-01-2016
            // changed 26-01-2016
            if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
            {
                [new_keypad hideOptionMenu];//Added by Siddhi infosoft
            }
            //            return;
        }
        else if ([@"factorial_ipad" isEqualToString:btn.accessibilityIdentifier])
        {
            //            mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_factorial andColor:myColor];
            str = @"!";
            // changed 25-01-2016
            if (activeTextfield!=nil&&new_keypad.isOptionMenuOpened)
            {
                [new_keypad hideOptionMenu];//Added by Siddhi infosoft
            }
        }
        else
        {
            switch (btn.tag) {
                case k_plus:
                    mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_plus andColor:myColor];
                    break;
                case k_minus:
                    mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_minus andColor:myColor];
                    break;
                case k_multiplication:
                    mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_multiplication andColor:myColor];
                    break;
                case k_devide:
                    mv = [[OperationView1 alloc]initWithFrame:viewFrame  andDelegate:self  withOpearationTag:op_devide andColor:myColor];
                    break;
                default:
                    break;
            }
        }
        
        if (mv!=nil)
        {
            mv.view.accessibilityLabel = operation_view_id;
            mv.view.tag = lastTag;
            
            mv.txt1.inputView = new_keypad.view;
            [updateScroll addSubview:mv.view];
            if (isTextFieldFirstResponder)
            {
                //                mv.txt1.textAlignment = NSTextAlignmentJustified;
                activeTextfield = mv.txt1;
                isTextFieldFirstResponder = FALSE;
            }
            viewFrame = mv.view.frame;
        }
        
        if (str.length>0)
        {
            NSLog(@"%@",updateScroll.subviews);
            
            if(LOGS_ON)NSLog(@"%@ pressed",str);
            if (btn.tag==k_dot)
            {
                if ([activeTextfield.text rangeOfString:str].location == NSNotFound)
                {
                    activeTextfield.text = [activeTextfield.text stringByAppendingString:str];
                }
            }
            else
            {
                // changed today 18-12-2015
                UITextRange *selectedRange = [activeTextfield selectedTextRange];
                
                NSRange range = [self selectedRange:activeTextfield];
                NSString * firstHalfString = [activeTextfield.text substringToIndex:range.location];
                NSString * secondHalfString = [activeTextfield.text substringFromIndex: range.location];
                
                NSString * insertingString = str;
                
                activeTextfield.text = [NSString stringWithFormat: @"%@%@%@",
                                        firstHalfString,
                                        insertingString,
                                        secondHalfString];
                range.location += [insertingString length];
                
                UITextPosition *newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:[insertingString length]];
                UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
                [activeTextfield setSelectedTextRange:newRange];
                
                //                activeTextfield.text = [activeTextfield.text stringByAppendingString:str];
            }
            
            if (![activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
            {
                [self textFieldDidChange:activeTextfield];
            }
            else if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"]&&activeTextfield.text.length>=1) // changed 31-12-2015   '=' is added due to operator length 1 is there that time width not set. left side gone text
            {
                [self getXpositionAfterUpdatingTestTextfield:activeTextfield];
            }
            
            return;
        }
        
    }
    else
    {
        //        return;
        lastTag--;
        isViewAdded = FALSE;
    }
    
    //14-8-2015-start
    if (isViewBetween)
    {
        [self manageViewAfterAddingViewBetweenTwoViewInScrollView:updateScroll];
        if (!isRequireNewTextField)
        {
            if (!isTextFieldFirstResponder)//17-8-2015
            {
                [activeTextfield becomeFirstResponder];//17-8-2015
            }
            return;
        }
        else
        {
            for (UIView *v in updateScroll.subviews)
            {
                if(LOGS_ON)NSLog(@"%ld",(long)v.tag);
                if (v.tag>=lastTag)
                {
                    lastTag=v.tag;
                    x = v.frame.origin.x+v.frame.size.width+space_between_view;
                }
                
                /*
                 if (lastTag>=50)
                 {
                 lastTag++;
                 }
                 */
            }
            //            isViewAdded = TRUE;
        }
    }
    //14-8-2015-End
    
    if (isRequireNewTextField)
    {
        if (!isViewBetween)//14-8-2015
        {
            if (isViewAdded)
            {
                x = viewFrame.origin.x + viewFrame.size.width + space_between_view;
            }
            else
            {
                x = viewFrame.origin.x;
            }
        }
        
        UITextField *updateTextField1 = [[UITextField alloc]init ];
        updateTextField1.frame = CGRectMake(x, txt.frame.origin.y, width, txt.frame.size.height);
        
        if (x+width<updateScroll.frame.size.width)
        {
            int width1 = updateScroll.frame.size.width - x;
            updateTextField1.frame = CGRectMake(x, txt.frame.origin.y, width1, txt.frame.size.height);
        }
        updateTextField1.inputView =new_keypad.view;
        updateTextField1.accessibilityIdentifier = @"test";
        updateTextField1.delegate = self;
        updateTextField1.tintColor = tint_Color;
        updateTextField1.tag = lastTag+1;
        
        updateTextField1.font = isIpad?math_font1:math_font1_iphone;
        updateTextField1.backgroundColor = [UIColor clearColor];
        [updateScroll addSubview:updateTextField1];
        if (isTextFieldFirstResponder)
        {
            [updateTextField1 becomeFirstResponder];
        }
        else
        {
            [activeTextfield becomeFirstResponder];//17-8-2015
        }
        isRequireNewTextField = FALSE;
    }
    updateScroll.contentSize=CGSizeMake(x+width+5, updateScroll.frame.size.height);
    
    // changed 19-01-2016
    if (updateScroll.contentSize.width>updateScroll.frame.size.width)
    {
        updateScroll.contentOffset = CGPointMake(updateScroll.contentSize.width-updateScroll.frame.size.width, updateScroll.contentOffset.y);
    }
    //
}
-(void)addNewTextfieldWithXpos:(int)x_pos isviewBetween:(BOOL)isViewBetween isviewAdded:(BOOL)isViewAdded isFirstResponder:(BOOL)isTextFieldFirstResponder withViewFrame:(CGRect)viewFrame withWidth:(int)width inScrollview:(UIScrollView*)updateScroll WithReferenceTextfield:(UITextField*)txt andTag:(int)lastTag
{
    
    if (!isViewBetween)//14-8-2015
    {
        if (isViewAdded)
        {
            x_pos = viewFrame.origin.x + viewFrame.size.width + space_between_view;
        }
        else
        {
            x_pos = viewFrame.origin.x;
            
        }
    }
    UITextField *updateTextField1 = [[UITextField alloc]init ];
    updateTextField1.frame = CGRectMake(x_pos, txt.frame.origin.y, width, txt.frame.size.height);
    
    if (x_pos+width<updateScroll.frame.size.width)
    {
        int width1 = updateScroll.frame.size.width - x_pos;
        updateTextField1.frame = CGRectMake(x_pos, txt.frame.origin.y, width1, txt.frame.size.height);
    }
    updateTextField1.inputView =new_keypad.view;
    updateTextField1.accessibilityIdentifier = @"test";
    updateTextField1.delegate = self;
    updateTextField1.tag = lastTag+1;
    updateTextField1.tintColor = tint_Color;
    updateTextField1.font = isIpad?math_font1:math_font1_iphone;
    updateTextField1.backgroundColor = [UIColor clearColor];
    [updateScroll addSubview:updateTextField1];
    if (isTextFieldFirstResponder)
    {
        [updateTextField1 becomeFirstResponder];
    }
    else
    {
        [activeTextfield becomeFirstResponder];//17-8-2015
    }
    
    updateScroll.contentSize=CGSizeMake(x_pos+width+5, updateScroll.frame.size.height);
}


- (void)setSelectedRange:(NSRange)selectedRange
{
    UITextPosition* from = [activeTextfield positionFromPosition:activeTextfield.beginningOfDocument offset:selectedRange.location];
    UITextPosition* to = [activeTextfield positionFromPosition:from offset:selectedRange.length-1];
    activeTextfield.selectedTextRange = [activeTextfield textRangeFromPosition:from toPosition:to];
}

- (NSRange)selectedRange:(UITextField *)txt
{
    UITextRange* range = txt.selectedTextRange;
    NSInteger location = [txt offsetFromPosition:txt.beginningOfDocument toPosition:range.start];
    NSInteger length = [txt offsetFromPosition:range.start toPosition:range.end];
    NSAssert(location >= 0, @"Location is valid.");
    NSAssert(length >= 0, @"Length is valid.");
    return NSMakeRange(location, length);
}

- (void)forwardOrBackwordClicked:(id)sender
{
    UIButton *btn = sender;
    UIScrollView *updateScroll;
    LAStudentCustomAnswerCell *cell = (LAStudentCustomAnswerCell *)[self superViewOfType:[LAStudentCustomAnswerCell class] forView:activeTextfield];
    if (cell)
    {
        updateScroll = cell.updateScroll;
    }
    
    // 05-01-2016
    NSRange rangeBefore = [self selectedRange:activeTextfield];
    int tagForActive = (int)activeTextfield.tag;
    //
    
    if(LOGS_ON)NSLog(@"%@",[updateScroll.subviews lastObject]);
    UIView *V;
    //    NSLog(@"%@",activeTextfield.accessibilityIdentifier);
    if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
    {
        // Changed today 18-12-2015
        
        // Get current selected range , this example assumes is an insertion point or empty selection
        UITextRange *selectedRange = [activeTextfield selectedTextRange];
        NSRange range1 = [self selectedRange:activeTextfield];
        
        BOOL isActionDone=NO;
        
        if (activeTextfield.text.length>0 )
        {
            // Calculate the new position, - for left and + for right
            UITextPosition *newPosition;
            
            if (btn.tag==k_forward && range1.location!=activeTextfield.text.length)
            {
                newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:1];
                isActionDone=YES;
            }
            else if (btn.tag==k_backward && range1.location!=0)
            {
                newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:-1];
                isActionDone=YES;
            }
            
            if (isActionDone) {
                // Construct a new range using the object that adopts the UITextInput, our textfield
                UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
                
                // Set new range
                [activeTextfield setSelectedTextRange:newRange];
                return;
            }
        }
        
        if (!isActionDone)
        {
            switch (btn.tag) {
                    
                case k_forward:
                {
                    V = [updateScroll viewWithTag:activeTextfield.tag+1];
                    break;
                }
                case k_backward:
                {
                    V = [updateScroll viewWithTag:activeTextfield.tag-1];
                    break;
                }
                    
                default:
                    break;
            }
        }
    }
    else
    {
        V = (UIView *)[self superViewOfType:[UIView class] forActiveTextField:activeTextfield];
        
    }
    if(LOGS_ON)NSLog(@"%@",V);
    if(LOGS_ON)NSLog(@"%ld",(long)activeTextfield.tag);
    
    if (V==nil) {
        return;
    }
    switch (btn.tag) {
        case k_backward:
        {
            if(LOGS_ON)NSLog(@"%@",V.accessibilityLabel);
            if (activeTextfield.tag>1&&![activeTextfield.accessibilityIdentifier isEqualToString:@"test"]&&![V.accessibilityLabel isEqualToString:operation_view_id])
            {
                // Changed today 18-12-2015
                
                BOOL isActionDone=NO;
                UITextRange *selectedRange = [activeTextfield selectedTextRange];
                NSRange range1 = [self selectedRange:activeTextfield];
                
                if (activeTextfield.text.length>0)
                {
                    // Calculate the new position, - for left and + for right
                    UITextPosition *newPosition;
                    
                    if (range1.location!=0)
                    {
                        newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:-1];
                        isActionDone=YES;
                    }
                    
                    if (isActionDone) {
                        // Construct a new range using the object that adopts the UITextInput, our textfield
                        UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
                        
                        // Set new range
                        [activeTextfield setSelectedTextRange:newRange];
                        return;
                    }
                }
                
                if (!isActionDone) {
                    UIView *newView = [V viewWithTag:activeTextfield.tag-1];
                    if (newView!=nil&&[newView isKindOfClass:[UITextField class]])
                    {
                        UITextField *txt = (UITextField*)newView;
                        [txt becomeFirstResponder];
                    }
                }
            }
            else
            {
                // Changed today 18-12-2015
                
                BOOL isActionDone=NO;
                UITextRange *selectedRange = [activeTextfield selectedTextRange];
                NSRange range1 = [self selectedRange:activeTextfield];
                
                if (activeTextfield.text.length>0)
                {
                    // Calculate the new position, - for left and + for right
                    UITextPosition *newPosition;
                    
                    if (range1.location!=0)
                    {
                        newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:-1];
                        isActionDone=YES;
                    }
                    
                    if (isActionDone) {
                        // Construct a new range using the object that adopts the UITextInput, our textfield
                        UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
                        
                        // Set new range
                        [activeTextfield setSelectedTextRange:newRange];
                        return;
                    }
                }
                
                UIView *newv = [updateScroll viewWithTag:V.tag-1];
                if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"]) {
                    newv = V;
                }
                //                while ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:operation_view_id])
                //                {
                //                    newv = [updateScroll viewWithTag:newv.tag-1];
                //                }
                UIView *newVi = nil;
                if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:fraction_view_id])
                {
                    newVi = [newv viewWithTag:2];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:operation_view_id])
                {
                    for (int i=0;i<newv.subviews.count;i++)
                    {
                        UIView *t = [newv.subviews objectAtIndex:i];
                        if(LOGS_ON)NSLog(@"%@",t);
                        if ([t isKindOfClass:[UITextField class]])
                        {
                            UITextField *tx = (UITextField*)t;
                            tx.inputView = new_keypad.view;
                            [tx becomeFirstResponder];
                            break;
                        }
                        else if([t isKindOfClass:[UIView class]]&&[t.accessibilityIdentifier isEqualToString:textField_container])
                        {
                            for (int j=0;j<t.subviews.count;j++)
                            {
                                UIView *t1 = [t.subviews objectAtIndex:j];
                                if(LOGS_ON)NSLog(@"%@",t1);
                                if ([t1 isKindOfClass:[UITextField class]])
                                {
                                    UITextField *tx = (UITextField*)t1;
                                    tx.inputView = new_keypad.view;
                                    //                                    tx.textAlignment = NSTextAlignmentJustified;
                                    [tx becomeFirstResponder];
                                    break;
                                }
                            }
                        }
                        
                    }
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:mixedFraction_view_id])
                {
                    newVi = [newv viewWithTag:3];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:limit_view_id])
                {
                    newVi = [newv viewWithTag:3];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:fx_view_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:avenir_view_id])
                {
                    newVi = [newv viewWithTag:2];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:avenirBox_view_id])
                {
                    newVi = [newv viewWithTag:4];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:permutation_view_id])
                {
                    newVi = [newv viewWithTag:2];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:combination_view_id])
                {
                    newVi = [newv viewWithTag:2];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:sqrt_view_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:nsqrt_view_id])
                {
                    newVi = [newv viewWithTag:2];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:exponent_e_view_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:alpha_view_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:sigma_view_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:mu_view_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:exponent_theta_view_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_log_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_ln_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_logn_id])
                {
                    newVi = [newv viewWithTag:2];
                    
                }
                
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:exponent_i_view_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:minus_exponent_view_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:plus_exponent_view_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:down_exponent_view_id])
                {
                    newVi = [newv viewWithTag:2];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:exponent_view_id])
                {
                    newVi = [newv viewWithTag:2];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:tenexponent_view_id])
                {
                    newVi = [newv viewWithTag:2];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:point_view_id])
                {
                    newVi = [newv viewWithTag:2];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:parenthesis_view_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:absolute_view_id])
                {
                    newVi = [newv viewWithTag:1];
                    
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:precalculus_sigma_id])
                {
                    newVi = [newv viewWithTag:3];
                    
                }
                
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_sin_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_arcsin_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_sinh_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_cos_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_arccos_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_cosh_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_tan_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_arctan_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_tanh_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_sec_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_arcsec_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_sech_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_csc_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_arccsc_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_csch_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_cot_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_arccot_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_coth_id])
                {
                    newVi = [newv viewWithTag:1];
                }
                
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_sinn_id])
                {
                    newVi = [newv viewWithTag:2];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_cosn_id])
                {
                    newVi = [newv viewWithTag:2];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_tann_id])
                {
                    newVi = [newv viewWithTag:2];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_secn_id])
                {
                    newVi = [newv viewWithTag:2];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_cscn_id])
                {
                    newVi = [newv viewWithTag:2];
                }
                else if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:trigonometric_cotn_id])
                {
                    newVi = [newv viewWithTag:2];
                }
                
                else if ([newv isKindOfClass:[UITextField class]])
                {
                    newVi = newv;
                    
                }
                if (newVi!=nil&&[newVi isKindOfClass:[UITextField class]])
                {
                    UITextField *txt = (UITextField*)newVi;
                    [txt becomeFirstResponder];
                    
                }
                
                
            }
            break;
        }
        case k_forward:
        {
            // Changed today 18-12-2015
            
            UITextRange *selectedRange = [activeTextfield selectedTextRange];
            NSRange range1 = [self selectedRange:activeTextfield];
            BOOL isActionDone=NO;
            if (activeTextfield.text.length>0 )
            {
                // Calculate the new position, - for left and + for right
                UITextPosition *newPosition;
                
                if (range1.location!=activeTextfield.text.length)
                {
                    newPosition = [activeTextfield positionFromPosition:selectedRange.start offset:1];
                    isActionDone=YES;
                }
                
                if (isActionDone) {
                    // Construct a new range using the object that adopts the UITextInput, our textfield
                    UITextRange *newRange = [activeTextfield textRangeFromPosition:newPosition toPosition:newPosition];
                    
                    // Set new range
                    [activeTextfield setSelectedTextRange:newRange];
                    return;
                }
            }
            
            UIView *newView;
            if (activeTextfield.tag>=1&&![activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
            {
                newView = [V viewWithTag:activeTextfield.tag+1];
                
            }
            else if([activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
            {
                newView = V;
            }
            if (newView!=nil&&[newView isKindOfClass:[UITextField class]]) {
                UITextField *txt = (UITextField*)newView;
                [txt becomeFirstResponder];
                
                // Changed today 18-12-2015
                UITextPosition *newPosition;
                newPosition = [txt positionFromPosition:[[txt selectedTextRange] start] offset:-txt.text.length];
                UITextRange *newRange = [txt textRangeFromPosition:newPosition toPosition:newPosition];
                [txt setSelectedTextRange:newRange];
                //
                
            }
            else if (newView!=nil&&[newView isKindOfClass:[UIView class]]&&[newView.accessibilityLabel isEqualToString:operation_view_id])
            {
                for (int i=0;i<newView.subviews.count;i++)
                {
                    UIView *t = [newView.subviews objectAtIndex:i];
                    if(LOGS_ON)NSLog(@"%@",t);
                    if ([t isKindOfClass:[UITextField class]])
                    {
                        UITextField *tx = (UITextField*)t;
                        tx.inputView = new_keypad.view;
                        [tx becomeFirstResponder];
                        break;
                    }
                    else if([t isKindOfClass:[UIView class]]&&[t.accessibilityIdentifier isEqualToString:textField_container])
                    {
                        for (int j=0;j<t.subviews.count;j++)
                        {
                            UIView *t1 = [t.subviews objectAtIndex:j];
                            if(LOGS_ON)NSLog(@"%@",t1);
                            if ([t1 isKindOfClass:[UITextField class]])
                            {
                                UITextField *tx = (UITextField*)t1;
                                tx.inputView = new_keypad.view;
                                //                                tx.textAlignment = NSTextAlignmentJustified;
                                [tx becomeFirstResponder];
                                break;
                            }
                        }
                    }
                    
                }
            }
            else
            {
                UIView *newv = [updateScroll viewWithTag:V.tag+1];
                if([activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
                {
                    newv = V;
                }
                if (newv!=nil&&[newv isKindOfClass:[UIView class]]&&[newv.accessibilityLabel isEqualToString:operation_view_id])
                {
                    for (int i=0;i<newv.subviews.count;i++)
                    {
                        UIView *t = [newv.subviews objectAtIndex:i];
                        if(LOGS_ON)NSLog(@"%@",t);
                        if ([t isKindOfClass:[UITextField class]])
                        {
                            UITextField *tx = (UITextField*)t;
                            tx.inputView = new_keypad.view;
                            [tx becomeFirstResponder];
                            break;
                        }
                        else if([t isKindOfClass:[UIView class]]&&[t.accessibilityIdentifier isEqualToString:textField_container])
                        {
                            for (int j=0;j<t.subviews.count;j++)
                            {
                                UIView *t1 = [t.subviews objectAtIndex:j];
                                if(LOGS_ON)NSLog(@"%@",t1);
                                if ([t1 isKindOfClass:[UITextField class]])
                                {
                                    UITextField *tx = (UITextField*)t1;
                                    tx.inputView = new_keypad.view;
                                    //                                    tx.textAlignment = NSTextAlignmentJustified;
                                    [tx becomeFirstResponder];
                                    break;
                                }
                            }
                        }
                        
                    }
                }
                UIView *newVi = nil;
                //                while ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:operation_view_id])
                //                {
                //                    newv = [updateScroll viewWithTag:newv.tag+1];
                //                    newVi = [newv viewWithTag:1];
                //                }
                //                if ([newv isKindOfClass:[UIView class]]&& [newv.accessibilityLabel isEqualToString:operation_view_id])
                //                {
                //                    newv = [updateScroll viewWithTag:newv.tag+1];
                //                    newVi = [newv viewWithTag:1];
                //                }
                if ([newv isKindOfClass:[UITextField class]]&&[newv.accessibilityIdentifier isEqualToString:@"test"]) {
                    newVi = newv;
                }
                if ([newv isKindOfClass:[UIView class]]&&![newv.accessibilityIdentifier isEqualToString:@"test"])
                {
                    newVi = [newv viewWithTag:1];
                }
                if (newv!=nil&&[newv isKindOfClass:[UIView class]]&&[newv.accessibilityLabel isEqualToString:operation_view_id])
                {
                    for (int i=0;i<newv.subviews.count;i++)
                    {
                        UIView *t = [newv.subviews objectAtIndex:i];
                        if(LOGS_ON)NSLog(@"%@",t);
                        if ([t isKindOfClass:[UITextField class]])
                        {
                            UITextField *tx = (UITextField*)t;
                            tx.inputView = new_keypad.view;
                            [tx becomeFirstResponder];
                            break;
                        }
                        else if([t isKindOfClass:[UIView class]]&&[t.accessibilityIdentifier isEqualToString:textField_container])
                        {
                            for (int j=0;j<t.subviews.count;j++)
                            {
                                UIView *t1 = [t.subviews objectAtIndex:j];
                                if(LOGS_ON)NSLog(@"%@",t1);
                                if ([t1 isKindOfClass:[UITextField class]])
                                {
                                    UITextField *tx = (UITextField*)t1;
                                    tx.inputView = new_keypad.view;
                                    //                                    tx.textAlignment = NSTextAlignmentJustified;
                                    [tx becomeFirstResponder];
                                    break;
                                }
                            }
                        }
                        
                    }
                }
                if (newVi!=nil&&[newVi isKindOfClass:[UITextField class]]) {
                    
                    UITextField *txt = (UITextField*)newVi;
                    txt.inputView = new_keypad.view;
                    [txt becomeFirstResponder];
                    
                    // Changed today 18-12-2015
                    // changed 18-01-2016 before just if condition is there
                    UITextPosition *newPosition;
                    if (txt.text.length>0) {
                        newPosition = [txt positionFromPosition:[[txt selectedTextRange] start] offset:-txt.text.length];
                    }else{
                        newPosition = [txt positionFromPosition:[[txt selectedTextRange] start] offset:0];
                    }
                    
                    //                    newPosition = [txt positionFromPosition:[[txt selectedTextRange] start] offset:-txt.text.length];
                    UITextRange *newRange = [txt textRangeFromPosition:newPosition toPosition:newPosition];
                    [txt setSelectedTextRange:newRange];
                    //
                }
            }
            
            break;
        }
        default:
            break;
    }
    
    // 13-01-2016
    if (btn.tag==k_backward)
    {
        NSRange rangeAfter = [self selectedRange:activeTextfield];
        //
        if (activeTextfield.tag==tagForActive && rangeBefore.location==rangeAfter.location)
        {
            UIView *getView = (UIView *)[[updateScroll.subviews objectAtIndex:0] viewWithTag:50];
            
            if (getView==nil) {
                getView = (UIView *)[[updateScroll.subviews objectAtIndex:0] viewWithTag:51];
            }
            
            UITextField *updateTextField1 = [[UITextField alloc]init];
            updateTextField1.frame = CGRectMake(0, 0, 5, updateScroll.frame.size.height-1);
            updateTextField1.inputView = new_keypad.view;
            updateTextField1.accessibilityIdentifier = @"test";
            updateTextField1.delegate = self;
            updateTextField1.tag = 50;
            updateTextField1.font = isIpad?math_font2:math_font2_iphone;
            updateTextField1.tintColor = tint_Color;
            updateTextField1.backgroundColor = [UIColor clearColor];  //changed 13-01-2016
            //            [updateScroll addSubview:updateTextField1];
            [updateTextField1 becomeFirstResponder];
            
            getView.tag=updateTextField1.tag+1;
            
            [updateScroll insertSubview:updateTextField1 atIndex:0];
            
            
            for (UIView *v1 in updateScroll.subviews)
            {
                if ([v1 isKindOfClass:[UIImageView class]])
                {
                    [v1 removeFromSuperview];
                }
                else
                {
                    v1.frame=CGRectMake(v1.frame.origin.x+5, v1.frame.origin.y, v1.frame.size.width, v1.frame.size.height);
                }
            }
            
            
            updateTextField1.backgroundColor=[UIColor clearColor];
            [updateTextField1 becomeFirstResponder];
            
            if (![activeTextfield.accessibilityIdentifier isEqualToString:@"test"])
            {
                [self textFieldDidChange:updateTextField1];
            }
            else if ([activeTextfield.accessibilityIdentifier isEqualToString:@"test"]&&activeTextfield.text.length>=1) // changed 13-01-2016 = is added because between text box size not set when lenght=1
            {
                [self getXpositionAfterUpdatingTestTextfield:updateTextField1];
            }
        }
    }
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}
-(void)txt1Responded:(UITapGestureRecognizer *)recognizer
{
    UIView *view = recognizer.view;
    for (int i=0; i<view.subviews.count; i++)
    {
        UIView *t = [view.subviews objectAtIndex:i];
        if ([t isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)t;
            [txt becomeFirstResponder];
            break;
        }
    }
}


#pragma mark - code ended by siddhi infosoft -


@end
