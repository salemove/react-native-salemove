import Foundation

extension UIStoryboard {
    class var media: UIStoryboard {
        let bundle = PodAsset.bundle(forPod: "react-native-salemove")
        return UIStoryboard(name: "Media", bundle: bundle)
    }
}
