private extension Selector {
    static let handleRemoteTap = #selector(MediaViewController.handleRemoteTap)
    static let handleLocalTap = #selector(MediaViewController.handleLocalTap)
}

let MediaViewControllerStoryboardID = "MediaViewControllerStoryboardID"

class MediaViewController: UIViewController {
    @IBOutlet weak var remoteMediaStack: UIStackView!
    @IBOutlet weak var localMediaStack: UIStackView!
    
    var remoteVideoStream: VideoStreamable?
    var localVideoStream: VideoStreamable?
    
    class func initStoryboardInstance() -> MediaViewController {
        return UIStoryboard.media.instantiateViewController(withIdentifier: MediaViewControllerStoryboardID)
            as! MediaViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func end(_ sender: Any) {
        Salemove.sharedInstance.endEngagement { success, error in
           self.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateStreams(streams: [String]?) {
        // TODO Dmitry fetch the streams from the SDK?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let remoteTapGesture = UITapGestureRecognizer(target: self, action: .handleRemoteTap)
        remoteMediaStack.addGestureRecognizer(remoteTapGesture)
        
        let localTapGesture = UITapGestureRecognizer(target: self, action: .handleLocalTap)
        localMediaStack.addGestureRecognizer(localTapGesture)
    }
    
    func handleVideoStream(stream: VideoStreamable) {
        if stream.isRemote {
            remoteVideoStream = stream
            let view = remoteVideoStream!.getStreamView()
            remoteMediaStack.insertArrangedSubview(view, at: 0)
            remoteVideoStream!.play()
        } else {
            localVideoStream = stream
            let view = localVideoStream!.getStreamView()
            localMediaStack.insertArrangedSubview(view, at: 0)
            localVideoStream!.play()
        }
    }
    
    func handleAudioStream(stream: AudioStreamable) {
        stream.play()
    }
    
    @objc func handleRemoteTap() {
        guard let remoteStream = remoteVideoStream else {
            return
        }
        
        remoteStream.isPaused ? remoteStream.resume() : remoteStream.pause()
    }
    
    @objc func handleLocalTap() {
        guard let localStream = localVideoStream else {
            return
        }
        
        localStream.isPaused ? localStream.resume() : localStream.pause()
    }
    
    func cleanUp() {
        remoteVideoStream = nil
        localVideoStream = nil
    }
    
    deinit {
        cleanUp()
    }
}
