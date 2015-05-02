//
//  LMTScoopsEditorsTableViewController.h
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

@import UIKit;
@class LMTScoopsEditor;

#define UNPUBLISHED_SECTION 0
#define PUBLISHED_SECTION 1


@interface LMTScoopsEditorsTableViewController : UITableViewController

@property (nonatomic, strong) LMTScoopsEditor *model;

-(id) initWithModel: (LMTScoopsEditor *) aModel style: (UITableViewStyle) aStyle;

@end
