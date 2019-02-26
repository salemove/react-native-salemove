import Foundation

@objc(SaleMove)
class SaleMove: NSObject {
    @objc(requestTwoWayAudio:withReject:)
    func requestTwoWayAudio(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        let offer = MediaUpgradeOffer(type: .audio, direction: .twoWay)
        Salemove.sharedInstance.requestMediaUpgrade(offer: offer) { success, error in
            guard success else {
                reject("", error?.reason, error?.error)
                return
            }
            
            resolve("")
        }
    }
    
    @objc(requestTwoWayVideo:withReject:)
    func requestTwoWayVideo(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        let offer = MediaUpgradeOffer(type: .video, direction: .twoWay)
        Salemove.sharedInstance.requestMediaUpgrade(offer: offer) { success, error in
            guard success else {
                reject("", error?.reason, error?.error)
                return
            }
            
            resolve("")
        }
    }
    
    @objc(sendMessage:callback:)
    func sendMessage(messageText: String, callback: @escaping RCTResponseSenderBlock) {
        Salemove.sharedInstance.send(message: messageText) { message, error in
            let incomingError = error ?? NSNull()
            
            guard let incomingMessage = message else {
                callback([incomingError, NSNull()])
                return
            }
           
            let payload = ["id" : incomingMessage.id,
                           "content": incomingMessage.content,
                           "sender": "visitor"]
            
            callback([incomingError, payload])
        }
    }
    
    @objc(listQueues:)
    func listQueues(callback: @escaping RCTResponseSenderBlock) {
        Salemove.sharedInstance.listQueues { queues, error in
            let incomingError = error ?? NSNull()
            
            guard let incomingQueues = queues else {
                callback([incomingError, NSNull()])
                return
            }
            
            var payload: [[AnyHashable: Any]] = []
            
            for queue in incomingQueues {
                payload.append(["id": queue.id,
                                "name": queue.name])
            }
            
            callback([incomingError, payload])
        }
    }
    @objc(requestEngagement:withResolve:withReject:)
    func requestEngagement(queueID: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        let context = VisitorContext(type: .page, url: "https://www.libertymutual.com")

        Salemove.sharedInstance.queueForEngagement(queueID: queueID, visitorContext: context) { queueTicket, error in
            guard let incomingTicket = queueTicket else {
                reject("", error?.reason, error?.error)
                return
            }
            
            resolve("")
        }
    }
    
    @objc(endEngagement:withReject:)
    func endEngagement(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        Salemove.sharedInstance.endEngagement { success, error in
            guard success else {
                reject("", error?.reason, error?.error)
                return
            }
            
            resolve("")
        }
    }
}
