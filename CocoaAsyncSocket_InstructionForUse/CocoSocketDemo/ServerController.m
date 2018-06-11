//
//  ServerController.m
//  CocoSocketDemo
//
//  Created by lanouhn on 16/3/16.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import "ServerController.h"
#import <GCDAsyncSocket.h>
#import "LHSocketSender.h"
#import "LHSocketManager.h"
#import "LHUnpackingData.h"
#import "LHSocketNotiObj.h"
#import "LHSocketDefine.h"
#import "NSString+LHString.h"
@interface ServerController ()<GCDAsyncSocketDelegate>{
    NSInteger testFlag;
    NSDictionary *currentPacketHead;
}
@property (weak, nonatomic) IBOutlet UITextField *portF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextView *showContentMessageTV;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

// 服务器socket(开放端口,监听客户端socket的链接)
@property (strong, nonatomic) GCDAsyncSocket *serverSocket;
// 保存客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;

@end

@implementation ServerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.初始化服务器socket, 在主线程里回调
    self.serverSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    testFlag = 0;
}
// 开始监听
- (IBAction)startNotice:(id)sender {
    // 2.开放哪一个端口
    NSError *error = nil;
//    self.portF.text = @"4757";
    self.portF.text = @"8080";
    BOOL result = [self.serverSocket acceptOnPort:self.portF.text.integerValue error:&error];
    if (result && error == nil) {
        // 开放成功
        [self showMessageWithStr:@"开放成功"];
    }
    
    
}
// 发送消息
// socket是保存的客户端scket, 表示给这个socket客户端发送消息
- (IBAction)sendMessage:(id)sender {
    self.messageTF.text = [NSString stringWithFormat:@"Nav logo写文章 注册登录首页前言本文旨以实例的方式，使用CocoaAsyncSocket这个框架进行数据封包和拆包。来解决频繁的数据发送下，导致的数据粘包、以及较大数据（例如图片、录音等等）的发送，导致的数据断包。本文实例Github地址:即时通讯的数据粘包、断包处理实例。注：文章内容属于应用的范畴，内容相对简单易懂。给大家对数据包的处理提供了一个思路， 希望能抛砖引玉。它是楼主CocoaAsyncSocket系列Read篇解析的一个前置插曲，至于详细的实现原理，作者会在后续的文章中写出。正文一、什么是粘包？经常我们发现，如果用客户端同一时间发送几条数据，而服务端只能收到一大条数据，类似下图：如图，由于传输的过程为数据流，经过TCP传输后，三条数据被合并成了一条，这就是数据粘包了。那么为什么会造成粘包呢？原来这是因为TCP使用了优化方法（Nagle算法）。它将多次间隔较小且数据量小的数据，合并成一个大的数据块，然后进行封包。这么做优点也很明显，就是为了减少广域网的小分组数目，从而减小网络拥塞的出现。具体的内容感兴趣的可以看看这两篇文章：TCP之Nagle算法&&延迟ACKTCP NAGLE算法和实现而UDP就不会有这种情况，它不会使用块的合并优化算法。这里说到了就顺便提一下，由于它支持的是一对多的模式，所以接收端的skbuff(套接字缓冲区）采用了链式结构来记录每一个到达的UDP包，在每个UDP包中就有了消息头（消息来源地址，端口等信息"];
    NSData *data = [self.messageTF.text dataUsingEncoding:NSUTF8StringEncoding];
    [self sendCommand:data commandType:LHPacketDataTypeText withTimeout:-1 tag:110];
}
// 接收消息
// socket是客户端socket, 表示从哪一个客户端读取消息
- (IBAction)receiveMessage:(id)sender {
    [self.clientSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:110];
//    [self.serverSocket disconnect];
}

 // 信息展示
- (void)showMessageWithStr:(NSString *)str {
    self.showContentMessageTV.text = [self.showContentMessageTV.text stringByAppendingFormat:@"%@ %ld\n", str,self.portF.text.integerValue];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}


#pragma mark - 服务器socketDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    testFlag = 0;
// 保存客户端的socket
    self.clientSocket = newSocket;
    [self showMessageWithStr:@"server 连接接成功"];
    NSLog(@"server 连接接成功");
    [self showMessageWithStr:[NSString stringWithFormat:@"服务器地址: %@ -端口: %d", newSocket.connectedHost, newSocket.connectedPort]];
    [self.clientSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:110];
//    [self.clientSocket readDataWithTimeout:10 tag:0];
}

// 收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@">>> sever 收到消息:%@",data);
    [[LHUnpackingData shareUnpackingData] unpackingDataWithData:data unpackingDataBlock:^(NSUInteger packetLength, NSString *packetType, NSString *error) {
        if (error) {
            NSLog(@"sever error：%@",error);
            return ;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (packetLength>0) {
                    [sock readDataToLength:packetLength withTimeout:-1 tag:110];
                    return ;
                }
                if ([packetType isEqualToString:@"img"]) {
                    NSLog(@"图片设置成功");
                    self.testImageView.image = [UIImage imageWithData:data];
                }else if ([packetType isEqualToString:@"hex"]) {
                    LHSocketNotiObj *notiObj = [[LHSocketNotiObj alloc] init];
                    notiObj.notiData = data;
                    if ([notiObj.noti_header1 isEqualToStringWithoutCase:Noti_Sever_header_1]) {
                        if ([notiObj.noti_header2 isEqualToStringWithoutCase:Noti_Sever_header_AA]) {
                            if ([notiObj.noti_length isEqualToStringWithoutCase:Noti_Sever_header_AA_l]) {
                                [self showMessageWithStr:@"心跳"];
                                NSLog(@"sever 收到消息:心跳");
                                NSData *data = [LHPacketData heartBeatParam];
                                [self sendCommand:data commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
                            }
                        }
                    }
                }else{
                    NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    if ([msg isEqualToString:@"心跳"]) {
                        //            if (testFlag<5) {
                        testFlag++;
                        [self sendCommand:data commandType:LHPacketDataTypeText withTimeout:-1 tag:110];
                        //            }
                    }

                    [self showMessageWithStr:msg];
                    NSLog(@"sever 收到消息:%@",msg);
                }
                
                [self.clientSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:110];
            });
        }
    }];
}

//发送消息
- (void)sendCommand:(NSData *)command commandType:(LHPacketDataType)sendDataType withTimeout:(NSTimeInterval)timeout tag:(long)tag{
    NSData *data = [LHPacketData packetDataWithData:command commandType:sendDataType];
    // withTimeout -1 : 无穷大,一直等
    // tag : 消息标记
    [self.clientSocket writeData:data withTimeout:timeout tag:tag];
}

//发送消息
- (void)sendCommand:(NSData *)command withTimeout:(NSTimeInterval)timeout tag:(long)tag{
    [self.clientSocket writeData:command withTimeout:timeout tag:tag];
}

// 链接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
//    testFlag = 0;
    NSLog(@"server 连接成功");
}

// 链接失败
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{

    NSLog(@"server 连接失败%@",err);
//    [self startNotice:nil];
}

//字典转为Json字符串
- (NSString *)dictionaryToJson:(NSDictionary *)dic{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


/*
// 收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

    //先读取到当前数据包头部信息
    if (!currentPacketHead) {
        currentPacketHead = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (!currentPacketHead) {
            NSLog(@"sever error：当前数据包的头为空");
            //断开这个socket连接或者丢弃这个包的数据进行下一个包的读取
            //....
            return;
        }
        NSUInteger packetLength = [currentPacketHead[@"size"] integerValue];
        //读到数据包的大小
        [sock readDataToLength:packetLength withTimeout:-1 tag:110];
        return;
    }
    //正式的包处理
    NSUInteger packetLength = [currentPacketHead[@"size"] integerValue];
    //说明数据有问题
    if (packetLength <= 0 || data.length != packetLength) {
        NSLog(@"sever error：当前数据包数据大小不正确");
        return;
    }
    NSString *type = currentPacketHead[@"type"];
    if ([type isEqualToString:@"img"]) {
        NSLog(@"图片设置成功");
        self.testImageView.image = [UIImage imageWithData:data];
    }else{
        
        NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if ([msg isEqualToString:@"心跳"]) {
            //            if (testFlag<5) {
            testFlag++;
            [self sendCommand:data commandType:LHSeverSendDataTypeText withTimeout:-1 tag:110];
            //            }
        }
        
        [self showMessageWithStr:msg];
        //        NSLog(@"sever 收到消息:%@",msg);
    }
    currentPacketHead = nil;
    [self.clientSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:110];
}
 */

- (void)unpackingDataWithData:(NSData *)readData unpackingDataBlock:(LHUnpackingDataBlock)unpackingDataBlock{
    //先读取到当前数据包头部信息
    if (!currentPacketHead) {
        currentPacketHead = [NSJSONSerialization JSONObjectWithData:readData options:NSJSONReadingMutableContainers error:nil];
        if (!currentPacketHead) {
            NSLog(@"sever error：当前数据包的头为空");
            unpackingDataBlock(0, nil,@"当前数据包的头为空");
            return;
        }
        NSUInteger packetLength = [currentPacketHead[@"size"] integerValue];
        unpackingDataBlock(packetLength, nil,nil);
        return;
    }
    //正式的包处理
    NSUInteger packetLength = [currentPacketHead[@"size"] integerValue];
    //说明数据有问题
    if (packetLength <= 0 || readData.length != packetLength) {
        NSLog(@"sever error：当前数据包数据大小不正确");
        unpackingDataBlock(0, nil,@"当前数据包数据大小不正确");
        return;
    }
    NSString *type = currentPacketHead[@"type"];
    unpackingDataBlock(0, type,nil);
    currentPacketHead = nil;
}
@end
