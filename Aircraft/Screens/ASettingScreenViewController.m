//
//  ASettingScreenViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 13-2-10.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "ASettingScreenViewController.h"

@implementation ASettingScreenViewController
@synthesize tableViewAdapter;
@synthesize tableView;
@synthesize bkgImageView;
@synthesize userPreferenceSessionTitlePanel;
@synthesize informationSessionTitlePanel;
@synthesize showGuideSwitch;
@synthesize soundMusicSwitch;
@synthesize showGuidesPanel;
@synthesize soundMusicPanel;
@synthesize languagePanel;
@synthesize aboutPanel;
@synthesize helpSupportPanel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.bkgImageView setImage:[UIImage imageForDarkLightRectBackground]];
    
    // load guide status
#warning TODO: make a finial check of number of guides
    BOOL isShowAllGuides = YES;
    for (int i = 1; i <= 3; i++)
        if (![ASetting needsForGuide:i])
            isShowAllGuides = NO;
    [self.showGuideSwitch setOn:isShowAllGuides];
    
    // load sound & music status
#warning TODO: set the sound&music switch
    
    [self.tableViewAdapter addView:[ATableViewAdapterView viewWithView:self.userPreferenceSessionTitlePanel] forKey:@"userPreferenceSessionTitlePanel" withStyle:ATableViewAdapterPanelStylePlain];
    [self.tableViewAdapter addView:[ATableViewAdapterView viewWithView:self.showGuidesPanel] forKey:@"showGuidesPanel" withStyle:ATableViewAdapterPanelStyleGrouped];
    [self.tableViewAdapter addView:[ATableViewAdapterView viewWithView:self.soundMusicPanel] forKey:@"soundMusicPanel" withStyle:ATableViewAdapterPanelStyleGrouped];
    [self.tableViewAdapter addView:[ATableViewAdapterView viewWithView:self.languagePanel target:self action:@selector(actionLanguageSelected)] forKey:@"languagePanel" withStyle:ATableViewAdapterPanelStyleGrouped];
    
    [self.tableViewAdapter addView:[ATableViewAdapterView viewWithView:self.informationSessionTitlePanel] forKey:@"informationSessionTitlePanel" withStyle:ATableViewAdapterPanelStylePlain];
    [self.tableViewAdapter addView:[ATableViewAdapterView viewWithView:self.aboutPanel target:self action:@selector(actionAboutSelected)] forKey:@"aboutPanel" withStyle:ATableViewAdapterPanelStyleGrouped];
    [self.tableViewAdapter addView:[ATableViewAdapterView viewWithView:self.helpSupportPanel target:self action:@selector(actionHelpSupportSelected)] forKey:@"helpSupportPanel" withStyle:ATableViewAdapterPanelStyleGrouped];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setTableViewAdapter:nil];
    [self setBkgImageView:nil];
    [self setUserPreferenceSessionTitlePanel:nil];
    [self setInformationSessionTitlePanel:nil];
    [self setShowGuidesPanel:nil];
    [self setSoundMusicPanel:nil];
    [self setLanguagePanel:nil];
    [self setAboutPanel:nil];
    [self setHelpSupportPanel:nil];
    [self setShowGuideSwitch:nil];
    [self setSoundMusicSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - actions

- (IBAction)actionSoundMusicSwitched:(id)sender 
{
    
}

- (IBAction)actionShowGuidesSwitched:(UISwitch *)sender 
{
#warning TODO: make a finial check of number of guides
    for (int i = 1; i <= 3; i++)
        [ASetting setValue:sender.isOn forGuideType:i];
}

- (void)actionLanguageSelected
{
    
}

- (void)actionAboutSelected
{
    
}

- (void)actionHelpSupportSelected
{
    
}

@end
