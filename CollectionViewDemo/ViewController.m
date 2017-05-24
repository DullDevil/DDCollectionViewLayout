//
//  ViewController.m
//  CollectionViewDemo
//
//  Created by 张桂杨 on 2017/4/27.
//  Copyright © 2017年 DD. All rights reserved.
//

#import "ViewController.h"
#import "CustomCardCollectionViewFlowLayout.h"
#import "DDCollectionViewLayout.h"
#import "DDAlignmentLayout.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DDCollectionViewLayoutDelegate,DDAlignmentLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
}

#pragma mark - deleagte
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    return 30;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
static NSString  * const cellReuseIdentifier = @"cellReuseIdentifier";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:DDUICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:DDUICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        view.backgroundColor = [UIColor darkGrayColor];
        
        return view;
    } else if ([kind isEqualToString:DDUICollectionElementKindSectionFooter]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:DDUICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        view.backgroundColor = [UIColor darkGrayColor];
        return view;
    }
    
    return nil;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(DDCollectionViewLayout *)layout heightOfItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    return (indexPath.row + 1) * 10;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(DDAlignmentLayout *)layout widthOfItemAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row + 1) * 5;
}
#pragma mark - setter && getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        DDAlignmentLayout *layout = [[DDAlignmentLayout alloc] initWithAlignment:DDAlignmentCenter];
        layout.delegate = self;
        layout.itemHeight = 60;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:DDUICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:DDUICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        _collectionView.backgroundColor = [UIColor whiteColor];


    }
    return _collectionView;
}

@end
