//
//  LHSocketOperation.h
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/6/5.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN int const UndefinedOperationCode;
UIKIT_EXTERN int const GetDeviceInfo;
UIKIT_EXTERN int const OpenSession;
UIKIT_EXTERN int const CloseSession;
UIKIT_EXTERN int const GetStorageIDs;
UIKIT_EXTERN int const GetStorageInfo;
UIKIT_EXTERN int const GetNumObjects;
UIKIT_EXTERN int const GetObjectHandles;
UIKIT_EXTERN int const GetObjectInfo;
UIKIT_EXTERN int const GetObject;
UIKIT_EXTERN int const GetThumb;
UIKIT_EXTERN int const DeleteObject;
UIKIT_EXTERN int const SendObjectInfo;
UIKIT_EXTERN int const SendObject;
UIKIT_EXTERN int const InitiateCapture;
UIKIT_EXTERN int const FormatStore;
UIKIT_EXTERN int const ResetDevice;
UIKIT_EXTERN int const SelfTest;
UIKIT_EXTERN int const SetObjectProtection;
UIKIT_EXTERN int const PowerDown;
UIKIT_EXTERN int const GetDevicePropDesc;
UIKIT_EXTERN int const GetDevicePropValue;
UIKIT_EXTERN int const SetDevicePropValue;
UIKIT_EXTERN int const ResetDevicePropValue;
UIKIT_EXTERN int const TerminateOpenCapture;
UIKIT_EXTERN int const MoveObject;
UIKIT_EXTERN int const CopyObject;
UIKIT_EXTERN int const GetPartialObject;
UIKIT_EXTERN int const InitiateOpenCapture;

UIKIT_EXTERN int const NikonInitiateCaptureRecInSdram;
UIKIT_EXTERN int const NikonAfDrive;
UIKIT_EXTERN int const NikonChangeCameraMode;
UIKIT_EXTERN int const NikonDeleteImagesInSdram;
UIKIT_EXTERN int const NikonGetLargeThumb;
UIKIT_EXTERN int const NikonGetEvent;
UIKIT_EXTERN int const NikonDeviceReady;
UIKIT_EXTERN int const NikonSetPreWbData;
UIKIT_EXTERN int const NikonGetVendorPropCodes;
UIKIT_EXTERN int const NikonAfAndCaptureInSdram;
UIKIT_EXTERN int const NikonGetPicCtrlData;
UIKIT_EXTERN int const NikonSetPicCtrlData;
UIKIT_EXTERN int const NikonDeleteCustomPicCtrl;
UIKIT_EXTERN int const NikonGetPicCtrlCapability;
UIKIT_EXTERN int const NikonGetPreviewImage;
UIKIT_EXTERN int const NikonStartLiveView;
UIKIT_EXTERN int const NikonEndLiveView;
UIKIT_EXTERN int const NikonGetLiveViewImage;
UIKIT_EXTERN int const NikonMfDrive;
UIKIT_EXTERN int const NikonChangeAfArea;
UIKIT_EXTERN int const NikonAfDriveCancel;
UIKIT_EXTERN int const NikonInitiateCaptureRecInMedia;
UIKIT_EXTERN int const NikonGetObjectPropsSupported;
UIKIT_EXTERN int const NikonGetObjectPropDesc;
UIKIT_EXTERN int const NikonGetObjectPropValue;
UIKIT_EXTERN int const NikonGetObjectPropList;

// Canon EOS
UIKIT_EXTERN int const EosTakePicture;
UIKIT_EXTERN int const EosSetDevicePropValue;
UIKIT_EXTERN int const EosSetPCConnectMode;
UIKIT_EXTERN int const EosSetEventMode;
UIKIT_EXTERN int const EosEventCheck;
UIKIT_EXTERN int const EosTransferComplete;
UIKIT_EXTERN int const EosResetTransfer;
UIKIT_EXTERN int const EosBulbStart;
UIKIT_EXTERN int const EosBulbEnd;
UIKIT_EXTERN int const EosGetDevicePropValue;
UIKIT_EXTERN int const EosRemoteReleaseOn;
UIKIT_EXTERN int const EosRemoteReleaseOff;
UIKIT_EXTERN int const EosGetLiveViewPicture;
UIKIT_EXTERN int const EosDriveLens;

UIKIT_EXTERN int const EosCameraRecordON;
UIKIT_EXTERN int const EosCameraRecordOFF;
