//
//  ATableViewAdapter.m
//  Aircraft
//
//  Created by Yufei Lang on 12/31/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "ATableViewAdapter.h"


#pragma mark - view class

@interface ATableViewAdapterView ()
@property (nonatomic, strong) NSString  *title;
@end

@implementation ATableViewAdapterView

@synthesize target = _target;
@synthesize selectionAction = _selectionAction;
@synthesize title = _title;
@synthesize view = _view;

+ (id)viewWithTitle:(NSString *)title
{
    ATableViewAdapterView *adapterView = [[ATableViewAdapterView alloc] init];
    adapterView.title = title;
    adapterView.target = nil;
    adapterView.selectionAction = nil;
    return adapterView;
    
}
+ (id)viewWithView:(UIView *)view
{
    ATableViewAdapterView *adapterView = [[ATableViewAdapterView alloc] init];
    adapterView.view = view;
    adapterView.target = nil;
    adapterView.selectionAction = nil;
    return adapterView;
}

+ (id)viewWithView:(UIView *)view target:(id)target action:(SEL)selectionAction
{
    ATableViewAdapterView *adapterView = [ATableViewAdapterView viewWithView:view];
    adapterView.target = target;
    adapterView.selectionAction = selectionAction;
    return adapterView;
}

- (UIView *)getView
{
    return _view;
}

- (NSString *)getTitle
{
    return _title;
}

@end

#pragma mark - panel class

@interface  ATableViewAdapterPanel()

+ (id)panelWithView:(id <ATableViewAdapterViewDelegate>)view style:(ATableViewAdapterPanelStyle)style;

@end

@implementation ATableViewAdapterPanel

@synthesize view = _view;
@synthesize style = _style;

+ (id)panelWithView:(id <ATableViewAdapterViewDelegate>)view style:(ATableViewAdapterPanelStyle)style
{
    ATableViewAdapterPanel *panel = [[ATableViewAdapterPanel alloc] init];
    panel.view = view;
    panel.style = style;
    return panel;
}

@end

#pragma mark - panel section class

@implementation ATableViewAdapterPanelSection

@synthesize key = _key;
@synthesize headerViews = _headerViews;
@synthesize headerKeys = _headerKeys;
@synthesize cellViews = _cellViews;
@synthesize cellKeys = _cellKeys;
@synthesize footerKeys = _footerKeys;
@synthesize footerViews = _footerViews;

- (NSMutableArray *)headerViews
{
    if (nil == _headerViews)
    {
        _headerViews = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _headerViews;
}

- (NSMutableArray *)cellViews
{
    if (nil == _cellViews)
    {
        _cellViews = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _cellViews;
}

- (NSMutableArray *)footerViews
{
    if (nil == _footerViews)
    {
        _footerViews = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _footerViews;
}

- (NSMutableArray *)headerKeys
{
    if (nil == _headerKeys)
    {
        _headerKeys = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _headerKeys;
}

- (NSMutableArray *)cellKeys
{
    if (nil == _cellKeys)
    {
        _cellKeys = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _cellKeys;
}

- (NSMutableArray *)footerKeys
{
    if (nil == _footerKeys)
    {
        _footerKeys = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _footerKeys;
}

@end

#pragma mark - adapter class

@implementation ATableViewAdapter

@synthesize tableView = _tableView;
@synthesize cellSelectionStyle = _cellSelectionStyle;

#define kAdapterDefaultSize 4

- (void)initialise
{
    _panelArrangement = [[NSMutableArray alloc]initWithCapacity:kAdapterDefaultSize];
    _cellSelectionStyle = UITableViewCellSelectionStyleGray;
}

- (void)beginUpdates
{
    
}

- (void)endUpdates
{
    
}

- (id)initWithTableView:(UITableView *)tableView
{
    self = [self init];
    if (self)
    {
        self.tableView = tableView;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initialise];
    }
    return self;
}

- (void)removeAllViews
{
    
    NSRange indexRange = NSMakeRange(0, [_panelArrangement count]);
    
    if ([_panelArrangement count] > 0)
    {
        [_panelArrangement removeAllObjects];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:indexRange] withRowAnimation:UITableViewRowAnimationBottom];
    }
}



- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    _tableView.delegate      = self;
    _tableView.dataSource    = self;
}

#define kPanelPosNone       0
#define kPanelPosHeader     1
#define kPanelPosCells      2
#define kPanelPosFooter     3
#define kPanelPosSection    4

- (BOOL)findPanel:(NSString *)key returnIndexOfSection:(NSUInteger *)idxSection returnIndex:(NSUInteger *)idxPos
{
    BOOL returnPos = kPanelPosNone;
    NSUInteger sectionIdx = NSNotFound;
    NSUInteger posIdx = NSNotFound;
    
    for (sectionIdx = 0; sectionIdx < [_panelArrangement count]; sectionIdx++)
    {
        ATableViewAdapterPanelSection *section = [_panelArrangement objectAtIndex:sectionIdx];
        if ([section.key isEqualToString:key])
        {
            returnPos   = kPanelPosSection;
            break;
        }
        
        posIdx = [section.headerKeys indexOfObject:key];
        if (NSNotFound != posIdx)
        {
            returnPos   = kPanelPosHeader;
            break;
        }
        
        posIdx = [section.cellKeys indexOfObject:key];
        if (NSNotFound != posIdx)
        {
            returnPos = kPanelPosCells;
            break;
        }
        
        posIdx = [section.footerKeys indexOfObject:key];
        if (NSNotFound != posIdx)
        {
            returnPos = kPanelPosFooter;
            break;
        }
    }
    
    if (sectionIdx < [_panelArrangement count])
    {
        if (kPanelPosNone != returnPos)
        {
            *idxPos     = posIdx;
        }
        
        *idxSection = sectionIdx;
    }
    
    return returnPos;
}


- (void)addView:(id <ATableViewAdapterViewDelegate>)view forKey:(NSString *)key withStyle:(ATableViewAdapterPanelStyle)style
{
    ATableViewAdapterPanel *panel = [ATableViewAdapterPanel panelWithView:view style:style];
    
    NSUInteger sectionIdx = 0, pos = 0;
    int found = [self findPanel:key returnIndexOfSection:&sectionIdx returnIndex:&pos];
    
    if (kPanelPosNone != found && kPanelPosSection != found)
    {
        ATableViewAdapterPanelSection *section = [_panelArrangement objectAtIndex:sectionIdx];
        
        if (kPanelPosHeader == found)
        {
            [section.headerViews replaceObjectAtIndex:pos withObject:panel];
            [section.headerKeys replaceObjectAtIndex:pos withObject:key];
        }
        else if (kPanelPosCells == found)
        {
            [section.cellViews replaceObjectAtIndex:pos withObject:panel];
            [section.cellKeys replaceObjectAtIndex:pos withObject:key];
        }
        else //if (kPanelPosFooter == found)
        {
            [section.footerViews replaceObjectAtIndex:pos withObject:panel];
            [section.footerKeys replaceObjectAtIndex:pos withObject:key];
        }
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:pos inSection:sectionIdx]] withRowAnimation:UITableViewRowAnimationBottom];
    }
    else
    {
        if (kPanelPosSection == found)
        {
            [_panelArrangement removeObjectAtIndex:sectionIdx];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIdx] withRowAnimation:UITableViewRowAnimationBottom];
        }
        
        ATableViewAdapterPanelSection *section = nil;
        
        sectionIdx = 0;
        int panelPos = kPanelPosNone;
        NSUInteger idx = 0;
        BOOL isNewSection = NO;
        
        if ([_panelArrangement count])
        {
            sectionIdx  = [_panelArrangement count] - 1;
            section     = [_panelArrangement objectAtIndex:sectionIdx];
        }
        else
        {
            section = [[ATableViewAdapterPanelSection alloc]init];
            [_panelArrangement addObject:section];
            isNewSection = YES;
        }
        
        if (self.tableView.style == UITableViewStylePlain)
        {
            // table is plain add to the cell
            [section.cellViews addObject:panel];
            [section.cellKeys addObject:key];
            panelPos = kPanelPosCells;
            idx = [section.cellViews count] - 1;
        }
        else
        {
            if (ATableViewAdapterPanelStylePlain == style)
            {
                if ([section.cellKeys count])
                {
                    [section.footerViews addObject:panel];
                    [section.footerKeys addObject:key];
                    panelPos = kPanelPosFooter;
                }
                else
                {
                    [section.headerViews addObject:panel];
                    [section.headerKeys addObject:key];
                    panelPos = kPanelPosHeader;
                }
            }
            else //WUTableViewAdapterPanelStyleGrouped
            {
                if ([section.footerViews count])
                {
                    // add a new section
                    ATableViewAdapterPanelSection *sectionNew = [[ATableViewAdapterPanelSection alloc]init];
                    [sectionNew.cellViews addObject:panel];
                    [sectionNew.cellKeys addObject:key];
                    
                    [_panelArrangement addObject:sectionNew];
                    isNewSection = YES;
                    panelPos = kPanelPosCells;
                    sectionIdx++;
                    idx = 0;
                    
                }
                else
                {
                    // no footers add to section
                    [section.cellViews addObject:panel];
                    [section.cellKeys addObject:key];
                    panelPos = kPanelPosCells;
                    idx = [section.cellViews count] - 1;
                }
            }
        }
        
        if (isNewSection)
        {
            [self.tableView insertSections:[NSIndexSet  indexSetWithIndex:sectionIdx] withRowAnimation:(UITableViewRowAnimationBottom)];
        }
        else
        {
            if (kPanelPosCells == panelPos)
            {
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:idx inSection:sectionIdx]] withRowAnimation:UITableViewRowAnimationBottom];
            }
            else
            {
                [self.tableView reloadSections:[NSIndexSet  indexSetWithIndex:sectionIdx] withRowAnimation:UITableViewRowAnimationBottom];
            }
        }
        
        // [self.tableView reloadData];
    }
}

- (void)removeView:(NSString *)key
{
    
    NSUInteger sectionIdx = 0, pos = 0;
    int found = [self findPanel:key returnIndexOfSection:&sectionIdx returnIndex:&pos];
    if (kPanelPosNone != found)
    {
        
        if (kPanelPosSection == found)
        {
            [_panelArrangement removeObjectAtIndex:sectionIdx];
            [self.tableView deleteSections:[NSIndexSet  indexSetWithIndex:sectionIdx] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else
        {
            ATableViewAdapterPanelSection *section = [_panelArrangement objectAtIndex:sectionIdx];
            
            if (kPanelPosCells == found)
            {
                [section.cellViews removeObjectAtIndex:pos];
                [section.cellKeys removeObjectAtIndex:pos];
                
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:pos inSection:sectionIdx]] withRowAnimation:UITableViewRowAnimationBottom];
            }
            else
            {
                if (kPanelPosHeader == found)
                {
                    [section.headerViews removeObjectAtIndex:pos];
                    [section.headerKeys removeObjectAtIndex:pos];
                }
                else //if (kPanelPosFooter == found)
                {
                    [section.footerViews removeObjectAtIndex:pos];
                    [section.footerKeys removeObjectAtIndex:pos];
                }
            }
            
            if ([section.cellKeys count] == 0 && [section.headerKeys count] == 0 && [section.footerKeys count] == 0)
            {
                [_panelArrangement removeObjectAtIndex:sectionIdx];
                [self.tableView deleteSections:[NSIndexSet  indexSetWithIndex:sectionIdx] withRowAnimation:UITableViewRowAnimationBottom];
            }
            else if (kPanelPosHeader == found)
            {
                [self.tableView reloadSections:[NSIndexSet  indexSetWithIndex:sectionIdx] withRowAnimation:UITableViewRowAnimationBottom];
            }
        }
    }
    
}



- (void)addSection:(Class)cellTemplateClass forKey:(NSString *)key withData:(id) dataSource target:(id)target action:(SEL)selectionAction
{
    ATableViewAdapterPanelSection *section = nil;
    if ([(NSArray *)dataSource count])
    {
        section = [[ATableViewAdapterPanelSection alloc]init];
        section.key = key;
        
        int idx = 0;
        
        while (idx < [(NSArray *)dataSource count])
        {
            ATableViewAdapterPanel *panel = nil;
            id data = [dataSource objectAtIndex:idx];
            
            if (nil != cellTemplateClass)
            {
                id object = [[cellTemplateClass alloc] init];
                if ([object conformsToProtocol:@protocol(ATableViewAdapterSectionDelegate)])
                {
                    id <ATableViewAdapterSectionDelegate> sectionItem =  (id <ATableViewAdapterSectionDelegate>)object;
                    [sectionItem setData:dataSource forIndex:idx];
                    sectionItem.target = target;
                    sectionItem.selectionAction = selectionAction;
                    
                    panel = [ATableViewAdapterPanel panelWithView:sectionItem style:ATableViewAdapterPanelStyleGrouped];
                }
            }
            if (nil == panel)
            {
                ATableViewAdapterView *sectionItem =  [ATableViewAdapterView viewWithTitle:[data description]];
                sectionItem.target = target;
                sectionItem.selectionAction = selectionAction;
                
                panel = [ATableViewAdapterPanel panelWithView:sectionItem style:ATableViewAdapterPanelStylePlain];
            }
            
            [section.cellViews addObject:panel];
            [section.cellKeys addObject:[NSString stringWithFormat:@"%@:%x", key, (uint)panel]];
            
            idx++;
        }
        
        [_panelArrangement addObject:section];
        
        [self.tableView insertSections:[NSIndexSet  indexSetWithIndex:([_panelArrangement count] - 1)] withRowAnimation:(UITableViewRowAnimationBottom)];
    }
}


- (void)addSection:(Class)cellTemplateClass forKey:(NSString *)key withData:(id)dataSource
{
    [self addSection:cellTemplateClass forKey:key withData:dataSource target:nil action:nil];
}


#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIdx
{
    ATableViewAdapterPanelSection *section = [_panelArrangement objectAtIndex:sectionIdx];
    return [section.cellKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATableViewAdapterPanelSection *section = [_panelArrangement objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adapterCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"adapterCell"];
    }
    
//    cell.backgroundColor = [UIColor clearColor];
//    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    // remove the previously attached views
    while ([cell.contentView.subviews count])
    {
        [[cell.contentView.subviews objectAtIndex:0] removeFromSuperview];
    }
    
    // attach the view
    ATableViewAdapterPanel *panel = [section.cellViews objectAtIndex:indexPath.row];
    if (panel)
    {
        UIView *view  = nil;
        if ([panel.view respondsToSelector:@selector(getView)])
        {
            view = [panel.view getView];
        }
        
        if (view)
        {
            [cell.contentView addSubview:view];
        }
        else
        {
            if ([panel.view respondsToSelector:@selector(getTitle)])
            {
                cell.textLabel.text = [panel.view getTitle];
            }
            else
            {
                NSAssert(NO, @"[error]: You have to provde either a title(getTitle method) or a view(getView) in order to use table view adapter.");
            }
        }
        
        if (nil == panel.view.target || nil == panel.view.selectionAction)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_panelArrangement count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}


#pragma mark - UITableViewDelegate

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATableViewAdapterPanelSection *panelSection = [_panelArrangement objectAtIndex:indexPath.section];
    if ([panelSection.cellViews count])
    {
        ATableViewAdapterPanel *panel = [panelSection.cellViews objectAtIndex:indexPath.row];
        if ([panel.view respondsToSelector:@selector(getViewFrame)])
        {
            return [panel.view getViewFrame].size.height;
        }
        else
        {
            UIView *view = [panel.view getView];
            return view ? view.frame.size.height : tableView.rowHeight;
        }
    }
    
    return tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSUInteger height = 0;
    
    ATableViewAdapterPanelSection *panelSection = [_panelArrangement objectAtIndex:section];
    if ([panelSection.headerViews count])
    {
        
        for(ATableViewAdapterPanel *panel in panelSection.headerViews)
        {
            if ([panel.view respondsToSelector:@selector(getViewFrame)])
            {
                CGRect frame = [panel.view getViewFrame];
                height = frame.size.height;
            }
            else
            {
                UIView *view = [panel.view getView];
                if (view)
                {
                    CGRect frame = view.frame;
                    frame.origin.y = height;
                    view.frame = frame;
                    
                    height += view.bounds.size.height;
                }
            }
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSUInteger height = 0;
    ATableViewAdapterPanelSection *panelSection = [_panelArrangement objectAtIndex:section];
    if ([panelSection.footerViews count])
    {
        for(ATableViewAdapterPanel *panel in panelSection.footerViews)
        {
            if ([panel.view respondsToSelector:@selector(getViewFrame)])
            {
                CGRect frame = [panel.view getViewFrame];
                height = frame.size.height;
            }
            else
            {
                UIView *view = [panel.view getView];
                if (view)
                {
                    CGRect frame = view.frame;
                    frame.origin.y = height;
                    view.frame = frame;
                    
                    height += view.bounds.size.height;
                }
            }
        }
    }
    return height;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSUInteger height = 0;
    
    ATableViewAdapterPanelSection *panelSection = [_panelArrangement objectAtIndex:section];
    if ([panelSection.headerViews count])
    {
        UIView *viewHolder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        viewHolder.autoresizesSubviews = NO;
        
        for(ATableViewAdapterPanel *panel in panelSection.headerViews)
        {
            UIView *view = [panel.view getView];
            if (view)
            {
                CGRect frame = view.frame;
                frame.origin.y = height;
                view.frame = frame;
                
                [viewHolder addSubview:view];
                height += view.bounds.size.height;
            }
        }
        
        viewHolder.frame = CGRectMake(0, 0, 320, height);
        
        return viewHolder;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSUInteger height = 0;
    
    ATableViewAdapterPanelSection *panelSection = [_panelArrangement objectAtIndex:section];
    if ([panelSection.footerViews count])
    {
        UIView *viewHolder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        
        for(ATableViewAdapterPanel *panel in panelSection.footerViews)
        {
            UIView *view = [panel.view getView];
            if (view)
            {
                CGRect frame = view.frame;
                frame.origin.y = height;
                view.frame = frame;
                
                [viewHolder addSubview:view];
                height += view.bounds.size.height;
            }
        }
        
        viewHolder.frame = CGRectMake(0, 0, 320, height);
        
        return viewHolder;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ATableViewAdapterPanelSection *section = [_panelArrangement objectAtIndex:indexPath.section];
    
    // attach the view
    ATableViewAdapterPanel *panel = [section.cellViews objectAtIndex:indexPath.row];
    if (panel)
    {
        if(panel.view.selectionAction)
        {
            // "use perform selector may cause a leak", that was the warning being given.
            // need to test that, but disable the warning for now.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [panel.view.target performSelector:panel.view.selectionAction withObject:panel.view];
#pragma clang diagnostic pop
        }
    }
}


@end

