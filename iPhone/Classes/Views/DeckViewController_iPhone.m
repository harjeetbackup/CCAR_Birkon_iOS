//
//  DeckViewController.m
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeckCell_iPhone.h"
#import "CardDetails_iPhone.h"
#import "AppDelegate_iPhone.h"

#import "FlashCard.h"
#import "CardList_iPhone.h"
#import "ModalViewCtrl_iPhone.h"

#import "DeckViewController_iPhone.h"
#import "SearchViewController_iPhone.h"
#import "IndexViewController_iPhone.h"
#import "MyCommentsViewController_iPhone.h"
#import "MyVoiceNotesViewController_iPhone.h"

#import "Utils.h"

#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//static NSString *facebookAppId=@"153061968092263";
//static NSString *facebookAppSecretKey=@"5c0f38edb94a13f9592f2df6f46ca202";
// this app id is for spearhead flash cards
//static NSString *facebookAppId=@"136422206434654";
//static NSString *facebookAppSecretKey=@"d9b94a7b6157859be29f2556d00fadde";



@implementation DeckViewController_iPhone
@synthesize cardDecks = _cardDecks;
bool navBar=YES;
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
	//[_tableView setBackgroundColor:[UIColor clearColor]];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        // code here
        self.navigationController.navigationBarHidden = NO;
        UIImage *image = [UIImage imageNamed:@"background.png"];
        [self.dailyBlessingImgView setImage:image];
        self.dailyBlessingToolBar.tintColor = [UIColor blackColor];
        self.searchButton.tintColor = [UIColor whiteColor];
        self.indexButton.tintColor = [UIColor whiteColor];
        self.settingButton.tintColor = [UIColor whiteColor];
        self.helpButton.tintColor = [UIColor whiteColor];
        self.infoButton.tintColor = [UIColor whiteColor];
       /* if([[UIScreen mainScreen] bounds].size.height == 568)
        {
            self.view.backgroundColor = [UIColor clearColor];
            CGRect copyRight = self.coprrightLabel.frame;
            copyRight.origin.y = 460;
            self.coprrightLabel.frame = copyRight;
        }*/
       // [[UIScreen mainScreen] bounds].size.height == 568
        
      /*  CGRect myFrameTableHeight = self.blessingTable.frame;
        myFrameTableHeight.size.height = 300;
        self.blessingTable.frame = myFrameTableHeight;
        
        CGRect myLabel = self.coprrightLabel.frame;
        myFrameTableHeight.size.height = 250;
        self.coprrightLabel.frame = myLabel;
        
        
        self.coprrightLabel.textColor = [UIColor  redColor];
        [self.coprrightLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:8.5]];*/

        
        // self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        // code here
        // self.navigationController.navigationBarHidden = NO;
        
       /* self.myLabelSeven.textColor = [UIColor  colorWithRed:54.0/255 green:95.0/255 blue:145.0/255 alpha:1];
        [self.myLabelSeven setFont:[UIFont fontWithName:@"Arial-BoldMT" size:48.5]];
        self.view.backgroundColor = [UIColor clearColor];*/
        //_tableView.backgroundView = self.myLabelSeven;

        UIImage *imageSetting = [UIImage imageNamed:@"6b.png"];
        [self.settingButton setImage:imageSetting];
        self.settingButton.tintColor = [UIColor  colorWithRed:52.0/255 green:122.0/255 blue:164.0/255 alpha:1];
        
        UIImage *imageIndex = [UIImage imageNamed:@"5.png"];
        [self.indexButton setImage:imageIndex];
        self.indexButton.tintColor = [UIColor  colorWithRed:52.0/255 green:122.0/255 blue:164.0/255 alpha:1];
        
        UIImage *imageZoom = [UIImage imageNamed:@"4.png"];
        [self.searchButton setImage:imageZoom];
        self.searchButton.tintColor = [UIColor colorWithRed:52.0/255 green:122.0/255 blue:164.0/255 alpha:1];
       
        UIImage *imageHelp = [UIImage imageNamed:@"7.png"];
        [self.helpButton setImage:imageHelp];
        self.helpButton.tintColor = [UIColor colorWithRed:52.0/255 green:122.0/255 blue:164.0/255 alpha:1];
        
        UIImage *imageInfo = [UIImage imageNamed:@"info_seven.png"];
        [self.infoButton setImage:imageInfo];
        self.infoButton.tintColor = [UIColor colorWithRed:52.0/255 green:122.0/255 blue:164.0/255 alpha:1];

        
       // [self.myLabelSeven setFrame:CGRectMake(0, 800, 320, 20)];
       // _tableView.backgroundView = self.myLabelSeven;
       /* UILabel *abc = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        abc.text = @"asjdlkasjdasjdl";
        abc.textColor = [UIColor redColor];
        _tableView.backgroundView = abc;
        //[self.view addSubview:abc];*/
        
        //self.coprrightLabel.textColor = [UIColor  colorWithRed:54.0/255 green:95.0/255 blue:145.0/255 alpha:1];
       // [self.coprrightLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:8.5]];
        
        self.view.backgroundColor = [UIColor clearColor];
       /* CGRect copyRight = self.coprrightLabel.frame;
        copyRight.origin.y = 505;
        self.coprrightLabel.frame = copyRight;*/

       // self.coprrightLabel.backgroundColor = [UIColor redColor];
        // UIImage *image = [UIImage imageNamed:@"Launching_iphone568@2x.png"];
        //[self.dailyBlessingImgView setImage:image];
        
        UIView *sevenViewNavBar = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,44)];
        
        sevenViewNavBar.backgroundColor = [UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
        //sevenViewNavBar.backgroundColor= [UIColor yellowColor];
        //[self.view addSubview:sevenViewNavBar];
        
        UILabel *sevenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 320, 50)];
        sevenLabel.text = @"NFTY’s Bencher by CCAR";
        [sevenLabel setTextAlignment:UITextAlignmentCenter];
        sevenLabel.textColor = [UIColor  colorWithRed:54.0/255 green:95.0/255 blue:145.0/255 alpha:1];
        [sevenLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
       // [self.view addSubview:sevenLabel];
        
        //[self.navigationController.navigationBar setTintColor:[UIColor redColor]];
        CGRect myFrameImg = self.dailyBlessingImg.frame;
        // myFrame.origin.x = 634;
        myFrameImg.origin.y = 0;
        self.dailyBlessingImg.frame = myFrameImg;
        
        CGRect myFrameTable = self.blessingTable.frame;
        myFrameTable.origin.y = 78;
        self.blessingTable.frame = myFrameTable;
        //self.dailyBlessingsTable.backgroundColor = [UIColor whiteColor];
        
        CGRect myFrameTableHeight = self.blessingTable.frame;
        myFrameTableHeight.size.height = 360;
        self.blessingTable.frame = myFrameTableHeight;
        
        //self.dailyBlessingToolBar.tintColor = [UIColor redColor];
        //self.dailyBlessingImg.hidden=YES;
    }
    
	/*
	UIImage *image = [UIImage imageNamed: @"footer_bar_bg.png"];
	UIImageView *imageview = [[UIImageView alloc] initWithImage: image];
	imageview.frame = CGRectMake(0.0,0.0,320.0,44.0);
	self.navigationItem.titleView = imageview;
	*/
	self.navigationController.navigationBarHidden = NO;
	self.navigationController.delegate = self;
	//self.title = @"Antibiotic Manual";
	//self.title = [Utils getValueForVar:kHeaderTitle];
	UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 250, 40)];
	tlabel.text=[Utils getValueForVar:kHeaderTitle];
    tlabel.textColor=[UIColor whiteColor];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.adjustsFontSizeToFitWidth=YES;
	tlabel.font = [UIFont boldSystemFontOfSize:18];
	[tlabel setTextAlignment:UITextAlignmentCenter];
   // self.navigationItem.titleView=tlabel;

	
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    navBar=YES;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [super viewWillAppear:animated];
        
        self.navigationItem.hidesBackButton=YES;
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        [super viewWillAppear:animated];
    }
    // [self.navigationController setNavigationBarHidden:YES animated:animated];
    // [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if(navBar)
        [self.navigationController setNavigationBarHidden:NO animated:animated];
        [super viewWillDisappear:animated];
    }
    
}

- (void)dealloc
{
    [_dailyBlessingImgView release];
    [_dailyBlessingToolBar release];
    [_searchButton release];
    [_indexButton release];
    [_settingButton release];
    [_helpButton release];
    [_infoButton release];
    [_coprrightLabel release];
    [_blessingTable release];
    [_dailyBlessingImg release];
    [_myLabelSeven release];
    [super dealloc];
}
/*-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton=YES;
    
}*/
#pragma mark -
#pragma mark UITableView delegates

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if([[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"yes"])
    {
        if(section == 4)
            return _cardDecks.flashCardDeckList.count;
        return 1;
    }
    else
    {
        if(section == 3)
            return _cardDecks.flashCardDeckList.count;
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return 1;
    }
    else
    {
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 50;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"yes"])
        return 5;
    else
        return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeckCell_iPhone* cell = nil;
   
    if([[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"yes"])
    {
        UITableViewCell* introCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        switch (indexPath.section)
        {
            case 0:
                tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
                introCell.textLabel.text=@"Introduction";
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                    introCell.backgroundColor=[UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
                }
                else{
                    introCell.backgroundColor=[Utils colorFromString:[Utils getValueForVar:kIntroDeckColor]];
                }
                
                return introCell;
                break;
            case 1:
                tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
                cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:_cardDecks.allCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kAllCardsTextColor]]];
                break;
                
            case 2:
                tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
                cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:_cardDecks.allSongsDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
                break;
            case 3:
                tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
                cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:_cardDecks.bookMarkedCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
                break;
                
            case 4:
                tableView.separatorColor = [Utils colorFromString:@"180,180,180"];
                cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row] withTextColor:[Utils colorFromString:[Utils getValueForVar:kDeckCardsTextColor]]];
                
                // cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
                
                break;
        }
    }
    else
    {
        switch (indexPath.section)
        {
            case 0:
                tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
                cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:_cardDecks.allCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kAllCardsTextColor]]];
                break;
                
            case 1:
                tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
                cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:_cardDecks.allSongsDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
                break;
            case 2:
                tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
                cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:_cardDecks.bookMarkedCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
                break;
                
            case 3:
                tableView.separatorColor = [Utils colorFromString:@"180,180,180"];
                cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row] withTextColor:[Utils colorFromString:[Utils getValueForVar:kDeckCardsTextColor]]];
                break;
        }
    }
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	cell.backgroundColor = [UIColor colorWithRed:0.0 green:0.322 blue:0.369 alpha:1.0];
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.section == 2 && [[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"no"] && indexPath.row == 0)|| (indexPath.section == 4 && [[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"yes"] && indexPath.row == 0))
        return;
    
    NSMutableArray* deckArray=nil;
    if([[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"yes"])
    { ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kcontentTypeIntro];
        switch (indexPath.section)
        {
            case 0:
                navBar = NO;
                deckArray = nil;
                [model setParentCtrl:self];
                [self presentModalViewController:model animated:YES];
                [model release];
                return;
                break;
                
                
            case 1:
                [AppDelegate_iPhone delegate].isBookMarked = NO;
                deckArray = [_cardDecks.allCardDeck  getCardsList];
                break;
            case 2:
                [AppDelegate_iPhone delegate].isBookMarked = NO;
                deckArray = [_cardDecks.allSongsDeck  getCardsList];
                break;
            case 3:
                [AppDelegate_iPhone delegate].isBookMarked = YES;
                deckArray = [_cardDecks.bookMarkedCardDeck  getCardsList];
                if (deckArray == nil || deckArray.count <= 0)
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There are no bookmarked items" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    return;
                }
                break;
                
            case 4:
                [AppDelegate_iPhone delegate].isBookMarked = NO;
                deckArray = [[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row]  getCardsList];
                break;
        }
        if([[[Utils getValueForVar:kCardList] lowercaseString] isEqualToString:@"yes"])
        {
            CardListIPhone* cardListView = [[CardListIPhone alloc] initWithNibName:@"CardList_iPhone" bundle:nil];
            [self.navigationController pushViewController:cardListView animated:YES];
            if(indexPath.section == 4)
                [cardListView showCardsForDeck:indexPath.row];
            else if(indexPath.section == 3)
                [cardListView showBookmarkCards];
            else if(indexPath.section == 2)
                [cardListView showAllSongs];
            else if(indexPath.section == 1)
                [cardListView showAllCards];
            [cardListView release];
        }
        else
        {
            CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
            detail.arrCards=deckArray;
            [self.navigationController pushViewController:detail animated:YES];
            if([AppDelegate_iPhone delegate].isRandomCard == 1)
            {
                [Utils randomizeArray:deckArray];
            }
            
            //[detail loadArrayOfCards:deckArray];
            [detail release];
        }
    }
    else{
        switch (indexPath.section)
        {
            case 0:
                [AppDelegate_iPhone delegate].isBookMarked = NO;
                deckArray = [_cardDecks.allCardDeck  getCardsList];
                break;
                
            case 1:
                [AppDelegate_iPhone delegate].isBookMarked = YES;
                deckArray = [_cardDecks.bookMarkedCardDeck  getCardsList];
                if (deckArray == nil || deckArray.count <= 0)
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There are no bookmarked items" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    return;
                }
                break;
                
            case 2:
                [AppDelegate_iPhone delegate].isBookMarked = NO;
                deckArray = [[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row]  getCardsList];
                break;
        }
        
        
        
    }
    
    //  cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIndexRowColor]];
    
}


- (IBAction)displaySettings
{
    navBar=NO;
	ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kContentTypeSetting];
	[model setParentCtrl:self];
	[self presentModalViewController:model animated:YES];
	[model release];
}

- (IBAction)displayHelp
{
    navBar=NO;
	ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kContentTypeHelp];
	[model setParentCtrl:self];
	[self presentModalViewController:model animated:YES];
	[model release];
}

- (IBAction)displayInfo
{
    navBar=NO;
	ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kContentTypeInfo];
	[model setParentCtrl:self];
	[self presentModalViewController:model animated:YES];
	[model release];
}


- (IBAction)searchCards
{
	SearchViewController_iPhone* searchView = [[SearchViewController_iPhone alloc] initWithNibName:@"SearchView_iPhone" bundle:nil];
	[self.navigationController pushViewController:searchView animated:YES];
	[searchView release];
}


- (IBAction)cardIndex
{
	IndexViewController_iPhone* indexView = [[IndexViewController_iPhone alloc] initWithNibName:@"IndexView_iPhone" bundle:nil];
	[self.navigationController pushViewController:indexView animated:YES];
	[indexView release];
}


- (void) myComments{
    
	MyCommentsViewController_iPhone* commentsView = [[MyCommentsViewController_iPhone alloc] initWithNibName:@"MyCommentsView_iPhone" bundle:nil];
	[self.navigationController pushViewController:commentsView animated:YES];
	[commentsView release];
	
}

- (void) myVoiceNotes{
	
	MyVoiceNotesViewController_iPhone* notesView = [[MyVoiceNotesViewController_iPhone alloc] initWithNibName:@"MyVoiceNotesView_iPhone" bundle:nil];
	[self.navigationController pushViewController:notesView animated:YES];
	[notesView release];
}


/* Added By Ravindra */

-(IBAction) showActionSheet{
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];
	
	
	[actionSheet addButtonWithTitle:@"Info"];
	
	if ([AppDelegate_iPhone delegate].isVoiceNotesEnabled) {
		[actionSheet addButtonWithTitle:@"My Voice Notes"];
	}
	
	if ([AppDelegate_iPhone delegate].isCommentsEnabled) {
		[actionSheet addButtonWithTitle:@"My Comments"];
	}
	
	
	if ([AppDelegate_iPhone delegate].isFacebookEnabled) {
		[actionSheet addButtonWithTitle:@"Publish to Facebook"];
	}
	
	if ([AppDelegate_iPhone delegate].isTwitterEnabled) {
		[actionSheet addButtonWithTitle:@"Publish to Twitter"];
	}
	
	[actionSheet addButtonWithTitle:@"Cancel"];
	actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;

	[actionSheet showInView:self.view];
	[actionSheet release]; 	
	
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
	if ([title isEqualToString:@"Info"]) {
		[self displayInfo];
	}
	
	else if ([title isEqualToString:@"Publish to Facebook"]) {
		[self publishToFacebook];
	}
	
	else if ([title isEqualToString:@"Publish to Twitter"]) {
		[self publishToTwitter];
	}
	
	else if ([title isEqualToString:@"My Voice Notes"]) {
		[self myVoiceNotes];
	}
	
	else if ([title isEqualToString:@"My Comments"]) {
		[self myComments];
	}
	
	//[title release];
}


-(void) publishToFacebook{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:[Utils getValueForVar:kFacebookMessage]];
        
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }
    
	
}



-(void) publishToTwitter{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[Utils getValueForVar:kTwitterMessage]];
        [self presentModalViewController:tweetSheet animated:YES];
    }
   
	
}

/* End of Updated Code By Ravindra */

- (void)updateInfo
{
	[_cardDecks updateProficiency];
	[_tableView reloadData];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if (viewController == self)
		[self updateInfo];
}


- (void)viewDidUnload {
    [self setDailyBlessingTable:nil];
    [self setDailyBlessingImgView:nil];
    [self setDailyBlessingToolBar:nil];
    [self setSearchButton:nil];
    [self setIndexButton:nil];
    [self setSettingButton:nil];
    [self setHelpButton:nil];
    [self setInfoButton:nil];
    [self setCoprrightLabel:nil];
    [self setBlessingTable:nil];
    [self setDailyBlessingImg:nil];
    [self setMyLabelSeven:nil];
    [super viewDidUnload];
}
@end
