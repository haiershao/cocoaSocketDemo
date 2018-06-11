//
//  LHSocketManager.m
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/21.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "LHSocketManager.h"
#import <GCDAsyncSocket.h>
#import "LHSocketSender.h"
#import "LHSocketNotiObj.h"
#import "LHSocketDefine.h"
#import "NSString+LHString.h"
#import "UIImage+LHImage.h"
static const NSInteger TIMEOUT = 30;
static const NSInteger kHeartLimit = 1000;

@interface LHSocketManager ()<GCDAsyncSocketDelegate>{
    NSInteger _reconnectNum;//当前重连次数
    NSInteger _heartCount;   //心跳次数
    NSDictionary *currentPacketHead;
}
@property (strong, nonatomic) GCDAsyncSocket *socket;
@property(nonatomic, copy) SocketConnectResponseBlock connectBlock; //连接成功回调
@property(nonatomic, copy) SocketWithReadDataBlock readDataBlock;   //接收到消息回调
@property(nonatomic ,strong) NSTimer  *heartTimer;                  //心跳定时器
@property(nonatomic ,strong) NSTimer  *reconnectTimer;              //断线重连定时器
@property (nonatomic, strong) NSString *host;                       // Socket连接的host地址
@property (nonatomic, assign) uint16_t port;                        // Sokcet连接的port
@end

@implementation LHSocketManager

#pragma  mark - 对象单例初始化方法
+ (instancetype)shareSocketManager{
    static dispatch_once_t onceToken;
    static LHSocketManager *_socketManager = nil;
    dispatch_once(&onceToken, ^{
        _socketManager = [[super allocWithZone:NULL] init];
        _socketManager.socket = [[GCDAsyncSocket alloc] initWithDelegate:_socketManager delegateQueue:dispatch_get_main_queue()];
        _socketManager.connectState = LHSocketConnectState_NotConnect;
    });
    return _socketManager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self shareSocketManager];
}

- (instancetype)init{
    self = [super init];
    if(self) {
        _heartCount = 0;
    }
    return self;
}

- (void)responseConnectBlock:(SocketConnectResponseBlock)connectBlock{
    if (connectBlock) {
        self.connectBlock = connectBlock;
    }
}

- (void)responseReadDataBlock:(SocketWithReadDataBlock)readDataBlock{
    if (readDataBlock) {
        self.readDataBlock = readDataBlock;
    }
}

+ (void)stopHeartTimer{
    [socketManager.heartTimer invalidate];
    socketManager.heartTimer = nil;
}

+ (void)startHeartTimer{
    [socketManager socketDidConnectBeginSend:@"心跳"];
}

+ (void)disConnectSocket {
    if ([LHSocketManager shareSocketManager].connectState == LHSocketConnectState_Connecting ||
        [LHSocketManager shareSocketManager].connectState == LHSocketConnectState_ConnectSuccess ||
        [LHSocketManager shareSocketManager].connectState == LHSocketConnectState_ReConnecting) {
        
        [socketManager.socket disconnect];
        socketManager.connectState = LHSocketConnectState_NotConnect;
        [socketManager.heartTimer invalidate];
        socketManager.heartTimer = nil;
    }
}

//连接主机
- (void)connectToHost:(NSString *)host port:(uint16_t)port viaInterface:(NSString *)viaInterface timeout:(NSTimeInterval)timeout{
    self.host = host;
    self.port = port;
    NSError *error = nil;
    [self.socket connectToHost:host onPort:port viaInterface:viaInterface withTimeout:timeout error:&error];
    if (error) {
        NSLog(@">>>connectToHost:%@",error);
        socketManager.connectState = LHSocketConnectState_ConnectFail;
    }
}

//开始发送心跳
- (void)socketDidConnectBeginSend:(NSString *)heartBody {
    [LHSocketManager shareSocketManager].connectState = LHSocketConnectState_ConnectSuccess;
    _reconnectNum = 0;
    if (!self.heartTimer) {
        self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                          target:self
                                                        selector:@selector(sendHeart:)
                                                        userInfo:heartBody
                                                         repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.heartTimer forMode:NSRunLoopCommonModes];
    }
}

//开始重连
- (void)socketDidDisconectBeginSendReconnect:(NSString *)reconnectBody {
    [LHSocketManager shareSocketManager].connectState = LHSocketConnectState_NotConnect;
    if (_reconnectNum >= 0 && _reconnectNum <= kHeartLimit) {
        NSLog(@"socketDidDisconectBeginSendReconnect 开始重连 %ld",(long)_reconnectNum);
        NSTimeInterval time = pow(2, _reconnectNum);
        if (!self.reconnectTimer) {
            self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                                   target:self
                                                                 selector:@selector(reconnection:)
                                                                 userInfo:reconnectBody
                                                                  repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.reconnectTimer forMode:NSRunLoopCommonModes];
        }
        _reconnectNum++;
    } else {
        [self.reconnectTimer invalidate];
        self.reconnectTimer = nil;
        _reconnectNum = 0;
    }
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSDictionary *dict = @{
                           @"host":host,
                           @"port":@(port)
                           };
    if (self.connectBlock) {
        self.connectBlock(nil,dict);
    }
    _reconnectNum = 0;
    socketManager.connectState = LHSocketConnectState_ConnectSuccess;
    [self socketDidConnectBeginSend:@"心跳"];
    [LHSocketManager receiveMessage];
}

//与服务端断开了
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error{
    NSLog(@"与服务端断开了%@",error);
    if (error) {
        if (self.connectBlock) {
            self.connectBlock(error,nil);
        }
        socketManager.connectState = LHSocketConnectState_ConnectFail;
    }else{
        //主动断开连接
        socketManager.connectState = LHSocketConnectState_NotConnect;
        [self socketDidDisconectBeginSendReconnect:@"重连"];
    }
    
}

//接收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    _heartCount = 0;
//    NSLog(@"client 收到消息:%@",data);
//    [LHSocketManager receiveMessage];
//    //先读取到当前数据包头部信息
//    if (!currentPacketHead) {
//        currentPacketHead = [NSJSONSerialization
//                             JSONObjectWithData:data
//                             options:NSJSONReadingMutableContainers
//                             error:nil];
//
//
//        if (!currentPacketHead) {
//            NSLog(@"sever error：当前数据包的头为空");
//            //断开这个socket连接或者丢弃这个包的数据进行下一个包的读取
//            //....
//            return;
//        }
//        NSUInteger packetLength = [currentPacketHead[@"size"] integerValue];
//        //读到数据包的大小
//        [sock readDataToLength:packetLength withTimeout:-1 tag:110];
//        return;
//    }
//    //正式的包处理
//    NSUInteger packetLength = [currentPacketHead[@"size"] integerValue];
//    //说明数据有问题
//    if (packetLength <= 0 || data.length != packetLength) {
//        NSLog(@"sever error：当前数据包数据大小不正确");
//        return;
//    }
//
//    NSString *type = currentPacketHead[@"type"];
//    if ([type isEqualToString:@"img"]) {
//        NSLog(@"图片设置成功");
//    }else if ([type isEqualToString:@"hex"]) {
//        LHSocketNotiObj *notiObj = [[LHSocketNotiObj alloc] init];
//        notiObj.notiData = data;
//        if ([notiObj.noti_header1 isEqualToStringWithoutCase:Noti_header_1]) {
//            if ([notiObj.noti_header2 isEqualToStringWithoutCase:Noti_header_AA]) {
//                if ([notiObj.noti_length isEqualToStringWithoutCase:Noti_header_AA_l]) {
//                    _heartCount = 0;
//                    NSLog(@"client 收到消息:心跳");
//                }
//            }
//        }
//    }else{
//        NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        if ([msg isEqualToString:@"心跳"]) {
//            _heartCount = 0;
//            NSLog(@"client 收到消息:%@",msg);
//        }
//    }
//    currentPacketHead = nil;
    
    if (self.readDataBlock) {
        self.readDataBlock(data);
    }
    [LHSocketManager receiveMessage];
}

//读取数据，有数据就会触发代理
+ (void)receiveMessage{
//    [socketManager.socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:110];
    [socketManager.socket readDataWithTimeout:-1 tag:0];
}

//发送消息
- (void)sendCommand:(NSData *)command withTimeout:(NSTimeInterval)timeout tag:(long)tag{
    if (!command) {
        return;
    }
//    NSLog(@"sendCommand %@",command);
    [socketManager.socket writeData:command withTimeout:timeout tag:tag];
}

//字典转为Json字符串
- (NSString *)dictionaryToJson:(NSDictionary *)dic{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//重置心跳次数
- (void)resetHeartCount {
    _heartCount = 0;
}

//发送心跳
- (void)sendHeart:(NSTimer *)timer {
    if (_heartCount >= kHeartLimit) {
        NSLog(@"去断开连接");
        [LHSocketManager disConnectSocket];
        return;
    } else {
        _heartCount ++;
    }
    if (timer != nil) {
//        NSData *data = [timer.userInfo dataUsingEncoding:NSUTF8StringEncoding];
//        NSData *data = [LHPacketData heartBeatParam];
//        Byte byte[14] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x01, 0x00, 0x02,0x00, 0x00,0x00,0x10, 0x0b};
//        int length = sizeof(byte);
//
//        NSData *byteData = [NSData dataWithBytes:byte length:length];
//        NSData *data = [LHPacketData heartBeatParamWithData:byteData];
        
        NSData *data = [LHPacketData encodeCommandCode:0x9116];
        NSLog(@"client 心跳包:%@",data);
        [LHSocketSender sendData:data commandType:LHPacketDataTypeHex withTimeout:-1 tag:111];
//        [LHSocketSender sendData:data commandType:LHPacketDataTypeText withTimeout:-1 tag:111];
    }
}

//重连
- (void)reconnection:(NSTimer *)timer {
    NSError *error = nil;
    if (![socketManager.socket connectToHost:socketManager.host onPort:socketManager.port withTimeout:TIMEOUT error:&error]) {
        NSLog(@"重连 %@",error);
        [LHSocketManager shareSocketManager].connectState = LHSocketConnectState_NotConnect;
    }
}

//监听到服务端发来的连接请求
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    NSLog(@"监听到服务端连接");
}
@end
