//
//  ANetConnBluetooth.m
//  Aircraft
//
//  Created by Yufei Lang on 12/25/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "ANetConnBluetooth.h"

@implementation ANetConnBluetooth

- (BOOL)isConnect
{
    return _isConnect;
}

// base class functions [Yufei Lang]
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
            NSLog(@"[error]: error while sending message, reason: %@.", error.description);
            return NO;
        }
        return YES;
    }
    else
    {
        NSLog(@"[error]: can not send data, empty session or not connected.");
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Canceled"
                                                    message:@"A connection has been canceled, please retry if you'd like to continue."
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state) {
        case GKPeerStateConnected:
        {
            _isConnect = YES;
            [self.sessionConnection setDataReceiveHandler:self withContext:nil];
            [self.peerPicker dismiss];
            if ([self.listener respondsToSelector:@selector(connectionEstablished)])
                [self.listener connectionEstablished];
        }
            break;
        case GKPeerStateDisconnected:
        {
            _isConnect = NO;
            if ([self.listener respondsToSelector:@selector(connectionDisconnected)])
                [self.listener connectionDisconnected];
        }
            break;
        default:
            break;
    }
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    if ([self.listener respondsToSelector:@selector(receivedData:)])
        [self.listener receivedData:data];
}

@end
