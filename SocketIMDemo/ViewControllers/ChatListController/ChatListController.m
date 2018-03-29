//
//  ChatListController.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "ChatListController.h"
#import "YJNChatInputBar.h"

@interface ChatListController ()

@end

@implementation ChatListController

#pragma mark -- Init Methods

- (instancetype)init {
    if(self = [super init]) {
        self.navigationItem.title = @"会话";
    }
    return self;
}

#pragma mark -- Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    CGFloat chatbarHeight = [YJNChatInputBar defaultHeight];
    YJNChatInputBar *inputBar = [[YJNChatInputBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight - 49 - 64, self.view.frame.size.width, chatbarHeight)];
    inputBar.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:inputBar];
}

#pragma mark -- Class Private Methods

#pragma mark -- Class Public Methods

#pragma mark -- Function Private Methods

#pragma mark -- Function Public Methods

#pragma mark -- Instance Private Methods

#pragma mark -- Instance Public Methods

@end
