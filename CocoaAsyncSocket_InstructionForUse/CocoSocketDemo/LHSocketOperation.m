//
//  LHSocketOperation.m
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/6/5.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>

int const UndefinedOperationCode = 0x1000;
int const GetDeviceInfo = 0x1001;
int const OpenSession = 0x1002;
int const CloseSession = 0x1003;
int const GetStorageIDs = 0x1004;
int const GetStorageInfo = 0x1005;
int const GetNumObjects = 0x1006;
int const GetObjectHandles = 0x1007;
int const GetObjectInfo = 0x1008;
int const GetObject = 0x1009;
int const GetThumb = 0x100A;
int const DeleteObject = 0x100B;
int const SendObjectInfo = 0x100C;
int const SendObject = 0x100D;
int const InitiateCapture = 0x100E;
int const FormatStore = 0x100F;
int const ResetDevice = 0x1010;
int const SelfTest = 0x1011;
int const SetObjectProtection = 0x1012;
int const PowerDown = 0x1013;
int const GetDevicePropDesc = 0x1014;
int const GetDevicePropValue = 0x1015;
int const SetDevicePropValue = 0x1016;
int const ResetDevicePropValue = 0x1017;
int const TerminateOpenCapture = 0x1018;
int const MoveObject = 0x1019;
int const CopyObject = 0x101A;
int const GetPartialObject = 0x101B;
int const InitiateOpenCapture = 0x101C;

int const NikonInitiateCaptureRecInSdram = 0x90C0;
int const NikonAfDrive = 0x90C1;
int const NikonChangeCameraMode = 0x90C2;
int const NikonDeleteImagesInSdram = 0x90C3;
int const NikonGetLargeThumb = 0x90C4;
int const NikonGetEvent = 0x90C7;
int const NikonDeviceReady = 0x90C8;
int const NikonSetPreWbData = 0x90C9;
int const NikonGetVendorPropCodes = 0x90CA;
int const NikonAfAndCaptureInSdram = 0x90CB;
int const NikonGetPicCtrlData = 0x90CC;
int const NikonSetPicCtrlData = 0x90CD;
int const NikonDeleteCustomPicCtrl = 0x90CE;
int const NikonGetPicCtrlCapability = 0x90CF;
int const NikonGetPreviewImage = 0x9200;
int const NikonStartLiveView = 0x9201;
int const NikonEndLiveView = 0x9202;
int const NikonGetLiveViewImage = 0x9203;
int const NikonMfDrive = 0x9204;
int const NikonChangeAfArea = 0x9205;
int const NikonAfDriveCancel = 0x9206;
int const NikonInitiateCaptureRecInMedia = 0x9207;
int const NikonGetObjectPropsSupported = 0x9801;
int const NikonGetObjectPropDesc = 0x9802;
int const NikonGetObjectPropValue = 0x9803;
int const NikonGetObjectPropList = 0x9805;

// Canon EOS
int const EosTakePicture = 0x910F;
int const EosSetDevicePropValue = 0x9110;
int const EosSetPCConnectMode = 0x9114;
int const EosSetEventMode = 0x9115;
int const EosEventCheck = 0x9116;
int const EosTransferComplete = 0x9117;
int const EosResetTransfer = 0x9119;
int const EosBulbStart = 0x9125;
int const EosBulbEnd = 0x9126;
int const EosGetDevicePropValue = 0x9127;
int const EosRemoteReleaseOn = 0x9128;
int const EosRemoteReleaseOff = 0x9129;
int const EosGetLiveViewPicture = 0x9153;
int const EosDriveLens = 0x9155;

int const EosCameraRecordON = 0x9133;
int const EosCameraRecordOFF = 0x9134;

