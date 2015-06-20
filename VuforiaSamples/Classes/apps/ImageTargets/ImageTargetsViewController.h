#import <UIKit/UIKit.h>
#import "ImageTargetsEAGLView.h"
#import "SampleApplicationSession.h"
#import <QCAR/DataSet.h>

@interface ImageTargetsViewController : UIViewController <SampleApplicationControl>{
    CGRect viewFrame;
    ImageTargetsEAGLView* eaglView;
    QCAR::DataSet*  dataSetCurrent;
    QCAR::DataSet*  dataSetStonesAndChips;
    SampleApplicationSession * vapp;
    
    BOOL switchToTarmac;
    BOOL switchToStonesAndChips;
    BOOL extendedTrackingIsOn;
    
}

@end
