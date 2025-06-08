#if os(iOS)
import SwiftUI

struct ShakeDetector: UIViewRepresentable {
    var onShake: () -> Void

    func makeUIView(context: Context) -> ShakeDetectingView {
        let view = ShakeDetectingView()
        view.onShake = onShake
        return view
    }

    func updateUIView(_ uiView: ShakeDetectingView, context: Context) {
        uiView.onShake = onShake
    }
}

class ShakeDetectingView: UIView {
    var onShake: (() -> Void)?

    override var canBecomeFirstResponder: Bool { true }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        onShake?()
    }
}

extension View {
    /// Calls action when the user shakes the device.
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.background(ShakeDetector(onShake: action))
    }
}
#endif
