//
//  IMUserManager.m
//  IMServer
//
//  Created by Mac on 2018/3/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "IMUserManager.h"

/**IMUserManager单例对象*/
static IMUserManager *IM_USER_MANAGER_INSTANCE;

@interface IMUserManager () {
    /**realm数据库路径*/
    NSString *_pathUrl;
    /**主线程创建的realm数据库对象  用来创建数据观察者使用*/
    RLMRealm *_mainThreadRLMRealm;
    /**持有RLMNotificationToken对象，不然创建后就消失了*/
    NSMutableArray<RLMNotificationToken*> *_allNotificationTokenArr;
}
@end

@implementation IMUserManager

#pragma mark -- Init Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        //得到用户对应的数据库路径
        NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        _pathUrl = pathArr[0];
        //imUser是随便写的，因为客户端所有的数据都存在一个数据库，因为登录用户是固定写死的，没有做登录操作
        _pathUrl = [_pathUrl stringByAppendingPathComponent:@"imUser"];
        //创建数据库
        _mainThreadRLMRealm = [RLMRealm realmWithURL:[NSURL URLWithString:_pathUrl]];
        //持有RLMNotificationToken对象
        _allNotificationTokenArr = [@[] mutableCopy];
    }
    return self;
}

#pragma mark -- Class Private Methods

/**
 获得当前调用方所在线程的realm数据库实例
 
 @return realm数据库实例
 */
- (RLMRealm*)currThreadRealmInstance {
    //得到数据库在当前线程中的实例
    RLMRealm *currRealm = [RLMRealm realmWithURL:[NSURL URLWithString:_pathUrl]];
    return currRealm;
}

#pragma mark -- Class Public Methods

#pragma mark -- Function Private Methods

#pragma mark -- Function Public Methods

#pragma mark -- Instance Private Methods

#pragma mark -- Instance Public Methods

+ (instancetype)manager {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        IM_USER_MANAGER_INSTANCE = [[self class] new];
    });
    return IM_USER_MANAGER_INSTANCE;
}

- (void)updateCurrChater:(IMChater*)chater {
    RLMRealm *rlmRealm = [self currThreadRealmInstance];
    [rlmRealm beginWriteTransaction];
    [IMChater createOrUpdateInRealm:rlmRealm withValue:chater];
    self.chater = chater;
    [rlmRealm commitWriteTransaction];
}

- (void)updateChatMessage:(IMChatMesssage*)message {
    RLMRealm *rlmRealm = [self currThreadRealmInstance];
    [rlmRealm beginWriteTransaction];
    [IMChatMesssage createOrUpdateInRealm:rlmRealm withValue:message];
    [rlmRealm commitWriteTransaction];
}

- (NSMutableArray<IMChatMesssage*>*)chatMessagesWithOwnerId:(int64_t)imid {
    NSMutableArray<IMChatMesssage*> *resultArr = [@[] mutableCopy];
    RLMRealm *rlmRealm = [self currThreadRealmInstance];
    RLMResults *results = [IMChatMesssage objectsInRealm:rlmRealm withPredicate:[NSPredicate predicateWithFormat:@"owner_imid = %@",@(imid)]];
    //依次填充所有的用户信息
    for (int index = 0; index < results.count; index ++) {
        //使用deepCopy拷贝一份数据
        [resultArr addObject:[results[index] deepCopy]];
    }
    return resultArr;
}
- (void)addChatMessageChangeListener:(modelChangeHandler)changeHandler {
    //监听数据库中IMChatMesssage表变化，实时通知外部
    RLMNotificationToken *notificationToken = [[IMChatMesssage allObjectsInRealm:_mainThreadRLMRealm] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        changeHandler();
    }];
    [_allNotificationTokenArr addObject:notificationToken];
}

@end
