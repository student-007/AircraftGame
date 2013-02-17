//
//  ANetConnBluetooth.m
//  Aircraft
//
//  Created by Yufei Lang on 12/25/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "ANetConnBluetooth.h"

@implementation ANetConnBluetooth

@synthesize peerPicker = _peerPicker;
@synthesize sessionConnection = _sessionConnection;

- (BOOL)isConnect
{
    return _isConnect;
}

#pragma mark - connection Operation protocol
- (void)makeConnection
{
    self.peerPicker = [[GKPeerPickerController alloc] init];
    self.peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    self.peerPicker.delegate = self;
    [self.peerPicker show];
}

- (void)closeConnection
{
    [self.sessionConnection disconnectFromAllPeers];
    _isConnect = NO;
}

- (BOOL)sendData:(NSData *)data
{
    if (self.sessionConnection && _isConnect)
    {
        NSError *error = nil;
        [self.sessionConnection sendDataToAllPeers:data withDataMode:GKSendDataUnreliable error:&error];
        if (error.description)
        {
//            NSLog(@"[error]: error while sending message, reason: %@.", error.description);
            [AErrorFacade LogError:error];
            return NO;
        }
        return YES;
    }
    else
    {
        [AErrorFacade errorWithDomain:kErrorDomainNet knownCode:kECConnEptSessionOrDisconnected];
        return NO;
    }
}

#pragma mark - GKPeerPickerControllerDelegate

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    self.sessionConnection = [[GKSession alloc] initWithSessionID:@"aircraftGame" displayName:nil sessionMode:GKSessionModePeer];
    self.sessionConnection.delegate = self;
    
    return self.sessionConnection;
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{   
    NSError *error = [AErrorFacade errorWithDomain:kErrorDomainNet knownCode:kECConnCanceledByUser];
    if ([self.listener respondsToSelector:@selector(connectionCanceled:)])
        [self.listener connectionCanceled:error];
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
    NSLog(@"[notice]: received a connection from peerID: %@", peerID);
#warning TODO: handle when receive connection request, dismiss the peer picker may be.
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state)
    {
        case GKPeerStateConnected:
        {
            _isConnect = YES;
            [self.sessionConnection setDataReceiveHandler:self withContext:nil];
//            self.sessionConnection.available = NO;
            [self.peerPicker dismiss];
            if ([self.listener respondsToSelector:@selector(connectionEstablishedWith:)])
                [self.listener connectionEstablishedWith:[session displayNameForPeer:peerID]];
        }
            break;
        case GKPeerStateDisconnected:
        {
            _isConnect = NO;
            if ([self.listener respondsToSelector:@selector(connectionDisconnected:)])
                [self.listener connectionDisconnected:nil];
        }
            break;
        case GKPeerStateConnecting:
        {
            // waiting for accept, or deny response
            // if being called, goes here then go to -session:didReceiveConnectionRequestFromPeer:
        }
            break;
        default:
            break;
    }
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    if ([self.listener respondsToSelector:@selector(connectionFailedWithError:)])
        [self.listener connectionFailedWithError:error];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    if ([self.listener respondsToSelector:@selector(connectionFailedWithError:)])
        [self.listener connectionFailedWithError:error];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    if ([self.listener respondsToSelector:@selector(receivedData:)])
        [self.listener receivedData:data];
}

@end
