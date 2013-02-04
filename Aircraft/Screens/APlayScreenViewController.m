//
//  APlayScreenViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 1/10/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "APlayScreenViewController.h"

@interface APlayScreenViewController ()
{
    AAircraftImageView *_tempAircraftForAdding;
    CGSize _tempAircraftSize;
}

- (void)setupBattleFields;
- (void)setupOperationPanel;
- (void)setupChattingField;
- (void)setupShadowView;
- (void)loadPage:(UIView *)viewPage toScrollView: (UIScrollView *)scrollView;

@end

@implementation APlayScreenViewController

@synthesize organizer = _organizer;

// battle fields
@synthesize scrollView = _scrollView;
@synthesize battleFldEnemy = _battleFldEnemy;
@synthesize battleFldSelf = _battleFldSelf;

// operation panel
@synthesize opPanel = _opPanel;

// chatting
@synthesize chatVC = _chatVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.organizer = [AGameOrganizer sharedInstance];
    
    [self setupBattleFields];
    [self setupOperationPanel];
    [self setupChattingField];
    [self setupShadowView];
    
    AAircraftModel *aircraft = [AAircraftModel aircraftWithOrgin:CGPointMake(4, 0) direction:AircraftDirectionLeft];
    [self.battleFldSelf addAircraft:aircraft];
    
    [self.organizer makeConnectionWithType:ConnectionTypeBluetooth];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
}

#pragma mark - setup battle fields

- (void)setupBattleFields
{
    self.battleFldEnemy = [self.organizer getBattleFieldVCFaction:BattleFieldEnemy];
    self.battleFldSelf = [self.organizer getBattleFieldVCFaction:BattleFieldSelf];
    
    self.battleFldEnemy.delegate = self;
    self.battleFldSelf.delegate = self;
    
    // enable paging [Yufei Lang 4/5/2012]
    self.scrollView.pagingEnabled = YES; 
    // disable scroll indicator [Yufei Lang 4/5/2012]
    self.scrollView.showsHorizontalScrollIndicator = NO; 
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    // set delegate to self in order to respond scroll actions [Yufei Lang 4/5/2012]
    self.scrollView.delegate = self; 
    self.scrollView.contentSize = CGSizeMake(self.battleFldEnemy.view.bounds.size.width + self.battleFldSelf.view.bounds.size.width, 1);
    // load my/enemy field into scroll view [Yufei Lang 4/5/2012]
    [self loadPage:self.battleFldSelf.view toScrollView:self.scrollView];
    [self loadPage:self.battleFldEnemy.view toScrollView:self.scrollView];
    [self.view addSubview:self.scrollView];
}

- (void)loadPage:(UIView *)viewPage toScrollView: (UIScrollView *)scrollView
{
    int iPageCount = scrollView.subviews.count;
    viewPage.frame = CGRectMake(viewPage.bounds.size.width * iPageCount, 0, viewPage.bounds.size.width, viewPage.bounds.size.height);
    [scrollView addSubview:viewPage];
}

#pragma mark - setup operation panel/view

- (void)setupOperationPanel
{
    self.opPanel = [self.organizer getOperationPanelVC];
    self.opPanel.viewDelegate = self;
    
    CGRect opPanelFrame = self.opPanel.view.frame;
    opPanelFrame.origin.x = 0;
    opPanelFrame.origin.y = self.scrollView.frame.origin.y + self.scrollView.frame.size.height;
    self.opPanel.view.frame = opPanelFrame;
    [self.view addSubview:self.opPanel.view];
}

- (void)userWantsToExit
{
    // organizer will also get a notice to reset the game
    [[AAppDelegate sharedInstance] popScreen:self animated:YES];
}

- (void)pressedAircraftHolderImg:(UILongPressGestureRecognizer *)longPressRecognizer
{
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan)
    {
        AAircraftHolderImageView *theView = (AAircraftHolderImageView *)longPressRecognizer.view;
        AAircraftModel *aircraft = [AAircraftModel aircraftWithOrgin:CGPointZero direction:theView.direction];
        _tempAircraftForAdding = [[AAircraftImageView alloc] initWithAircraftModel:aircraft];
        _tempAircraftForAdding.alpha = 0.7;
        
        CGSize smallerSize = _tempAircraftSize = _tempAircraftForAdding.frame.size;
        smallerSize.width /= 3;
        smallerSize.height /= 3;
        _tempAircraftForAdding.frame = CGRectMake(0, 0, smallerSize.width, smallerSize.height);
        CGPoint touchPoint = [longPressRecognizer locationInView:self.view];
        _tempAircraftForAdding.center = CGPointMake(touchPoint.x, touchPoint.y - smallerSize.height / 2);
        
        [self.view addSubview:_tempAircraftForAdding];
        
        [UIView beginAnimations:@"scaleToNormalSize" context:NULL];
        [UIView setAnimationDuration:0.2f];
        _tempAircraftForAdding.frame = CGRectMake(touchPoint.x - _tempAircraftSize.width / 2,
                                                  touchPoint.y - _tempAircraftSize.height,
                                                  _tempAircraftSize.width,
                                                  _tempAircraftSize.height);
        [UIView commitAnimations];
    }
    else if (longPressRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint pointAtOrginalView = [longPressRecognizer locationInView:longPressRecognizer.view];
        if ([longPressRecognizer.view pointInside:pointAtOrginalView withEvent:nil])
            if (_tempAircraftForAdding)
            {
                [_tempAircraftForAdding releasePath];
                [_tempAircraftForAdding removeFromSuperview];
                _tempAircraftForAdding = nil;
            }
    }
}

- (void)aircraftHolderDraging:(UIPanGestureRecognizer *)panRecognizer
{
    if (_tempAircraftForAdding)
    {
        if (panRecognizer.state == UIGestureRecognizerStateChanged)
        {
            CGPoint translation = [panRecognizer translationInView:self.view];
            
            [_tempAircraftForAdding setCenter:CGPointMake(_tempAircraftForAdding.center.x + translation.x,
                                                          _tempAircraftForAdding.center.y + translation.y)];
            [panRecognizer setTranslation:CGPointZero inView:self.view];
        }
        else if (panRecognizer.state == UIGestureRecognizerStateEnded)
        {
            // only analysis if touching point within self battle field
            CGPoint touchPt = [panRecognizer locationInView:self.battleFldSelf.view];
            if ([self.battleFldSelf.view pointInside:touchPt withEvent:nil])
            {
                AircraftDirection direction = ((AAircraftHolderImageView *)panRecognizer.view).direction;
                CGPoint oldOrgin = [self.view convertPoint:_tempAircraftForAdding.frame.origin toView:self.battleFldSelf.view];
                
                // check if inside the field grid
                if (oldOrgin.x >= -5 && oldOrgin.y >= -5 &&
                    oldOrgin.x + _tempAircraftSize.width <= 10 * kMappingFactor + 5 &&
                    oldOrgin.y + _tempAircraftSize.height <= 10 * kMappingFactor + 5)
                {
                    CGPoint newAircraftOrginPos;
                    newAircraftOrginPos.x = (int)(oldOrgin.x / kMappingFactor);
                    newAircraftOrginPos.y = (int)(oldOrgin.y / kMappingFactor);
                    
                    if (((int)oldOrgin.x % kMappingFactor) > kMappingFactor / 2)
                        newAircraftOrginPos.x += 1;
                    if (((int)oldOrgin.y % kMappingFactor) > kMappingFactor / 2)
                        newAircraftOrginPos.y += 1;
                    
                    AAircraftModel *newAircraft = [AAircraftModel aircraftWithOrgin:newAircraftOrginPos direction:direction];
                    [self.battleFldSelf addAircraft:newAircraft];
                }
            }
            
            [_tempAircraftForAdding releasePath];
            [_tempAircraftForAdding removeFromSuperview];
            _tempAircraftForAdding = nil;
        }
    }
}

#pragma mark - setup chatting view

- (void)setupChattingField
{
    self.chatVC = [self.organizer getChatVC];
    
    CGRect chatViewFrame = self.chatVC.view.frame;
    chatViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - 20 - chatViewFrame.size.height;
    self.chatVC.view.frame = chatViewFrame;
    [self.view addSubview:self.chatVC.view];
}

#pragma mark - setup shadow views

- (void)setupShadowView
{
    UIEdgeInsets insets = UIEdgeInsetsMake(1, 2, 1, 2);
    UIImage *upperShadowImg = [[UIImage imageNamed:@"dropShadowUp.png"] resizableImageWithCapInsets:insets];
    UIImage *lowerShadowImg = [[UIImage imageNamed:@"dropShadowDown.png"] resizableImageWithCapInsets:insets];
    
    UIImageView *upperShadowImgView = [[UIImageView alloc] initWithImage:upperShadowImg];
    UIImageView *lowerShadowImgView = [[UIImageView alloc] initWithImage:lowerShadowImg];
    
    CGRect frame = CGRectMake(0, 0, 320.0f, upperShadowImg.size.height);
    
    // adjust frame for upper shadow view
    frame.origin.y = self.scrollView.frame.origin.y + self.scrollView.frame.size.height - upperShadowImg.size.height;
    upperShadowImgView.frame = frame;
    
    // adjust frame for lower shadow view
    frame.origin.y = self.opPanel.view.frame.origin.y + self.opPanel.view.frame.size.height;
    lowerShadowImgView.frame = frame;
    
    [self.view addSubview:upperShadowImgView];
    [self.view addSubview:lowerShadowImgView];
}

#pragma mark - battle field view controller delegate

- (void)displayBattleField:(ABattleFieldViewController *)battleFieldVC
{
    [self.scrollView scrollRectToVisible:battleFieldVC.view.frame animated:YES];
}

- (void)userWantsToSwitchFieldFrom:(ABattleFieldViewController *)currentBattleField
{
    CGRect crrentFldFrame = currentBattleField.view.frame;
    
    CGRect visibleRect = CGRectMake(fabsf(crrentFldFrame.origin.x - crrentFldFrame.size.width),
                                    crrentFldFrame.origin.y,
                                    crrentFldFrame.size.width,
                                    crrentFldFrame.size.height);
    [self.scrollView scrollRectToVisible:visibleRect animated:YES];
}

/*!
 @discussion this point is the row and col in grid(intgers value)
 notice: this method will be called even gama is not on (battle not start)
 */
- (void)userTappedBattleField:(ABattleFieldViewController *)battleFld atGridPoint:(CGPoint)point;
{
    if (battleFld.faction == BattleFieldEnemy)
    {
        [self.chatVC resignTxtFldFirstResponder];
    }
    else if (battleFld.faction == BattleFieldSelf)
    {
        [self.chatVC resignTxtFldFirstResponder];
    }
    else
    {
        
    }
}

@end
