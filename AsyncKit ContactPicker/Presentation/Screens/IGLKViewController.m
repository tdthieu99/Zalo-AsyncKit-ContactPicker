//
//  IGLKViewController.m
//  AsyncKit ContactPicker
//
//  Created by Trần Đình Tôn Hiếu on 5/2/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "IGLKViewController.h"

#import "Contact.h"
#import "ContactBusiness.h"
#import "PickerViewModel.h"
#import "AppConsts.h"

#import "IGLKPickerTableView.h"
#import "IGLKPickerCollectionView.h"

@interface IGLKViewController () <IGLKPickerTableViewDelegate, IGLKPickerCollectionViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray<Contact *> *contacts;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *sectionData;

@property (nonatomic, strong) NSMutableArray<PickerViewModel *> *pickerModels;

@property (nonatomic, strong) ContactBusiness *contactBusiness;

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet IGLKPickerTableView *tableView;
@property (nonatomic, weak) IBOutlet IGLKPickerCollectionView *collectionView;


@end

@implementation IGLKViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _contacts = [[NSMutableArray alloc] init];
        _pickerModels = [[NSMutableArray alloc] init];
        _sectionData = [[NSMutableArray alloc] init];
        for (int i = 0; i < ALPHABET_SECTIONS_NUMBER; i++) {
            [_sectionData addObject:[NSMutableArray new]];
        }
        
        _contactBusiness = [[ContactBusiness alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    [_tableView setViewController:self];
    
    _collectionView.delegate = self;
    
    _searchBar.placeholder = @"Search for contacts";
    _searchBar.delegate = self;
    
    [self checkPermissionAndLoadContacts];
}

#pragma mark - LoadContacts

- (void)checkPermissionAndLoadContacts {
    ContactAuthorState authorizationState = [self.contactBusiness permissionStateToAccessContactData];
    switch (authorizationState) {
        case ContactAuthorStateAuthorized:
            [self loadContacts];
            break;
        case ContactAuthorStateDenied:
            [self showNotPermissionView];
            break;
        default:
            [self.contactBusiness requestAccessWithCompletionHandle:^(BOOL granted) {
                if (granted) {
                    [self loadContacts];
                } else {
                    [self showNotPermissionView];
                }
            }];
            break;
    }
}

- (void)showNotPermissionView {
    
}

- (void)loadContacts {
    [self.contactBusiness loadContactsWithCompletion:^(NSArray<Contact *> *contacts, NSError *error) {
        if (!error) {
            if (contacts.count > 0) {
                [self initContactsData:contacts];
                self.pickerModels = [self getPickerModelsArrayFromContacts:self.contacts];
                [self.tableView setViewModels:self.pickerModels];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
    }];
}

- (void)initContactsData:(NSArray<Contact *> *)contacts {
    if (!contacts)
        return;
    
    self.contacts = [NSMutableArray arrayWithArray:contacts];
    self.sectionData = [self.contactBusiness sortedByAlphabetSectionsArrayFromContacts:self.contacts];
}

- (NSMutableArray<PickerViewModel *> *)getPickerModelsArrayFromContacts:(NSArray<Contact *> *)contacts {
    if (!contacts) {
        return nil;
    }
    
    NSMutableArray<PickerViewModel *> *pickerModels = [[NSMutableArray alloc] init];
    
    for (Contact *contact in contacts) {
        PickerViewModel *pickerModel = [[PickerViewModel alloc] init];
        pickerModel.identifier = contact.identifier;
        pickerModel.name = contact.name;
        pickerModel.isChosen = NO;
        
        [pickerModels addObject:pickerModel];
    }
    
    return pickerModels;
}

#pragma mark - IGLKPickerTableViewDelegate

- (void)pickerTableView:(IGLKPickerTableView *)tableView checkedCellAtIndexPath:(NSIndexPath *)indexPath {
    PickerViewModel *model = [self.pickerModels objectAtIndex:indexPath.row];
    if (!model)
        return;
    
    [self.collectionView addElement:model];
}

- (void)pickerTableView:(IGLKPickerTableView *)tableView uncheckedCellAtIndexPath:(NSIndexPath *)indexPath {
    PickerViewModel *model = [self.pickerModels objectAtIndex:indexPath.row];
    if (!model)
        return;
    
    [self.collectionView removeElement:model];
}

#pragma mark - IGLKPickerCollectionViewDelegate

- (void)collectionView:(IGLKPickerCollectionView *)collectionView removeItem:(PickerViewModel *)item {
    if (!item)
        return;
    if (collectionView == self.collectionView) {
        [self.tableView uncheckModel:item];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

@end
