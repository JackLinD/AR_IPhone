/*===============================================================================
Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.
 
Confidential and Proprietary - Qualcomm Connected Experiences, Inc.
Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

#import "SampleApplicationShaderUtils.h"

@implementation SampleApplicationShaderUtils

+ (GLuint)compileShader:(NSString*)shaderFileName withType:(GLenum)shaderType {
    NSString* shaderName = [[shaderFileName lastPathComponent] stringByDeletingPathExtension];
    NSString* shaderFileType = [shaderFileName pathExtension];
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:shaderFileType];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    GLuint shaderHandle = glCreateShader(shaderType);
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    glCompileShader(shaderHandle);
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    return shaderHandle;
    
}

+ (int)createProgramWithVertexShaderFileName:(NSString*) vertexShaderFileName
                      fragmentShaderFileName:(NSString *) fragmentShaderFileName {
    GLuint vertexShader = [self compileShader:vertexShaderFileName withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:fragmentShaderFileName withType:GL_FRAGMENT_SHADER];
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    return programHandle;
}


@end
