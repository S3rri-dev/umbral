import AppKit
import SwiftUI

// Mantiene el property wrapper compatible con las herramientas de línea de comandos.
typealias ViewState<Value> = State<Value>

enum Brand {
    static let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Umbral"
    static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"

    static func logo(_ size: CGFloat) -> some View {
        Group {
            if let image = asset("BrandMark") {
                Image(nsImage: image).resizable().scaledToFit()
            } else {
                Image(systemName: "square.on.square").font(.system(size: size * 0.62))
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }

    static var menuGlyph: Image {
        guard let image = asset("MenuMark") else { return Image(systemName: "square.on.square") }
        image.size = NSSize(width: 18, height: 18)
        image.isTemplate = true
        return Image(nsImage: image)
    }

    private static func asset(_ name: String) -> NSImage? {
        Bundle.main.url(forResource: name, withExtension: "png").flatMap(NSImage.init(contentsOf:))
    }
}

enum AppAppearance: String, CaseIterable, Identifiable {
    case system, light, dark

    var id: Self { self }

    var title: String {
        switch self {
        case .system: "Sistema"
        case .light: "Clara"
        case .dark: "Oscura"
        }
    }

    var scheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

enum AppAccent: String, CaseIterable, Identifiable {
    case system, blue, purple, pink, red, orange, yellow, green, graphite

    var id: Self { self }

    var title: String {
        switch self {
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

    var color: Color {
        let color: NSColor = switch self {
        case .system: .controlAccentColor
        case .blue: .systemBlue
        case .purple: .systemPurple
        case .pink: .systemPink
        case .red: .systemRed
        case .orange: .systemOrange
        case .yellow: .systemYellow
        case .green: .systemGreen
        case .graphite: .systemGray
        }
        return Color(nsColor: color)
    }

    var tint: Color? { self == .system ? nil : color }
}

@main
struct MacUtilitiesApp: App {
    @AppStorage("umbral.setupFinished") private var setupFinished = false
    @AppStorage("umbral.appearance") private var appearance = AppAppearance.system
    @AppStorage("umbral.accent") private var accent = AppAccent.graphite
    @ViewState private var selection: CatalogSection? = .explore

    var body: some Scene {
        Window(Brand.name, id: "catalog") {
            Group {
                if setupFinished {
                    CatalogView(selection: $selection, appearance: $appearance, accent: $accent) {
                        setupFinished = false
                    }
                } else {
                    SetupView { startSection in
                        selection = startSection
                        setupFinished = true
                    }
                }
            }
            .frame(minWidth: 640, minHeight: 530)
            .tint(accent.tint)
            .preferredColorScheme(appearance.scheme)
        }
        .defaultSize(width: 820, height: 660)

        MenuBarExtra {
            QuickPanel(setupFinished: setupFinished, selection: $selection)
                .tint(accent.tint)
                .preferredColorScheme(appearance.scheme)
        } label: {
            Brand.menuGlyph.accessibilityLabel(Brand.name)
        }
        .menuBarExtraStyle(.window)
    }
}
