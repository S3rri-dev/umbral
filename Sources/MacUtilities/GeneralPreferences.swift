import SwiftUI

struct PageHeading: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.title.weight(.semibold))
                .accessibilityAddTraits(.isHeader)
            Text(subtitle)
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 6)
    }
}

struct GeneralPreferences: View {
    @Binding var appearance: AppAppearance
    @Binding var accent: AppAccent
    let repeatSetup: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PageHeading(title: "General", subtitle: "Personaliza la interfaz de \(Brand.name).")

                VStack(alignment: .leading, spacing: 13) {
                    Text("Apariencia").font(.headline)
                    HStack(spacing: 9) {
                        ForEach(AppAppearance.allCases) { mode in
                            appearanceButton(mode)
                        }
                    }
                    Text("El tema se aplica a las ventanas y al panel de \(Brand.name).")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Divider()
                    accentPicker
                }
                .padding(16)
                .background(.quaternary.opacity(0.55), in: RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 14) {
                    LabeledContent("Idioma de la app", value: "Español")
                    Divider()
                    LabeledContent("Primer inicio") {
                        Button("Repetir bienvenida", action: repeatSetup)
                    }
                }
                .padding(16)
                .background(.quaternary.opacity(0.55), in: RoundedRectangle(cornerRadius: 16))
            }
            .frame(maxWidth: 750, alignment: .leading)
            .padding(28)
            .frame(maxWidth: .infinity)
        }
    }

    private func appearanceButton(_ mode: AppAppearance) -> some View {
        Button {
            appearance = mode
        } label: {
            VStack(spacing: 6) {
                AppearanceSketch(appearance: mode)
                Text(mode.title).font(.callout.weight(.medium))
            }
            .padding(6)
            .frame(maxWidth: .infinity)
            .background(appearance == mode ? accent.color.opacity(0.15) : .clear,
                        in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(appearance == mode ? accent.color : .clear, lineWidth: 1.5)
                    .allowsHitTesting(false)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(appearance == mode ? .isSelected : [])
    }

    private var accentPicker: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack {
                Text("Color de acento").font(.headline)
                Spacer()
                Text(accent.title).foregroundStyle(.secondary)
            }

            HStack(spacing: 8) {
                ForEach(AppAccent.allCases) { option in
                    Button {
                        accent = option
                    } label: {
                        Circle()
                            .fill(swatchStyle(option))
                            .frame(width: 21, height: 21)
                            .frame(width: 28, height: 28)
                            .overlay {
                                if accent == option {
                                    Circle().strokeBorder(option.color, lineWidth: 1.8)
                                }
                            }
                            .contentShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(option.title)
                    .accessibilityAddTraits(accent == option ? .isSelected : [])
                    .help(option == .system ? "Usar el color de acento de macOS" : option.title)
                }
            }

            Text("Elige Sistema para usar el color de acento de macOS.")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Color de acento")
    }

    private func swatchStyle(_ option: AppAccent) -> AnyShapeStyle {
        if option == .system {
            return AnyShapeStyle(
                AngularGradient(colors: [.pink, .orange, .yellow, .green, .blue, .purple, .pink], center: .center)
            )
        }
        return AnyShapeStyle(option.color)
    }
}

private struct AppearanceSketch: View {
    let appearance: AppAppearance

    private let light = Color(white: 0.86)
    private let dark = Color(white: 0.24)

    var body: some View {
        ZStack {
            switch appearance {
            case .system:
                LinearGradient(stops: [.init(color: light, location: 0.5), .init(color: dark, location: 0.5)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            case .light:
                light
            case .dark:
                dark
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 3) {
                    Circle().fill(.red)
                    Circle().fill(.yellow)
                    Circle().fill(.green)
                }
                .frame(width: 19, height: 4)

                Capsule().fill(.tint).frame(width: 33, height: 3)
                Capsule().fill(.gray.opacity(0.43)).frame(width: 49, height: 3)
            }
            .padding(7)
            .background(appearance == .dark ? Color.black.opacity(0.52) : Color.white.opacity(0.85),
                        in: RoundedRectangle(cornerRadius: 5))
        }
        .frame(height: 58)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityHidden(true)
    }
}
