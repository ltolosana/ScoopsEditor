//
//  LMTScoops.m
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#import "LMTScoops.h"
#import "LMTScoop.h"

@interface LMTScoops ()

@property (strong, nonatomic) NSArray *scoops;

@end

@implementation LMTScoops

#pragma mark - Properties
-(int) scoopCount{
    
    return [self.scoops count];
}


#pragma mark - Init
-(id) init{
    if (self = [super init]) {
        
        LMTScoop *noticia1 = [LMTScoop scoopWithTitle:@"Noticia 1"
                                                 body:@"Esta es una noticia  1 importante"
                                               author:@"Yo mismo"
                                                photo:nil];

        
        LMTScoop *noticia2 = [LMTScoop scoopWithTitle:@"Noticia 2"
                                                 body:@"Esta es una noticia 2 importante"
                                               author:@"Yo mismo"
                                                photo:nil];
 
        LMTScoop *noticia3 = [LMTScoop scoopWithTitle:@"Noticia"
                                                 body:@"Esta es una noticia 3 importante"
                                               author:@"Yo mismo"
                                                photo:nil];

        
        self.scoops = @[noticia1, noticia2, noticia3];
        
    }
    
    return self;
    
}

-(LMTScoop *) scoopAtIndex: (int) index{
    
    return [self.scoops objectAtIndex:index];
}

@end
