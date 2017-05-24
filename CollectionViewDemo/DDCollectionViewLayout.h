//
//  DDCollectionViewLayout.h
//  CollectionViewDemo
//
//  Created by 张桂杨 on 2017/4/27.
//  Copyright © 2017年 DD. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const DDUICollectionElementKindSectionHeader;
UIKIT_EXTERN NSString *const DDUICollectionElementKindSectionFooter;

@class DDCollectionViewLayout;

@protocol DDCollectionViewLayoutDelegate <NSObject>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(DDCollectionViewLayout *)layout heightOfItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;


@end

@interface DDCollectionViewLayout : UICollectionViewLayout
@property (assign, nonatomic) NSInteger numberOfColumns;
@property (assign, nonatomic) CGFloat columnSpacing;
@property (assign, nonatomic) CGFloat rowSpacing;
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@property (assign, nonatomic) CGFloat headerViewHeight;//头视图的高度
@property (assign, nonatomic) CGFloat footViewHeight;//尾视图的高度

@property(nonatomic, weak) id<DDCollectionViewLayoutDelegate> delegate;
@end
