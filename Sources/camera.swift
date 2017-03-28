/// Camera class that encapsulates iOS / macOS camera access
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import Foundation

#if os(iOS)
import UIKit

// MARK: - Camera class
public class Camera: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

	public var imagePickerController: UIImagePickerController?
	public var image: UIImage?

	public func present(controller: UIViewController) {
		imagePickerController = UIImagePickerController()
		if imagePickerController != nil {
			imagePickerController!.delegate = self

			imagePickerController!.sourceType = UIImagePickerControllerSourceType.camera
			imagePickerController!.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo

			imagePickerController!.showsCameraControls = false
			imagePickerController!.setNavigationBarHidden(true, animated: true)
			imagePickerController!.setToolbarHidden(true, animated: true)

			imagePickerController!.edgesForExtendedLayout = .all

			controller.present(imagePickerController!, animated: true, completion: nil)
		}
	}

	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		self.image = info[UIImagePickerControllerOriginalImage] as? UIImage
	}
}

#endif
