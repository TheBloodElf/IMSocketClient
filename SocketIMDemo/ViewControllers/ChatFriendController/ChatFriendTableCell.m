//
//  ChatFriendTableCell.m
//  SocketIMDemo
//
//  Created by Mac on 2018/3/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ChatFriendTableCell.h"

@implementation ChatFriendTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatarImageView.layer.cornerRadius = 25;
    _avatarImageView.clipsToBounds = YES;
    _userName.textColor = [UIColor colorFromHexCode:@"#333333"];
}

@end
