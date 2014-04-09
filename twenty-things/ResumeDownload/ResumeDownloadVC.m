//
//  ResumeDownloadVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/7/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "ResumeDownloadVC.h"
#import "OAuthLoginNavVC.h"
#import <ArcGIS/ArcGIS.h>

#define TWENTY_THINGS_IDENTIFIER    @"20Things"

/*
 1. Shows off resume download
 2. Shows login to portal
 3. Shows storing credential
 */

@interface ResumeDownloadVC ()<AGSPortalDelegate, UIAlertViewDelegate>
@property (nonatomic, assign) BOOL promptedOnce;
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
@property (nonatomic, copy) NSString *resumeID;
@property (nonatomic, strong) AGSPortal *portal;
@property (nonatomic, strong) AGSTiledMapServiceLayer *exportTileLayer;

@property (nonatomic, strong) AGSExportTileCacheTask *exportTileCacheTask;

@property (nonatomic, strong) AGSOAuthLoginViewController *oAuthVC;
@property (nonatomic, strong) OAuthLoginNavVC *loginNavVC;

@property (nonatomic, weak) id<AGSResumableTaskJob> resumableJob;

@property (nonatomic, strong) AGSKeychainItemWrapper *keychainWrapper;

@end

@implementation ResumeDownloadVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // create our keychain wrapper so we can store/retrieve stuff from the keychain
    self.keychainWrapper = [[AGSKeychainItemWrapper alloc] initWithIdentifier:TWENTY_THINGS_IDENTIFIER accessGroup:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    
    // check if we have a stored credential
    // and attempt to load the portal if so
    AGSCredential *savedCredential = (AGSCredential*)[self.keychainWrapper keychainObject];
    if (savedCredential) {
        NSLog(@"loading with saved credential");
        [self loadPortalWithCredential:savedCredential];
        return;
    }
    
    // we want to require login, so keep showing page until
    // the user successfully logs in
    if (!self.promptedOnce) {
        [self setupAndDisplayLogin];
    }
}

- (void)setupAndDisplayLogin {
    
    self.promptedOnce = YES;
    
    // create our OAuth VC
    self.oAuthVC = [[AGSOAuthLoginViewController alloc] initWithPortalURL:[self portalURL]
                                                                 clientID:[self clientID]];
    
    // give our vc a title
    self.oAuthVC.title = @"Login to Geobrew";
    
    // setup 'cancel' button
    self.oAuthVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(cancelLogin:)];
    
    // prevent retain cycle
    __weak ResumeDownloadVC *weakSelf = self;
    
    // create our container to put the OAuth skeleton vc inside
    self.loginNavVC = [[OAuthLoginNavVC alloc] initWithRootViewController:self.oAuthVC];
    
    // dismiss our login
    self.oAuthVC.completion = ^(AGSCredential *credential, NSError *error){
        [weakSelf.loginNavVC dismissViewControllerAnimated:YES completion:NULL];
        [weakSelf loadPortalWithCredential:credential];
    };
    
    // present Login VC to user
    [self presentViewController:self.loginNavVC animated:YES completion:NULL];
}

//
- (void)cancelLogin:(id)sender {
    [self.loginNavVC dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)downloadBtnClicked:(id)sender {
    
    // KVC trick to get an array of levels from the AGSLOD objects in the tileInfo.lods array
    // AGSLOD has a 'level' property...
    // calling value for key on an array with a key name that matches a property of the object
    // in the array will return a new array of those property values...
    //
    // e.g @[ lod1, lod2 ]
    //
    // this returns a new array equivalent to @[ @(lod1.level), @(lod2.level) ]
    NSArray *levels = [self.exportTileLayer.tileInfo.lods valueForKey:@"level"];
    
    // create params using
    AGSExportTileCacheParams *params = [[AGSExportTileCacheParams alloc] initWithLevelsOfDetail:levels
                                                                                 areaOfInterest:self.mapView.visibleAreaEnvelope];

    // set some compression on our tiles to save space
    params.recompressionQuality = 0.60;
    
    // kick off our download (no resumeID yet)
    [self kickoffOrResumeDownloadWithParams:params resumeID:nil];
}

- (void)kickoffOrResumeDownloadWithParams:(AGSExportTileCacheParams*)params resumeID:(NSString*)resumeID {
    
    __weak ResumeDownloadVC *weakSelf = self;
    
    self.exportTileCacheTask = [[AGSExportTileCacheTask alloc] initWithURL:[self exportTopoURL]];
    self.exportTileCacheTask.credentialCache = self.portal.credentialCache;
    
    // create a block to handle status callbacks
    void(^statusBlock)(AGSResumableTaskJobStatus, NSDictionary*) = ^(AGSResumableTaskJobStatus status, NSDictionary *userInfo){
        
        // create a string value from the status enum
        NSString *statusString = AGSResumableTaskJobStatusAsString(status);

        NSLog(@"export status: %@", statusString);
        
        // if we are downloading, log the bytes down and bytes expected
        // we can get those from the userInfo dictionary using the string constant keys
        if (status == AGSResumableTaskJobStatusFetchingResult) {
            long long bytesDownloaded = [userInfo[AGSDownloadProgressTotalBytesDownloadedKey] longLongValue];
            long long bytesExpected = [userInfo[AGSDownloadProgressTotalBytesExpectedKey] longLongValue];
            NSLog(@"downloading: %lld/%lld", bytesDownloaded, bytesExpected);
        }
    };
    
    // create a completion block to reset our map and add our TPK to the map
    void(^completionBlock)(AGSLocalTiledLayer*, NSError*) = ^(AGSLocalTiledLayer *localTiledLayer, NSError *error) {
        [weakSelf.mapView reset];
        [weakSelf.mapView addMapLayer:localTiledLayer];
        
        // new at 10.2.2 - override minScale/maxScale in case you have
        // operational data that is more detailed than your basemap
        weakSelf.mapView.minScale = 100000;
        
        // remove our resume ID since job completed
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"resumeID"];
        
        // call synchronize so we write out the values
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
    
    // if we have resume data, resume our download
    if (resumeID.length) {
        NSLog(@"resuming a previous download");
        self.resumableJob = [self.exportTileCacheTask exportTileCacheWithResumeID:resumeID
                                                                           status:statusBlock
                                                                       completion:completionBlock];
    }
    else {
        NSLog(@"starting a new download");
        self.resumableJob = [self.exportTileCacheTask exportTileCacheWithParameters:params
                                                                 downloadFolderPath:nil
                                                                        useExisting:NO
                                                                             status:statusBlock
                                                                         completion:completionBlock];
    }
    
    // store our resume ID in case app is killed
    [[NSUserDefaults standardUserDefaults] setValue:self.resumableJob.resumeID forKey:@"resumeID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)logoutClicked:(id)sender {
    // if user logs out, cancel our job
    [self.resumableJob cancel];
    
    // remove any resumeIDs
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"resumeID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // remove our user's credential from keychain since they explicitly logged out
    [self.keychainWrapper reset];
    
    // clear out our portal
    self.portal = nil;
    
    // reset the map view
    [self.mapView reset];
    
    // hide our map view
    self.mapView.hidden = YES;
    
    // re-prompt for login
    [self setupAndDisplayLogin];
}

- (void)loadPortalWithCredential:(AGSCredential*)cred {
    self.portal = [[AGSPortal alloc] initWithURL:[self portalURL] credential:cred];
    self.portal.delegate = self;
}

- (NSURL*)exportTopoURL {
    return [NSURL URLWithString:@"http://tiledbasemaps.arcgis.com/arcgis/rest/services/World_Topo_Map/MapServer"];
}

- (NSURL*)portalURL {
    return [NSURL URLWithString:@"https://www.arcgis.com"];
}

- (NSString*)clientID {
#error Insert a clientID for your OAuth-enabled application
    return nil;
}


#pragma mark AGSPortalDelegate

-(void)portalDidLoad:(AGSPortal *)portal {

    // save our portal credential in the keychain
    [self.keychainWrapper setKeychainObject:portal.credential];
    
    // unhide the map now that our portal is loaded
    self.mapView.hidden = NO;
    
    self.exportTileLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:[self exportTopoURL] credential:nil];
    
    // pass the credential cache from the portal so it can handle generating a credential
    // for the exportable tile layer
    self.exportTileLayer.credentialCache = self.portal.credentialCache;
    [self.mapView addMapLayer:self.exportTileLayer];
    
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:-12973339.119440766
                                                ymin:4004738.947715673
                                                xmax:-12972574.749157893
                                                ymax:4006095.704967771
                                    spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    [self.mapView zoomToEnvelope:env animated:YES];
    
    // check if we can resume a previous download
    self.resumeID = [[NSUserDefaults standardUserDefaults] valueForKey:@"resumeID"];
    if (self.resumeID.length) {
        // prompt user to resume
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Resume Job?"
                                                     message:@"A previous job was detected, do you wish to resume?"
                                                    delegate:self
                                           cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [av show];
    }
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // buttonIndex
    // 0 - NO
    // 1 - YES
    
    // call method to resume with resume ID
    if (buttonIndex == 1) {
        [self kickoffOrResumeDownloadWithParams:nil resumeID:self.resumeID];
    }
    else {
        // remove old jobID
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"resumeID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
