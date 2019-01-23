import Foundation
import SalemoveSDK

@objc public class InteractableClient: NSObject {
    public weak var rootController: UIViewController?
}

extension InteractableClient: Interactable {
    public var onScreenSharingOffer: ScreenshareOfferBlock {
        return { answer in
            answer(true)
        }
    }

    public var onScreenStreamAdded: ScreenStreamAddedBlock {
        return { stream in
            // TODO handle the stream
        }
    }

    public var onMediaUpgradeOffer: MediaUgradeOfferBlock {
        return { _, answer in
            answer(true)
        }
    }
    
    public var onAudioStreamAdded: AudioStreamAddedBlock {
        return { [unowned self] stream in
            if let presented = self.rootController?.presentedViewController as? MediaViewController {
                presented.handleAudioStream(stream: stream)
                
            } else {
                let controller = MediaViewController.initStoryboardInstance()
                self.rootController?.present(controller, animated: true, completion: {
                    controller.handleAudioStream(stream: stream)
                })
            }
        }
    }
    
    public var onVideoStreamAdded: VideoStreamAddedBlock {
        return { [unowned self] stream in
            if let presented = self.rootController?.presentedViewController as? MediaViewController {
                presented.handleVideoStream(stream: stream)
                
            } else {
                let controller = MediaViewController.initStoryboardInstance()
                self.rootController?.present(controller, animated: true, completion: {
                    controller.handleVideoStream(stream: stream)
                })
            }
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
        
        InteractableEmmiter.emitEvent(withName: "operator_message", andPayload: payload)
    }
    
    public func handleOperators(operators: [Operator]) {}
    public func fail(with error: SalemoveError) {}
}
