//
//  SearchViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "SearchViewController.h"
#import "RCLabel.h"
#import "StringHelper.h"
#import "CardDetails.h"
#import "DBAccess.h"
#import "FlashCard.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



@implementation SearchViewController
@synthesize _tableView;
@synthesize cards;
@synthesize _searchBar;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    
	[super viewDidLoad];
	self.navigationItem.title=@"Search Cards";
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, 64, 30)];
	//[leftButtonImg setImage:[UIImage imageNamed:@"backSeven.png"] forState:UIControlStateNormal];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [self.searchButton setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
        CGRect myFrameTableHeight = _tableView.frame;
        myFrameTableHeight.size.height = 670;
        _tableView.frame = myFrameTableHeight;
    }
    else
    {
        [self.searchButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        CGRect myFrameTableHeight = _tableView.frame;
        myFrameTableHeight.size.height = 660;
        _tableView.frame = myFrameTableHeight;
    }

	[leftButtonImg addTarget:self action:@selector(closeSearch:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
	self.navigationItem.leftBarButtonItem=leftButton;
	
	cards=[[AppDelegate_iPad getDBAccess] searchCardsByName:@""];
	
}


-(void) setParentViewCtrl:(DeckViewController*) parentView{
	_parentView=parentView;
}


-(IBAction) closeSearch:(id)sender{
	[self.view removeFromSuperview];
}


- (void)popView{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	/*
	if ([searchText isEqualToString:@""]) {
		return;
	}
	
	[cards removeAllObjects];	 
	cards=[[AppDelegate_iPad getDBAccess] searchCardsByName:searchText];
	[_tableView reloadData];
	 */
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
	NSString *searchText=[searchBar text];
	//if ([searchText isEqualToString:@""]) {
	//	return;
	//}
	
	[cards removeAllObjects];	 
	cards=[[AppDelegate_iPad getDBAccess] searchCardsByName:searchText];
	[_tableView reloadData];
	
	[searchBar resignFirstResponder];

}


- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
	[cards removeAllObjects];	 
	cards=[[AppDelegate_iPad getDBAccess] searchCardsByName:@""];
	[_tableView reloadData];
	
	[searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark Table view data source

FlashCard* card;
NSString * strCardName;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	// Return the number of rows in the section.
    if ([cards count]==0) {
		return 1;
	}
	
	return [cards count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSearchCardListColor]]];
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]];
        [cell setSelectedBackgroundView:bgColorView];
        [bgColorView release];
	}
    
	if ([cards count]==0) {
		cell.textLabel.text = @"No Search Result Found!";
		cell.textLabel.font = [UIFont systemFontOfSize:14];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}else {
		NSString *cellValue = [[cards objectAtIndex:indexPath.row] cardName];
        
        NSString* newStr=[self stringByDecodingHTMLEntitiesInString:cellValue];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 25)];
        newStr = [newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        // NSString* newStr=[self stringByDecodingHTMLEntitiesInString:str];
        label = [newStr Answer_newSizedCellLabelWithSystemFontOfSize:14];
        if ([cell.contentView subviews]){
            for (UIView *subview in [cell.contentView subviews]) {
                [subview removeFromSuperview];
            }
        }
        [cell.contentView addSubview:label];
        
        // cell.textLabel.text = cellValue;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellValue=nil;
	}

	
	
    return cell;
}


- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	CGSize labelSize = CGSizeMake(450.0f, 20.0);
	if ([cards count]!=0) {
		
		card=(FlashCard*)[cards objectAtIndex:indexPath.row];
		strCardName = [card cardName];
		if ([strCardName length] > 0)
			labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 16.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
	}
	return 24.0 + labelSize.height;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([cards count]==0) {
		return;
	}
	
	[_parentView showSearchViewForDeck:cards cardIndex:indexPath.row search:[_searchBar text]];
	
	/*[_parentView clearView];
	
	CardDetails* detail = [[CardDetails alloc] initWithNibName:@"CardDetailsiPad" bundle:nil];
	[self.view addSubview:detail.view];
	
	detail._selectedCardIndex=indexPath.row;
	detail._searchText=[_searchBar text];
	[detail loadArrayOfCards:cards withParentViewC:_parentView];
	[detail release];	 
	 */

}

- (NSString *)stringByDecodingHTMLEntitiesInString:(NSString *)input {
    NSMutableString *results = [NSMutableString string];
    NSScanner *scanner = [NSScanner scannerWithString:input];
    [scanner setCharactersToBeSkipped:nil];
    while (![scanner isAtEnd]) {
        NSString *temp;
        if ([scanner scanUpToString:@"&" intoString:&temp]) {
            [results appendString:temp];
        }
        if ([scanner scanString:@"&" intoString:NULL]) {
            BOOL valid = YES;
            unsigned c = 0;
            NSUInteger savedLocation = [scanner scanLocation];
            if ([scanner scanString:@"#" intoString:NULL]) {
                // it's a numeric entity
                if ([scanner scanString:@"x" intoString:NULL]) {
                    // hexadecimal
                    unsigned int value;
                    if ([scanner scanHexInt:&value]) {
                        c = value;
                    } else {
                        valid = NO;
                    }
                } else {
                    // decimal
                    int value;
                    if ([scanner scanInt:&value] && value >= 0) {
                        c = value;
                    } else {
                        valid = NO;
                    }
                }
                if (![scanner scanString:@";" intoString:NULL]) {
                    // not ;-terminated, bail out and emit the whole entity
                    valid = NO;
                }
            } else {
                if (![scanner scanUpToString:@";" intoString:&temp]) {
                    // &; is not a valid entity
                    valid = NO;
                } else if (![scanner scanString:@";" intoString:NULL]) {
                    // there was no trailing ;
                    valid = NO;
                } else if ([temp isEqualToString:@"amp"]) {
                    c = '&';
                } else if ([temp isEqualToString:@"quot"]) {
                    c = '"';
                } else if ([temp isEqualToString:@"lt"]) {
                    c = '<';
                } else if ([temp isEqualToString:@"gt"]) {
                    c = '>';
                } else {
                    // unknown entity
                    valid = NO;
                }
            }
            if (!valid)
            {
                // we errored, just emit the whole thing raw
                [results appendString:[input substringWithRange:NSMakeRange(savedLocation, [scanner scanLocation]-savedLocation)]];
            }
            else
            {
                [results appendFormat:@"%C", (unichar)c];
            }
        }
    }
    return results;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_searchButton release];
    [super dealloc];
}


- (void)viewDidUnload {
    [self setSearchButton:nil];
    [super viewDidUnload];
}
@end

