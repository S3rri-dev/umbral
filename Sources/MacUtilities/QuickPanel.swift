import AppKit
import SwiftUI

struct QuickPanel: View {
    let setupFinished: Bool
    @Binding var selection: CatalogSection?
    @Environment(\.openWindow) private var openWindow
    @ViewState private var tab: CatalogSection = .windows

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 7) {
                Brand.logo(31)
                Text(Brand.name).font(.headline)
                Spacer()
                Text(Brand.version)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if setupFinished {
                Picker("Categoría", selection: $tab) {
                    Label("Ventanas", systemImage: CatalogSection.windows.icon).tag(CatalogSection.windows)
                    Label("Audio", systemImage: CatalogSection.audio.icon).tag(CatalogSection.audio)
                }
                .pickerStyle(.segmented)
                .labelsHidden()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Herramientas previstas").font(.caption.weight(.medium)).foregroundStyle(.secondary)
                    ForEach(tab.tools) { utility in
                        Label(utility.title, systemImage: utility.icon)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(.quaternary.opacity(0.45), in: RoundedRectangle(cornerRadius: 11))

                HStack {
                    Button("Ver catálogo") { show(tab) }
                        .buttonStyle(.borderedProminent)
                    Button("Ajustes") { show(.general) }
                    Spacer()
                    quitButton
                }
            } else {
                HStack {
                    Button("Completar bienvenida") { show(.explore) }
                        .buttonStyle(.borderedProminent)
                    Spacer()
                    quitButton
                }
            }
        }
        .padding(14)
        .frame(width: 306)
    }

    private var quitButton: some View {
        Button {
            NSApp.terminate(nil)
        } label: {
            Image(systemName: "power")
        }
        .accessibilityLabel("Salir de \(Brand.name)")
        .help("Salir de \(Brand.name)")
    }

    private func show(_ section: CatalogSection) {
        selection = section
        openWindow(id: "catalog")
        NSApp.activate()
    }
}
