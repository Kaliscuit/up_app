//
//  UPProfileTimelineView.m
//  up
//
//  Created by joy.long on 13-12-12.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPProfileTimelineView.h"
#import "UPTimeLineTableViewCell.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
@interface UPProfileTimelineView()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
}

@end
@implementation UPProfileTimelineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:BaseLightBackgroundColor];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BaseLightBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UPTimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLineCell"];
    if (cell == nil) {
        cell = [[UPTimeLineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimeLineCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.leftDateLabel.text = @"周三";
    cell.leftTimeLabel.text = @"15:30";
    if (indexPath.row > 0) {
        cell.smallImage.alpha = 0.5f;
    }

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"正在学习Ruby初级教程"];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:kCTUnderlineStyleSingle],NSUnderlineStyleAttributeName,
                                RGBCOLOR(46.0f, 204.0f, 113.0f),NSUnderlineColorAttributeName, nil];
    [str addAttributes:attributes range:NSMakeRange(4, str.length - 4)];
    [cell.rightContentLabel setAttributedText:str];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}
@end
