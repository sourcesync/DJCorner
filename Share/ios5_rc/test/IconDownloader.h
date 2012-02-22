

@class DJ;
@class RootViewController;

@protocol IconDownloaderDelegate;

@interface IconDownloader : NSOperation
{
    DJ *appRecord;
    NSIndexPath *indexPathInTableView;
    id <IconDownloaderDelegate> delegate; 
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) DJ *appRecord;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end