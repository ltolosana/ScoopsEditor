//
//  LMTScoops.h
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#define LMTSCOOPS_DID_CHANGE_NOTIFICATION @"LMTSCOOPS_DID_CHANGE_NOTIFICATION"
#define SCOOPS_KEY @"SCOOPS"

@import Foundation;
#import "LMTScoop.h"

@interface LMTScoops : NSObject

@property (nonatomic) int scoopCount;

-(LMTScoop *) scoopAtIndex: (int) index;


@end
