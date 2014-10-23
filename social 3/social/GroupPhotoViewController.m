//
//  GroupPhotoViewController.m
//  social
//
//  Created by Anindya on 8/9/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "GroupPhotoViewController.h"
#import "ImageViewController.h"
@interface GroupPhotoViewController ()

@end

@implementation GroupPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [super viewDidLoad];
    imageArray = [[NSMutableArray alloc]init];
    _imageCollection.backgroundColor = [UIColor clearColor];
    [self queryParseMethod];
    // Do any additional setup after loading the view.
}

- (void)queryParseMethod {
    NSLog(@"start query");
    NSPredicate *grppredicate = [NSPredicate predicateWithFormat:@"groupName = %@",_groupName];
    PFQuery *query = [PFQuery queryWithClassName:kFeed predicate:grppredicate];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            imageFilesArray = [[NSArray alloc] initWithArray:objects];
            for(int i = 0 ;i<[imageFilesArray count];i++){
                PFObject *feedObject = [imageFilesArray objectAtIndex:i];
                PFFile *feedImage = [feedObject objectForKey:@"feedImage"];
                if(feedImage){
                    [imageArray addObject:feedImage];
                }
            }
            
            [_imageCollection reloadData];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imageArray count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ImageCell";
    GroupImageCell *cell = (GroupImageCell *)[_imageCollection dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFFile *imageFile = [imageArray objectAtIndex:indexPath.row];
    //PFFile *imageFile = [imageObject objectForKey:@"feedImage"];
    
//    cell.activity.hidden = NO;
  //  [cell.activity startAnimating];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.groupImageView.image = [UIImage imageWithData:data];
          //  [cell.activity stopAnimating];
          //  cell.activity.hidden = YES;
        }
    }];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PFFile *imageFile = [imageArray objectAtIndex:indexPath.row];
    //PFFile *imageFile = [imageObject objectForKey:@"feedImage"];
    
    //    cell.activity.hidden = NO;
    //  [cell.activity startAnimating];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
          
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
//            ImageViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"ImageView"];
//            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainVc];
//              mainVc.image = [UIImage imageWithData:data];
//            [self.navigationController presentViewController:navController animated:YES completion:nil];
        }
    }];

    
   
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
