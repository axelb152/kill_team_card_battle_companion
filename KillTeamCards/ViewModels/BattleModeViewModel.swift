import Foundation

@MainActor
class BattleModeViewModel: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var isChromeVisible: Bool = true
    @Published var isOverlayVisible: Bool = false

    private var chromeTimer: Timer?

    func resetTimer() {
        chromeTimer?.invalidate()
        isChromeVisible = true
        chromeTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.isChromeVisible = false
            }
        }
    }

    func navigateTo(index: Int) {
        currentIndex = index
        isOverlayVisible = false
        resetTimer()
    }

    func cancelTimer() {
        chromeTimer?.invalidate()
        chromeTimer = nil
    }
}
