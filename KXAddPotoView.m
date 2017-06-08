//
//  KXAddPotoView.m
//  ObserveTestDemo
//
//  Created by kuxing on 16-12-20.
//  Copyright (c) 2014年 Yang. All rights reserved.
//

#import "KXAddPotoView.h"

@interface KXAddPotoView()


@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIImageView *mainPhotoMask;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation KXAddPotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.photosInfoDic = [[NSMutableDictionary alloc] init];
        self.photoInfoData = [[NSMutableDictionary alloc] init];
        
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, DeleButton_W/2.0, ImageWith, ImageWith)];
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.backgroundColor = [UIColor grayColor];
        self.photoView.layer.cornerRadius = 10;
        self.photoView.clipsToBounds = YES;
        self.photoView.userInteractionEnabled = YES;
        [self addSubview:self.photoView];
        
        self.mainPhotoMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, ImageWith-15, ImageWith, 15)];
        self.mainPhotoMask.image = [UIImage imageNamed:@"edit_image_main"];
        self.mainPhotoMask.hidden = YES;
        self.mainPhotoMask.backgroundColor = [UIColor clearColor];
        [self.photoView addSubview:self.mainPhotoMask];
        
        
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectButton.frame = self.photoView.bounds;
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"photo_click_tm"] forState:UIControlStateHighlighted];
        [self.selectButton addTarget:self action:@selector(selectPhotoView:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoView addSubview:self.selectButton];
        
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator.frame = self.photoView.bounds;
        [self.photoView addSubview:self.indicator];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.frame = CGRectMake(PhotoView_W-DeleButton_W, 0, DeleButton_W, DeleButton_W);
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"img_del"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deletePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton.backgroundColor = [UIColor clearColor];
        [self addSubview:self.deleteButton];
        self.deleteButton.hidden = YES;
        
//        self.photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.photoView.frame) + 5, ImageWith, 20)];
//        self.photoLabel.backgroundColor = [UIColor cyanColor];
//        self.photoLabel.textColor = [UIColor blackColor];
//        self.photoLabel.font = [UIFont systemFontOfSize:13];
//        self.photoLabel.text = @"";
//        self.photoLabel.hidden = YES;
//        self.photoLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:self.photoLabel];

        
        self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cameraButton.frame = CGRectMake(0, DeleButton_W/2.0, ImageWith, ImageWith);
//        [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"img_add"] forState:UIControlStateNormal];
//        [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"img_add_click"] forState:UIControlStateHighlighted];

//        [self.cameraButton setImage:[UIImage imageNamed:@"edit_image_add_click"] forState:UIControlStateHighlighted];
//        [self.cameraButton setTitle:@"点此上传" forState:UIControlStateNormal];
//        [self.cameraButton setTitleColor:[UIColor colorWithHexString:@"#00A8FF"] forState:UIControlStateNormal];
//        [self.cameraButton setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
//        [self.cameraButton setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
//        [self.cameraButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.cameraButton addTarget:self action:@selector(cameraButtonAciton:) forControlEvents:UIControlEventTouchUpInside];
        self.cameraButton.hidden = YES;
        [self addSubview:self.cameraButton];
        
        self.hidden = YES;
    }
    
    return self;
}

- (void)setBtnBGImage:(UIImage *)btnBGImage
{
    _btnBGImage = btnBGImage;
    [self.cameraButton setBackgroundImage:btnBGImage forState:UIControlStateNormal];
//    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"img_add_click"] forState:UIControlStateHighlighted];
    
}

- (void)startLoading
{
    _inLoading = YES;
    [self.indicator startAnimating];
}

- (void)stopLoading
{
    _inLoading = NO;
    [self.indicator stopAnimating];
}



- (void)setIndex:(NSInteger)index
{
//    [UIView animateWithDuration:0.3 animations:^{
        self.frame = [KXAddPotoView photoFrameWithIndex:index];
//    }];
    _index = index;
    [self.photosInfoDic setObject:[NSNumber numberWithInteger:_index] forKey:@"index"];
}

- (void)setImage:(UIImage *)image
{
    if (image)
    {
        _image = image;
        self.photoView.image = _image;
        [self.photosInfoDic setObject:_image forKey:@"image"];
    }
}

-(void)setImageTitle:(NSString *)imageTitle
{
    if (imageTitle)
    {
        _imageTitle = imageTitle;
//        self.photoLabel.text = _imageTitle;
        
    }
}

- (void)setIsCamera:(BOOL)isCamera
{
    _isCamera = isCamera;
    self.hidden = NO;
    
    if (_isCamera)
    {
        self.photoView.hidden = YES;
        self.deleteButton.hidden = YES;
//        self.photoLabel.hidden   =YES;
        self.cameraButton.hidden = NO;
        self.selectButton.hidden = YES;
        
    }else
    {
        self.photoView.hidden = NO;
        self.deleteButton.hidden = NO;
//        self.photoLabel.hidden   = NO;
        self.cameraButton.hidden = YES;
        self.selectButton.hidden = NO;
    }
}

- (void)setIsMain:(BOOL)isMain
{
    _isMain = isMain;
    self.mainPhotoMask.hidden = !isMain;
}

+ (CGRect)photoFrameWithIndex:(NSInteger)index
{
//    CGRect frame= CGRectMake(Xpadding+(ImageWith+Xpadding)*(index%3), Xpadding-DeleButton_W/2.0+(ImageWith+Xpadding+30)*(index/3), PhotoView_W, PhotoView_W + 15);
    CGRect frame= CGRectMake(Xpadding+(ImageWith+Xpadding)*(index%3), Xpadding-DeleButton_W/2.0+(ImageWith+Xpadding)*(index/3), PhotoView_W, PhotoView_W);

    return frame;
}


#pragma mark - button action
- (void)cameraButtonAciton:(id)sender
{
    if (self.isCamera)
    {
        NSLog(@"点击照相机!");
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(KXAddPotoViewCameraAddPhoto:)])
    {
        [self.delegate KXAddPotoViewCameraAddPhoto:self];
    }
}

- (void)selectPhotoView:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KXAddPotoView:selectedPhotoAtIndex:)])
    {

        [self.delegate KXAddPotoView:self selectedPhotoAtIndex:self.index];
    }
}

- (void)doDelete
{
    [self deletePhotoAction:nil];
}

- (void)deletePhotoAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KXAddPotoView:deletePhotoAtIndex:)])
    {
        [self.delegate KXAddPotoView:self deletePhotoAtIndex:self.index];
    }
    
//    self.photoView.image = nil;
//    self.hidden = YES;
}

@end
