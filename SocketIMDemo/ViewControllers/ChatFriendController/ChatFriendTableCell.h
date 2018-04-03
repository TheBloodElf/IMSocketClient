//
//  ChatFriendTableCell.h
//  SocketIMDemo
//
//  Created by Mac on 2018/3/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 好友表格视图行
 */
@interface ChatFriendTableCell : UITableViewCell

/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/**名字*/
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end
