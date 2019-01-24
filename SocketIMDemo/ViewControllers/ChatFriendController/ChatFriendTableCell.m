//
//  ChatFriendTableCell.m
//  SocketIMDemo
//
//  Created by Mac on 2018/3/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ChatFriendTableCell.h"

@interface ChatFriendTableCell ()

/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/**名字*/
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation ChatFriendTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatarImageView.layer.cornerRadius = 25;
    _avatarImageView.clipsToBounds = YES;
    _userName.textColor = [UIColor colorFromHexCode:@"#333333"];
}

- (void)dataDidChange {
    User *user = self.data;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"default_image_icon"]];
    _userName.text = user.nick;
}

@end
