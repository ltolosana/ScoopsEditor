//
//  LMTScoopsTableViewController.h
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

@import UIKit;
@class LMTScoops;


@interface LMTScoopsTableViewController : UITableViewController

@property (nonatomic, strong) LMTScoops *model;
//@property (nonatomic, strong) NSMutableArray *model;

-(id) initWithModel: (LMTScoops *) aModel style: (UITableViewStyle) aStyle;

@end
