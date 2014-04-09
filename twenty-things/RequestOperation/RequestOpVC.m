//
//  RequestOpVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/11/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "RequestOpVC.h"
#import <ArcGIS/ArcGIS.h>

#define ONE_MB_FILE_URL [NSURL URLWithString:@"http://mirror.internode.on.net/pub/test/1meg.test"]
#define TEN_MB_FILE_URL [NSURL URLWithString:@"http://mirror.internode.on.net/pub/test/10meg.test"]

@interface RequestOpVC ()
{
    NSOperationQueue *_opQueue;
}
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bytesLabel;
- (IBAction)startDownload:(id)sender;

@end

@implementation RequestOpVC

-(void)dealloc {
    [_opQueue cancelAllOperations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (IBAction)startDownload:(id)sender {
    
    _opQueue = [NSOperationQueue new];
    
    // find our documents directory for this application
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = paths[0];
    
    
    __weak RequestOpVC *weakSelf = self;
    
    // create operation
    AGSRequestOperation *op = [[AGSRequestOperation alloc] initWithURL:ONE_MB_FILE_URL];
    
    // specify an output path so the data is written to a file
    op.outputPath = [NSString stringWithFormat:@"%@/test.download", documentsDir];
    
    // remove existing version of file
    if ([[NSFileManager defaultManager] fileExistsAtPath:op.outputPath isDirectory:NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:op.outputPath error:nil];
    }
    
    // just log the completion
    op.completionHandler = ^(id obj) {
        NSLog(@"Downloaded file to %@", obj);
    };
    
    // log the error
    op.errorHandler = ^(NSError *error) {
        NSLog(@"uh oh! error: %@", error);
    };
    
    // update the UI when progress is updated.
    // note, bytesE can be -1 when a contentLength is not set by the server
    op.progressHandler = ^(long long bytesD, long long bytesE) {
        double pct = (double)bytesD / bytesE;
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", 100*pct];
        weakSelf.bytesLabel.text = [NSString stringWithFormat:@"%lld/%lld", bytesD, bytesE];
        weakSelf.progressView.progress = pct;
    };
    
    // add the operation to queue to be started
    [_opQueue addOperation:op];
}
@end
