//
//  DSThingsViewController.m
//  twenty-things
//
//  Created by Eric Ito on 3/6/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "DSThingsViewController.h"
#import <ArcGIS/ArcGIS.h>

static NSString *kTipCellID = @"kTipCellID";

@interface DSThingsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tipsVCNames;
@property (nonatomic, strong) NSDictionary *tipsVCMap;
@end

@implementation DSThingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTipCellID];
    
    // place display names of view controllers here...
    self.tipsVCNames = @[@"Coordinate Conversion",
                         @"Simulate Location",
                         @"Custom Dynamic Layer",
                         @"Override GPS Symbol",
                         @"Geodesic Operations",
                         @"Resume Downloads",
                         @"GL Rendering Modes",
                         @"Graphic KVC",
                         @"Request Op",
                         @"Custom Background",
                         @"Prefetch Tiles",
                         @"Set Max Envelope"];
    
    // map display name to the actual view controller name...
    self.tipsVCMap = @{@"Coordinate Conversion" : @"CoordinateConversionVC",
                       @"Simulate Location" : @"SimulatedLocationVC",
                       @"Custom Dynamic Layer": @"CustomDynamicLayerVC",
                       @"Override GPS Symbol" : @"OverrideGPSVC",
                       @"Geodesic Operations" : @"GeodesicOpsVC",
                       @"Resume Downloads" : @"ResumeDownloadVC",
                       @"GL Rendering Modes" : @"GLRenderModesVC",
                       @"Graphic KVC" : @"GraphicKVCVC",
                       @"Request Op" : @"RequestOpVC",
                       @"Custom Background" : @"CustomGridColorVC",
                       @"Prefetch Tiles" : @"PrefetchTilesVC",
                       @"Set Max Envelope" : @"SetMaxEnvVC"};
    
    self.title = @"20 Things...";

    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource/UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTipCellID];
    NSString *vcName = self.tipsVCNames[indexPath.row];
    cell.textLabel.text = vcName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcName = self.tipsVCMap[self.tipsVCNames[indexPath.row]];
    
    // this will get the name of the VC to instantiate and then create it and push onto the navigation stack
    Class c = NSClassFromString(vcName);
    UIViewController *vc = [[c alloc] initWithNibName:vcName bundle:nil];
    vc.title = vcName;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tipsVCNames.count;
}

@end
