//
//  OutlineViewController.m
//  OutlineViewDemo
//
//  Created by Live365_Joni on 7/8/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import "OutlineViewController.h"

@implementation OutlineViewController
@dynamic  outlineView;

-(void)dealloc
{
    [_outlineView release];
    [super dealloc];
}

-(id)init
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL fileURLWithPath:@"/Users/live365/Desktop/mp3"];
        _contents = [[OTMediaFolderEntity alloc] initWithFileURL:url];
        [_outlineView reloadData];
    }
    return self;
}

-(void)setOutlineView:(NSOutlineView *)outlineView
{
    _outlineView = [outlineView retain];
    [_outlineView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
}

-(void)_removeItemAtRow:(NSInteger)row
{
    id item = [_outlineView itemAtRow:row];
    OTMediaFolderEntity *parent = (OTMediaFolderEntity*)[_outlineView parentForItem:item];
    if (parent == nil) {
        parent = _contents;
    }
    NSInteger indexInParent = [parent.children indexOfObject:item];
    [parent.children removeObjectAtIndex:indexInParent];
    if (parent == _contents) {
        parent = nil;
    }
    [_outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:indexInParent] inParent:parent withAnimation:NSTableViewAnimationEffectFade ];
}

#pragma mark -
#pragma mark - outlineView Delegate and dataSource
-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return _contents.children.count;
    }else{
        return [[(OTMediaFolderEntity *)item children] count];
    }
    return 0;
}

-(id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [_contents.children objectAtIndex:index] ;
    }
    else{
        return [[(OTMediaFolderEntity *)item children] objectAtIndex:index] ;
    }
}

-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    BOOL result = [item isKindOfClass:[OTMediaFolderEntity class]];
    return result;
}

-(id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return item;
}

-(CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
    if ([item isKindOfClass:[OTMediaFolderEntity class]]) {
        return 20;
    }
    else{
        return 30;
    }
}

-(NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    if ([item isKindOfClass:[OTMediaFolderEntity class]]) {
        return [outlineView makeViewWithIdentifier:@"GroupCell" owner:self];
    }
    else
    {
        NSView *result = [outlineView makeViewWithIdentifier:@"Main Cell" owner:self];
        return result;
    }
    return nil;
}

-(id<NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView pasteboardWriterForItem:(id)item
{
    return item;
}

#pragma mark -
#pragma mark - IBAction
-(IBAction)showMediaReveal:(id)sender
{
    NSInteger row = [_outlineView rowForView:sender];
    if (row != -1) {
        OTMediaEntity *entity = [_outlineView itemAtRow:row];
        if (entity) {
            [[NSWorkspace sharedWorkspace] selectFile:[entity.fileURL path] inFileViewerRootedAtPath:nil];
        }
    }
}

-(IBAction)deleteSelectedItems:(id)sender
{
    [_outlineView beginUpdates];
    [_outlineView.selectedRowIndexes enumerateIndexesWithOptions:NSEnumerationReverse usingBlock:^(NSUInteger index, BOOL *stop) {
        [self _removeItemAtRow:index];
    }];
    [_outlineView endUpdates];
}

@end
