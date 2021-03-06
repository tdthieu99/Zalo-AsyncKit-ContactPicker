//
//  IGLKPickerTableSectionController.m
//  AsyncKit ContactPicker
//
//  Created by Trần Đình Tôn Hiếu on 5/2/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "IGLKPickerTableSectionController.h"
#import "IGLKPickerTableCell.h"
#import "AppConsts.h"

static const int kPaddingTop = 5;
static const int kPaddingBottom = 5;

@interface IGLKPickerTableSectionController () <IGListBindingSectionControllerDataSource>

@property (nonatomic, strong) PickerViewModel *currentModel;

@end

@implementation IGLKPickerTableSectionController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.inset = UIEdgeInsetsMake(kPaddingTop, 0, kPaddingBottom, 0);
    }
    return self;
}


#pragma mark - IGListBindingSectionControllerDataSource

- (NSArray<id<IGListDiffable>> *)sectionController:(IGListBindingSectionController *)sectionController
                               viewModelsForObject:(id)object {
    if (object && [object isKindOfClass:[PickerViewModel class]]) {
        PickerViewModel *model = (PickerViewModel *)object;
        _currentModel = model;
        return @[model];
    }
    return nil;
}

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sectionController:(IGListBindingSectionController *)sectionController
           sizeForViewModel:(id)viewModel
                    atIndex:(NSInteger)index {
    CGFloat avatarImageHeight = [UIScreen mainScreen].bounds.size.width / 7.f;
    return CGSizeMake(self.collectionContext.containerSize.width, avatarImageHeight + 20);
}

- (UICollectionViewCell<IGListBindable> *)sectionController:(IGListBindingSectionController *)sectionController
                                           cellForViewModel:(id)viewModel
                                                    atIndex:(NSInteger)index {
    IGLKPickerTableCell *cell =  [self.collectionContext dequeueReusableCellOfClass:[IGLKPickerTableCell class]
                                                               forSectionController:self
                                                                            atIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionController:loadImageToCell:ofModel:)]) {
        [self.delegate sectionController:self
                         loadImageToCell:cell
                                 ofModel:_currentModel];
    }
    return cell;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionController:didSelectItemAtModel:)]) {
        [self.delegate sectionController:self
                    didSelectItemAtModel:_currentModel];
    }
}

@end
