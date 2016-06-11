//
//  ViewController.m
//  TMTest
//
//  Created by Vishal Mishra, Gagan on 10/06/16.
//  Copyright © 2016 Vishal Mishra, Gagan. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"

static NSString *CellIdentifier = @"CustomCellIdentifier";

@interface ViewController ()
@property(strong,nonatomic) NSMutableArray *arrayOfRecords;  //Array ised to strore record from Server
@property(strong,nonatomic) NSMutableDictionary *dictionaryOfImages;  //Dictionary used to store images from server in order to avoid re-fetching
@end

@implementation ViewController

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {}
    return self;
}

#pragma -mark View Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Pull to refresh";
    self.dictionaryOfImages =[NSMutableDictionary dictionary];
    //Regster for custom cell class here
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    //Initialize refresh control of UItableView
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor greenColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshAndLoadtableViewContents) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -mark  refersh tableview
-(void)refreshAndLoadtableViewContents
{
    [self.refreshControl beginRefreshing];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/746330/facts.json"]];
    NSURLSession *sharedSession =[NSURLSession sharedSession];
    NSURLSessionDataTask *sessionTask =  [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            NSString *rspnse = [[NSString alloc]initWithData:data encoding:NSISOLatin1StringEncoding];
            NSData *metaData = [rspnse dataUsingEncoding:NSUTF8StringEncoding];
            id jsonObject = [NSJSONSerialization JSONObjectWithData:metaData options:kNilOptions error:&error];
           // NSLog(@"jsonObject is : %@",jsonObject);
            if ([jsonObject isKindOfClass:[NSDictionary class] ])
            {
                  if (jsonObject[@"rows"]!=nil && [jsonObject[@"rows"] isKindOfClass:[NSArray class]])
                {
                    self.arrayOfRecords = [jsonObject[@"rows"] copy];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];  //Reload table on main queue
                    if (jsonObject[@"title"]!=nil)
                    {
                        self.title = jsonObject[@"title"];  //set navigation item title
                    }
                });
            }
        }
        else{
            [self showAlertWithTitle:@"Message" AndMessage:error.localizedDescription];
        }
        [self.refreshControl  endRefreshing];
    }];
    [sessionTask resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayOfRecords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Add title on cell
    if ([self.arrayOfRecords[indexPath.row] valueForKey:@"title"]!=[NSNull null])
    {
        cell.titleLabel.text = [self.arrayOfRecords[indexPath.row] valueForKey:@"title"];
    }
    else{
        cell.titleLabel.text =@"Default title goes here";
    }

    //Add Description in cell
    if ([self.arrayOfRecords[indexPath.row] valueForKey:@"description"]!=[NSNull null])
    {
        cell.descriptionLabel.text = [self.arrayOfRecords[indexPath.row] valueForKey:@"description"];
    }
    else{
        cell.descriptionLabel.text =@"Default desctption goes here";
    }
    
    if ([self.arrayOfRecords[indexPath.row] valueForKey:@"imageHref"]!=[NSNull null])
    {
        NSString *cellIndexPathString =[NSString stringWithFormat:@"%ld",(long)indexPath.row];    //Used as key to store image in dictionary
        //Load stored image if already exist
        if ([self.dictionaryOfImages valueForKey:cellIndexPathString])
        {
            cell.iconImageView.image =[self.dictionaryOfImages objectForKey:cellIndexPathString];
        }
        else{
            cell.iconImageView.image =[UIImage imageNamed:@"deafult"];
            [self downloadImageWithURL:[NSURL URLWithString:[self.arrayOfRecords[indexPath.row] valueForKey:@"imageHref"]] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.iconImageView.image = image;
                        [self.dictionaryOfImages setObject:image forKey:cellIndexPathString];
                    });
                }
            }];
        }
      }
    
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([self.arrayOfRecords[indexPath.row] valueForKey:@"description"]!=[NSNull null])
    {
        cell.descriptionLabel.text = [self.arrayOfRecords[indexPath.row] valueForKey:@"description"];
    }
    else{
        cell.descriptionLabel.text =@"Descrption Default";
    }
    
    cell.descriptionLabel.preferredMaxLayoutWidth = tableView.bounds.size.width - (20.0 * 2.0f);
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell.contentView setNeedsLayout];
    
    [cell.contentView layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}

#pragma -mark image downloading
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *sharedSession =[NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask= [sharedSession downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ( !error )
        {
            NSData *data = [NSData dataWithContentsOfURL:location];
            UIImage *image = [UIImage imageWithData:data];
            if (image)
            {
                completionBlock(YES,image);
            }
            else{
                completionBlock(NO,nil);
            }
        } else{
            completionBlock(NO,nil);
        }
    }];
    [downloadTask resume];
}

#pragma -mark show alert 
-(void)showAlertWithTitle:(NSString*)title AndMessage:(NSString*)message
{
    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
    alertController=nil;
    alertAction=nil;
}
@end
