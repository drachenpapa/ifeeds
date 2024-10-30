//
//  IFArticlesViewController.m
//  iFeeds
//
//  Created by Henning Wrede on 08.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import "IFFeedViewController.h"



@interface IFFeedViewController () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *article;
    NSMutableString *articleID;
    NSMutableString *name;
    NSMutableString *author;
    NSMutableString *url;
    NSMutableString *pubDate;
    NSMutableString *content;
    NSMutableString *summary;
    NSString *element;
}
@end



@implementation IFFeedViewController


- (void) awakeFromNib {
    [super awakeFromNib];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    feeds = [[NSMutableArray alloc] init];
    [self updateFeed];
    self.toolbarLabel.title = [NSString stringWithFormat:@"%lu %@", (unsigned long)[feeds count], NSLocalizedString(@"articles", nil)];
    // RefreshControl beschreibt die Wischgeste nach unten zum Aktualisieren
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateFeed) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void) updateFeed {
    [feeds removeAllObjects];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:self.linkToFeed];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table View

-(NSInteger) numberOfSectionsInTableView: (UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feeds.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"name"];
    NSString *detailText = [NSString stringWithFormat:@"%@ - %@", [[feeds objectAtIndex:indexPath.row] objectForKey:@"author"], [[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"]];
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UINavigationController *navVC = (UINavigationController *) self.splitViewController.viewControllers.lastObject;
        IFArticleViewController *articleVC = (IFArticleViewController *) navVC.topViewController;
        articleVC.navigationItem.title = [feeds[indexPath.row] objectForKey:@"title"];
        articleVC.url = [NSURL URLWithString: [[feeds[indexPath.row] objectForKey: @"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        articleVC.content = [feeds[indexPath.row] objectForKey:@"content"];
    }
}


#pragma mark - NSXMLParser

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    
    // Anmerkung: wird elementName verwendet, werden die Artikel ab und an nicht angezeigt.
    if ([element isEqualToString:@"item"] || [element isEqualToString:@"entry"]) {
        article   = [[NSMutableDictionary alloc] init];
        articleID = [[NSMutableString alloc] init];;
        name      = [[NSMutableString alloc] init];
        author    = [[NSMutableString alloc] init];
        url       = [[NSMutableString alloc] init];
        pubDate   = [[NSMutableString alloc] init];
        content   = [[NSMutableString alloc] init];
        if ([element isEqualToString:@"entry"]) {
            summary      = [[NSMutableString alloc] init];
        }
    }
    // Hack, um Daten aus den Tag-Attributen zuzuordnen
    if ([element isEqualToString:@"link"] && [[attributeDict objectForKey:@"href"] length] != 0) {
        url = [attributeDict objectForKey:@"href"];
    }
}

- (void) parser:(NSXMLParser *) parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"]) {
        [article setObject:articleID forKey:@"articleID"];
        [article setObject:name      forKey:@"name"];
        [article setObject:author    forKey:@"author"];
        [article setObject:url       forKey:@"url"];
        [article setObject:pubDate   forKey:@"pubDate"];
        // Wenn der Content eines Artikel verfuegbar ist, soll nur dieser gespeichert und spaeter angezeigt werden.
        // Da die Instanvariable Content auch die Description von RSS-Feeds enthaelt, muss hierfuer keine eigene Abfrage implementiert werden.
        if ([content length] != 0) {
            [article setObject:content forKey:@"content"];
        } else {
            // Ist der Content nicht verfuegbar, wird die Summary genutzt.
            [article setObject:summary forKey:@"content"];
        }
        [feeds addObject:[article copy]];
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([element isEqualToString:@"guid"] || [element isEqualToString:@"id"]) {
        [articleID appendString:string];
    } else if ([element isEqualToString:@"title"]) {
        [name appendString:string];
    } else if ([element isEqualToString:@"author"] || [element isEqualToString:@"name"]) {
        [author appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [url appendString:string];
    } else if ([element isEqualToString:@"pubDate"] || [element isEqualToString:@"updated"]) {
        [pubDate appendString:string];
    } else if ([element isEqualToString:@"description"] || [element isEqualToString:@"content"]) {
        [content appendString:string];
    } else if ([element isEqualToString:@"summary"]) {
        [summary appendString:string];
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    [self.tableView reloadData];
}


#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Setzt den Text des "Zurueck"-Buttons in der Navigationsleiste.
    // Andernfalls steht dort der Name des Feeds, welcher ueber das Design hinauslaufen koennte.
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"button.back", nil) style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    // Artikel wird angezeigt
    if ([[segue identifier] isEqualToString:@"showArticle"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Titel in der Navigation mit dem Titel des Artikels setzen
        [[segue destinationViewController] setTitle:[feeds[indexPath.row] objectForKey:@"name"]];
        // Den Namen setzen, damit der Artikeltitel geteilt wird
        [[segue destinationViewController] setArticleTitle:[feeds[indexPath.row] objectForKey:@"name"]];
        // Den anzuzeigenden Inhalt des Artikels setzen
        [[segue destinationViewController] setContent:[feeds[indexPath.row] objectForKey:@"content"]];
        // Die URL des Artikels setzen
        [[segue destinationViewController] setUrl:[NSURL URLWithString: [[feeds[indexPath.row] objectForKey: @"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}

@end
