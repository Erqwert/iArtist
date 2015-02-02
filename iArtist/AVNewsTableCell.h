//
//  AVNewsTableCell.h
//  iArtist
//
//  Created by Andrii V. on 02.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVPicture.h"
#import "AVAuthor.h"

@interface AVNewsTableCell : UITableViewCell

@property (strong, nonatomic) AVPicture *newsPicture;
@property (strong, nonatomic) AVAuthor *newsAutor;

@end
