//
//  UseManager.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "UserManager.h"

/**UserManager单例对象*/
static UserManager *USER_MANAGER_INSTANCE;

@interface UserManager () {
    /**realm数据库路径*/
    NSString *_pathUrl;
    /**主线程创建的realm数据库对象  用来创建数据观察者使用*/
    RLMRealm *_mainThreadRLMRealm;
}

@end

@implementation UserManager

#pragma mark -- Init Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        //得到用户对应的数据库路径
        NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        _pathUrl = pathArr[0];
        //user是随便写的，因为客户端所有的数据都存在一个数据库，因为登录用户是固定写死的，没有做登录操作
        _pathUrl = [_pathUrl stringByAppendingPathComponent:@"user"];
        //创建数据库
        _mainThreadRLMRealm = [RLMRealm realmWithURL:[NSURL URLWithString:_pathUrl]];
    }
    return self;
}

#pragma mark -- Function Methods

#pragma mark -- Private Methods

/**
 获得当前调用方所在线程的realm数据库实例
 
 @return realm数据库实例
 */
- (RLMRealm*)currThreadRealmInstance {
    //得到数据库在当前线程中的实例
    RLMRealm *currRealm = [RLMRealm realmWithURL:[NSURL URLWithString:_pathUrl]];
    return currRealm;
}

#pragma mark -- Public Methods

+ (instancetype)manager {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        USER_MANAGER_INSTANCE = [[self class] new];
    });
    return USER_MANAGER_INSTANCE;
}

- (void)updateCurrUser:(User*)user {
    RLMRealm *rlmRealm = [self currThreadRealmInstance];
    [rlmRealm beginWriteTransaction];
    [User createOrUpdateInRealm:rlmRealm withValue:user];
    self.user = user;
    [rlmRealm commitWriteTransaction];
}

- (void)updateUsers:(NSMutableArray<User*>*)users {
    RLMRealm *rlmRealm = [self currThreadRealmInstance];
    [rlmRealm beginWriteTransaction];
    //先删除当前所有的用户
    RLMResults *results = [User objectsInRealm:rlmRealm withPredicate:nil];
    while (results.count) {
        [rlmRealm deleteObject:results.firstObject];
    }
    //再添加新用户
    for (User *user in users) {
        [User createOrUpdateInRealm:rlmRealm withValue:user];
    }
    [rlmRealm commitWriteTransaction];
}

- (NSMutableArray<User*>*)allUsers {
    NSMutableArray<User*> *allUsers = [@[] mutableCopy];
    RLMRealm *rlmRealm = [self currThreadRealmInstance];
    RLMResults *results = [User objectsInRealm:rlmRealm withPredicate:nil];
    //依次填充所有的用户信息
    for (int index = 0; index < results.count; index ++) {
        //使用deepCopy拷贝一份数据
        [allUsers addObject:[results[index] deepCopy]];
    }
    return allUsers;
}

@end

