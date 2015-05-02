//
//  LMTScoopsEditor.h
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#define LMTSCOOPSEDITOR_DID_CHANGE_NOTIFICATION @"LMTSCOOPSEDITOR_DID_CHANGE_NOTIFICATION"
#define SCOOPSEDITOR_KEY @"SCOOPSEDITOR"

@import Foundation;
#import "LMTScoop.h"

@interface LMTScoopsEditor : NSObject

@property (nonatomic) int unpublishedScoopCount;
@property (nonatomic) int publishedScoopCount;

-(LMTScoop *) unpublishedScoopAtIndex: (int) index;
-(LMTScoop *) publishedScoopAtIndex: (int) index;

@end
