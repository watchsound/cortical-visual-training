//
//  ImageProcessor.m
//  SpookCam
//
//  Created by Jack Wu on 2/21/2014.
//
//

#import "ImageProcessor.h"

@interface ImageProcessor ()

@end

@implementation ImageProcessor

@synthesize strokeWidth = _strokeWidth;

+ (instancetype)sharedProcessor {
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
     ((ImageProcessor*) sharedInstance).strokeWidth = 2;
  });
  
  return sharedInstance;
}

#pragma mark - Public

- (UIImage*)processImage:(UIImage*)inputImage  overlay:(UIImage*)overlay  alpha:(UInt32)overlayAlpha{
    return [self processUsingPixels:inputImage overlay:overlay alpha: overlayAlpha];
}

#pragma mark - Private

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )
- (UIImage *)processUsingPixels:(UIImage*)inputImage  overlay:(UIImage*)ghostImage alpha:(UInt32)overlayAlpha{
  
  // 1. Get the raw pixels of the image
  UInt32 * inputPixels;
  
  CGImageRef inputCGImage = [inputImage CGImage];
  NSUInteger inputWidth = CGImageGetWidth(inputCGImage);
  NSUInteger inputHeight = CGImageGetHeight(inputCGImage);
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  NSUInteger bytesPerPixel = 4;
  NSUInteger bitsPerComponent = 8;
  
  NSUInteger inputBytesPerRow = bytesPerPixel * inputWidth;
  
  inputPixels = (UInt32 *)calloc(inputHeight * inputWidth, sizeof(UInt32));
  
  CGContextRef context = CGBitmapContextCreate(inputPixels, inputWidth, inputHeight,
                                               bitsPerComponent, inputBytesPerRow, colorSpace,
                                               kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  
  CGContextDrawImage(context, CGRectMake(0, 0, inputWidth, inputHeight), inputCGImage);
  
  // 2. Blend the ghost onto the image
  CGImageRef ghostCGImage = [ghostImage CGImage];
  
//  // 2.1 Calculate the size & position of the ghost
//  CGFloat ghostImageAspectRatio = ghostImage.size.width / ghostImage.size.height;
//  NSInteger targetGhostWidth = inputWidth * 0.25;
//  CGSize ghostSize = CGSizeMake(targetGhostWidth, targetGhostWidth / ghostImageAspectRatio);
//  CGPoint ghostOrigin = CGPointMake(inputWidth * 0.5, inputHeight * 0.2);
//  
//  // 2.2 Scale & Get pixels of the ghost
//  NSUInteger ghostBytesPerRow = bytesPerPixel * ghostSize.width;
//  
//  UInt32 * ghostPixels = (UInt32 *)calloc(ghostSize.width * ghostSize.height, sizeof(UInt32));
//  
//  CGContextRef ghostContext = CGBitmapContextCreate(ghostPixels, ghostSize.width, ghostSize.height,
//                                                    bitsPerComponent, ghostBytesPerRow, colorSpace,
//                                                    kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//  
//  CGContextDrawImage(ghostContext, CGRectMake(0, 0, ghostSize.width, ghostSize.height),ghostCGImage);
  
    //hanning - we dont scale here..
     CGSize ghostSize =  ghostImage.size;
     CGPoint ghostOrigin = CGPointMake(0, 0);
     NSUInteger ghostBytesPerRow = bytesPerPixel * ghostSize.width;
     UInt32 * ghostPixels = (UInt32 *)calloc(ghostSize.width * ghostSize.height, sizeof(UInt32));
     CGContextRef ghostContext = CGBitmapContextCreate(ghostPixels, ghostSize.width, ghostSize.height,
                                                       bitsPerComponent, ghostBytesPerRow, colorSpace,
                                                       kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
     CGContextDrawImage(ghostContext, CGRectMake(0, 0, ghostSize.width, ghostSize.height),ghostCGImage);

    
    
  // 2.3 Blend each pixel
    NSUInteger threshold = 250;
    
  NSUInteger offsetPixelCountForInput = ghostOrigin.y * inputWidth + ghostOrigin.x;
  for (NSUInteger j = 1; j < ghostSize.height-2; j++) {
    for (NSUInteger i = 1; i < ghostSize.width -2; i++) {
      UInt32 * inputPixel = inputPixels + j * inputWidth + i + offsetPixelCountForInput;
      UInt32 inputColor = *inputPixel;
      
      UInt32 * ghostPixel = ghostPixels + j * (int)ghostSize.width + i;
      UInt32 ghostColor = *ghostPixel;
      
        UInt32 gr =   R(ghostColor);
        UInt32 gg =   G(ghostColor);
        UInt32 gb =   B(ghostColor);
        
        
        // 00 01 02
        // 10 11 12
        // 20 21 22  //11 is the current point
        if ( gr > threshold && gg > threshold && gb > threshold ){
            
            *inputPixel = RGBAMake(255, 0, 0, overlayAlpha);
            
            if ( _strokeWidth == 1 ){
                
            } else {
                UInt32 * inputPixel00 = inputPixels + (j-1) * inputWidth + i -1 + offsetPixelCountForInput;
                UInt32 * inputPixel01 = inputPixels + (j-1) * inputWidth + i   + offsetPixelCountForInput;
                UInt32 * inputPixel10 = inputPixels + j * inputWidth + i -1   + offsetPixelCountForInput;
               
                 *inputPixel00 = RGBAMake(255, 0, 0, overlayAlpha);
                 *inputPixel01 = RGBAMake(255, 0, 0, overlayAlpha);
                 *inputPixel10 = RGBAMake(255, 0, 0, overlayAlpha);
                
                if ( _strokeWidth > 2 ){
                    UInt32 * inputPixel12 = inputPixels + j * inputWidth + i +1   + offsetPixelCountForInput;
                    UInt32 * inputPixel21 = inputPixels + (j+1) * inputWidth + i   + offsetPixelCountForInput;
                    UInt32 * inputPixel02 = inputPixels + (j-1) * inputWidth + i +1   + offsetPixelCountForInput;
                    *inputPixel02 = RGBAMake(255, 0, 0, overlayAlpha);
                    *inputPixel12 = RGBAMake(255, 0, 0, overlayAlpha);
                    UInt32 * inputPixel20 = inputPixels + (j+1) * inputWidth + i -1 + offsetPixelCountForInput;
                    *inputPixel20 = RGBAMake(255, 0, 0, overlayAlpha);
                    *inputPixel21 = RGBAMake(255, 0, 0, overlayAlpha);
                    UInt32 * inputPixel22 = inputPixels + (j+1) * inputWidth + i +1   + offsetPixelCountForInput;
                    *inputPixel22 = RGBAMake(255, 0, 0, overlayAlpha);
                    
                }
            }
        }
  
    }
  }
  

  // 4. Create a new UIImage
  CGImageRef newCGImage = CGBitmapContextCreateImage(context);
  UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];
  
  // 5. Cleanup!
  CGColorSpaceRelease(colorSpace);
  CGContextRelease(context);
  CGContextRelease(ghostContext);
    
  CGImageRelease(newCGImage);
  //  CGImageRelease(inputCGImage);
     // CGImageRelease(ghostCGImage);
  free(inputPixels);
  free(ghostPixels);
  
  return processedImage;
}
#undef RGBAMake
#undef R
#undef G
#undef B
#undef A
#undef Mask8

#pragma mark Helpers


@end
