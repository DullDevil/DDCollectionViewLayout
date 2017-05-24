//
//  DDCollectionViewLayout.m
//  CollectionViewDemo
//
//  Created by 张桂杨 on 2017/4/27.
//  Copyright © 2017年 DD. All rights reserved.
//

#import "DDCollectionViewLayout.h"

NSString *const DDUICollectionElementKindSectionHeader = @"DDUICollectionElementKindSectionHeader";
NSString *const DDUICollectionElementKindSectionFooter = @"DDUICollectionElementKindSectionFooter";


@interface DDCollectionViewLayout () {
    CGFloat _itemWidth;
}
@property (strong, nonatomic) NSMutableDictionary *cellLayoutInfo;//保存cell的布局
@property (strong, nonatomic) NSMutableDictionary *headLayoutInfo;//保存头视图的布局
@property (strong, nonatomic) NSMutableDictionary *footLayoutInfo;//保存尾视图的布局

@property (assign, nonatomic) CGFloat startY;//记录开始的Y
@property (strong, nonatomic) NSMutableDictionary *maxYForColumn;//记录瀑布流每列最下面那个cell的底部y值
@property (strong, nonatomic) NSMutableArray *shouldanimationArr;//记录需要添加动画的NSIndexPath

@end


@implementation DDCollectionViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.numberOfColumns = 3;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.columnSpacing = 10;
        self.rowSpacing = 10;
        
        
        self.maxYForColumn = [NSMutableDictionary dictionary];
        self.shouldanimationArr = [NSMutableArray array];
        self.cellLayoutInfo = [NSMutableDictionary dictionary];
        self.headLayoutInfo = [NSMutableDictionary dictionary];
        self.footLayoutInfo = [NSMutableDictionary dictionary];
    }
    return self;

}
- (void)prepareLayout {
    [super prepareLayout];

    //重新布局需要清空
    [self.cellLayoutInfo removeAllObjects];
    [self.headLayoutInfo removeAllObjects];
    [self.footLayoutInfo removeAllObjects];
    [self.maxYForColumn removeAllObjects];
    self.startY = 0;
    
    CGFloat contentWidth = self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right;
    _itemWidth = (contentWidth - self.columnSpacing * (self.numberOfColumns - 1))/self.numberOfColumns;
    
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionsCount; section ++) {
        [self calSectionHeaderWithSection:section];
        [self calItemFrameWithSection:section];
        [self calSectionFooterWithSection:section];
    }
}
#pragma mark - 计算位置
#pragma mark ---cell
- (void)calItemFrameWithSection:(NSInteger)section {
    
    for (int i = 0; i < _numberOfColumns; i++) {
        self.maxYForColumn[@(i)] = @(self.startY);
    }
    
    NSInteger rowsCount = [self.collectionView numberOfItemsInSection:section];
    for (NSInteger row = 0; row < rowsCount; row++) {
        NSIndexPath *indexPath =[NSIndexPath indexPathForItem:row inSection:section];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGFloat minY  = 0;
        NSInteger shorterColumn = [self queryShorterColumn:&minY];
        
        CGFloat x = shorterColumn * _itemWidth + self.sectionInset.left + shorterColumn * self.columnSpacing;
        
        CGFloat height = [(id<DDCollectionViewLayoutDelegate>)self.delegate collectionView:self.collectionView layout:self heightOfItemAtIndexPath:indexPath itemWidth:_itemWidth];
        
        attribute.frame = CGRectMake(x, minY, _itemWidth, height);
        self.cellLayoutInfo[indexPath] = attribute;
        
        CGFloat maxY = minY + self.rowSpacing + height;
        self.maxYForColumn[@(shorterColumn)] = @(maxY);
        
        if (row == rowsCount -1) {
            for (int i = 1; i < _numberOfColumns; i++) {
                maxY = MAX(maxY, [self.maxYForColumn[@(i)] floatValue]);
            }
            self.startY = maxY - self.rowSpacing + self.sectionInset.bottom;
        }
    }
}

- (NSInteger)queryShorterColumn:(CGFloat *)resultY {
    NSInteger shorterColumn = 0;
    CGFloat minY = [self.maxYForColumn[@(0)] floatValue];
    for (int i = 1; i < _numberOfColumns; i++) {
        if ([self.maxYForColumn[@(i)] floatValue] < minY) {
            minY = [self.maxYForColumn[@(i)] floatValue];
            shorterColumn = i;
        }
    }
    *resultY = minY;
    return shorterColumn;
}
#pragma mark ---区头
- (void)calSectionHeaderWithSection:(NSInteger)section {
    
    NSIndexPath *supplementaryViewIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    if (_headerViewHeight>0 && [self.collectionView.dataSource respondsToSelector:@selector(collectionView: viewForSupplementaryElementOfKind: atIndexPath:)]) {
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:DDUICollectionElementKindSectionHeader withIndexPath:supplementaryViewIndexPath];
        
        attribute.frame = CGRectMake(0, self.startY, self.collectionView.frame.size.width, _headerViewHeight);
        self.headLayoutInfo[supplementaryViewIndexPath] = attribute;
        
        self.startY = self.startY + _headerViewHeight + self.sectionInset.top;
    }else{
        //没有头视图的时候，也要设置section的第一排cell到顶部的距离
        self.startY = self.startY + self.sectionInset.top;
    }

}
#pragma mark ---区尾
- (void)calSectionFooterWithSection:(NSInteger)section {
    NSIndexPath *supplementaryViewIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    if (_footViewHeight>0 && [self.collectionView.dataSource respondsToSelector:@selector(collectionView: viewForSupplementaryElementOfKind: atIndexPath:)]) {
        
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:DDUICollectionElementKindSectionFooter withIndexPath:supplementaryViewIndexPath];
        
        attribute.frame = CGRectMake(0, self.startY, self.collectionView.frame.size.width, _footViewHeight);
        self.footLayoutInfo[supplementaryViewIndexPath] = attribute;
        
        self.startY = self.startY + _footViewHeight;
    }
}
#pragma mark - deleagte

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray array];
    
    //添加当前屏幕可见的cell的布局
    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    //添加当前屏幕可见的头视图的布局
    [self.headLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    //添加当前屏幕可见的尾部的布局
    [self.footLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    return allAttributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, MAX(self.startY, self.collectionView.frame.size.height));
}


@end
