//
//  LHSocketProperty.m
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/6/5.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// PTP
int const UndefinedProperty = 0x5000;
int const BatteryLevel = 0x5001;
int const FunctionalMode = 0x5002;
int const ImageSize = 0x5003;
int const CompressionSetting = 0x5004;
int const WhiteBalance = 0x5005;
int const RGBGain = 0x5006;
int const FNumber = 0x5007; // Aperture Value
int const FocalLength = 0x5008;
int const FocusDistance = 0x5009;
int const FocusMode = 0x500A;
int const ExposureMeteringMode = 0x500B;
int const FlashMode = 0x500C;
int const ExposureTime = 0x500D; // Shutter Speed
int const ExposureProgramMode = 0x500E;
int const ExposureIndex = 0x500F; // ISO Speed
int const ExposureBiasCompensation = 0x5010;
int const DateTime = 0x5011;
int const CaptureDelay = 0x5012;
int const StillCaptureMode = 0x5013;
int const Contrast = 0x5014;
int const Sharpness = 0x5015;
int const DigitalZoom = 0x5016;
int const EffectMode = 0x5017;
int const BurstNumber = 0x5018;
int const BurstInterval = 0x5019;
int const TimelapseNumber = 0x501A;
int const TimelapseInterval = 0x501B;
int const FocusMeteringMode = 0x501C;
int const UploadURL = 0x501D;
int const Artist = 0x501E;
int const CopyrightInfo = 0x501F;

// MTP/Microsoft
int const MtpDeviceFriendlyName = 0xD402;
int const MtpSessionInitiatorInfo = 0xD406;
int const MtpPerceivedDeviceType = 0xD407;

// Canon EOS
int const EosApertureValue = 0xD101;
int const EosShutterSpeed = 0xD102;
int const EosIsoSpeed = 0xD103;
int const EosExposureCompensation = 0xD104;
int const EosShootingMode = 0xD105;
int const EosDriveMode = 0xD106;
int const EosMeteringMode = 0xD107;
int const EosAfMode = 0xD108;
int const EosWhitebalance = 0xD109;
int const EosColorTemperature = 0xD10A;
int const EosPictureStyle = 0xD110;
int const EosAvailableShots = 0xD11B;
int const EosEvfOutputDevice = 0xD1B0;
int const EosEvfMode = 0xD1B3;
int const EosEvfWhitebalance = 0xD1B4;
int const EosEvfColorTemperature = 0xD1B6;

// Nikon
int const NikonShutterSpeed = 0xD100;
int const NikonFocusArea = 0xD108;
int const NikonWbColorTemp = 0xD01E;
int const NikonRecordingMedia = 0xD10B;
int const NikonExposureIndicateStatus = 0xD1B1;
int const NikonActivePicCtrlItem = 0xD200;
int const NikonEnableAfAreaPoint = 0xD08D;
