import Foundation
import SalemoveSDK

@objc public class InteractableClient: NSObject {
    
}

extension InteractableClient: Interactable {
    public var onMediaUpgradeOffer: MediaUgradeOfferBlock {
        return { _, answer in
            answer(true)
        }
    }
    
    public var onAudioStreamAdded: AudioStreamAddedBlock {
        return { [unowned self] stream in
            // TODO: Handle the stream
        }
    }
    
    public var onVideoStreamAdded: VideoStreamAddedBlock {
        return { [unowned self] stream in
            // TODO: Handle the stream
        }
    }
    
    public var onMessagesUpdated: MessagesUpdateBlock {
        return { [unowned self] messages in
            // TODO: Handle the messages
        }
    }
    
    public func start() {
        InteractableEmmiter.emitEvent(withName: "engagement_start", andPayload: nil)
    }
    public func end() {
        InteractableEmmiter.emitEvent(withName: "engagement_end", andPayload: nil)
    }
    
    public func receive(message: Message) {
        let payload: [AnyHashable: Any] = [
            "id": message.id,
            "content": message.content,
            "sender": "operator"
        ]
        
        InteractableEmmiter.emitEvent(withName: "engagement_started", andPayload: payload)
    }
    
    public func handleOperators(operators: [Operator]) {}
    public func fail(with error: SalemoveError) {}
}
