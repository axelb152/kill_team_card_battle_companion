import UIKit

enum OrientationHelper {
    static func lock(_ orientation: UIInterfaceOrientationMask) {
        AppDelegate.orientationLock = orientation

        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes
                .first as? UIWindowScene else { return }
            windowScene.requestGeometryUpdate(
                .iOS(interfaceOrientations: orientation)
            ) { error in
                print("OrientationHelper: \(error.localizedDescription)")
            }
            windowScene.windows.first?.rootViewController?
                .setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            let value: Int
            switch orientation {
            case .landscapeLeft, .landscape:
                value = UIInterfaceOrientation.landscapeLeft.rawValue
            case .landscapeRight:
                value = UIInterfaceOrientation.landscapeRight.rawValue
            default:
                value = UIInterfaceOrientation.portrait.rawValue
            }
            UIDevice.current.setValue(value, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
}
