//
//  LMTScoop.h
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#define SCOOP_DID_CHANGE_NOTIFICATION @"LMTSCOOP_DID_CHANGE_NOTIFICATION"
#define SCOOP_KEY @"SCOOP"

@import Foundation;
@import UIKit;

@class LMTImage;

#define NO_RATING -1

@interface LMTScoop : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *authorName;
@property (nonatomic) int rating; // 0 - 5
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy) NSString *photoString;
@property (nonatomic) BOOL published;
@property (nonatomic) BOOL preparedToPublish;



//Class Methods

+(instancetype) scoopWithTitle: (NSString *) title
                    identifier: (NSString *) identifier
                          body: (NSString *) body
                        author: (NSString *) author
                    authorName: (NSString *) authorName
                   photoString: (NSString *) photoString
                     published: (BOOL) published
             preparedToPublish: (BOOL) preparedToPublish
                        rating: (int) rating;

+(instancetype) scoopWithTitle: (NSString *) title
                    identifier: (NSString *) identifier
                          body: (NSString *) body
                        author: (NSString *) author
                    authorName: (NSString *) authorName
                   photoString: (NSString *) photoString
                     published: (BOOL) published;

+(instancetype) scoopWithTitle: (NSString *) title
                    identifier: (NSString *) identifier
                          body: (NSString *) body
                        author: (NSString *) author
                    authorName: (NSString *) authorName
                     published: (BOOL) published;

+(NSArray *) observableKeys;

//Designated Init

-(id) initWithTitle: (NSString *) title
         identifier: (NSString *) identifier
               body: (NSString *) body
             author: (NSString *) author
         authorName: (NSString *) authorName
        photoString: (NSString *) photoString
          published: (BOOL) published
  preparedToPublish: (BOOL) preparedToPublish
             rating: (int) rating;

-(id) initWithTitle: (NSString *) title
         identifier: (NSString *) identifier
               body: (NSString *) body
             author: (NSString *) author
         authorName: (NSString *) authorName
        photoString: (NSString *) photoString
          published: (BOOL) published;

-(id) initWithTitle: (NSString *) title
         identifier: (NSString *) identifier
               body: (NSString *) body
             author: (NSString *) author
         authorName: (NSString *) authorName
          published: (BOOL) published;


@end
