//
//  VoiceNotesViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 17/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "VoiceNotesViewController.h"
#import "AppDelegate_iPad.h"
#import "VoiceRecordingViewController.h"
#import "DBAccess.h"


@implementation VoiceNotesViewController

@synthesize _tableView;
@synthesize voiceNotes;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[super viewDidLoad];
	_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
	voiceNotes=[[AppDelegate_iPad getDBAccess] getCardVoiceNotes:flashCardId];
	
}

-(void) setFlashCardId:(NSInteger)cardId{
	flashCardId=cardId;
}

-(void) setParent:(CardDetails*)parent{
	_parent=parent;
}

-(void) fetchVoiceNotes{
	voiceNotes=[[AppDelegate_iPad getDBAccess] getCardVoiceNotes:flashCardId];
	[_tableView reloadData];
}

-(IBAction) addNewNote{
	
	VoiceRecordingViewController* viewController = [[VoiceRecordingViewController alloc] initWithNibName:@"VoiceRecordingViewiPad" bundle:nil];
	[viewController setFlashCardId:flashCardId];
	[viewController setParentController:self];
	
	//[_parent.view addSubview:viewController.view];
	//[self presentModalViewController:viewController animated:YES];
	//[viewController release];
	
	[self.view addSubview:viewController.view];

}

-(IBAction) closeNotes{
	// Stop if playing....
	if (avPlayer!=nil && [avPlayer isPlaying]) {
		[avPlayer stop];
	}
	
	//[self dismissModalViewControllerAnimated:YES];
	[self.view removeFromSuperview];
	[_parent updateNavBar];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [voiceNotes count];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{    
	return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// If row is deleted, remove it from the list.
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		VoiceNote* note=(VoiceNote*)[voiceNotes objectAtIndex:indexPath.row];
		BOOL result=[[AppDelegate_iPad getDBAccess] deleteVoiceNote:note.voiceNoteId];
		if (result==YES) {
			[voiceNotes removeObjectAtIndex:indexPath.row];
			[_tableView reloadData];
		}		
	}
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kCardListColor]];
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]];
        [cell setSelectedBackgroundView:bgColorView];
        [bgColorView release];
		//cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.929 blue:0.592 alpha:1.0];
		
		/*cell.backgroundView  = [[[UIImageView alloc] 
		 initWithImage:[UIImage imageNamed:@"all_cards_bg.png"]] autorelease];*/
		
		UIImage* myImage=[UIImage imageNamed:@"arrow.png"];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
		[cell setAccessoryView:imageView];
	}
	
	
	
	NSString *cellValue = [[voiceNotes objectAtIndex:indexPath.row] title];
	cell.textLabel.text = cellValue;
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Stop if playing....
	if (avPlayer!=nil && [avPlayer isPlaying]) {
		[avPlayer stop];
	}
	
	
	VoiceNote* note=[voiceNotes objectAtIndex:indexPath.row];
	
	NSString* msg=[NSString stringWithFormat:@"Playing...%@",note.title];
	UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
	alertView.tag=1;
	[alertView show];
	[alertView release];

	
	// Play the note
	avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:note.recordedFileURL error:&error];
	[avPlayer prepareToPlay];
	[avPlayer play];
	
		
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
	if (alertView.tag==1) {
		if (avPlayer!=nil && [avPlayer isPlaying]) {
			[avPlayer stop];
		}
	}
	

}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
}



// Memory Management
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	
	// Stop if playing....
	if (avPlayer!=nil && [avPlayer isPlaying]) {
		[avPlayer stop];
		[avPlayer dealloc];
	}
	
}

- (void)dealloc {
	[super dealloc];
}


@end
