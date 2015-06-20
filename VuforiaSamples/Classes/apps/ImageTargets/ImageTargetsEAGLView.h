#import <UIKit/UIKit.h>

#import <QCAR/UIGLViewProtocol.h>

#import "Texture.h"
#import "SampleApplicationSession.h"
//#import "SampleApplication3DModel.h"


#define NUM_AUGMENTATION_TEXTURES 1


@interface ImageTargetsEAGLView : UIView <UIGLViewProtocol> {
@private
    EAGLContext *context;
    GLuint defaultFramebuffer;
    GLuint colorRenderbuffer;
    GLuint depthRenderbuffer;
    GLuint shaderProgramID;
    GLint vertexHandle;
    GLint normalHandle;
    GLint textureCoordHandle;
    GLint mvpMatrixHandle;
    GLint texSampler2DHandle;
    NSMutableArray *objects3D; 
    
    Texture* augmentationTexture[NUM_AUGMENTATION_TEXTURES];

    SampleApplicationSession * vapp;
}

- (id)initWithFrame:(CGRect)frame appSession:(SampleApplicationSession *) app;

- (void)finishOpenGLESCommands;
- (void)freeOpenGLESResources;

//- (void) setOffTargetTrackingMode:(BOOL) enabled;
@end
