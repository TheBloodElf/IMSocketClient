//
//  PrivateChatController.m
//  SocketIMDemo
//
//  Created by Mac on 2018/3/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PrivateChatController.h"

//Views
#import "OtherTextChatCell.h"
#import "OwnerTextChatCell.h"

@interface PrivateChatController ()<UITableViewDelegate,UITableViewDataSource> {
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
    UITableView *_tableView;
    /**数据源*/
    NSArray<IMChatMesssage*> *_chatMessages;
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
    //消息变化了，重新获取
    __weak typeof(self) weakSelf = self;
    [_iMUserManager addChatMessageChangeListener:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf chatMessageChange];
    }];
}

#pragma mark - Class Method

#pragma mark - Override Method

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _chatMessages ? _chatMessages.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = nil;
    
    //获取具体的消息
    IMChatMesssage *chatMessage = _chatMessages[indexPath.row];
    //文本消息
    if(chatMessage.content.type == E_CHAT_CONTENT_TYPE_TEXT) {
        tableViewCell = [tableView dequeueReusableCellWithIdentifier:(chatMessage.sender.imid == _ownerChater.imid) ? @"OwnerTextChatCell" : @"OtherTextChatCell" forIndexPath:indexPath];
    }
    tableViewCell.data = chatMessage;
    
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Function Method

#pragma mark - Private Method

/**
 初始化模型、视图
 */
- (void)initModesAndViews {
    _userManager = [UserManager manager];
    _iMUserManager = [IMUserManager manager];
    _iMUserSocket = [IMUserSocket socket];
    _chatMessages = @[];
    //获取自己
    _ownerChater = _iMUserManager.chater;
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
    
    //表格视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.tableHeaderView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //使用自动计算高度
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView registerNib:[UINib nibWithNibName:@"OtherTextChatCell" bundle:nil] forCellReuseIdentifier:@"OtherTextChatCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OwnerTextChatCell" bundle:nil] forCellReuseIdentifier:@"OwnerTextChatCell"];
    [self.view addSubview:_tableView];
}

/**
 添加点击事件
 */
- (void)setViewsClickEvents {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightClicked:)];
}

/**
 设置界面圆角、边框或者其他操作
 */
- (void)setViewsRoundLineOrOtherOperation {
    
}

/**
 聊天内容改变了，需要重新获取当前的所有消息
 */
- (void)chatMessageChange {
    //本地获取自己和他的所有聊天消息
    NSMutableArray<IMChatMesssage*> *chatMessages = [_iMUserManager chatMessageWith:_otherChater.imid];
    _chatMessages = [chatMessages copy];
    [_tableView reloadData];
}

- (void)rightClicked:(UIBarButtonItem*)item {
    //弹出输入框，让用户输入内容
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"发送内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __block __weak UITextField *weakTextField = nil;
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        weakTextField = textField;
        textField.placeholder = @"输入内容";
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sendTextMessage:weakTextField.text];
    }];
    UIAlertAction *canAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [okAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [canAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [alertVC addAction:okAction];
    [alertVC addAction:canAction];
    [self presentViewController:alertVC animated:YES completion:nil];
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
    chatMessage.time = [NSDate new].timeIntervalSince1970;
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
