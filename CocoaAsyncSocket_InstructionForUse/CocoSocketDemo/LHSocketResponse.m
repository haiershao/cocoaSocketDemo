//
//  LHSocketResponse.m
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/6/5.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>

int const responseOk = 0x2001;
int const GeneralError = 0x2002;
int const SessionNotOpen = 0x2003;
int const InvalidTransactionID = 0x2004;
int const OperationNotSupported = 0x2005;
int const ParameterNotSupported = 0x2006;
int const IncompleteTransfer = 0x2007;
int const InvalidStorageID = 0x2008;
int const InvalidObjectHandle = 0x2009;
int const DevicePropNotSupported = 0x200A;
int const InvalidObjectFormatCode = 0x200B;
int const StoreIsFull = 0x200C;
int const ObjectWriteProtect = 0x200D;
int const StoreReadOnly = 0x200E;
int const AccessDenied = 0x200F;
int const NoThumbnailPresent = 0x2010;
int const PartialDeletion = 0x2012;
int const StoreNotAvailable = 0x2013;
int const SpecificationByFormatUnsupported = 0x2014;
int const NoValidObjectInfo = 0x2015;
int const DeviceBusy = 0x2019;
int const InvalidParentObject = 0x201A;
int const InvalidDevicePropFormat = 0x201B;
int const InvalidDevicePropValue = 0x201C;
int const InvalidParameter = 0x201D;
int const SessionAlreadyOpen = 0x201E;
int const TransferCancelled = 0x201F;
int const SpecificationOfDestinationUnsupported = 0x2020;

// Nikon ?
int const HardwareError = 0xA001;
int const OutOfFocus = 0xA002;
int const ChangeCameraModeFailed = 0xA003;
int const InvalidStatus = 0xA004;
int const SetPropertyNotSupport = 0xA005;
int const WbPresetError = 0xA006;
int const DustReferenceError = 0xA007;
int const ShutterSpeedBulb = 0xA008;
int const MirrorUpSequence = 0xA009;
int const CameraModeNotAdjustFnumber = 0xA00A;
int const NotLiveView = 0xA00B;
int const MfDriveStepEnd = 0xA00C;
int const MfDriveStepInsufficiency = 0xA00E;
int const InvalidObjectPropCode = 0xA801;
int const vInvalidObjectPropFormat = 0xA802;
int const ObjectPropNotSupported = 0xA80A;

// Canon EOS
int const EosUnknown_MirrorUp = 0xA102; // ?
