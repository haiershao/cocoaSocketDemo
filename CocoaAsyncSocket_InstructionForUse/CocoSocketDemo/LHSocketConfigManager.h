//
//  LHSocketConfigManager.h
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/23.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LH_Socket_Ip_Debug @""
#define LH_Socket_Port_Debug
#define LH_Socket_UdpPort_Debug

#define LH_Socket_Ip @""
#define LH_Socket_Port
#define LH_Socket_UdpPort

#define LH_Socket_Timeout 5
#define LH_Socket_PingTimeInterval 30
#define LH_Socket_ReconnectTime 10
#define LH_Socket_ReconnectTimeInterval 5

@interface LHSocketConfigManager : NSObject
@property(nonatomic, readonly) NSString *ip;
@property(nonatomic, readonly) uint16_t port;
/**
 超时时间
 默认为5s;
 */
@property(nonatomic, readonly) NSTimeInterval timeout;
/**
 断线之后重连次数
 默认为10次;
 */
@property(nonatomic, readonly) int reconnectTime;
/**
 断线之后重连的间隔时间
 默认为5s;
 */
@property(nonatomic, readonly) float reconnectTimeInterval;
/**
 连接错误
 */
@property(nonatomic, readonly) NSError *connectError;
/**
 发送心跳开启定时器的时间间隔
 默认为30s发一次;
 */
@property(nonatomic,readonly)float pingTimeInterval;


+ (instancetype)ConfigWithSocketIp:(NSString*)ip port:(uint16_t)port;

+ (instancetype)ConfigWithSocketIp:(NSString*)ip port:(uint16_t)port timeout:(NSTimeInterval)timeout;

+ (instancetype)ConfigWithSocketIp:(NSString*)ip port:(uint16_t)port timeout:(NSTimeInterval)timeout pingTimeInterval:(float)pingTimeInterval reconnectTime:(int)reconnectTime reconnectTimeInterval:(float)reconnectTimeInterval;
@end
