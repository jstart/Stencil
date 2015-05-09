//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "NSMenu+StencilAdditions.h"
#import "DZLImplementationCombine.h"
#import "Stencil.h"

NSString *const ProjectNavigatorContextualMenu = @"Project navigator contextual menu";

@implementation_combine(NSMenu, Additions)

- (instancetype)initWithTitle:(NSString *)aTitle
{
  [Stencil sharedPlugin].beginCreateTemplateFromGroup = NO;
  if ([Stencil sharedPlugin].canCreateFromCustomTemplate) {
    [Stencil sharedPlugin].menuItemNewFromCustomTemplate.action = [Stencil sharedPlugin].menuItemDelete.action;
  } else {
    [Stencil sharedPlugin].menuItemNewFromCustomTemplate.action = nil;
  }
  
  typeof(self) menu = dzlSuper(initWithTitle:aTitle);
  [[Stencil sharedPlugin] observeHighlightedItemForMenu:menu];
  return menu;
}

- (void)addItem:(NSMenuItem *)menuItemBeingAddedByXcode
{
  BOOL isContextualMenu = [self.title isEqualToString:ProjectNavigatorContextualMenu];
  if (isContextualMenu) {
    [[Stencil sharedPlugin] observeHighlightedItemForMenu:self];
  }
  
  BOOL addCustomFileItem = (isContextualMenu && [menuItemBeingAddedByXcode.title isEqualToString:@"New Fileâ¦"]);
  
  if (addCustomFileItem) {
    NSMenuItem *customMenuItem = [[NSMenuItem alloc] initWithTitle:MenuItemTitleNewFileFromCustomTemplate action:nil keyEquivalent:@""];
    dzlSuper(addItem:customMenuItem);
    [Stencil sharedPlugin].menuItemNewFile = menuItemBeingAddedByXcode;
    [Stencil sharedPlugin].menuItemNewFromCustomTemplate = customMenuItem;
    if (![Stencil sharedPlugin].canCreateFromCustomTemplate) {
      customMenuItem.action = nil;
    }
  }
  
  BOOL addCreateTemplate = (isContextualMenu && [menuItemBeingAddedByXcode.title isEqualToString:@"Delete"]);
  
  if (addCreateTemplate) {
    NSMenuItem *customMenuItem = [[NSMenuItem alloc] initWithTitle:@"Create File Template from Group" action:menuItemBeingAddedByXcode.action keyEquivalent:@""];
    dzlSuper(addItem:customMenuItem);
    [Stencil sharedPlugin].menuItemDelete = menuItemBeingAddedByXcode;
    [Stencil sharedPlugin].menuItemCreateTemplateFromGroup = customMenuItem;
    [self addItem:[NSMenuItem separatorItem]];
  }
  
  dzlSuper(addItem:menuItemBeingAddedByXcode);
}


@end


@implementation NSMenu (StencilAdditions)

- (void)duplicateItemWithTitle:(NSString *)existingTitle duplicateTitle:(NSString *)duplicateTitle
{
  NSUInteger index = [self indexOfItemWithTitle:existingTitle];
  NSMenuItem *originalItem = [self itemWithTitle:existingTitle];
  NSMenuItem *customNewMenuItem = [[NSMenuItem alloc] initWithTitle:duplicateTitle action:originalItem.action keyEquivalent:@""];
  [self insertItem:customNewMenuItem atIndex:index];
}

@end
