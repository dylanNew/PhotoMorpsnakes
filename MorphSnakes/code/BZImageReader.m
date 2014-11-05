//
//  BZImageReader.m
//  MorphSnakes
//
//  Created by myname on 14-11-5.
//  Copyright (c) 2014年 Bouzou. All rights reserved.
//

#import "BZImageReader.h"

@interface BZImageReader ()
{
    CGFloat width;
    CGFloat height;
}
@end

@implementation BZImageReader

- (void)setImg:(UIImage *)img
{
    if (img == _img)
        return;
    
    self.imgPixel = nil;
    _img = img;
    width = img.size.width;
    height = img.size.height;
    
    self.imgPixel = RequestImagePixelData(_img);
}

- (void)setImgPixel:(unsigned char *)imgPixel
{
    if (_imgPixel == imgPixel)
    {
        return;
    }
    
    if (_imgPixel)
    {
        free(_imgPixel);
    }
    _imgPixel = imgPixel;
}

- (BZColorPixel *)getColorPixelAtPoint:(CGPoint)apoint
{
    int i = 4 * width * apoint.y + 4 * apoint.x;
    int r = (unsigned char)self.imgPixel[i];
    int g = (unsigned char)self.imgPixel[i+1];
    int b = (unsigned char)self.imgPixel[i+2];
    
    BZColorPixel *pixel = [[BZColorPixel alloc] initWithr:r g:g b:b a:1];
    return pixel;
    
}

- (UIColor *)getColorAtPoint:(CGPoint)apoint
{
    int i = 4 * width * apoint.y + 4 * apoint.x;
    int r = (unsigned char)self.imgPixel[i];
    int g = (unsigned char)self.imgPixel[i+1];
    int b = (unsigned char)self.imgPixel[i+2];
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

- (int)getRAtPoint:(CGPoint)apoint
{
    int i = 4 * width * apoint.y + 4 * apoint.x;
    int r = (unsigned char)self.imgPixel[i];
    return r;
}

- (int)getGAtPoint:(CGPoint)apoint
{
    int i = 4 * width * apoint.y + 4 * apoint.x;
    int g = (unsigned char)self.imgPixel[i+1];
    return g;
}

- (int)getBAtPoint:(CGPoint)apoint
{
    int i = 4 * width * apoint.y + 4 * apoint.x;
    int b = (unsigned char)self.imgPixel[i+2];
    return b;
}

+ (UIImage *)imageWithPixel:(unsigned char *)pixel
                      width:(CGFloat)w
                     height:(CGFloat)h
{
    NSInteger dataLength = w*h* 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, pixel, dataLength, NULL);

    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(w,
                                        h,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytesPerRow,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider,
                                        NULL,
                                        NO,
                                        renderingIntent);
    UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return my_Image;
}

- (UIImage *)getGrayImage
{
    for (int i = 0; i < width * height * 4; i = i + 4)
    {
        int r = (unsigned char)self.imgPixel[i];
        int g = (unsigned char)self.imgPixel[i+1];
        int b = (unsigned char)self.imgPixel[i+2];
        float gray = r * 0.2989 + g * 0.587 + b * 0.114;
//        float gray = (r+g+b)/3.0;
        self.imgPixel[i] = gray;
        self.imgPixel[i+1] = gray;
        self.imgPixel[i+2] = gray;
    }
    return [BZImageReader imageWithPixel:self.imgPixel width:width height:height];
}

#pragma mark -
// 返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
static unsigned char *RequestImagePixelData(UIImage *inImage)
{
	CGImageRef img = [inImage CGImage];
	CGSize size = [inImage size];
    //使用上面的函数创建上下文
	CGContextRef cgctx = CreateRGBABitmapContext(img);
	
	CGRect rect = {{0,0},{size.width, size.height}};
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
	CGContextDrawImage(cgctx, rect, img);
	unsigned char *data = CGBitmapContextGetData (cgctx);
    //释放上面的函数创建的上下文
	CGContextRelease(cgctx);
	return data;
}

static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)
{
	CGContextRef context = NULL;
	CGColorSpaceRef colorSpace;
	void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
	int bitmapByteCount;
	int bitmapBytesPerRow;
    
	size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
	size_t pixelsHigh = CGImageGetHeight(inImage);
    
	bitmapBytesPerRow	= (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
	colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
	//分配足够容纳图片字节数的内存空间
	bitmapData = malloc( bitmapByteCount );
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
	context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
	CGColorSpaceRelease( colorSpace );
	return context;
}

@end
