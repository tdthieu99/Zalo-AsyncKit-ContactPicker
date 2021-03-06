//
//  UIImage+Addtions.m
//  AsyncKit ContactPicker
//
//  Created by Trần Đình Tôn Hiếu on 5/8/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIImage+Addtions.h"

@implementation UIImage (Additions)

- (UIImage *)makeCircularImageWithSize:(CGSize)size {
  CGRect circleRect = (CGRect) {CGPointZero, size};
  UIGraphicsBeginImageContextWithOptions(circleRect.size, NO, 0);

  UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:circleRect cornerRadius:circleRect.size.width/2];
  [circle addClip];

  [self drawInRect:circleRect];
    
  UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();

  return roundedImage;
}

@end

