import Foundation
import SalemoveSDK

class InteractableClient: Interactable {
    var onMediaUpgradeOffer: MediaUgradeOfferBlock {
        return { _, answer in
            answer(true)
        }
    }
    
    var onAudioStreamAdded: AudioStreamAddedBlock {
        return { [unowned self] stream in
            // TODO: Handle the stream
        }
    }
    
    var onVideoStreamAdded: VideoStreamAddedBlock {
        return { [unowned self] stream in
            // TODO: Handle the stream
        }
    }
    
    var onMessagesUpdated: MessagesUpdateBlock {
        return { [unowned self] messages in
            // TODO: Handle the messages
        }
    }
    
    func start() {
        InteractableEmmiter.emitEvent(withName: "engagement_start", andPayload: nil)
    }
    func end() {
        InteractableEmmiter.emitEvent(withName: "engagement_end", andPayload: nil)
    }
    
    func receive(message: Message) {
        let payload: [AnyHashable: Any] = [
            "id": message.id,
            "content": message.content,
            "sender": "operator"
        ]
        
        InteractableEmmiter.emitEvent(withName: "engagement_started", andPayload: payload)
    }
    
    func handleOperators(operators: [Operator]) {}
    func fail(with error: SalemoveError) {}
}
