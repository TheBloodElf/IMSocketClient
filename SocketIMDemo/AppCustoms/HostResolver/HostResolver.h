//
//  CMHostResolver.h
//  CMChatSocket
//
//  Created by C.Maverick on 15/7/17.
//  Copyright (c) 2015年 C.Maverick. All rights reserved.
//


/*
 You can use the object to map from a DNS name to a set of addresses or from a
 address to a set of DNS names.  To do this:
 
 1. create the QCFHostResolver object with the info you have
 
 2. set a delegate
 
 3. call -start
 
 4. wait for -hostResolverDidFinish: to be called
 
 5. extract the information you need from the resolvedXxx properties
 */


#import <Foundation/Foundation.h>

@protocol HostResolverDelegate;
/**
 域名、ip解析，并没有缓存到本地，而是启动应用都重新解析，因为dns服务器缓存时间无法固定
 */
@interface HostResolver : NSObject {

}

// Initialise the object for name-to-address translation.
- (id)initWithName:(NSString *)name;
// Initialise the object for address-to-name translation based on a (struct sockaddr)
// embedded in an NSData object.
- (id)initWithAddress:(NSData *)address;
// Initialise the object for address-to-name translation based on an address string.
- (id)initWithAddressString:(NSString *)addressString;

// properties set up by the various -init routines
@property (nonatomic, copy,   readonly ) NSString * name;
@property (nonatomic, copy,   readonly ) NSData   * address;
@property (nonatomic, copy,   readonly ) NSString * addressString;

// properties you can set at any time
@property (nonatomic, weak,   readwrite) id<HostResolverDelegate> delegate;

// Starts the resolution process.
// It's not safe to call this is if the resolve is running.
- (void)start;
// Cancels a resolve.  It's safe to call this redundantly.
- (void)cancel;

// properties that are set when resolution completes
@property (nonatomic, copy,   readonly ) NSError *  error;
@property (nonatomic, copy,   readonly ) NSArray *  resolvedAddresses;      // of NSData, containing (struct sockaddr)
@property (nonatomic, copy,   readonly ) NSArray *  resolvedAddressStrings; // of NSString
@property (nonatomic, copy,   readonly ) NSArray *  resolvedNames;          // of NSString

@end

@protocol HostResolverDelegate <NSObject>

@optional
// Called when resolution completes succesfully.  Either the resolvedAddress[es|Strings]
// or the resolvedNames properties will contain meaningful results depending on whether
// the object was initialised for name-to-address or address-to-name translation.
- (void)hostResolverDidFinish:(HostResolver *)resolver;
// Called when resolution fails.  The error parameter reflects the value in the error
// property
- (void)hostResolver:(HostResolver *)resolver didFailWithError:(NSError *)error;

@end
