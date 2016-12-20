//
//  ViewController.m
//  EdmundsAPICalling
//
//  Created by Naresh Kandala on 04/12/16.
//  Copyright © 2016 Naresh Kandala. All rights reserved.
//

#import "ViewController.h"
#define kMyString @"This is my string text!"
#import "MBProgressHUD.h"
@interface ViewController ()<UISearchBarDelegate>

{
    NSArray *dict;
    NSMutableArray *total_array;
}
@property (nonatomic,strong) NSArray        *dataSourceForSearchResult;
@property (nonatomic)        BOOL           searchBarActive;
@property (nonatomic)        float          searchBarBoundsY;

@property (nonatomic,strong) UISearchBar        *searchBar;
@property (nonatomic,strong) UIRefreshControl   *refreshControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self callApi];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)callApi{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSURL *url = [NSURL URLWithString:@"http://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=3bg4rbn5vr66hc3bd2z6z6tf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *err;
            NSLog(@"data %@",data);
            
            NSMutableDictionary *arr =   [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
          //  NSLog(@"%@",arr);
            
           
            dict = [arr objectForKey:@"makes"];
            NSLog(@"dictionary : %@",dict);
            total_array = [NSMutableArray new];
            for (int k = 0 ; k<[dict count]; k++) {
                
            
            NSDictionary *arr1 = [dict objectAtIndex:k];
           // NSLog(@"Devuda :  %@",arr1);
            
            NSString *str1 = [NSString stringWithFormat: @"%@",[arr1 objectForKey:@"name"]];
            NSArray *model_arr = [arr1 objectForKey: @"models"];
          //  NSLog(@"%@",model_arr);
            
            NSDictionary *dict1 = [model_arr objectAtIndex:0];
          //  NSLog(@"%@",dict1);
            
           // NSString *str = [NSString stringWithFormat:@"%@",[dict1 objectForKey:@"name"]];
          //  NSLog(@"%@",str);
            NSArray *arr_years = [dict1 objectForKey:@"years"];
           //// NSLog(@"jsvc %@",arr_years);
            
            for (int i = 0; i<[arr_years count]; i++) {
                
                //  if ([arr_years objectAtIndex:i]) {
                
                NSLog(@"dhcsh %@",[arr_years objectAtIndex:i]);
                NSString *year_str = [NSString stringWithFormat:@"%@",[[arr_years objectAtIndex:i] valueForKey:@"year"]];
                
                NSMutableArray *aara = [NSMutableArray new];
                if ([year_str isEqual:@"2016"] ) {
                    
                    
                    
                    NSString *car_str = str1;
                    NSString *str_year = [NSString stringWithFormat:@"%@",[[arr_years objectAtIndex:i] valueForKey:@"year"]];
                    
                    [aara addObject:car_str];
                    [aara addObject:str_year];
                    
                    [total_array addObject:aara];

                }

            }

            
            
        }
            NSLog(@"fx %@",total_array);
            
            }
        dispatch_async(dispatch_get_main_queue(), ^{
              [MBProgressHUD hideHUDForView:self.view animated:YES];

            [self.tableVc reloadData];
            
        });
        
    }];
    [task resume];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchBarActive) {
        return self.dataSourceForSearchResult.count;
    }else{
    return total_array.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    if (self.searchBarActive) {
        
        NSLog(@"jsvcjs %@", [self.dataSourceForSearchResult objectAtIndex:indexPath.row]);
        
        cell.textLabel.text = [self.dataSourceForSearchResult objectAtIndex:indexPath.row];
        
       // cell.textLabel.text = [[total_array objectAtIndex:indexPath.row] objectAtIndex:0]  ;
        //cell.detailTextLabel.text = [[total_array objectAtIndex:indexPath.row] objectAtIndex:1];


    }else{
        cell.textLabel.text = [[total_array objectAtIndex:indexPath.row] objectAtIndex:0]  ;
        cell.detailTextLabel.text = [[total_array objectAtIndex:indexPath.row] objectAtIndex:1];

    }
    
    
    
    return cell;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //[[self navigationController] setNavigationBarHidden:YES animated:NO];
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top-blue-bg_25*22.png"]
    //                    forBarMetrics:UIBarMetricsDefault];
    //  [[self navigationController] removeFromParentViewController];
    
    
    
    if (_shouldRefresh){
        
        [self.tableVc reloadData];
        
    }
    [super viewWillAppear:animated];
    [self prepareUI];
}
#pragma mark - actions
-(void)refreashControlAction
{
    [self cancelSearching];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // stop refreshing after 2 seconds
        [self.tableVc reloadData];
        [self.refreshControl endRefreshing];
    });
}
#pragma mark - search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSPredicate *resultPredicate    = [NSPredicate predicateWithFormat:@"SELF contains %@", searchText];
    
        self.dataSourceForSearchResult  = [[total_array objectAtIndex:0] filteredArrayUsingPredicate:resultPredicate];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0) {
        // search and reload data source
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText
                                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchDisplayController.searchBar
                                                         selectedScopeButtonIndex]]];
        [self.tableVc reloadData];
    }else{
        // if text lenght == 0
        // we will consider the searchbar is not active
        self.searchBarActive = NO;
    }
    if (self.searchBar.text.length==0) {
        [self.tableVc reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self cancelSearching];
    [self.tableVc reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchBarActive = YES;
    [self.view endEditing:YES];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    [self.searchBar setShowsCancelButton:YES animated:YES];
    UITextField *textField = [searchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    self.searchBarActive = NO;
    [self.searchBar setShowsCancelButton:NO animated:YES];
    if (self.searchBar.text.length==0) {
        [self.tableVc reloadData];
    }
}

-(void)cancelSearching{
    self.searchBarActive = NO;
    [self.searchBar resignFirstResponder];
    self.searchBar.text  = @"";
    self.dataSourceForSearchResult = 0 ;
    [self.tableVc reloadData];
    
}
-(void)prepareUI{
    [self addSearchBar];
    [self addRefreshControl];
}

-(void)addSearchBar{
    if (!self.searchBar) {
        self.searchBarBoundsY = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, self.searchview.frame.size.width,25)];
        self.searchBar.searchBarStyle       = UISearchBarIconSearch;
        self.searchBar.tintColor            = [UIColor whiteColor];
        self.searchBar.barTintColor         = [UIColor lightGrayColor];
        self.searchBar. backgroundColor     = [UIColor grayColor];
        
        self.searchBar.delegate             = self;
        self.searchBar.placeholder          = @"Search";
        
        
        
        
        
        
        
        
        //        NSString *stringColor = @"#227abd";
        //        NSUInteger red, green, blue;
        //        sscanf([stringColor UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
        //
        //        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        //
        //        self.searchBar.layer.borderColor=color.CGColor;
        //        self.searchBar.layer.borderWidth=2.0f;
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
        
        // add KVO observer.. so we will be informed when user scroll colllectionView
        [self addObservers];
    }
    
    if (![self.searchBar isDescendantOfView:self.view]) {
        [self.searchview addSubview:self.searchBar];
        //        self.searchview.backgroundColor =[UIColor lightGrayColor];
    }
}
-(void)addRefreshControl{
    //    if (!self.refreshControl) {
    //        self.refreshControl                  = [UIRefreshControl new];
    //        self.refreshControl.tintColor        = [UIColor whiteColor];
    //        [self.refreshControl addTarget:self
    //                                action:@selector(refreashControlAction)
    //                      forControlEvents:UIControlEventValueChanged];
    //    }
    //    if (![self.refreshControl isDescendantOfView:self.tableview]) {
    //        [self.tableview addSubview:self.refreshControl];
    //    }
}
-(void)startRefreshControl{
    if (!self.refreshControl.refreshing) {
        [self.refreshControl beginRefreshing];
    }
}
#pragma mark - observer
- (void)addObservers{
    [self.tableVc addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
- (void)removeObservers{
    [self.tableVc removeObserver:self forKeyPath:@"contentOffset" context:Nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UITableView *)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"] && object == self.tableVc ) {
        //        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x,
        //                                          self.searchBarBoundsY + ((-1* object.contentOffset.y)-self.searchBarBoundsY),
        //                                          self.searchBar.frame.size.width,
        //                                          self.searchBar.frame.size.height);
    }
}


@end
