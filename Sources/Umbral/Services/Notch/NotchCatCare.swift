// SPDX-License-Identifier: GPL-3.0-or-later

import AppKit

enum NotchCatCare {
    private static let mealInterval: TimeInterval = 4 * 60 * 60

    static func isHungry(lastMeal: TimeInterval, at now: Date = .now) -> Bool {
        guard lastMeal.isFinite, lastMeal > 0 else { return true }
        return now.timeIntervalSince1970 - lastMeal >= mealInterval
    }

    static func feed(in defaults: UserDefaults = .standard, at now: Date = .now) {
        defaults.set(now.timeIntervalSince1970, forKey: DefaultsKey.notchCatLastMeal)
    }

    private static let meowSound: NSSound? = {
        guard let resource = Bundle.main.url(forResource: "CatMeow", withExtension: "wav") else { return nil }
        let sound = NSSound(contentsOf: resource, byReference: true)
        sound?.volume = 0.42
        return sound
    }()

    static func playMeow() {
        guard UserDefaults.standard.bool(forKey: DefaultsKey.notchCatSounds) else { return }
        meowSound?.stop()
        meowSound?.play()
    }
}

struct NotchCatCareStrings {
    private let spanish: Bool
    init(_ language: AppLanguage) { spanish = language == .es }

    var cat: String { spanish ? "Gato" : "Cat" }
    var care: String { spanish ? "Cuidados del gato" : "Cat care" }
    var hungry: String { spanish ? "Tiene hambre" : "Hungry" }
    var fed: String { spanish ? "Ya ha comido" : "Fed" }
    var feed: String { spanish ? "Dar de comer" : "Feed" }
    var meow: String { spanish ? "Maullar" : "Meow" }
    var nap: String { spanish ? "Siesta" : "Nap" }
    var wake: String { spanish ? "Despertar" : "Wake up" }
    var sleeping: String { spanish ? "Durmiendo" : "Sleeping" }
    var sound: String { spanish ? "Sonidos del gato" : "Cat sounds" }
    var soundHint: String {
        spanish ? "Activa el maullido audible. Con el sonido apagado, el gato sigue maullando con un gesto."
                : "Enable audible meows. With sound off, the cat still meows with a gesture."
    }
}
