//
//  RLMObject+JSON.h
//  RealmJSONDemo
//
//  Created by Matthew Cheok on 27/7/14.
//  Copyright (c) 2014 Matthew Cheok. All rights reserved.
//

#import <Realm/Realm.h>
#import "MCJSONDateTransformer.h"
#import "MCJSONValueTransformer.h"

@interface RLMObject (JSON)

+ (NSArray *)createOrUpdateInRealm:(RLMRealm *)realm withJSONArray:(NSArray *)array;
+ (instancetype)createOrUpdateInRealm:(RLMRealm *)realm withJSONDictionary:(NSDictionary *)dictionary;
+ (instancetype)objectInRealm:(RLMRealm *)realm withPrimaryKeyValue:(id)primaryKeyValue;

- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)JSONDictionary;

- (id)primaryKeyValue;
+ (id)primaryKeyValueFromJSONDictionary:(NSDictionary *)dictionary;

- (void)performInTransaction:(void (^)(void))transaction;
- (void)removeFromRealm;
//值是不是一样
+ (BOOL)values:(RLMObject*)object1 isEqual:(RLMObject*)object2;
+ (BOOL)arrayValues:(NSArray<RLMObject*>*)array1 isEqual:(NSArray<RLMObject*>*)array2;

@end

@interface RLMArray (JSON)

- (NSArray *)NSArray;
- (NSArray *)JSONArray;

@end
