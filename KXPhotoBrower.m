//
//  KXPhotoBrower.m
//  ObserveTestDemo
//
//  Created by kuxing on 16-12-20.
//  Copyright (c) 2016年 Yang. All rights reserved.
//

#import "KXPhotoBrower.h"
#import "UIImageView+WebCache.h"

@interface KXPhotoBrower ()<KXAddPotoViewDelegate>
{
    NSMutableArray *usedPhotos;
    NSMutableArray *unUsedPhotos;
    
}

@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation KXPhotoBrower

- (id)initWithFrame:(CGRect)frame withType:(KXPhotoBrowerType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        usedPhotos = [[NSMutableArray alloc] init];
        unUsedPhotos = [[NSMutableArray alloc] init];
        _photoArrays = [[NSMutableArray alloc] init];
        _maxNumberOfPhoto = MaxNumberOfPhoto;
        self.type = type;
        
        for (int i=0; i<self.maxNumberOfPhoto+1; i++)
        {
            KXAddPotoView *photoView = [[KXAddPotoView alloc] initWithFrame:CGRectZero];
            photoView.delegate = self;
            if (self.type == KXPhotoBrowerTypeWater)
            {
                photoView.btnBGImage = [UIImage imageNamed:@"img_add_water"];
            }
            else
            {
                photoView.btnBGImage = [UIImage imageNamed:@"djsc_icon"];
                
            }
            [unUsedPhotos addObject:photoView];
            [self addSubview:photoView];
        }
        
        [self loadPhotos];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        usedPhotos = [[NSMutableArray alloc] init];
        unUsedPhotos = [[NSMutableArray alloc] init];
        _photoArrays = [[NSMutableArray alloc] init];
        _maxNumberOfPhoto = MaxNumberOfPhoto;
        
        for (int i=0; i<self.maxNumberOfPhoto+1; i++)
        {
            KXAddPotoView *photoView = [[KXAddPotoView alloc] initWithFrame:CGRectZero];
            photoView.delegate = self;
            [unUsedPhotos addObject:photoView];
            [self addSubview:photoView];
        }
        
        [self loadPhotos];
    }
    return self;
}

+ (float)getPhotoViewHeightWithNumber:(NSInteger)number
{
    if (number < 0)
    {
        number = 1;
    }
//    else
//    {
//        if (number > 7)
//        {
//            number = 7;
//        }
//    }
//    float height = Xpadding + (Xpadding + ImageWith + 30) * (number / 3 + 1);
    float height = Xpadding + (Xpadding + ImageWith ) * (number / 3 + 1) +10;

    return height;
}

- (void)reloadPhotosDic:(NSMutableArray *)photos
{
    _photos = photos;
    [self reset];
}

- (void)reset
{
    [self resetArrays];
    [self loadPhotos];
}

- (void)resetArrays
{
    if (!usedPhotos) return;
    NSInteger count = usedPhotos.count;
    [_photoArrays removeAllObjects];
    
    for (int i=0; i<count; i++)
    {
        KXAddPotoView *photoView = usedPhotos[count - i - 1];
        [photoView stopLoading];
        photoView.hidden = YES;
        [unUsedPhotos addObject:photoView];
        [usedPhotos removeObject:photoView];
    }
}

- (void)loadPhotos
{
    
    NSInteger count = MIN(self.photos.count+1, self.maxNumberOfPhoto+1);
    count = 1;
    
    for (int i=0; i<count; i++)
    {
        KXAddPotoView *photoView = [unUsedPhotos lastObject];
        
        if (photoView)
        {
            [unUsedPhotos removeObject:photoView];
            photoView.index = i;
            [usedPhotos addObject:photoView];
            
            if (i == count - 1)
            {
                photoView.isCamera = YES;
                photoView.isMain = NO;
            }else
            {
                photoView.isMain = (i == 0) && (self.type == KXPhotoBrowerTypeDefault);
                photoView.isCamera = NO;
                UIImage *image = self.photos[i];
                [_photoArrays addObject:photoView];
                photoView.image = image;
            }
            
        }else break;
        
    }
    
    [self checkIsMaxNumber];
}

- (BOOL)isLoading
{
    for (int i=0; i<usedPhotos.count; i++)
    {
        KXAddPotoView *photoView = usedPhotos[i];
        if (photoView.inLoading == YES) return YES;
    }
    return NO;
}

- (void)checkIsMaxNumber
{

    KXAddPotoView *photoView = [usedPhotos lastObject];
    
    if (usedPhotos.count == self.maxNumberOfPhoto + 1)
    {
        if (photoView.isCamera)
        {
            photoView.hidden = YES;
        }
    }else
    {
        if (photoView.isCamera)
        {
            photoView.hidden = NO;
        }
    }
}

//- (void)KXPhotoBrower:(KXPhotoBrower *)photoBrower deletePhotoAtIndex:(NSInteger)index
//{
////    KXAddPotoView *photoView = usedPhotos[index];
////    [unUsedPhotos addObject:photoView];
////    [usedPhotos removeObjectAtIndex:index];
////    [_photoArrays removeObjectAtIndex:index];
////    NSInteger count = usedPhotos.count;
////    
////    for (int i=(int)index; i<count; i++)
////    {
////        KXAddPotoView *photoView = usedPhotos[i];
////        photoView.index = i;
////    }
////    
////    [self checkIsMaxNumber];
//
//}


- (void)KXAddPotoView:(KXAddPotoView *)addPhotoView deletePhotoAtIndex:(NSInteger)index
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(KXPhotoBrower:deletePhotoAtIndex:)])
    {
        [self.delegate KXPhotoBrower:self deletePhotoAtIndex:index];
    }
    
}

- (void)deletePhotoAtIndex:(NSInteger)index
{
    KXAddPotoView *photoView = usedPhotos[index];
    photoView.image = nil;
    photoView.hidden = YES;
    [unUsedPhotos addObject:photoView];
    [usedPhotos removeObjectAtIndex:index];
    [_photoArrays removeObjectAtIndex:index];
    NSInteger count = usedPhotos.count;
    
    for (int i=(int)index; i<count; i++)
    {
        KXAddPotoView *photoView = usedPhotos[i];
        photoView.index = i;
    }
    
    [self checkIsMaxNumber];
}

- (void)KXAddPotoView:(KXAddPotoView *)addPhotoView selectedPhotoAtIndex:(NSInteger)index
{
    if (self && [self.delegate respondsToSelector:@selector(KXPhotoBrower:selectedPhotoView:atIndex:)])
    {
        [self.delegate KXPhotoBrower:self selectedPhotoView:addPhotoView atIndex:index];
    }
}

- (void)KXAddPotoViewCameraAddPhoto:(KXAddPotoView *)addPhotoView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KXPhotoBrowerClickCamera:)])
    {
        [self.delegate KXPhotoBrowerClickCamera:self];
    }
}

- (void)addPhotoViewWithURL:(NSString *)urlString withImgTitle:(NSString *)imgTitle
{
    KXAddPotoView *photoView = [unUsedPhotos lastObject];
        if (photoView)
    {
        [unUsedPhotos removeObject:photoView];
        NSInteger index = usedPhotos.count - 1;
        photoView.frame = [KXAddPotoView photoFrameWithIndex:index];
        photoView.index = index;
        photoView.isCamera = NO;
        photoView.isMain = (index == 0) && (self.type == KXPhotoBrowerTypeDefault);
        [photoView.photoView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
//        photoView.photoLabel.text = imgTitle;
        [usedPhotos insertObject:photoView atIndex:index];
        [_photoArrays insertObject:photoView atIndex:index];
        
        KXAddPotoView *cameraView = [usedPhotos lastObject];
        cameraView.index = index + 1;
    }
    [self checkIsMaxNumber];
}

- (float)photoCount
{
    return (self.maxNumberOfPhoto - unUsedPhotos.count);
}

- (KXAddPotoView *)addPhotoWithImage:(UIImage *)image withImgTitle:(NSString *)imgTitle
{
    KXAddPotoView *photoView = [unUsedPhotos lastObject];
    
//    if (self.type == KXPhotoBrowerTypeWater)
//    {
//        photoView.btnBGImage = [UIImage imageNamed:@"img_add_water"];
//    }
//    else
//    {
//        photoView.btnBGImage = [UIImage imageNamed:@"img_add"];
//        
//    }

    
    if (photoView)
    {
        [unUsedPhotos removeObject:photoView];
        NSInteger index = usedPhotos.count - 1;
        photoView.isMain = (index == 0) && (self.type == KXPhotoBrowerTypeDefault);
        photoView.frame = [KXAddPotoView photoFrameWithIndex:index];
        photoView.index = index;
        photoView.isCamera = NO;
        
        if (image)
        {
            photoView.image = image;
        
        }else
        {
            photoView.image = [UIImage imageNamed:@"send_dynamic_camera"];
        }
        
        [usedPhotos insertObject:photoView atIndex:index];
        [_photoArrays insertObject:photoView atIndex:index];
        
        KXAddPotoView *cameraView = [usedPhotos lastObject];
        cameraView.index = index + 1;
    }
    
    [self checkIsMaxNumber];
    
    return photoView;
}

@end
