//
//  LHPacketData.m
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/28.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "LHPacketData.h"
#import "LHSocketDefine.h"
#import <GCDAsyncSocket.h>
#import "NSString+LHString.h"
#import "LHSocketDecodeTool.h"
#import "LHConst.h"
@interface LHPacketData ()

@end
int countID;
@implementation LHPacketData
//封包
+ (NSData *)packetDataWithData:(NSData *)command commandType:(LHPacketDataType)packetDataType{
    NSUInteger size = command.length;
    NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
    NSString *typeStr = @"";
    if (packetDataType == LHPacketDataTypeText) {
        typeStr = @"text";
    }else if (packetDataType == LHPacketDataTypeImage){
        typeStr = @"img";
    }else if(packetDataType == LHPacketDataTypeHex || packetDataType == LHPacketDataTypeData){
        typeStr = @"hex";
        return command;
    }else{
        typeStr = @"text";
    }
    [headDic setObject:typeStr forKey:@"type"];
    [headDic setObject:[NSString stringWithFormat:@"%ld",size] forKey:@"size"];
    NSString *jsonStr = [LHPacketData dictionaryToJson:headDic];
    NSData *lengthData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mData = [NSMutableData dataWithData:lengthData];
    //分界
    [mData appendData:[GCDAsyncSocket CRLFData]];
    [mData appendData:command];
    return mData;
}

//字典转为Json字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//心跳
+ (NSData *)heartBeatParam {
    
    //1000 0000 0C00 0000 0100 0200 0000 0000
    Byte byte[16] = {0x10, 0x00,0x00, 0x00, 0x0c,0x00, 0x00, 0x00,0x01, 0x00, 0x02,0x00, 0x00,0x00,0x00, 0x00};
    NSData *byteData = [NSData dataWithBytes:byte length:sizeof(byte)];
    
//    Byte data[6];
//
//    //header
//    data[0] = (Byte) 0xAA;
//    data[1] = (Byte) 0x58;
//
//    //length
//    data[2] = (Byte) 0x03;
//
//    //body
//    data[3] = (Byte) 0x01;
//
//    data[4] = (Byte) 0x01;
//
//    //check
//    Byte sum_check = 0;
//    for (int j = 3; j < 5; j++) {
//        sum_check += data[j];
//    }
//    data[5] = (Byte) (sum_check & 0xFF);
//
//    NSData *byteData = [NSData dataWithBytes:data length:sizeof(data)];
    

    
    
    //1d00 0000 0100 0000 4473 6c72 4461 7368 626f 6172 6453 6572 7665 7200 00
//    Byte data[29] = {0x1d, 0x00,0x00, 0x00, 0x01,0x00, 0x00, 0x00,0x44, 0x73, 0x6c,0x72, 0x44,0x61,0x73, 0x68,0x62, 0x6f,0x61, 0x72,0x64, 0x53, 0x65,0x72, 0x76,0x65, 0x72, 0x00, 0x00};
//    NSData *byteData = [NSData dataWithBytes:data length:sizeof(data)];
    return byteData;
}

//心跳
+ (NSData *)heartBeatParamWithData:(NSData *)data{
    int length = (int)data.length;
    NSArray *dataArr = [LHPacketData snalysisData:data];
    // = {0x10, 0x00,0x00, 0x00, 0x0c,0x00, 0x00, 0x00,0x01, 0x00, 0x02,0x00, 0x00,0x00,0x00, 0x00}
    Byte byte[length+2];
    for (int i = 0 ; i<dataArr.count; i++) {
        int temp = [dataArr[i] intValue];
        if (i < 4) {
            byte[i+1] = (Byte)(temp& 0xFF);
        }else{
            byte[i+1+1] = (Byte)(temp& 0xFF);
        }
//        NSLog(@"heartBeatParamWithData %d -- %@ -- %x",temp, dataArr[i],byte[i+1+1]);
    }
    byte[0] = (Byte)((length+2)& 0xFF);
    byte[4] = (Byte)((length-2)& 0xFF);
    NSData *byteData = [NSData dataWithBytes:byte length:sizeof(byte)];
    return byteData;
}

//无参数
+ (NSData *)encodeCommandCode:(int)code{
    countID ++;
    NSMutableData *mData = [NSMutableData data];
    int value = 16;
    Byte byte[4] = {};
    byte[3] =  (Byte) ((value>>24) & 0xFF);
    byte[2] =  (Byte) ((value>>16) & 0xFF);
    byte[1] =  (Byte) ((value>>8) & 0xFF);
    byte[0] =  (Byte) (value & 0xFF);
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    
    int value1 = 12;
    Byte byte1[4] = {};
    byte1[3] =  (Byte) ((value1>>24) & 0xFF);
    byte1[2] =  (Byte) ((value1>>16) & 0xFF);
    byte1[1] =  (Byte) ((value1>>8) & 0xFF);
    byte1[0] =  (Byte) (value1 & 0xFF);
    NSData *data1 = [NSData dataWithBytes:byte1 length:sizeof(byte1)];
    
    short value2 = TypeCommand;//Type.command ，先写死
    Byte byte2[2] = {};
    byte2[1] =  (Byte) ((value2>>8) & 0xFF);
    byte2[0] =  (Byte) (value2 & 0xFF);
    NSData *data2 = [NSData dataWithBytes:byte2 length:sizeof(byte2)];
    
    short value3 = code;//int code
    Byte byte3[2] = {};
    byte3[1] =  (Byte) ((value3>>8) & 0xFF);
    byte3[0] =  (Byte) (value3 & 0xFF);
    NSData *data3 = [NSData dataWithBytes:byte3 length:sizeof(byte3)];
    
    int ID = countID;//先写死
    Byte byte4[4] = {};
    byte4[3] =  (Byte) ((ID>>24) & 0xFF);
    byte4[2] =  (Byte) ((ID>>16) & 0xFF);
    byte4[1] =  (Byte) ((ID>>8) & 0xFF);
    byte4[0] =  (Byte) (ID & 0xFF);
    NSData *data4 = [NSData dataWithBytes:byte4 length:sizeof(byte4)];
    
    [mData appendData:data];
    [mData appendData:data1];
    [mData appendData:data2];
    [mData appendData:data3];
    [mData appendData:data4];
//    NSLog(@">>> %@",mData);
    //    NSLog(@"%4x -- %4x -- %4x -- %4x === %@ -- %@ -- %@ -- %@ -- %@",byte[0],byte[1],byte[2],byte[3],data,data1,data2,data3,mData);
    return mData;
}

//一个参数
+ (NSData *)encodeCommandCode:(int)code param0:(int)p0{
    countID ++;
    NSMutableData *mData = [NSMutableData data];
    int value = 20;
    Byte byte[4] = {};
    byte[3] =  (Byte) ((value>>24) & 0xFF);
    byte[2] =  (Byte) ((value>>16) & 0xFF);
    byte[1] =  (Byte) ((value>>8) & 0xFF);
    byte[0] =  (Byte) (value & 0xFF);
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    
    int value1 = 16;
    Byte byte1[4] = {};
    byte1[3] =  (Byte) ((value1>>24) & 0xFF);
    byte1[2] =  (Byte) ((value1>>16) & 0xFF);
    byte1[1] =  (Byte) ((value1>>8) & 0xFF);
    byte1[0] =  (Byte) (value1 & 0xFF);
    NSData *data1 = [NSData dataWithBytes:byte1 length:sizeof(byte1)];
    
    short value2 = TypeCommand;//Type.command ，先写死
    Byte byte2[2] = {};
    byte2[1] =  (Byte) ((value2>>8) & 0xFF);
    byte2[0] =  (Byte) (value2 & 0xFF);
    NSData *data2 = [NSData dataWithBytes:byte2 length:sizeof(byte2)];
    
    short value3 = code;//int code
    Byte byte3[2] = {};
    byte3[1] =  (Byte) ((value3>>8) & 0xFF);
    byte3[0] =  (Byte) (value3 & 0xFF);
    NSData *data3 = [NSData dataWithBytes:byte3 length:sizeof(byte3)];
    
    int ID = countID;
    Byte byte4[4] = {};
    byte4[3] =  (Byte) ((ID>>24) & 0xFF);
    byte4[2] =  (Byte) ((ID>>16) & 0xFF);
    byte4[1] =  (Byte) ((ID>>8) & 0xFF);
    byte4[0] =  (Byte) (ID & 0xFF);
    NSData *data4 = [NSData dataWithBytes:byte4 length:sizeof(byte4)];
    
    int value5 = p0;
    Byte byte5[4] = {};
    byte5[3] =  (Byte) ((value5>>24) & 0xFF);
    byte5[2] =  (Byte) ((value5>>16) & 0xFF);
    byte5[1] =  (Byte) ((value5>>8) & 0xFF);
    byte5[0] =  (Byte) (value5 & 0xFF);
    NSData *data5 = [NSData dataWithBytes:byte5 length:sizeof(byte5)];
    
    [mData appendData:data];
    [mData appendData:data1];
    [mData appendData:data2];
    [mData appendData:data3];
    [mData appendData:data4];
    [mData appendData:data5];
    //    NSLog(@">>> %@",mData);
    //    NSLog(@"%4x -- %4x -- %4x -- %4x === %@ -- %@ -- %@ -- %@ -- %@",byte[0],byte[1],byte[2],byte[3],data,data1,data2,data3,mData);
    return mData;
}

//两个参数
+ (NSData *)encodeCommandCode:(int)code param1:(int)p1 param2:(int)p2{
    countID ++;
    NSMutableData *mData = [NSMutableData data];
    int value = 24;
    Byte byte[4] = {};
    byte[3] =  (Byte) ((value>>24) & 0xFF);
    byte[2] =  (Byte) ((value>>16) & 0xFF);
    byte[1] =  (Byte) ((value>>8) & 0xFF);
    byte[0] =  (Byte) (value & 0xFF);
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    
    int value1 = 20;
    Byte byte1[4] = {};
    byte1[3] =  (Byte) ((value1>>24) & 0xFF);
    byte1[2] =  (Byte) ((value1>>16) & 0xFF);
    byte1[1] =  (Byte) ((value1>>8) & 0xFF);
    byte1[0] =  (Byte) (value1 & 0xFF);
    NSData *data1 = [NSData dataWithBytes:byte1 length:sizeof(byte1)];
    
    short value2 = TypeCommand;//Type.command ，先写死
    Byte byte2[2] = {};
    byte2[1] =  (Byte) ((value2>>8) & 0xFF);
    byte2[0] =  (Byte) (value2 & 0xFF);
    NSData *data2 = [NSData dataWithBytes:byte2 length:sizeof(byte2)];
    
    short value3 = code;//int code
    Byte byte3[2] = {};
    byte3[1] =  (Byte) ((value3>>8) & 0xFF);
    byte3[0] =  (Byte) (value3 & 0xFF);
    NSData *data3 = [NSData dataWithBytes:byte3 length:sizeof(byte3)];
    
    int ID = countID;
    Byte byte4[4] = {};
    byte4[3] =  (Byte) ((ID>>24) & 0xFF);
    byte4[2] =  (Byte) ((ID>>16) & 0xFF);
    byte4[1] =  (Byte) ((ID>>8) & 0xFF);
    byte4[0] =  (Byte) (ID & 0xFF);
    NSData *data4 = [NSData dataWithBytes:byte4 length:sizeof(byte4)];
    
    int value5 = p1;
    Byte byte5[4] = {};
    byte5[3] =  (Byte) ((value5>>24) & 0xFF);
    byte5[2] =  (Byte) ((value5>>16) & 0xFF);
    byte5[1] =  (Byte) ((value5>>8) & 0xFF);
    byte5[0] =  (Byte) (value5 & 0xFF);
    NSData *data5 = [NSData dataWithBytes:byte5 length:sizeof(byte5)];
    
    int value6 = p2;
    Byte byte6[4] = {};
    byte6[3] =  (Byte) ((value6>>24) & 0xFF);
    byte6[2] =  (Byte) ((value6>>16) & 0xFF);
    byte6[1] =  (Byte) ((value6>>8) & 0xFF);
    byte6[0] =  (Byte) (value6 & 0xFF);
    NSData *data6 = [NSData dataWithBytes:byte6 length:sizeof(byte6)];
    [mData appendData:data];
    [mData appendData:data1];
    [mData appendData:data2];
    [mData appendData:data3];
    [mData appendData:data4];
    [mData appendData:data5];
    [mData appendData:data6];
    //    NSLog(@">>> %@",mData);
    //    NSLog(@"%4x -- %4x -- %4x -- %4x === %@ -- %@ -- %@ -- %@ -- %@",byte[0],byte[1],byte[2],byte[3],data,data1,data2,data3,mData);
    return mData;
}

//三个参数
+ (NSData *)encodeCommandCode:(int)code param1:(int)p1 param2:(int)p2 param3:(int)p3{
    countID ++;
    NSMutableData *mData = [NSMutableData data];
    int value = 28;
    Byte byte[4] = {};
    byte[3] =  (Byte) ((value>>24) & 0xFF);
    byte[2] =  (Byte) ((value>>16) & 0xFF);
    byte[1] =  (Byte) ((value>>8) & 0xFF);
    byte[0] =  (Byte) (value & 0xFF);
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    
    int value1 = 24;
    Byte byte1[4] = {};
    byte1[3] =  (Byte) ((value1>>24) & 0xFF);
    byte1[2] =  (Byte) ((value1>>16) & 0xFF);
    byte1[1] =  (Byte) ((value1>>8) & 0xFF);
    byte1[0] =  (Byte) (value1 & 0xFF);
    NSData *data1 = [NSData dataWithBytes:byte1 length:sizeof(byte1)];
    
    short value2 = TypeCommand;//Type.command ，先写死
    Byte byte2[2] = {};
    byte2[1] =  (Byte) ((value2>>8) & 0xFF);
    byte2[0] =  (Byte) (value2 & 0xFF);
    NSData *data2 = [NSData dataWithBytes:byte2 length:sizeof(byte2)];
    
    short value3 = code;//int code
    Byte byte3[2] = {};
    byte3[1] =  (Byte) ((value3>>8) & 0xFF);
    byte3[0] =  (Byte) (value3 & 0xFF);
    NSData *data3 = [NSData dataWithBytes:byte3 length:sizeof(byte3)];
    
    int ID = countID;
    Byte byte4[4] = {};
    byte4[3] =  (Byte) ((ID>>24) & 0xFF);
    byte4[2] =  (Byte) ((ID>>16) & 0xFF);
    byte4[1] =  (Byte) ((ID>>8) & 0xFF);
    byte4[0] =  (Byte) (ID & 0xFF);
    NSData *data4 = [NSData dataWithBytes:byte4 length:sizeof(byte4)];
    
    int value5 = p1;
    Byte byte5[4] = {};
    byte5[3] =  (Byte) ((value5>>24) & 0xFF);
    byte5[2] =  (Byte) ((value5>>16) & 0xFF);
    byte5[1] =  (Byte) ((value5>>8) & 0xFF);
    byte5[0] =  (Byte) (value5 & 0xFF);
    NSData *data5 = [NSData dataWithBytes:byte5 length:sizeof(byte5)];
    
    int value6 = p2;
    Byte byte6[4] = {};
    byte6[3] =  (Byte) ((value6>>24) & 0xFF);
    byte6[2] =  (Byte) ((value6>>16) & 0xFF);
    byte6[1] =  (Byte) ((value6>>8) & 0xFF);
    byte6[0] =  (Byte) (value6 & 0xFF);
    NSData *data6 = [NSData dataWithBytes:byte6 length:sizeof(byte6)];
    
    int value7 = p2;
    Byte byte7[4] = {};
    byte7[3] =  (Byte) ((value7>>24) & 0xFF);
    byte7[2] =  (Byte) ((value7>>16) & 0xFF);
    byte7[1] =  (Byte) ((value7>>8) & 0xFF);
    byte7[0] =  (Byte) (value7 & 0xFF);
    NSData *data7 = [NSData dataWithBytes:byte7 length:sizeof(byte7)];
    
    [mData appendData:data];
    [mData appendData:data1];
    [mData appendData:data2];
    [mData appendData:data3];
    [mData appendData:data4];
    [mData appendData:data5];
    [mData appendData:data6];
    [mData appendData:data7];
    //    NSLog(@">>> %@",mData);
    //    NSLog(@"%4x -- %4x -- %4x -- %4x === %@ -- %@ -- %@ -- %@ -- %@",byte[0],byte[1],byte[2],byte[3],data,data1,data2,data3,mData);
    return mData;
}

/*
 public ByteBuffer encodeData(int code, int p0, int p1) {
 int id = MyApplication.getNextTransactionId();
 ByteBuffer b = ByteBuffer.allocate(40);
 b.order(ByteOrder.LITTLE_ENDIAN);
 b.putInt(40);
 b.putInt(12);
 b.putShort((short) CanonPtp.Type.Command);
 b.putShort((short) code);
 b.putInt(id);
 b.putInt(24);
 b.putShort((short) CanonPtp.Type.Data);
 b.putShort((short) code);
 b.putInt(id);
 b.putInt(12);
 b.putInt(p0);
 b.putInt(p1);
 b.position(0);
 return b;
 }
 */
//复合型
+ (NSData *)encodeCommandCodeAndCommandData:(int)code param1:(int)p1 param2:(int)p2{
    countID ++;
    NSMutableData *mData = [NSMutableData data];
    int value = 40;
    Byte byte[4] = {};
    byte[3] =  (Byte) ((value>>24) & 0xFF);
    byte[2] =  (Byte) ((value>>16) & 0xFF);
    byte[1] =  (Byte) ((value>>8) & 0xFF);
    byte[0] =  (Byte) (value & 0xFF);
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    
    int value1 = 12;
    Byte byte1[4] = {};
    byte1[3] =  (Byte) ((value1>>24) & 0xFF);
    byte1[2] =  (Byte) ((value1>>16) & 0xFF);
    byte1[1] =  (Byte) ((value1>>8) & 0xFF);
    byte1[0] =  (Byte) (value1 & 0xFF);
    NSData *data1 = [NSData dataWithBytes:byte1 length:sizeof(byte1)];
    
    short value2 = TypeCommand;//Type.command ，先写死
    Byte byte2[2] = {};
    byte2[1] =  (Byte) ((value2>>8) & 0xFF);
    byte2[0] =  (Byte) (value2 & 0xFF);
    NSData *data2 = [NSData dataWithBytes:byte2 length:sizeof(byte2)];
    
    short value3 = code;//int code
    Byte byte3[2] = {};
    byte3[1] =  (Byte) ((value3>>8) & 0xFF);
    byte3[0] =  (Byte) (value3 & 0xFF);
    NSData *data3 = [NSData dataWithBytes:byte3 length:sizeof(byte3)];
    
    int ID = countID;
    Byte byte4[4] = {};
    byte4[3] =  (Byte) ((ID>>24) & 0xFF);
    byte4[2] =  (Byte) ((ID>>16) & 0xFF);
    byte4[1] =  (Byte) ((ID>>8) & 0xFF);
    byte4[0] =  (Byte) (ID & 0xFF);
    NSData *data4 = [NSData dataWithBytes:byte4 length:sizeof(byte4)];
    
    int value5 = 24;
    Byte byte5[4] = {};
    byte5[3] =  (Byte) ((value5>>24) & 0xFF);
    byte5[2] =  (Byte) ((value5>>16) & 0xFF);
    byte5[1] =  (Byte) ((value5>>8) & 0xFF);
    byte5[0] =  (Byte) (value5 & 0xFF);
    NSData *data5 = [NSData dataWithBytes:byte5 length:sizeof(byte5)];
    
    short value6 = TypeData;
    Byte byte6[2] = {};
    byte6[1] =  (Byte) ((value6>>8) & 0xFF);
    byte6[0] =  (Byte) (value6 & 0xFF);
    NSData *data6 = [NSData dataWithBytes:byte6 length:sizeof(byte6)];
    
    short value7 = code;//int code
    Byte byte7[2] = {};
    byte7[1] =  (Byte) ((value7>>8) & 0xFF);
    byte7[0] =  (Byte) (value7 & 0xFF);
    NSData *data7 = [NSData dataWithBytes:byte7 length:sizeof(byte7)];
    
    Byte byte8[4] = {};
    byte8[3] =  (Byte) ((ID>>24) & 0xFF);
    byte8[2] =  (Byte) ((ID>>16) & 0xFF);
    byte8[1] =  (Byte) ((ID>>8) & 0xFF);
    byte8[0] =  (Byte) (ID & 0xFF);
    NSData *data8 = [NSData dataWithBytes:byte8 length:sizeof(byte8)];
    
    int value9 = 12;
    Byte byte9[4] = {};
    byte9[3] =  (Byte) ((value9>>24) & 0xFF);
    byte9[2] =  (Byte) ((value9>>16) & 0xFF);
    byte9[1] =  (Byte) ((value9>>8) & 0xFF);
    byte9[0] =  (Byte) (value9 & 0xFF);
    NSData *data9 = [NSData dataWithBytes:byte9 length:sizeof(byte9)];
    
    int value10 = p1;
    Byte byte10[4] = {};
    byte10[3] =  (Byte) ((value10>>24) & 0xFF);
    byte10[2] =  (Byte) ((value10>>16) & 0xFF);
    byte10[1] =  (Byte) ((value10>>8) & 0xFF);
    byte10[0] =  (Byte) (value10 & 0xFF);
    NSData *data10 = [NSData dataWithBytes:byte10 length:sizeof(byte10)];
    
    int value11 = p2;
    Byte byte11[4] = {};
    byte11[3] =  (Byte) ((value11>>24) & 0xFF);
    byte11[2] =  (Byte) ((value11>>16) & 0xFF);
    byte11[1] =  (Byte) ((value11>>8) & 0xFF);
    byte11[0] =  (Byte) (value11 & 0xFF);
    NSData *data11 = [NSData dataWithBytes:byte11 length:sizeof(byte11)];
    [mData appendData:data];
    [mData appendData:data1];
    [mData appendData:data2];
    [mData appendData:data3];
    [mData appendData:data4];
    [mData appendData:data5];
    [mData appendData:data6];
    [mData appendData:data7];
    [mData appendData:data8];
    [mData appendData:data9];
    [mData appendData:data10];
    [mData appendData:data11];
    NSLog(@">>>encodeCommandCodeAndCommandData %@",data6);
    //    NSLog(@"%4x -- %4x -- %4x -- %4x === %@ -- %@ -- %@ -- %@ -- %@",byte[0],byte[1],byte[2],byte[3],data,data1,data2,data3,mData);
    return mData;
}

+ (NSArray *)snalysisData:(NSData *)notiData{
    //解析data
    NSString *dataString = [NSString convertDataToHexStr:notiData];
    NSArray *noti_array = [LHSocketDecodeTool snalysisWithResponseString:dataString];
    return noti_array;
}
@end
