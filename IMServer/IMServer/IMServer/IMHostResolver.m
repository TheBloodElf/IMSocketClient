//
//  HostResolver.m
//  CMChatSocket
//
//  Created by C.Maverick on 15/7/17.
//  Copyright (c) 2015年 C.Maverick. All rights reserved.
//

#import "IMHostResolver.h"

#if TARGET_OS_IPHONE
    #include <CFNetwork/CFNetwork.h>
#else
    #include <CoreServices/CoreServices.h>
#endif

// We use the BSD-level routines getaddrinfo() and getnameinfo() to convert between strings 
// and numeric addresses in an address format independent way.  These routines came from 
// <netdb.h>, which requires that we include a bunch of other files.
#import <sys/socket.h>
#import <sys/types.h>
#import <netdb.h>

@interface IMHostResolver () {

}

// read/write versions of public properties
@property (nonatomic, copy,   readwrite) NSError *      error;
// private properties
@property (nonatomic, assign, readwrite) CFHostRef      host;
@property (nonatomic, assign, readonly ) CFHostInfoType infoType;
@property (nonatomic, strong, readwrite) NSThread *     runLoopThread;

@end


@implementation IMHostResolver

@synthesize name = _name;
@synthesize address = _address;
@synthesize addressString = _addressString;
@synthesize delegate = _delegate;
@synthesize error = _error;

@synthesize host = _host;
@synthesize runLoopThread = _runLoopThread;


#pragma mark -
#pragma mark - init & dealloc

- (id)initWithName:(NSString *)name; {
    return [self initWithName:name address:nil addressString:nil];
}

- (id)initWithAddress:(NSData *)address {
    return [self initWithName:nil address:address addressString:nil];
}

- (id)initWithAddressString:(NSString *)addressString; {
    return [self initWithName:nil address:nil addressString:addressString];
}


- (id)initWithName:(NSString *)name address:(NSData *)address addressString:(NSString *)addressString {
    CFHostRef   host;
    // One, and only one, of the input parameters must be non-nil.
    assert( ((name != nil) + (address != nil) + (addressString != nil)) == 1 );
    
    // Construct a CFHost from the supplied parameters.
    host = NULL;
    if (name != nil) {
        host = CFHostCreateWithName(NULL, (__bridge CFStringRef) name );
    }
    else {
        if (address == nil) {
            int                 err;
            struct addrinfo     template; 
            struct addrinfo *   result;
            
            assert(addressString != nil);
        
            // Use a BSD-level routine to convert the address string into an address.  It's 
            // important that we specificy AI_NUMERICHOST and AI_NUMERICSERV so that this routine 
            // just does numeric conversion; without that, if addressString was a DNS name, 
            // we would hit the network trying to resolve it, and do that synchronously.
            memset(&template, 0, sizeof(template));
            template.ai_flags = AI_NUMERICHOST | AI_NUMERICSERV;
            err = getaddrinfo([addressString UTF8String], NULL, &template, &result);
            if (err == 0) {
                address = [NSData dataWithBytes:result->ai_addr length:result->ai_addrlen];
                freeaddrinfo(result);
            }
        }
        if (address != nil) {
            host = CFHostCreateWithAddress(NULL, (__bridge CFDataRef) address);
        }
    }

    // Call super and then initialise our state.
    self = [super init];
    if (self != nil) {
        if (host == NULL) {
            self = nil;
        }
        else {
            self->_host = host;
            CFRetain(self->_host);
            self->_name = [name copy];
            self->_address = [address copy];
            self->_addressString = [addressString copy];
        }
    }
    
    // Clean up.
    if (host != NULL) {
        CFRelease(host);
    }
    
    return self;
}

- (void)dealloc {
    if (self->_host != NULL) {
        CFHostSetClient(self->_host, NULL, NULL);
        CFRelease(self->_host);
    }
}


#pragma mark -
#pragma mark - public methods

// See comment in header.
- (void)start {
    Boolean             success;
    CFHostClientContext context = { 0, (__bridge void *) self, NULL, NULL, NULL };
    CFStreamError       streamError;
    NSError *           error;
    
    assert(self.runLoopThread == nil);
    
    success = CFHostSetClient(self.host, HostResolutionCallback, &context);
    if ( ! success ) {
        error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:nil];
    }
    if (error == nil) {
        CFHostScheduleWithRunLoop(self.host, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        success = CFHostStartInfoResolution(self.host, self.infoType, &streamError);
        if ( ! success ) {
            error = [self errorFromStreamError:streamError];
        }
    }
    if (error == nil) {
        self.runLoopThread = [NSThread currentThread];
    } else {
        [self stopWithError:error notify:YES];
    }
}

// See comment in header.
- (void)cancel {
    if (self.runLoopThread != nil) {
        // Call common code to stop the resolve with a user cancelled error.
        [self stopWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil] notify:NO];
    }
}

- (NSArray *)resolvedAddresses {
    NSArray *result;
    Boolean hasBeenResolved;
    
    result = (__bridge NSArray *) CFHostGetAddressing(self.host, &hasBeenResolved);
    if ( ! hasBeenResolved ) {
        result = nil;
    }
    return result;
}

- (NSArray *)resolvedAddressStrings {
    NSMutableArray *result;
    NSArray *addresses;
    
    // Get the resolved addresses and convert each in turn to an address string.
    result = nil;
    addresses = self.resolvedAddresses;
    if (addresses != nil) {
        result = [[NSMutableArray alloc] init];
        for (NSData * address in addresses) {
            int         err;
            char        addrStr[NI_MAXHOST];
            
            assert([address isKindOfClass:[NSData class]]);
            
            err = getnameinfo((const struct sockaddr *) [address bytes], (socklen_t) [address length], addrStr, sizeof(addrStr), NULL, 0, NI_NUMERICHOST);
            if (err == 0) {
                [result addObject:[NSString stringWithUTF8String:addrStr]];
            }
            else {
                result = nil;
                break;
            }
        }
    }
    
    return result;
}

- (NSArray *)resolvedNames {
    NSArray *result;
    Boolean hasBeenResolved;
    
    result = (__bridge NSArray *) CFHostGetNames(self.host, &hasBeenResolved);
    if ( ! hasBeenResolved ) {
        result = nil;
    }
    return result;
}


#pragma mark -
#pragma mark - pravite methods

- (CFHostInfoType)infoType {
    return (self.name != nil) ? kCFHostAddresses : kCFHostNames;
}

/* Convert a CFStreamError to a NSError.  This is less than ideal.  I only handle a
 * limited number of error constant, and I can't use a switch statement because
 * some of the kCFStreamErrorDomainXxx values are not a constant.  Wouldn't it be
 * nice if there was a public API to do this mapping <rdar://problem/5845848>
 * or a CFHost API that used CFError <rdar://problem/6016542>.*/
- (NSError *)errorFromStreamError:(CFStreamError)streamError {
    NSError *       error;
    NSString *      domainStr;
    NSDictionary *  userInfo;
    NSInteger       code;
    
    domainStr = nil;
    userInfo = nil;
    code = streamError.error;
    if (streamError.domain == kCFStreamErrorDomainPOSIX) {
        domainStr = NSPOSIXErrorDomain;
    }
    else if (streamError.domain == kCFStreamErrorDomainMacOSStatus) {
        domainStr = NSOSStatusErrorDomain;
    }
    else if (streamError.domain == kCFStreamErrorDomainNetServices) {
        domainStr = (__bridge NSString *) kCFErrorDomainCFNetwork;
    }
    else if (streamError.domain == kCFStreamErrorDomainNetDB) {
        domainStr = (__bridge NSString *) kCFErrorDomainCFNetwork;
        code = kCFHostErrorUnknown;
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:streamError.error], kCFGetAddrInfoFailureKey, nil];
    }
    else {
        // If it's something we don't understand, we just assume it comes from CFNetwork.
        assert(NO);
        domainStr = (__bridge NSString *) kCFErrorDomainCFNetwork;
    }

    error = [NSError 
        errorWithDomain:domainStr 
        code:code 
        userInfo:userInfo
    ];
    assert(error != nil);

    return error;
}

// A bottleneck for all stopping code.  error is nil if the resolution completed
// successfully, or the error otherwise.  notify is YES if we should tell our
// delegate about the stop.
- (void)stopWithError:(NSError *)error notify:(BOOL)notify {
    // we're now officially stopped
    assert([NSThread currentThread] == self.runLoopThread);
    self.runLoopThread = nil;
    
    // latch the error
    if (self.error == nil) {
        self.error = error;
    }
    
    // shut everything down
    (void) CFHostSetClient(self.host, NULL, NULL);
    CFHostUnscheduleFromRunLoop(self.host, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    CFHostCancelInfoResolution(self.host, self.infoType);
    
    // tell our delegate, if required
    if (notify) {
        if (self.error == nil) {
            if ([self.delegate respondsToSelector:@selector(hostResolverDidFinish:)]) {
                [self.delegate hostResolverDidFinish:self];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(hostResolver:didFailWithError:)]) {
                [self.delegate hostResolver:self didFailWithError:error];
            }
        }
    }
}

// Called by CFHost when the resolution finishes.  The implementation just extracts the
// object pointer from the info parameter and then calls -stopWithError:notify: on that.
static void HostResolutionCallback(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError *error, void *info) {
    IMHostResolver *    obj;
    
    obj = (__bridge IMHostResolver *) info;
    assert([obj isKindOfClass:[IMHostResolver class]]);
    assert(theHost == obj->_host);
    assert(typeInfo == obj.infoType);
    
    if ( (error == NULL) || ( (error->domain == 0) && (error->error == 0) ) ) {
        [obj stopWithError:nil notify:YES];
    }
    else {
        [obj stopWithError:[obj errorFromStreamError:*error] notify:YES];
    }
}



@end
