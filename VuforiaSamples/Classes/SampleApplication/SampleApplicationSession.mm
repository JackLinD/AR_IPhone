/*===============================================================================
Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

#import "SampleApplicationSession.h"
#import <QCAR/QCAR.h>
#import <QCAR/QCAR_iOS.h>
#import <QCAR/Tool.h>
#import <QCAR/Renderer.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/VideoBackgroundConfig.h>
#import <QCAR/UpdateCallback.h>

namespace {
    SampleApplicationSession* instance = nil;
    
    int mQCARInitFlags;
    QCAR::CameraDevice::CAMERA mCamera = QCAR::CameraDevice::CAMERA_DEFAULT;
    class VuforiaApplication_UpdateCallback : public QCAR::UpdateCallback {
        virtual void QCAR_onUpdate(QCAR::State& state);
    } qcarUpdate;
}

@interface SampleApplicationSession ()

@property (nonatomic, readwrite) CGSize mARViewBoundsSize;
@property (nonatomic, readwrite) UIInterfaceOrientation mARViewOrientation;
@property (nonatomic, readwrite) BOOL mIsActivityInPortraitMode;
@property (nonatomic, readwrite) BOOL cameraIsActive;
@property (nonatomic, assign) id delegate;

@end


@implementation SampleApplicationSession
@synthesize viewport;

- (id)initWithDelegate:(id<SampleApplicationControl>) delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        instance = self;
        QCAR::registerCallback(&qcarUpdate);
    }
    return self;
}

- (void)dealloc
{
    instance = nil;
    [self setDelegate:nil];
    [super dealloc];
}
- (BOOL)isRetinaDisplay
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && 2.0 == [UIScreen mainScreen].scale);
}


- (void) initAR:(int) QCARInitFlags ARViewBoundsSize:(CGSize) ARViewBoundsSize orientation:(UIInterfaceOrientation) ARViewOrientation {
    self.cameraIsActive = NO;
    self.cameraIsStarted = NO;
    mQCARInitFlags = QCARInitFlags;
    self.isRetinaDisplay = [self isRetinaDisplay];
    self.mARViewOrientation = ARViewOrientation;
    self.mARViewBoundsSize = ARViewBoundsSize;
    [self performSelectorInBackground:@selector(initQCARInBackground) withObject:nil];
}


- (void)initQCARInBackground
{

    @autoreleasepool {
        QCAR::setInitParameters(mQCARInitFlags);
        NSInteger initSuccess = 0;
        do {
            initSuccess = QCAR::init();
        } while (0 <= initSuccess && 100 > initSuccess);
        [self performSelectorOnMainThread:@selector(prepareAR) withObject:nil waitUntilDone:NO];
    }
}
- (void) QCAR_onUpdate:(QCAR::State *) state {
    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(onQCARUpdate:)]) {
        [self.delegate onQCARUpdate:state];
    }
}

- (void) prepareAR  {
    QCAR::onSurfaceCreated();
    
    
    if (self.mARViewOrientation == UIInterfaceOrientationPortrait)
    {
        QCAR::onSurfaceChanged(self.mARViewBoundsSize.width, self.mARViewBoundsSize.height);
        QCAR::setRotation(QCAR::ROTATE_IOS_90);
        
        self.mIsActivityInPortraitMode = YES;
    }
    else if (self.mARViewOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        QCAR::onSurfaceChanged(self.mARViewBoundsSize.width, self.mARViewBoundsSize.height);
        QCAR::setRotation(QCAR::ROTATE_IOS_270);
        
        self.mIsActivityInPortraitMode = YES;
    }
    else if (self.mARViewOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        QCAR::onSurfaceChanged(self.mARViewBoundsSize.height, self.mARViewBoundsSize.width);
        QCAR::setRotation(QCAR::ROTATE_IOS_180);
        
        self.mIsActivityInPortraitMode = NO;
    }
    else if (self.mARViewOrientation == UIInterfaceOrientationLandscapeRight)
    {
        QCAR::onSurfaceChanged(self.mARViewBoundsSize.height, self.mARViewBoundsSize.width);
        QCAR::setRotation(1);
        
        self.mIsActivityInPortraitMode = NO;
    }
    

    [self initTracker];
}

- (void) initTracker {
    [self.delegate doInitTrackers];
//        [self.delegate onInitARDone:[self NSErrorWithCode:E_INIT_TRACKERS]];
//        return;
//    }
    [self loadTrackerData];
}


- (void) loadTrackerData {
    [self performSelectorInBackground:@selector(loadTrackerDataInBackground) withObject:nil];
    
}

- (void)loadTrackerDataInBackground
{
    // Background thread must have its own autorelease pool
    @autoreleasepool {
        // the application can now prepare the loading of the data
        [self.delegate doLoadTrackersData];
    }
    
    [self.delegate onInitARDone:nil];
}

// Configure QCAR with the video background size
- (void)configureVideoBackgroundWithViewWidth:(float)viewWidth andHeight:(float)viewHeight
{
    QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
    QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    QCAR::VideoBackgroundConfig config;
    config.mEnabled = true;
    config.mSynchronous = true;
    config.mPosition.data[0] = 0.0f;
    config.mPosition.data[1] = 0.0f;
    if (self.mIsActivityInPortraitMode) {
        float aspectRatioVideo = (float)videoMode.mWidth / (float)videoMode.mHeight;
        float aspectRatioView = viewHeight / viewWidth;
        
        if (aspectRatioVideo < aspectRatioView) {
            config.mSize.data[0] = (int)videoMode.mHeight * (viewHeight / (float)videoMode.mWidth);
            config.mSize.data[1] = (int)viewHeight;
        }
        else {
            config.mSize.data[0] = (int)viewWidth;
            config.mSize.data[1] = (int)videoMode.mWidth * (viewWidth / (float)videoMode.mHeight);
        }
    }
    else {
        float temp = viewWidth;
        viewWidth = viewHeight;
        viewHeight = temp;
        float aspectRatioVideo = (float)videoMode.mWidth / (float)videoMode.mHeight;
        float aspectRatioView = viewWidth / viewHeight;
        
        if (aspectRatioVideo < aspectRatioView) {
            config.mSize.data[0] = (int)viewWidth;
            config.mSize.data[1] = (int)videoMode.mHeight * (viewWidth / (float)videoMode.mWidth);
        }
        else {
            config.mSize.data[0] = (int)videoMode.mWidth * (viewHeight / (float)videoMode.mHeight);
            config.mSize.data[1] = (int)viewHeight;
        }
    }
    viewport.posX = ((viewWidth - config.mSize.data[0]) / 2) + config.mPosition.data[0];
    viewport.posY = (((int)(viewHeight - config.mSize.data[1])) / (int) 2) + config.mPosition.data[1];
    viewport.sizeX = config.mSize.data[0];
    viewport.sizeY = config.mSize.data[1];
 
#ifdef DEBUG_SAMPLE_APP
    NSLog(@"VideoBackgroundConfig: size: %d,%d", config.mSize.data[0], config.mSize.data[1]);
    NSLog(@"VideoMode:w=%d h=%d", videoMode.mWidth, videoMode.mHeight);
    NSLog(@"width=%7.3f height=%7.3f", viewWidth, viewHeight);
    NSLog(@"ViewPort: X,Y: %d,%d Size X,Y:%d,%d", viewport.posX,viewport.posY,viewport.sizeX,viewport.sizeY);
#endif
    
    QCAR::Renderer::getInstance().setVideoBackgroundConfig(config);
    NSLog(@"我在这里");
}

- (bool)startCamera:(QCAR::CameraDevice::CAMERA)camera viewWidth:(float)viewWidth andHeight:(float)viewHeight error:(NSError **)error
{
    QCAR::CameraDevice::getInstance().init(camera);
    QCAR::CameraDevice::getInstance().start();
    mCamera = camera;
    [self.delegate doStartTrackers];
    [self configureVideoBackgroundWithViewWidth:viewWidth andHeight:viewHeight];
    const QCAR::CameraCalibration& cameraCalibration = QCAR::CameraDevice::getInstance().getCameraCalibration();
    _projectionMatrix = QCAR::Tool::getProjectionGL(cameraCalibration, 2.0f, 5000.0f);
    return YES;
}


- (bool) startAR:(QCAR::CameraDevice::CAMERA)camera error:(NSError **)error {
    [self startCamera: camera viewWidth:self.mARViewBoundsSize.width andHeight:self.mARViewBoundsSize.height error:error];
    self.cameraIsActive = YES;
    self.cameraIsStarted = YES;
    return YES;
}
void VuforiaApplication_UpdateCallback::QCAR_onUpdate(QCAR::State& state)
{
    if (instance != nil) {
        [instance QCAR_onUpdate:&state];
    }
}

@end
