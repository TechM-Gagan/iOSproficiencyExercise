//
//  CustomTableViewCell.m
//  TMTest
//
//  Created by Vishal Mishra, Gagan on  10/06/16.
//  Copyright © 2016 Vishal Mishra, Gagan. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // Add ImageView on the cell
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        [self.iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.iconImageView.image =[UIImage imageNamed:@"deafult"];
        [self.contentView addSubview:self.iconImageView];

        // Add title label on the cell
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.titleLabel setNumberOfLines:1];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.titleLabel];
        
        // Add Description label on the cell
        self.descriptionLabel = [[UILabel alloc] init];
        [self.descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.descriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.descriptionLabel setNumberOfLines:0];
        [self.descriptionLabel setTextAlignment:NSTextAlignmentLeft];
        [self.descriptionLabel setTextColor:[UIColor darkGrayColor]];
        [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.descriptionLabel];
    }
    
    return self;
}

-(void)updateConstraints
{
    [super updateConstraints];
    
    if (self.isConstrainedApplied)  //Return if constraint has been applied
    {
        return;
    }
    
 

    NSArray *constraintsArray;

    // Get the views dictionary
    NSDictionary *viewsDictionary =
    @{
      @"iconImageView" : self.iconImageView,
      @"titleLabel" : self.titleLabel,
      @"descriptionLabel" : self.descriptionLabel
      };
    
    NSString *format =nil;
    
  
    //Create the constraints using the visual language format
    format = @"V:|-10-[iconImageView]-10-[descriptionLabel]-10-|";
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary];
    [self.contentView addConstraints:constraintsArray];
    
    
    format = @"|-110-[titleLabel]-10-|";
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary];
    [self.contentView addConstraints:constraintsArray];
    
    
    format = @"|-10-[descriptionLabel]-10-|";
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary];
    [self.contentView addConstraints:constraintsArray];
    
    //dict
    NSDictionary *dictImageCell =@{@"iconImageView": self.iconImageView };;
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[iconImageView(80)]" options:0 metrics:nil views:dictImageCell];
    [self.contentView addConstraints:constraintsArray];
    
    self.isConstrainedApplied = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
