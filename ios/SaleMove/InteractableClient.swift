import Foundation
import SalemoveSDK

@objc open class InteractableClient: NSObject {
    @objc open weak var rootController: UIViewController?
    @objc open var visitorScreenSharing: VisitorScreenSharingState?
}

extension InteractableClient: Interactable {
    open var onVisitorScreenSharingStateChange: VisitorScreenSharingStateChange {
        return { [unowned self] state, error in
            guard error == nil else {
                return
            }
            self.visitorScreenSharing = state
        }
    }

    open var onScreenSharingOffer: ScreenshareOfferBlock {
        return { answer in
            answer(true)
        }
    }

    open var onEngagementRequest: RequestOfferBlock {
        return { [unowned self] answer in
            let context = VisitorContext(type: .page, url: "https://www.glia.com/")
            let completion: SuccessBlock = { _, _ in }

            answer(context, true, completion)
        }
    }

    open var onOperatorTypingStatusUpdate: OperatorTypingStatusUpdate {
        return { [unowned self] status in
            if status.isTyping {
                InteractableEmmiter.emitEvent(withName: "operator_preview_typing", andPayload: nil)
            } else {
                InteractableEmmiter.emitEvent(withName: "operator_preview_deleted", andPayload: nil)
            }
        }
    }

    open var onMediaUpgradeOffer: MediaUgradeOfferBlock {
        return { _, answer in
            answer(true)
        }
    }
    
    open var onAudioStreamAdded: AudioStreamAddedBlock {
        return { [unowned self] stream, error in
            guard let currentSream = stream, error == nil else {
                return
            }

            DispatchQueue.main.async {
                if let presented = self.rootController?.presentedViewController as? MediaViewController {
                    presented.handleAudioStream(stream: currentSream)

                } else {
                    let controller = MediaViewController.initStoryboardInstance()
                    self.rootController?.present(controller, animated: true, completion: {
                        controller.handleAudioStream(stream: currentSream)
                    })
                }
            }
        }
    }
    
    open var onVideoStreamAdded: VideoStreamAddedBlock {
        return { [unowned self] stream, error in
            guard let currentSream = stream, error == nil else {
                return
            }

            DispatchQueue.main.async {
                if let presented = self.rootController?.presentedViewController as? MediaViewController {
                    presented.handleVideoStream(stream: currentSream)

                } else {
                    let controller = MediaViewController.initStoryboardInstance()
                    self.rootController?.present(controller, animated: true, completion: {
                        controller.handleVideoStream(stream: currentSream)
                    })
                }
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
    open func fail(error: SalemoveError) {}
}

extension InteractableClient {
    open func stopScreensharing() {
        visitorScreenSharing?.localScreen?.stopSharing()
        visitorScreenSharing = nil
    }
}
