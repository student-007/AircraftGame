//
//  ATableViewAdapter.h
//  Aircraft
//
//  Created by Yufei Lang on 12/31/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@protocol ATableViewAdapterViewDelegate;
@protocol ATableViewAdapterSectionDelegate;

typedef enum
{
    ATableViewAdapterPanelStylePlain,  // appears in header / footer
    ATableViewAdapterPanelStyleGrouped // appears in section
} ATableViewAdapterPanelStyle;

@interface ATableViewAdapter : NSObject<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray  *_panelArrangement;
//    UITableView     *_tableView;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic) UITableViewCellSelectionStyle cellSelectionStyle;

- (id)initWithTableView:(UITableView *)tableView;

- (void)beginUpdates;
- (void)endUpdates;

- (void)addView:(id <ATableViewAdapterViewDelegate>)view forKey:(NSString *)key withStyle:(ATableViewAdapterPanelStyle)style;
- (void)removeView:(NSString *)key;
- (void)removeAllViews;

- (void)addSection:(Class)cellTemplateClass forKey:(NSString *)key withData:(id)dataSource;
- (void)addSection:(Class)cellTemplateClass forKey:(NSString *)key withData:(id)dataSource target:(id)target action:(SEL)selectionAction;

@end

#pragma mark - view protocol/delegate

@protocol ATableViewAdapterViewDelegate <NSObject>

@optional // set target and action if want to trager something when select
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selectionAction;

@required
- (UIView *)getView;

@optional
- (CGRect) getViewFrame;
- (NSString *)getTitle;

@end

#pragma mark - section view protocol/delegate

@protocol ATableViewAdapterSectionDelegate <ATableViewAdapterViewDelegate>

@required
- (void)setData:(id)dataSource forIndex:(NSUInteger)index;

@optional
- (NSUInteger )getIndex;

@end

#pragma mark - view class

@interface ATableViewAdapterView : NSObject<ATableViewAdapterViewDelegate>
{
    // either view or title
    UIView      *_view;
    NSString    *_title;
}
@property (nonatomic, strong) IBOutlet UIView *view;

+ (id)viewWithTitle:(NSString *)title;
+ (id)viewWithView:(UIView *)view;
+ (id)viewWithView:(UIView *)view target:(id)target action:(SEL)selectionAction;
@end

#pragma mark - panel class

@interface  ATableViewAdapterPanel  : NSObject
{

}

@property (nonatomic, strong) id<ATableViewAdapterViewDelegate> view;
@property (nonatomic, assign) ATableViewAdapterPanelStyle style;

@end

#pragma mark - panel section class

@interface  ATableViewAdapterPanelSection  : NSObject
{
    
}

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSMutableArray * headerViews;
@property (nonatomic, strong) NSMutableArray * cellViews;
@property (nonatomic, strong) NSMutableArray * footerViews;

@property (nonatomic, strong) NSMutableArray * headerKeys;
@property (nonatomic, strong) NSMutableArray * cellKeys;
@property (nonatomic, strong) NSMutableArray * footerKeys;

@end
