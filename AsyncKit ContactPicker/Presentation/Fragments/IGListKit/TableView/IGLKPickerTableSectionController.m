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

@interface IGLKPickerTableSectionController () <IGListBindingSectionControllerDataSource>

@property (nonatomic, strong) PickerViewModel *currentModel;

@end

@implementation IGLKPickerTableSectionController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSource = self;
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
    return CGSizeMake(self.collectionContext.containerSize.width, AVATAR_IMAGE_HEIHGT + 20);
}

- (UICollectionViewCell<IGListBindable> *)sectionController:(IGListBindingSectionController *)sectionController
                                           cellForViewModel:(id)viewModel
                                                    atIndex:(NSInteger)index {
    IGLKPickerTableCell *cell =  [self.collectionContext dequeueReusableCellOfClass:[IGLKPickerTableCell class]
                                                               forSectionController:self
                                                                            atIndex:index];
    
    return cell;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtModel:)]) {
        [self.delegate didSelectItemAtModel:_currentModel];
    }
}

@end