//
//  ChatMineView.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "ChatMineView.h"

@interface ChatMineView () {
    /**滚动视图*/
    UIScrollView *_scrollView;
}

@end

@implementation ChatMineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //配置滚动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height + 0.5);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        //用户头像
        UIImageView *imageView = [UIImageView new];
        imageView.tag = USER_AVATER_IMAGEVIEW_TAG;
        [_scrollView addSubview:imageView];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 50;
        imageView.sd_layout.widthIs(100).heightIs(100).centerXEqualToView(_scrollView).topSpaceToView(_scrollView, 100);
        //用户名字
        UILabel *label = [UILabel new];
        [_scrollView addSubview:label];
        label.tag = USER_NAME_LABEL_TAG;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor blackColor];
        [label setSingleLineAutoResizeWithMaxWidth:0];
        label.sd_layout.autoHeightRatio(0).topSpaceToView(imageView, 50).centerXEqualToView(_scrollView);
    }
    return self;
}

@end
