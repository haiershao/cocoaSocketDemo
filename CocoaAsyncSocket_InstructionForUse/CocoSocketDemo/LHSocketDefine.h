//
//  LHSocketDefine.h
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/29.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#ifndef LHSocketDefine_h
#define LHSocketDefine_h

//#define Noti_header_1       @"aa"
//#define Noti_header_AA      @"58"
//#define Noti_header_AA_l    @"03"
//
//#define Noti_Sever_header_1       @"aa"
//#define Noti_Sever_header_AA      @"58"
//#define Noti_Sever_header_AA_l    @"03"

#define Noti_header_1       @"10"
#define Noti_header_AA      @"00"
#define Noti_header_AA_l    @"00"

#define Noti_Sever_header_1       @"10"
#define Noti_Sever_header_AA      @"00"
#define Noti_Sever_header_AA_l    @"00"

typedef NS_ENUM(NSInteger, Setting_Target) {
    Setting_Target_JV            = 0x01,
    Setting_Target_JH            = 0x02,
    Setting_Target_XYZ           = 0x03,
    Setting_Target_PW            = 0x04,
    Setting_Target_PD            = 0x05,
    Setting_Target_WM            = 0x06,
    Setting_Target_RS            = 0x07,
    Setting_Target_PV            = 0x08,
    Setting_Target_MT_Inside     = 0x09,
    Setting_Target_MT_Mid        = 0x0a,
    Setting_Target_MT_Outside    = 0x0b,
    Setting_Target_Stay_Duration = 0x0c,
};

#define Response_header_image   @"ffd8"
#define Response_header_image_1   @"ff"

#define Response_header_preview   @"1c00"
#define Response_header_preview_1 @"0000"
#define Response_header_preview_2 @"0120"

#define Response_header_result   @"1000"
#define Response_header_result_1 @"0000"

#define Request_header_take_picture @"1400"
#define Request_header_take_picture_1 @"0000"

/*
 a904 佳能
 cf31 500D
 5032 6D
 */
#define Request_header_usb_info_1 @"0000"
#define Request_header_usb_info_2 @"0044"
#define Request_header_canon @"a904"
#define Request_header_canon_500D @"cf31"
#define Request_header_canon_6D @"5032"

#define Request_header_camera_connect_1 @"2000"
#define Request_header_camera_connect_2 @"0000"
#define Request_header_camera_connect_3 @"0120"


#endif /* LHSocketDefine_h */
