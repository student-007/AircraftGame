//
//  ALanguageScreenViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 13-2-11.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "ALanguageScreenViewController.h"

@interface ALanguageScreenViewController() 
{
@private
    
}

- (void)assignDisplayLanguageCheckMark;
@end

@implementation ALanguageScreenViewController
@synthesize tableViewAdapter;
@synthesize tableView;
@synthesize languageEnglishPanel;
@synthesize languageSimplifiedChinesePanel;
@synthesize checkMarkImgViewSimplifiedChinese;
@synthesize checkMarkImgViewEnglish;

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
    
    [self.tableViewAdapter addView:[ATableViewAdapterView viewWithView:self.languageEnglishPanel target:self action:@selector(actionSelectedEnglish)] forKey:@"languageEnglishPanel" withStyle:ATableViewAdapterPanelStyleGrouped];
    [self.tableViewAdapter addView:[ATableViewAdapterView viewWithView:self.languageSimplifiedChinesePanel target:self action:@selector(actionSelectedSimplifiedChinese)] forKey:@"languageSimplifiedChinesePanel" withStyle:ATableViewAdapterPanelStyleGrouped];
}

- (void)viewDidUnload
{
    [self setLanguageEnglishPanel:nil];
    [self setLanguageSimplifiedChinesePanel:nil];
    [self setCheckMarkImgViewSimplifiedChinese:nil];
    [self setCheckMarkImgViewEnglish:nil];
    [self setTableViewAdapter:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self assignDisplayLanguageCheckMark];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - methods

- (void)assignDisplayLanguageCheckMark
{
    [self.checkMarkImgViewEnglish setImage:nil];//[UIImage imageNamed:@""]];
    [self.checkMarkImgViewSimplifiedChinese setImage:nil];//[UIImage imageNamed:@""]];
    
    NSString *langCode = [ALocale currentLocale].langCode;
    if ([langCode caseInsensitiveCompare:@"en"] == NSOrderedSame) 
    {
        [self.checkMarkImgViewEnglish setImage:[UIImage imageNamed:@"checkMark.png"]];
    }
    else if ([langCode caseInsensitiveCompare:@"zh-Hans"] == NSOrderedSame)
    {
        [self.checkMarkImgViewSimplifiedChinese setImage:[UIImage imageNamed:@"checkMark.png"]];
    }
    else
        [AErrorFacade errorWithDomain:kErrorDomainSetting knownCode:kECLanguageNoLangCode];
}

#pragma mark - actions

- (void)actionSelectedEnglish
{
    [[ALocale currentLocale] changeLanguageTo:@"en"];
    [self assignDisplayLanguageCheckMark];
}

- (void)actionSelectedSimplifiedChinese
{
    [[ALocale currentLocale] changeLanguageTo:@"zh-Hans"];
    [self assignDisplayLanguageCheckMark];
}
@end
