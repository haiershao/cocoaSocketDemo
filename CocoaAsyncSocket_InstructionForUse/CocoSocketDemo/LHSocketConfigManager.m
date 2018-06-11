//
//  LHSocketConfigManager.m
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/23.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "LHSocketConfigManager.h"
@interface LHSocketConfigManager (){
    
}

@property(nonatomic,readwrite)NSString * ip;
@property(nonatomic,readwrite)uint16_t port;
@property(nonatomic,readwrite)NSTimeInterval timeout;
@property(nonatomic,readwrite)float pingTimeInterval;
@property(nonatomic,readwrite)int reconnectTime;
@property(nonatomic,readwrite)float reconnectTimeInterval;
@end

static LHSocketConfigManager *_socketConfigManager = nil;
@implementation LHSocketConfigManager

+ (instancetype)ConfigWithSocketIp:(NSString*)ip port:(uint16_t)port{
    return [self ConfigWithSocketIp:ip port:port timeout:LH_Socket_Timeout pingTimeInterval:LH_Socket_PingTimeInterval reconnectTime:LH_Socket_ReconnectTime reconnectTimeInterval:LH_Socket_ReconnectTimeInterval];
}

+ (instancetype)ConfigWithSocketIp:(NSString*)ip port:(uint16_t)port timeout:(NSTimeInterval)timeout{
    return [self ConfigWithSocketIp:ip port:port timeout:timeout pingTimeInterval:LH_Socket_PingTimeInterval reconnectTime:LH_Socket_ReconnectTime reconnectTimeInterval:LH_Socket_ReconnectTimeInterval];
}

+ (instancetype)ConfigWithSocketIp:(NSString*)ip port:(uint16_t)port timeout:(NSTimeInterval)timeout pingTimeInterval:(float)pingTimeInterval reconnectTime:(int)reconnectTime reconnectTimeInterval:(float)reconnectTimeInterval{
    if(![self p_checkStringVaildWithStr:ip]){
        return nil;
    }
    if(!port || port <= 0){
        return nil;
    }
    if(timeout <= 0){
        return nil;
    }
    if(pingTimeInterval <= 0){
        return nil;
    }
    if(reconnectTime < 0){
        return nil;
    }
    if(reconnectTimeInterval < 0){
        return nil;
    }
    if(_socketConfigManager){
        return _socketConfigManager;
    }else{
        LHSocketConfigManager *configM = [[self alloc]init];
        if(!configM.ip){
            configM.ip = ip;
            configM.port = port;
            configM.timeout = timeout;
            configM.pingTimeInterval = pingTimeInterval;
            configM.reconnectTime = reconnectTime;
            configM.reconnectTimeInterval = reconnectTimeInterval;
        }
        return configM;
    }
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_socketConfigManager == nil) {
            _socketConfigManager = [super allocWithZone:zone];
        }
    });
    return _socketConfigManager;
}

- (id)copyWithZone:(NSZone *)zone{
    return _socketConfigManager;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return _socketConfigManager;
}

+ (BOOL)p_checkStringVaildWithStr:(NSString*)str{
    if (!str || [str isEqualToString:@""]) {
        return NO;
    }else{
        return YES;
    }
}
@end
