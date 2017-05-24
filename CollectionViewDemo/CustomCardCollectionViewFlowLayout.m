

#import "CustomCardCollectionViewFlowLayout.h"

@interface CustomCardCollectionViewFlowLayout () {
    CGSize _contentSize;
    CGSize _itemSize;
}

@property(nonatomic, assign) NSInteger itemsCount;

@end

@implementation CustomCardCollectionViewFlowLayout

-(void)prepareLayout {
    [super prepareLayout];
    
    _itemsCount = [self.collectionView numberOfItemsInSection:0];
    _contentSize = CGSizeMake(_itemsCount * CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame));
    _itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame) - _itemEdgeInsets.left - _itemEdgeInsets.right, CGRectGetHeight(self.collectionView.frame) - _itemEdgeInsets.top - _itemEdgeInsets.bottom);
    return ;
}

-(CGSize)collectionViewContentSize {
    
    return _contentSize;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attr.size = _itemSize;
    
    attr.frame = CGRectMake(indexPath.row * CGRectGetWidth(self.collectionView.frame) + _itemEdgeInsets.left, _itemEdgeInsets.top, attr.size.width, attr.size.height);

    return attr;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [NSMutableArray array];
    
    

    for (NSInteger i=0 ; i < _itemsCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        if(CGRectIntersectsRect(attr.frame, rect)) {
            [attributes addObject:attr];
        }
    }
    
    return attributes;
}





@end
