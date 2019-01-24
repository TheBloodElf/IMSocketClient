//
//  PrivateChatController.m
//  SocketIMDemo
//
//  Created by Mac on 2018/3/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PrivateChatController.h"

@interface PrivateChatController () {
    /**自己对应聊天体系中哪个人*/
    IMChater *_ownerChater;
    /**对方的uid*/
    int _targetId;
    /**当前和哪个人在聊天*/
    IMChater *_otherChater;
    
    /**用户模型管理器*/
    UserManager *_userManager;
    /**聊天模型管理器*/
    IMUserManager *_iMUserManager;
    /**聊天发送类*/
    IMUserSocket *_iMUserSocket;
    
    
    /**表格视图*/
    
}

@end

@implementation PrivateChatController

#pragma mark - Init Method

- (instancetype)initWithTargetId:(int)targetId {
    self = [super init];
    if(!self) {
        return nil;
    }

    _targetId = targetId;
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化模型、视图
    [self initModesAndViews];
    //添加点击事件
    [self setViewsClickEvents];
    //设置界面圆角、边框或者其他操作
    [self setViewsRoundLineOrOtherOperation];
    self.navigationItem.title = _otherChater.nick;
}

#pragma mark - Class Method

#pragma mark - Override Method

#pragma mark - Function Method

#pragma mark - Private Method

/**
 初始化模型、视图
 */
- (void)initModesAndViews {
    _userManager = [UserManager manager];
    _iMUserManager = [IMUserManager manager];
    _iMUserSocket = [IMUserSocket socket];
    //获取自己
    _ownerChater = [IMChater new];
    _ownerChater.imid = _userManager.user.uid;
    _ownerChater.avatar = _userManager.user.avatar;
    _ownerChater.nick = _userManager.user.nick;
    //获取当前聊天的人
    for (User *currUser in [_userManager allUsers]) {
        if(currUser.uid != _targetId) {
            continue;
        }
        //赋值
        _otherChater = [IMChater new];
        _otherChater.imid = currUser.uid;
        _otherChater.avatar = currUser.avatar;
        _otherChater.nick = currUser.nick;
        break;
    }
}

/**
 添加点击事件
 */
- (void)setViewsClickEvents {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightClicked:)];
}

/**
 设置界面圆角、边框或者其他操作
 */
- (void)setViewsRoundLineOrOtherOperation {
    
}

- (void)rightClicked:(UIBarButtonItem*)item {
    //弹出输入框，让用户输入内容
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"发送内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入内容";
    }];
    
    
    [self sendTextMessage:@"hello world!"];
}

/**
 发送文本消息
 
 @param message 文本消息内容
 */
- (void)sendTextMessage:(NSString *)message {
    //内容为空 不执行操作
    if([NSString isBlank:message]) {
        return;
    }
    
    //构造聊天消息
    IMChatMesssage *chatMessage = [IMChatMesssage new];
    chatMessage.msg_id = [NSDate new].timeIntervalSince1970 * 1000;
    chatMessage.status = E_CHAT_SEND_STATUS_SENDING;
    chatMessage.time = [NSDate new].timeIntervalSince1970 * 1000;
    chatMessage.show_time = NO;
    chatMessage.sender = _ownerChater;
    chatMessage.reciver = _otherChater;
    //构造消息内容
    IMChatMessageContent *chatMessageContent = [IMChatMessageContent new];
    chatMessageContent.type = E_CHAT_CONTENT_TYPE_TEXT;
    chatMessageContent.text = message;
    chatMessage.content = chatMessageContent;
    
    //把消息放进数据库
    [_iMUserManager updateChatMessage:chatMessage];
    //开始向服务器发送数据
    [_iMUserSocket sendChatMessage:chatMessage];
}

#pragma mark - Public Method

@end
