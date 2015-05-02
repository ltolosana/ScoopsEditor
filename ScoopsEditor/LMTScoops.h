//
//  LMTScoops.h
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

@import Foundation;
#import "LMTScoop.h"

@interface LMTScoops : NSObject

@property (nonatomic) int scoopCount;

-(LMTScoop *) scoopAtIndex: (int) index;


@end
