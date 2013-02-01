#include "UnixSystemSocket.hh"

// CONSTRUCTORS

@implementation SystemSocket


- (id) initWithFd:(int)fd
{
    _socket = fd;
}

- (id) initWithProtocolType:(enum SOCKET_PROTOCOL)proto andPort:(int)port
{
    _port = port;
    _protocol = proto;
    if (![self openSocket])
    {
        NSLog(@"Socket: Error lors de l'open");
    }
}

- (id) initWithProtocolType:(enum SOCKET_PROTOCOL)proto andPort:(int)port andAddress:(NSString *)address
{
    _port = port;
    _protocol = proto;
    _address = address;
    if (![self openSocket])
    {
        NSLog(@"Socket: Error lors de l'open");
    }
}

- (bool) openSocket
{
    struct protoent       *pe;
    
    if (_protocol == UDP)
        pe = getprotobyname("UDP");
    else
        pe = getprotobyname("TCP");
    
    if (-1 == (_socket = socket(AF_INET /*IPv4*/, SOCK_STREAM, pe->p_proto)))
        return (NO);
    return (YES);
}


- (bool) bindSocket
{
  _sin.sin_family = AF_INET; // IPv4
  _sin.sin_port = htons(_port);
  _sin.sin_addr.s_addr = INADDR_ANY;
  if (-1 == bind(_socket, (const struct sockaddr *)&_sin, sizeof(_sin)))
    return (false);
  return (true);
}

- (bool) listenSocket
{
  if (-1 == listen(_socket, 128))
    return (false);
  return (true);
}

- (bool) acceptSocket
{
  unsigned int            fd;
  int                     client_len;

  if (-1 == (fd = accept(_socket, (struct sockaddr *)&_sin, (socklen_t *)&client_len)))
    return (false);

  _tmpSocket =  [[SystemSocket alloc] initWithFd:fd];

  return (true);
}

- (bool) connectSocket
{
  if (-1 == (connect(self->_socket, (struct sockaddr *)&_sin, sizeof(_sin))))
    return (false);
  return (true);
}

- (bool) closeSocket
{
  close(_socket);
  return (true);
}

- (SystemSocket *) GetNewConnection
{
    if ([self acceptSocket])
        return (_tmpSocket);
    return (0);
}


- (void) Bind
{
  if (! [self bindSocket] || ! [self listenSocket])
  {
      NSLog(@"Bind ou listen socket error");
  }
}

- (void) Connect
{
  if (! [self connectSocket])
  {
      NSLog(@"Error: Connect error");
  }
}

- (void) Delete
{
  [self closeSocket];
}

- (void) Send:(const char *)data withSize:(const int)size
{
    if (size != write(_socket, data, size))
    {
        NSLog(@"Error: Send");
    }
}

- (void) Recv:(char *)data withSize:(const int)size
{
    if (size != write(_socket, data, size))
    {
        NSLog(@"Error: Recv");
    }
}

@end