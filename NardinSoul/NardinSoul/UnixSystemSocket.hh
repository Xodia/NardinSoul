#ifndef UNIX_SYSTEM_SOCKET_HH
#define UNIX_SYSTEM_SOCKET_HH

#import <UIKit/UIKit.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>

enum SOCKET_PROTOCOL {
    TCP = 0,
    UDP
    };

@interface SystemSocket : NSObject
{
    enum SOCKET_PROTOCOL           _protocol;
    unsigned int              _port;
    int                       _socket;
    SystemSocket            *_tmpSocket;
    NSString                  *_address;
    struct sockaddr_in	    _sin;
}


- (bool) openSocket;
- (bool) bindSocket;
- (bool) listenSocket;
- (bool) acceptSocket;
- (bool) closeSocket;
- (bool) connectSocket;

- (SystemSocket *) GetNewConnection;
- (void) Bind;
- (void) Connect;
- (void) Delete;
- (void) Send: (const char *)data withSize: (const int) size;
- (void) Recv: (char *)data withSize: (const int) size;

- (id) initWithProtocolType: (enum SOCKET_PROTOCOL) proto andPort: (int) port;
- (id) initWithProtocolType: (enum SOCKET_PROTOCOL) proto andPort: (int) port andAddress: (NSString *) address;
- (id) initWithFd: (int) fd;
@end

#endif
