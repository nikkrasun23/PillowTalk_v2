//
//  EasterEggService.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 11/04/2025.
//


import Foundation
import UIKit

final class EasterEggService {
    enum TapTarget {
        case viewA
        case viewB
    }
    
    private var tapSequence: [TapTarget] = []
    private var lastTap: TapTarget?
    private var tapCount: Int = 0
    private var timer: Timer?
    private let tapLimit = 10
    private let timeLimit: TimeInterval = 10
    
    private let onSuccess: () -> Void
    
    init(onSuccess: @escaping () -> Void) {
        self.onSuccess = onSuccess
    }
    
    func registerTap(on target: TapTarget) {
        if tapCount == 0 {
            startTimer()
        }
        
        // Проверка чередования
        if let last = lastTap, last == target {
            reset()
            return
        }
        
        lastTap = target
        tapCount += 1
        
        if tapCount >= tapLimit {
            triggerEasterEgg()
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeLimit, repeats: false) { [weak self] _ in
            self?.reset()
        }
    }
    
    private func triggerEasterEgg() {
        timer?.invalidate()
        triggerSuccessHaptic()
        onSuccess()
        reset()
    }
    
    private func reset() {
        tapCount = 0
        lastTap = nil
        timer?.invalidate()
        timer = nil
    }
    
    private func triggerSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    deinit {
        timer?.invalidate()
    }
}
