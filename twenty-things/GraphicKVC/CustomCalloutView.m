//
//  CustomCalloutView.m
//  twenty-things
//
//  Created by Eric Ito on 3/12/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "CustomCalloutView.h"

static NSString *kCellID = @"cellid";

@interface CustomCalloutView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@end

@implementation CustomCalloutView

// setup a simple table view in our callout view to display all the attributes.
// this is purely to demonstrate using a custom view... you would want something more interesting than
// a table view for your own callouts
- (id)initWithFrame:(CGRect)frame attributes:(NSDictionary*)attrs
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.tableView];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
        [self updateAttributes:attrs];
    }
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    cell.textLabel.text = self.keys[indexPath.row];
    cell.detailTextLabel.text = self.values[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keys.count;
}

- (void)updateAttributes:(NSDictionary*)attrs {
    self.keys = [attrs allKeys];
    self.values = [attrs allValues];
}
@end
