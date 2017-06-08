//
//  KXAddPotoView.h
//  ObserveTestDemo
//
//  Created by kuxing on 16-12-20.
//  Copyright (c) 2016年 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define Xpadding        15
//#define DeleButton_W    20
//#define ImageWith       ([[UIScreen mainScreen] bounds].size.width - Xpadding*5)/4.0
//#define PhotoView_W     (ImageWith + DeleButton_W/2.0)

#define Xpadding        15
#define DeleButton_W    30
#define ImageWith       ([[UIScreen mainScreen] bounds].size.width - Xpadding*4)/3.0
#define PhotoView_W     (ImageWith + DeleButton_W/2.0)


@protocol KXAddPotoViewDelegate;
@interface KXAddPotoView : UIView

@property (nonatomic, assign) id<KXAddPotoViewDelegate> delegate;
@property (nonatomic, assign) NSInteger             index;
@property (nonatomic, assign) BOOL                  isCamera;
@property (nonatomic, strong) UIImageView           *photoView;
//@property (nonatomic, strong) UILabel               *photoLabel;
@property (nonatomic, strong) UIImage               *image;
@property (nonatomic, copy)  NSString               *imageTitle;
@property (nonatomic, strong) NSMutableDictionary   *photosInfoDic;
@property (nonatomic, strong) NSMutableDictionary   *photoInfoData;
@property (nonatomic, assign) BOOL                  isMain;
@property (nonatomic, assign, readonly) BOOL        inLoading;

@property (nonatomic, strong) UIImage               *btnBGImage;
+ (CGRect)photoFrameWithIndex:(NSInteger)index;
- (void)doDelete;
- (void)startLoading;
- (void)stopLoading;

@end

@protocol KXAddPotoViewDelegate <NSObject>

- (void)KXAddPotoView:(KXAddPotoView *)addPhotoView deletePhotoAtIndex:(NSInteger)index;
- (void)KXAddPotoView:(KXAddPotoView *)addPhotoView selectedPhotoAtIndex:(NSInteger)index;
- (void)KXAddPotoViewCameraAddPhoto:(KXAddPotoView *)addPhotoView;

@end
