//
//  UseManager.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "UserManager.h"

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
    if(!self) {
        return nil;
    }
    
    //得到用户对应的数据库路径
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    _pathUrl = pathArr[0];
    //user是随便写的，因为客户端所有的数据都存在一个数据库，因为登录用户是固定写死的，没有做登录操作
    _pathUrl = [_pathUrl stringByAppendingPathComponent:@"user"];
    //创建数据库
    _mainThreadRLMRealm = [RLMRealm realmWithURL:[NSURL URLWithString:_pathUrl]];
    
    //构造假数据
    [self createDefaultUsers];
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
    static UserManager *userManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        userManager = [UserManager new];
    });
    return userManager;
}

- (void)createDefaultUsers {
    //用户应该有10个
    if([self allUsers].count == 10) {
        return;
    }
    
    //伪造体系中的用户User对象
    NSMutableArray<User*> *users = [@[] mutableCopy];
    NSArray<NSString*> *avatars = @[@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2718048146,2060718930&fm=26&gp=0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548308065086&di=3ccbf76a03de8d44df827ba338c7675b&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201512%2F16%2F20151216153355_ZsaCF.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548308065086&di=092b27d65388cabe524df9228f79df97&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201512%2F16%2F20151216153331_5xcjf.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548308065086&di=4465389b82c9da173b16d1077740e3a7&imgtype=0&src=http%3A%2F%2Fwww.zhlzw.com%2FUploadFiles%2FArticle_UploadFiles%2F201210%2F20121004031901967.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548308065086&di=eda648a25cb17d96c37410aa2beb7774&imgtype=0&src=http%3A%2F%2Fpic.sundxs.com%2Fallimg%2F1706%2F37-1F605161G6-50.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548308065085&di=46c1a19554df4cf62810705c8979d7b8&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201512%2F14%2F20151214192347_THMrz.thumb.700_0.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548308065085&di=a15a0a4cafac12f8eefd9352ebda7478&imgtype=0&src=http%3A%2F%2Fwww.zhlzw.com%2Fsj%2FUploadFiles_9645%2F201210%2F2012102918003616.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548308065084&di=0a0c5037dfd38de69c2cc27d1b601649&imgtype=0&src=http%3A%2F%2Fwww.zhlzw.com%2Fsj%2FUploadFiles_9645%2F201210%2F18198067-ccf.jpg",@"http://hot.online.sh.cn/images/attachement/jpeg/site1/20180225/IMGf48e3894467146954814361.jpeg",@"http://pic.90sjimg.com/design/00/58/41/78/58f06c55b0350.png"];
    NSArray<NSString*> *nicks = @[@"张无忌",@"小龙女",@"孙悟空",@"沙悟净",@"唐僧",@"白龙马",@"赵云",@"诸葛亮",@"妲己",@"蔡文姬"];
    assert(nicks.count == avatars.count);
    
    for (int index = 0; index < nicks.count; index ++) {
        User *user = [[User alloc] initWithUid:10000 + index nick:nicks[index] avatar:avatars[index]];
        [users addObject:user];
    }
    //更新
    [self updateUsers:users];
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

