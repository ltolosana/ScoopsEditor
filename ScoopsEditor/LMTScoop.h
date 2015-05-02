//
//  LMTScoop.h
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

@import Foundation;
@import UIKit;

#define NO_RATING -1

@interface LMTScoop : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *author;
@property (nonatomic) int rating; // 0 - 5
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic) BOOL published;


//Class Methods

+(instancetype) scoopWithTitle: (NSString *) title
                          body: (NSString *) body
                        author: (NSString *) author
                         photo: (UIImage *) photo
                     published: (BOOL) published
                        rating: (int) rating;

+(instancetype) scoopWithTitle: (NSString *) title
                          body: (NSString *) body
                        author: (NSString *) author
                         photo: (UIImage *) photo;

//Designated Init

-(id) initWithTitle: (NSString *) title
               body: (NSString *) body
             author: (NSString *) author
              photo: (UIImage *) photo
          published: (BOOL) published
             rating: (int) rating;

-(id) initWithTitle: (NSString *) title
               body: (NSString *) body
             author: (NSString *) author
              photo: (UIImage *) photo;


@end