//
//  KXPhotoBrower.h
//  ObserveTestDemo
//
//  Created by kuxing on 16-12-20.
//  Copyright (c) 2016年 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KXAddPotoView.h"

#define MaxNumberOfPhoto 80

typedef NS_ENUM(NSInteger, KXPhotoBrowerType)
{
    KXPhotoBrowerTypeDefault,
    KXPhotoBrowerTypeNotMain,
    KXPhotoBrowerTypeWater
};

@protocol KXPhotoBrowerDelegate;
@interface KXPhotoBrower : UIView

@property (nonatomic, assign) id<KXPhotoBrowerDelegate> delegate;
@property (nonatomic, assign) KXPhotoBrowerType type;
@property (nonatomic, assign) NSInteger maxNumberOfPhoto;
@property (nonatomic, strong, readonly) NSMutableArray *photoArrays;
@property (nonatomic, assign, readonly, getter=isLoading) BOOL inLoading;
@property (nonatomic, assign) int  photoNUm;

- (id)initWithFrame:(CGRect)frame withType:(KXPhotoBrowerType)type;
+ (float)getPhotoViewHeightWithNumber:(NSInteger)number;
- (void)reloadPhotosDic:(NSMutableArray *)photos;
- (void)addPhotoViewWithURL:(NSString *)urlString withImgTitle:(NSString *)imgTitle;
- (KXAddPotoView *)addPhotoWithImage:(UIImage *)image withImgTitle:(NSString *)imgTitle;
- (void)deletePhotoAtIndex:(NSInteger)index;
- (float)photoCount;
- (void)reset;

@end

@protocol KXPhotoBrowerDelegate <NSObject>

- (void)KXPhotoBrowerClickCamera:(KXPhotoBrower *)photoBrower;
- (void)KXPhotoBrower:(KXPhotoBrower *)photoBrower selectedPhotoView:(KXAddPotoView *)photoView atIndex:(NSInteger)index;
//- (void)KXPhotoBrower:(KXPhotoBrower *)photoBrower deletePhotoAtIndex:(NSInteger)index;

- (void)KXPhotoBrower:(KXPhotoBrower *)photoBrower deletePhotoAtIndex:(NSInteger)index;

@end
