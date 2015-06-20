/*===============================================================================
Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

#import <Foundation/Foundation.h>
#import <QCAR/Matrices.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/State.h>

#define E_INITIALIZING_QCAR         100

#define E_INITIALIZING_CAMERA       110
#define E_STARTING_CAMERA           111
#define E_STOPPING_CAMERA           112
#define E_DEINIT_CAMERA             113

#define E_INIT_TRACKERS             120
#define E_LOADING_TRACKERS_DATA     121
#define E_STARTING_TRACKERS         122
#define E_STOPPING_TRACKERS         123
#define E_UNLOADING_TRACKERS_DATA   124
#define E_DEINIT_TRACKERS           125

#define E_CAMERA_NOT_STARTED        150

#define E_INTERNAL_ERROR                -1


@protocol SampleApplicationControl

@required
- (void) onInitARDone:(NSError *)error;
- (bool) doInitTrackers;
- (bool) doLoadTrackersData;
- (bool) doStartTrackers;
//- (bool) doStopTrackers;
//- (bool) doUnloadTrackersData;
//- (bool) doDeinitTrackers;

@optional
- (void) onQCARUpdate: (QCAR::State *) state;

@end

@interface SampleApplicationSession : NSObject

- (id)initWithDelegate:(id<SampleApplicationControl>) delegate;
- (void) initAR:(int) QCARInitFlags ARViewBoundsSize:(CGSize) ARViewBoundsSize orientation:(UIInterfaceOrientation) ARViewOrientation;
- (bool) startAR:(QCAR::CameraDevice::CAMERA) camera error:(NSError **)error;
//- (bool) pauseAR:(NSError **)error;
//- (bool) resumeAR:(NSError **)error;
//- (bool) stopAR:(NSError **)error;
//- (bool) stopCamera:(NSError **)error;

@property (nonatomic, readwrite) BOOL isRetinaDisplay;
@property (nonatomic, readwrite) BOOL cameraIsStarted;
@property (nonatomic, readwrite) QCAR::Matrix44F projectionMatrix;


@property (nonatomic, readwrite) struct tagViewport {
  int posX;
  int posY;
  int sizeX;
  int sizeY;
} viewport;

@end
