//
//  CustomTableViewCell.h
//  TMTest
//
//  Created by Vishal Mishra, Gagan on 10/06/16.
//  Copyright © 2016 Vishal Mishra, Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;   //UILabel object to show "title" text in each cell
@property (strong, nonatomic) UILabel *descriptionLabel; //UILabel object to show "description" text in each cell
@property (strong, nonatomic) UIImageView * iconImageView; //UIIMageView object to show "imageHref" from server in each cell
@property (assign, nonatomic) BOOL isConstrainedApplied;  //BOOL to check whether constraint has been appied or not in Cell

@end
