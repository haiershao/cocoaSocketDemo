//
//  ClientController.m
//  CocoSocketDemo
//
//  Created by lanouhn on 16/3/16.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import "ClientController.h"
#import <GCDAsyncSocket.h>
#import "LHSocketManager.h"
#import "LHSocketSender.h"
#import "LHSocketNotiObj.h"
#import "NSString+LHString.h"
#import "LHSocketDefine.h"
#import "LHConst.h"
#import "LHSocketOperation.h"
#import "LHSocketResponse.h"
#import "LHSocketProperty.h"
#import "UIImage+LHImage.h"
#import "LHSocketDecodeTool.h"
#import "NSArray+LHArray.h"
#define blockSelf(self) __weak __block typeof(self) weakSelf = self;
@interface ClientController ()<GCDAsyncSocketDelegate>{
    NSInteger index;
    BOOL senderFlag;
    BOOL startAppend;
    BOOL imageAppending;
    int imageLength;
    int beginImageLength;
    int imageHeaderLength;
    int beginImageHeaderLength;
    NSInteger testindex;
    
}
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextView *showMessageTF;
@property(nonatomic ,strong) NSTimer  *imageTimer;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property(nonatomic ,strong) NSMutableData *appendMDtata;
@property(nonatomic ,strong) NSMutableData *beginAppendMDtata;
@property(nonatomic ,strong) NSMutableArray *imageDataArr;
@end

@implementation ClientController
- (NSMutableData *)appendMDtata{
    if (!_appendMDtata) {
        _appendMDtata = [NSMutableData data];
    }
    return _appendMDtata;
}

- (NSMutableData *)beginAppendMDtata{
    if (!_beginAppendMDtata) {
        _beginAppendMDtata = [NSMutableData data];
    }
    return _beginAppendMDtata;
}

- (NSMutableArray *)imageDataArr{
    if (!_imageDataArr) {
        _imageDataArr = [NSMutableArray array];
    }
    return _imageDataArr;
}

//就是先发送查询USB信息收到后再发连接USB，再发打开回话指令，最后再发拍照才行是吧
//public ByteBuffer encodeCommand(int code) {
//    ByteBuffer b = ByteBuffer.allocate(16);
//    b.order(ByteOrder.LITTLE_ENDIAN);
//    b.putInt(16);
//    b.putInt(12);
//    b.putShort((short) CanonPtp.Type.Command);
//    b.putShort((short) code);
//    b.putInt(MyApplication.getNextTransactionId());
//    b.position(0);
//    return b;
//}


//public ByteBuffer encodeCommand(int code, int p0) {
//    ByteBuffer b = ByteBuffer.allocate(20);
//    b.order(ByteOrder.LITTLE_ENDIAN);
//    b.putInt(20);
//    b.putInt(16);
//    b.putShort((short) CanonPtp.Type.Command);
//    b.putShort((short) code);
//    b.putInt(MyApplication.getNextTransactionId());
//    b.putInt(p0);
//    b.position(0);
//    return b;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    //14000000 10000000 01000210 01000000 01000000
    //     00100000 00010002 10010000 00010000 00
    // Do any additional setup after loading the view.
    
//    int value = 2222;
//    int value = 0x1001;
    
//    NSData *tempData = [LHPacketData encodeCommandCode:camera_connect param1:canon param2:canon_type];
//    NSData *tempData = [LHPacketData encodeCommandCode:0x1001];
    NSData *opensessionData = [LHPacketData encodeCommandCode:OpenSession param0:1];
    NSLog(@">>> %@ -- %lu",opensessionData,(unsigned long)opensessionData.length);
    NSMutableData *newdata = [opensessionData subdataWithRange:NSMakeRange(4, opensessionData.length-4)];
    NSLog(@">>> %@",newdata);
    NSMutableData *mData = [NSMutableData data];
    mData = newdata;
    NSLog(@"mData %@",mData);
//    NSData *opensessionData = [LHPacketData encodeCommandCodeAndCommandData:EosSetDevicePropValue param1:EosEvfOutputDevice param2:camera_previre_on];
//    NSLog(@">>> \n%@",opensessionData);
//    NSString *testStr = [NSString hexStringFromData:opensessionData];
//    NSLog(@"=== testStr %@",testStr);
//    testStr = [@"ffd8" stringByAppendingString:testStr];
//    NSLog(@"=== ffd8 testStr %@",testStr);
//    NSData *data = [NSString dataFromHexString:testStr];
//    NSLog(@"=== data %@",data);
    
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"test%ld",4] ofType:@"jpeg"];
//    NSData *data5 = [NSData dataWithContentsOfFile:filePath];
//    NSLog(@"data5 %@",data5);
//    NSString *str = [NSString hexStringFromData:data5];
//    NSLog(@"str %@",str);
//    NSData *testData = [NSString dataFromHexString:str];
//    NSLog(@"testData %@",testData);
//    self.testImageView.image = [UIImage imageWithData:testData];
    
    senderFlag = NO;
    startAppend = NO;
    imageAppending = YES;
    imageLength = 0;
    imageHeaderLength = 0;
    beginImageHeaderLength = 0;
    beginImageLength = 0;
    index = 0;
    testindex = 0;
    [socketManager responseConnectBlock:^(NSError *error, NSDictionary *result){
        if (error) {
            NSLog(@"responseConnectBlock 连接失败 %@",error);
        }else{
            NSLog(@"responseConnectBlock 连接成功");
            [self showMessageWithStr:@"连接成功"];
            [self showMessageWithStr:[NSString stringWithFormat:@"服务器IP: %@", result[@"host"]]];
        }
    }];
    
    [socketManager responseReadDataBlock:^(NSData *result) {
        
        if (result.length<200) {
        NSLog(@">>>result.length %ld",result.length);
        NSLog(@"client 收到消息:%@",result);
        }
        LHSocketNotiObj *notiObj = [[LHSocketNotiObj alloc] init];
        notiObj.notiData = result;
        [self snalysisWithNotiObj:notiObj];
//        unsigned char *dataByes = [result bytes];
//        CGSize imageSize = CGSizeMake(1080, 720);
//        [UIImage imageFromBRGABytes:dataByes imageSize:imageSize];
//        self.testImageView.image = [UIImage imageWithData:result];
        NSString *text = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        [self showMessageWithStr:text];
    }];
    
//    NSData *data =  [self hexToBytes:@"0120"];
//    NSLog(@">>> data %@",data);
//    [self encodeCommandCode:0x2001];
    
//    NSLog(@"compare%d",[@"0120" compareWithHexint:0x2001]);
    
    
    NSArray *arr = @[@"db73",@"0300"];
    int result = [NSArray arrayConverIntWithArray:arr];
    NSLog(@">>> %d",result);
//    NSString *str = arr[0];
//    str = [str stringByAppendingString:arr[1]];
//    NSArray *tempArr = [NSString snalysisWithResponseTwoString:str];
//    tempArr = [[tempArr reverseObjectEnumerator] allObjects];
//    NSLog(@">>> %@",tempArr);
}

- (int)arrayConverIntWithArray:(NSArray *)array{
    NSString *appendStr = @"";
    for (NSString *tempStr in array) {
        appendStr = [appendStr stringByAppendingString:tempStr];
    }
    NSArray *tempArr = [NSString snalysisWithResponseTwoString:appendStr];
    tempArr = [[tempArr reverseObjectEnumerator] allObjects];
    NSString *text = [tempArr componentsJoinedByString:@""];
    NSNumber *tempResult = [NSString numberHexString:text];
//    NSString *text = @"0x0373db";
    int result = [tempResult intValue];
    NSLog(@">>> %d",result);
    return result;
}

-(NSData *)hexToBytes:(NSString *)str{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

- (void)encodeCommandCode:(int)code{
    int value = code;
    Byte byte[2] = {};
    byte[1] =  (Byte) ((value>>8) & 0xFF);
    byte[0] =  (Byte) (value & 0xFF);
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    NSLog(@">>>encodeCommandCode %@",data);
}

- (BOOL)compareStr:(NSString *)str withInt:(int)value{
    NSMutableData* dataStr = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [dataStr appendBytes:&intValue length:1];
    }
    
    Byte byte[2] = {};
    byte[1] =  (Byte) ((value>>8) & 0xFF);
    byte[0] =  (Byte) (value & 0xFF);
    NSData *dataValue = [NSData dataWithBytes:byte length:sizeof(byte)];
    if ([dataStr isEqualToData:dataValue]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)covertData{
    NSLog(@"covertData %ld",self.beginAppendMDtata.length);
//    NSLog(@"=== beginAppendMDtata %@\n",self.beginAppendMDtata);
    //拼接的data长度等于图片的大小就可以转图片了
    if (beginImageLength>0&&self.beginAppendMDtata.length>0) {
        if ((self.beginAppendMDtata.length - beginImageHeaderLength)>=beginImageLength&&beginImageLength!=0&&imageAppending) {
            startAppend = NO;
            NSLog(@"111=== beginImageHeaderLength %d\n",beginImageHeaderLength);
            NSLog(@"222=== beginImageLength %d\n",beginImageLength);
            NSLog(@"333 self.beginAppendMDtata.length %lu",(unsigned long)self.beginAppendMDtata.length);
            NSLog(@"444=== beginAppendMDtata %@\n",self.beginAppendMDtata);
            NSData *imageData = [self.beginAppendMDtata subdataWithRange:NSMakeRange(beginImageHeaderLength, self.beginAppendMDtata.length-beginImageHeaderLength)];
            //            NSString *str  = [NSString hexStringFromData:self.appendMDtata];
            //            NSString *str1 = [str componentsSeparatedByString:@"ffd8"].lastObject;
            //            NSString *imageStr = [@"ffd8" stringByAppendingString:str1];
            //            imageStr = [imageStr stringByAppendingString:@"<…>"];
            //            NSLog(@">>>imageStr %@",imageStr);
            //            NSData *imageData = [NSString dataFromHexString:imageStr];
            NSLog(@">>>imageData %@ -- %d\n",imageData,beginImageHeaderLength);
            NSLog(@"555=== appendMDtata %lu\n",(unsigned long)imageData.length);
            self.testImageView.image = [UIImage imageWithData:imageData];
            imageLength = 0;
            startAppend = NO;
            self.appendMDtata = nil;
            imageHeaderLength = 0;
            testindex = 0;
        }
    }
}
//125719
//125643

- (void)unpackingImageData{
    if (!self.imageDataArr.count) {
        return ;
    }
    NSMutableData *imageAppendData = [NSMutableData data];
    for (NSData *tempData in self.imageDataArr) {
        NSLog(@"tempData>>> %lu",tempData.length);
//        NSLog(@"tempData>>> %@",tempData);
        [imageAppendData appendData:tempData];
    }
    NSLog(@"unpackingImageData>> %lu",imageAppendData.length);
    if (imageAppendData.length != beginImageLength) return;
    NSData *imageData = [imageAppendData subdataWithRange:NSMakeRange(beginImageHeaderLength, imageAppendData.length-beginImageHeaderLength)];
    NSLog(@"unpackingImageData>>> %lu %@",imageData.length,[NSThread currentThread]);
//    NSLog(@"unpackingImageData>>> %@",imageData);
    UIImage *image = [UIImage imageWithData:imageData];
    NSLog(@"unpackingImageData %@",image);
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!image) return;
        self.testImageView.image = image;
    });
    NSLog(@"unpackingImageData %@",NSStringFromCGRect(self.testImageView.frame));
    
}

- (void)testImage:(UIImage *)image{
    blockSelf(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.testImageView.image = image;
        NSLog(@"=====================");
    });
    
}

- (void)snalysisWithNotiObj:(LHSocketNotiObj *)notiObj{
   
    if ([notiObj.noti_header1 isEqualToStringWithoutCase:Request_header_usb_info_1]) {//得到USB信息
        if ([notiObj.noti_header2 isEqualToStringWithoutCase:Request_header_usb_info_2]) {
            NSString *camera = notiObj.noti_values[9];
            NSString *cameraType = notiObj.noti_values[10];
            if ([camera isEqualToStringWithoutCase:Request_header_canon]) {
                if ([cameraType isEqualToStringWithoutCase:Request_header_canon_6D]) {
                    //连接相机
                    NSData *connectData = [LHPacketData encodeCommandCode:Camera_connect param1:Canon param2:Canon_type];
                    [LHSocketSender sendData:connectData commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
                    NSLog(@"client camera 500D");
                }
            }
        }
    }
    
    if ([notiObj.noti_header1 isEqualToStringWithoutCase:Request_header_camera_connect_1]) {//连接相机成功
        if ([notiObj.noti_header2 isEqualToStringWithoutCase:Request_header_camera_connect_2]) {
            NSString *camera = notiObj.noti_values[8];
            NSString *cameraType = notiObj.noti_values[9];
            NSString *cameraConnect = notiObj.noti_values[13];
            if ([camera isEqualToStringWithoutCase:Request_header_canon]) {
                if ([cameraType isEqualToStringWithoutCase:Request_header_canon_6D]) {
                    if ([cameraConnect isEqualToStringWithoutCase:Request_header_camera_connect_3]) {
                        //打开会话
                        NSData *opensessionData = [LHPacketData encodeCommandCode:OpenSession param0:1];
                        [LHSocketSender sendData:opensessionData commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
                        
                        //获取deviceinfo
//                        NSData *connectData = [LHPacketData encodeCommandCode:GetDeviceInfo];
//                        [LHSocketSender sendData:connectData commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
                        NSLog(@"client opensession");
                    }
                }
            }
        }
    }
    
    if (notiObj.notiData.length>1000) {
        NSString *tempStr = @"";
        if ([notiObj.noti_values containsObject:Response_header_image]) {
            NSInteger index = [notiObj.noti_values indexOfObject:Response_header_image];
            tempStr = notiObj.noti_values[index+1];
            tempStr = [tempStr substringWithRange:NSMakeRange(0, 2)];
            if ([tempStr isEqualToString:Response_header_image_1]) {
                NSLog(@"image>>> %@",tempStr);
                beginImageLength = imageLength;
                imageLength = [NSArray arrayConverIntWithArray:@[notiObj.noti_values[0],notiObj.noti_values[1]]];
                NSLog(@"imageLength>>> %d",imageLength);
                startAppend = YES;
                imageAppending = !imageAppending;
                beginImageHeaderLength = imageHeaderLength;
                imageHeaderLength = (int)2*index;
                NSLog(@"imageHeaderLength index>>> %ld",(long)index);
                NSLog(@"snalysisWithNotiObj>>> %lu",(unsigned long)self.imageDataArr.count);
                [self unpackingImageData];
                [self.imageDataArr removeAllObjects];
            }
        }
        if (startAppend) {//开始组装数据
//            NSString *tempStr = [NSString hexStringFromData:notiObj.notiData];
//            [self.imageDataArr addObject: tempStr];
            [self.imageDataArr addObject: notiObj.notiData];
        }
}
    
    
    if ([notiObj.noti_header1 isEqualToStringWithoutCase:Response_header_preview]){
        if ([notiObj.noti_header2 isEqualToStringWithoutCase:Response_header_preview_1]) {
            NSString *tempStr = notiObj.noti_values[11];
            NSLog(@"==111preview: %@",tempStr);
            if ([tempStr isEqualToString:Response_header_preview_2]) {
                if (self.previewButton.selected) {
                    NSData *previewData = [LHPacketData encodeCommandCode:EosGetLiveViewPicture param1:GetLiveViewPicture_p1 param2:0 param3:0];
                    NSLog(@"==222preview: %@",previewData);
                    [LHSocketSender sendData:previewData commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
                }
            }
        }
    }
    
    if ([notiObj.noti_header1 isEqualToStringWithoutCase:Response_header_result]
        ||[notiObj.noti_header1 isEqualToStringWithoutCase:Request_header_take_picture]) {
        if ([notiObj.noti_header2 isEqualToStringWithoutCase:Response_header_result_1]
            ||[notiObj.noti_header2 isEqualToStringWithoutCase:Request_header_take_picture_1]) {
            NSString *tempStr = notiObj.noti_values[5];
            if ([tempStr compareWithHexint: responseOk]) {//此操作OK
                NSLog(@">>>responseOk");
                
                if (self.previewButton.selected) {
//                    [LHSocketManager stopHeartTimer];
                    NSData *previewData = [LHPacketData encodeCommandCode:EosGetLiveViewPicture param1:GetLiveViewPicture_p1 param2:0 param3:0];
                    NSLog(@"==preview: %@",previewData);
                   [LHSocketSender sendData:previewData commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
                }
            }else if ([tempStr compareWithHexint: GeneralError]){
                NSLog(@">>>GeneralError");
            }else if ([tempStr compareWithHexint: SessionNotOpen]){
                NSLog(@">>>SessionNotOpen");
            }else if ([tempStr compareWithHexint: InvalidTransactionID]){
                NSLog(@">>>InvalidTransactionID");
            }else if ([tempStr compareWithHexint: OperationNotSupported]){
                NSLog(@">>>OperationNotSupported");
            }else if ([tempStr compareWithHexint: ParameterNotSupported]){
                NSLog(@">>>ParameterNotSupported");
            }else if ([tempStr compareWithHexint: IncompleteTransfer]){
                NSLog(@">>>IncompleteTransfer");
            }else if ([tempStr compareWithHexint: InvalidStorageID]){
                NSLog(@">>>InvalidStorageID");
            }else if ([tempStr compareWithHexint: InvalidObjectHandle]){
                NSLog(@">>>InvalidObjectHandle");
            }else if ([tempStr compareWithHexint: DevicePropNotSupported]){
                NSLog(@">>>DevicePropNotSupported");
            }else if ([tempStr compareWithHexint: InvalidObjectFormatCode]){
                NSLog(@">>>InvalidObjectFormatCode");
            }else if ([tempStr compareWithHexint: StoreIsFull]){
                NSLog(@">>>StoreIsFull");
            }else if ([tempStr compareWithHexint: ObjectWriteProtect]){
                NSLog(@">>>ObjectWriteProtect");
            }else if ([tempStr compareWithHexint: StoreReadOnly]){
                NSLog(@">>>StoreReadOnly");
            }else if ([tempStr compareWithHexint: AccessDenied]){
                NSLog(@">>>AccessDenied");
            }else if ([tempStr compareWithHexint: NoThumbnailPresent]){
                NSLog(@">>>NoThumbnailPresent");
            }else if ([tempStr compareWithHexint: PartialDeletion]){
                NSLog(@">>>PartialDeletion");
            }else if ([tempStr compareWithHexint: StoreNotAvailable]){
                NSLog(@">>>StoreNotAvailable");
            }else if ([tempStr compareWithHexint: SpecificationByFormatUnsupported]){
                NSLog(@">>>SpecificationByFormatUnsupported");
            }else if ([tempStr compareWithHexint: NoValidObjectInfo]){
                NSLog(@">>>NoValidObjectInfo");
            }else if ([tempStr compareWithHexint: DeviceBusy]){
                NSLog(@">>>DeviceBusy");
            }else if ([tempStr compareWithHexint: InvalidParentObject]){
                NSLog(@">>>InvalidParentObject");
            }else if ([tempStr compareWithHexint: InvalidDevicePropFormat]){
                NSLog(@">>>InvalidDevicePropFormat");
            }else if ([tempStr compareWithHexint: InvalidDevicePropValue]){
                NSLog(@">>>InvalidDevicePropValue");
            }else if ([tempStr compareWithHexint: InvalidParameter]){
                NSLog(@">>>InvalidParameter");
            }else if ([tempStr compareWithHexint: SessionAlreadyOpen]){
                NSLog(@">>>SessionAlreadyOpen");
            }else if ([tempStr compareWithHexint: TransferCancelled]){
                NSLog(@">>>TransferCancelled");
            }else if ([tempStr compareWithHexint: SpecificationOfDestinationUnsupported]){
                NSLog(@">>>SpecificationOfDestinationUnsupported");
            }
        }
    }
}

- (void)appendImageData:(NSData *)imageData{
    testindex ++;
    NSLog(@">>>appendImageData>>>%ld",(long)testindex);
    [self.appendMDtata appendData:imageData];
//    NSLog(@">>>appendImageData>>> %@",self.appendMDtata);
}

// 开始连接
- (IBAction)connectAction:(id)sender {
    //192.168.3:343
    //伴侣
    self.addressTF.text = @"192.168.1.1";
    self.portTF.text = @"4757";
    //博闻电脑
//    self.addressTF.text = @"192.168.3.143";
//    self.portTF.text = @"4758";
    [socketManager connectToHost:self.addressTF.text port:self.portTF.text.integerValue viaInterface:nil timeout:-1];
}

// 发送消息
- (IBAction)sendMessageAction:(id)sender {
    NSData *data = [self.messageTF.text dataUsingEncoding:NSUTF8StringEncoding];
//    if (!self.imageTimer) {
//        self.imageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                           target:self
//                                                         selector:@selector(sendImage)
//                                                         userInfo:nil
//                                                          repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:self.imageTimer forMode:NSRunLoopCommonModes];
//    }
    [self sendImage];
}

- (void)sendImage{
    index++;
    if (index>4) {
        index = 0;
    }
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"test%ld",index] ofType:@"jpeg"];
//    NSData *data5 = [NSData dataWithContentsOfFile:filePath];
//    // withTimeout -1 : 无穷大,一直等
//    // tag : 消息标记
//    [LHSocketSender sendData:data5 commandType:LHPacketDataTypeImage withTimeout:-1 tag:110];
    NSLog(@"===");
    //0x0002
    NSData *data = [LHPacketData encodeCommandCode:Usb_info];
    NSLog(@"发送消息：%@",data);
    [LHSocketSender sendData:data commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
    senderFlag = NO;
}



//先切PC模式
- (IBAction)setModelButton:(UIButton *)sender {
    if (!self.previewButton.selected) {
        NSData *PCModelData = [LHPacketData encodeCommandCode:EosSetPCConnectMode param0:1];
        NSLog(@"==PCModelData: %@",PCModelData);
        [LHSocketSender sendData:PCModelData commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
    }
}


//拍照
- (IBAction)snapButtonClick:(UIButton *)sender {
    NSData *data = [LHPacketData encodeCommandCode:EosTakePicture];
    NSLog(@"发送消息：%@",data);
    [LHSocketSender sendData:data commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
    senderFlag = NO;
}

- (void)previewCommand{
    NSData *data = [LHPacketData encodeCommandCodeAndCommandData:EosSetDevicePropValue param1:EosEvfOutputDevice param2:camera_previre_on];
    NSLog(@"发送消息：%@",data);
    [LHSocketSender sendData:data commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
}

//预览
- (IBAction)previewButtonClick:(UIButton *)sender {
    self.previewButton.selected = !self.previewButton.selected;
    if (self.previewButton.selected) {
        //先切PC模式
//        [self snapButtonClick:nil];
        [self performSelector:@selector(previewCommand) withObject:nil afterDelay:1.0];
        senderFlag = NO;
    }else{
//        [LHSocketManager startHeartTimer];
        NSData *data = [LHPacketData encodeCommandCodeAndCommandData:EosSetDevicePropValue param1:EosEvfOutputDevice param2:camera_previre_off];
        NSLog(@"发送消息：%@",data);
        [LHSocketSender sendData:data commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
        senderFlag = NO;
    }
    
}

- (IBAction)getCameraParamsButtonClick:(UIButton *)sender {
    //先切PC模式
    [self snapButtonClick:nil];
    [self performSelector:@selector(getCameraParams0) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(getCameraParams1) withObject:nil afterDelay:1.0];
}

- (void)getCameraParams0{
    NSData *data = [LHPacketData encodeCommandCode:EosSetEventMode param0:1];
    NSLog(@"发送消息：%@",data);
    [LHSocketSender sendData:data commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
}

- (void)getCameraParams1{
    NSData *data = [LHPacketData encodeCommandCode:EosEventCheck];
    NSLog(@"发送消息：%@",data);
    [LHSocketSender sendData:data commandType:LHPacketDataTypeHex withTimeout:-1 tag:110];
}

// 接收消息
- (IBAction)receiveMessageAction:(id)sender {
//     [self.clientSocket readDataWithTimeout:11 tag:0];
//    [LHSocketManager receiveMessage];
}

- (IBAction)disconnectButtonAction:(UIButton *)sender {
    [LHSocketManager disConnectSocket];
}

// 信息展示
- (void)showMessageWithStr:(NSString *)str {
    self.showMessageTF.text = [self.showMessageTF.text stringByAppendingFormat:@"%@\n", str];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}
@end
