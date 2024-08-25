//
//  ImageProcessor.h
//  SpookCam
//
//  Created by Jack Wu on 2/21/2014.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ImageProcessor : NSObject{
    
}

+ (instancetype)sharedProcessor;

//stroke width  1,  2 , 3   only three values... should be enum type...
@property (assign) int strokeWidth;

- (UIImage*)processImage:(UIImage*)inputImage overlay:(UIImage*)overlay  alpha:(UInt32)overlayAlpha;

@end
