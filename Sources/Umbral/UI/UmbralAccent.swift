// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

enum UmbralAccent: String, CaseIterable {
    static let key = "umbral.accent"

    case system, blue, purple, pink, red, orange, yellow, green, graphite

    var color: Color? {
        switch self {
        case .system: nil
        case .blue: Color(nsColor: .systemBlue)
        case .purple: Color(nsColor: .systemPurple)
        case .pink: Color(nsColor: .systemPink)
        case .red: Color(nsColor: .systemRed)
        case .orange: Color(nsColor: .systemOrange)
        case .yellow: Color(nsColor: .systemYellow)
        case .green: Color(nsColor: .systemGreen)
        case .graphite: Color(nsColor: .systemGray)
        }
    }

    func title(_ language: AppLanguage) -> String {
        guard language == .es else { return rawValue.capitalized }
        return switch self {
        case .system: "Sistema"
        case .blue: "Azul"
        case .purple: "Morado"
        case .pink: "Rosa"
        case .red: "Rojo"
        case .orange: "Naranja"
        case .yellow: "Amarillo"
        case .green: "Verde"
        case .graphite: "Grafito"
        }
    }
}

struct UmbralAccentStyle: ViewModifier {
    @AppStorage(UmbralAccent.key) private var accent = UmbralAccent.system

    func body(content: Content) -> some View {
        content.accentColor(accent.color).tint(accent.color)
    }
}
