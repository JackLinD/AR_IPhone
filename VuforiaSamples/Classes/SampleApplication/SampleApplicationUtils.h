/*===============================================================================
Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

#ifndef __SHADERUTILS_H__
#define __SHADERUTILS_H__


#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>



namespace SampleApplicationUtils
{
    void setRotationMatrix(float angle, float x, float y, float z, 
                           float *nMatrix);
    void translatePoseMatrix(float x, float y, float z,
                             float* nMatrix = NULL);
    void rotatePoseMatrix(float angle, float x, float y, float z, 
                          float* nMatrix = NULL);
    void scalePoseMatrix(float x, float y, float z, 
                         float* nMatrix = NULL);
    void multiplyMatrix(float *matrixA, float *matrixB, 
                        float *matrixC);
}

#endif  // __SHADERUTILS_H__
