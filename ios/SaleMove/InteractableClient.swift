import Foundation
import SalemoveSDK

@objc open class InteractableClient: NSObject {
    @objc open weak var rootController: UIViewController?
    @objc open var localScreen: LocalScreen?
}

extension InteractableClient: Interactable {
    open var onScreenSharingOffer: ScreenshareOfferBlock {
        return { answer in
            answer(true)
        }
    }

    open var onLocalScreenAdded: LocalScreenAddedBlock {
        return { [unowned self] screen in
            self.localScreen = screen
        }
    }

    open var onMediaUpgradeOffer: MediaUgradeOfferBlock {
        return { _, answer in
            answer(true)
        }
    }
    
    open var onAudioStreamAdded: AudioStreamAddedBlock {
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
    
    open var onVideoStreamAdded: VideoStreamAddedBlock {
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
    
    open var onMessagesUpdated: MessagesUpdateBlock {
        return { [unowned self] messages in
            // TODO: Handle the messages
        }
    }
    
    open func start() {
        InteractableEmmiter.emitEvent(withName: "engagement_start", andPayload: nil)
    }
    open func end() {
        InteractableEmmiter.emitEvent(withName: "engagement_end", andPayload: nil)
        stopScreensharing()
    }
    
    open func receive(message: Message) {
        let payload: [AnyHashable: Any] = [
            "id": message.id,
            "content": message.content,
            "sender": String(describing: message.sender)
        ]

        InteractableEmmiter.emitEvent(withName: "message_received", andPayload: payload)
    }
    
    open func handleOperators(operators: [Operator]) {}
    open func fail(with error: SalemoveError) {}
}

extension InteractableClient {
    open func stopScreensharing() {
        localScreen?.stopSharing()
        localScreen = nil
    }
}
