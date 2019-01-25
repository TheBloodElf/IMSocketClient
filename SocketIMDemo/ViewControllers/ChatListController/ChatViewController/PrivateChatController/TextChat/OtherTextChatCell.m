//
//  OtherTextChatCell.m
//  SocketIMDemo
//
//  Created by Mac on 2019/1/25.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "OtherTextChatCell.h"

@interface OtherTextChatCell ()

/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *avaterImage;
/**内容*/
@property (weak, nonatomic) IBOutlet UITextView *messageText;
/**发送失败按钮*/
@property (weak, nonatomic) IBOutlet UIButton *failButton;
/**正在发送*/
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadActity;

@end

@implementation OtherTextChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avaterImage.layer.cornerRadius = 20;
    _avaterImage.clipsToBounds = YES;
    [_failButton addTarget:self action:@selector(failButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)failButtonClick:(UIButton*)bnutton {
    if(self.delegate && [self.delegate respondsToSelector:@selector(resendChatMessage:)]) {
        [self.delegate resendChatMessage:self.data];
    }
}

- (void)dataDidChange {
    _loadActity.hidden = YES;
    [_loadActity stopAnimating];
    _failButton.hidden = YES;
    
    IMChatMesssage *chatMessage = self.data;
    [_avaterImage sd_setImageWithURL:[NSURL URLWithString:chatMessage.sender.avatar] placeholderImage:[UIImage imageNamed:@"default_image_icon"]];
    _messageText.text = chatMessage.content.text;
    //正在发送
    if(chatMessage.status == E_CHAT_SEND_STATUS_SENDING) {
        _loadActity.hidden = NO;
        [_loadActity startAnimating];
    }
    //发送失败
    if(chatMessage.status == E_CHAT_SEND_STATUS_SENDFIAL) {
        _failButton.hidden = NO;
    }
}

@end
