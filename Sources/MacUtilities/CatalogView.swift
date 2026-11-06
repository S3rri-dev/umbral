import SwiftUI

struct CatalogView: View {
    @Binding var selection: CatalogSection?
    @Binding var appearance: AppAppearance
    @Binding var accent: AppAccent
    let repeatSetup: () -> Void
    @ViewState private var tool: Utility?
    @ViewState private var search = ""
    @FocusState private var sidebarFocus: CatalogSection?

    private var query: String { search.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        NavigationSplitView {
            List {
                Section("Preferencias") {
                    sidebarRow(.general)
                    sidebarRow(.menuBar)
                }

                Section("Catálogo") {
                    sidebarRow(.explore)
                    sidebarRow(.windows)
                    sidebarRow(.audio)
                }

                Section("Biblioteca") {
                    sidebarRow(.library)
                }
            }
            .listStyle(.sidebar)
            .onMoveCommand { moveSidebarFocus($0, from: selection ?? .explore) }
            .navigationSplitViewColumnWidth(min: 175, ideal: 195, max: 235)
            .safeAreaInset(edge: .bottom, alignment: .leading) {
                Label("Versión \(Brand.version)", systemImage: "square.stack")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 14)
            }
        } detail: {
            detail
                .navigationTitle("Ajustes de \(Brand.name)")
        }
        .navigationSplitViewStyle(.balanced)
        .searchable(text: $search, placement: .sidebar, prompt: "Buscar fichas")
        .onChange(of: selection) {
            tool = nil
            search = ""
        }
        .onChange(of: query) {
            tool = nil
        }
    }

    @ViewBuilder
    private var detail: some View {
        if let tool {
            toolDetail(tool)
        } else if !query.isEmpty {
            let results = Utility.allCases.filter {
                "\($0.title) \($0.summary) \($0.category.title)".localizedStandardContains(query)
            }
            if results.isEmpty {
                ContentUnavailableView.search(text: query)
            } else {
                catalog("Resultados", tools: results)
            }
        } else {
            let section = selection ?? .explore
            switch section {
            case .general:
                GeneralPreferences(appearance: $appearance, accent: $accent, repeatSetup: repeatSetup)
            case .menuBar:
                menuPreferences
            case .library:
                library
            case .explore, .windows, .audio:
                catalog(section.title, tools: section.tools)
            }
        }
    }

    private func sidebarRow(_ section: CatalogSection) -> some View {
        let isSelected = selection == section
        return Button {
            selection = section
            sidebarFocus = section
            tool = nil
            search = ""
        } label: {
            Label {
                Text(section.title)
                    .fontWeight(isSelected ? .semibold : .regular)
            } icon: {
                Image(systemName: section.icon)
                    .foregroundStyle(isSelected ? AnyShapeStyle(.primary) : AnyShapeStyle(accent.color))
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 29, alignment: .leading)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(accent.color.opacity(0.30))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .focused($sidebarFocus, equals: section)
        .onMoveCommand { moveSidebarFocus($0, from: section) }
        .listRowInsets(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func moveSidebarFocus(_ direction: MoveCommandDirection, from section: CatalogSection) {
        let sections = CatalogSection.allCases
        guard direction == .up || direction == .down,
              let index = sections.firstIndex(of: section) else { return }
        let nextIndex = index + (direction == .up ? -1 : 1)
        guard sections.indices.contains(nextIndex) else { return }
        sidebarFocus = sections[nextIndex]
        selection = sections[nextIndex]
    }

    private func catalog(_ title: String, tools: [Utility]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                PageHeading(title: title, subtitle: "Fichas de las herramientas previstas.")

                ForEach(tools) { utility in
                    ToolRow(utility: utility) {
                        tool = utility
                    }
                }
            }
            .frame(maxWidth: 850)
            .padding(28)
            .frame(maxWidth: .infinity)
        }
    }

    private var menuPreferences: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PageHeading(title: "Barra de menús", subtitle: "Abre el panel rápido desde el icono de \(Brand.name).")
                MenuGuide()
                Text("El panel reúne las fichas previstas de Ventanas y Audio y da acceso al catálogo y a los ajustes.")
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: 750, alignment: .leading)
            .padding(28)
            .frame(maxWidth: .infinity)
        }
    }

    private var library: some View {
        ContentUnavailableView {
            Label("Biblioteca vacía", systemImage: "tray")
        } description: {
            Text("Las herramientas que añadas aparecerán aquí. El catálogo está en vista previa.")
        } actions: {
            Button("Explorar catálogo") {
                selection = .explore
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func toolDetail(_ utility: Utility) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Button {
                    tool = nil
                } label: {
                    Label(query.isEmpty ? "Volver al catálogo" : "Volver a resultados", systemImage: "chevron.left")
                }
                .buttonStyle(.borderless)

                VStack(alignment: .leading, spacing: 14) {
                    ToolGlyph(utility: utility, size: 54)
                    Text(utility.title)
                        .font(.system(size: 32, weight: .semibold))
                        .accessibilityAddTraits(.isHeader)
                    Text(utility.summary)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Label("En preparación", systemImage: "clock")
                        .font(.headline)
                    Text(utility.example)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Todavía no se puede descargar ni activar.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.quaternary.opacity(0.45), in: RoundedRectangle(cornerRadius: 14))
            }
            .frame(maxWidth: 850, alignment: .leading)
            .padding(28)
            .frame(maxWidth: .infinity)
        }
    }
}

private struct ToolRow: View {
    let utility: Utility
    let openDetail: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            ToolGlyph(utility: utility, size: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(utility.title)
                    .font(.headline)
                Text(utility.summary)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Ver ficha", action: openDetail)
                .accessibilityLabel("Ver ficha de \(utility.title)")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(Color(nsColor: .controlBackgroundColor), in: RoundedRectangle(cornerRadius: 13))
        .overlay {
            RoundedRectangle(cornerRadius: 13)
                .strokeBorder(.primary.opacity(0.10))
                .allowsHitTesting(false)
        }
    }
}

private struct ToolGlyph: View {
    let utility: Utility
    let size: CGFloat

    var body: some View {
        Image(systemName: utility.icon)
            .font(.system(size: size * 0.42, weight: .semibold))
            .foregroundStyle(.secondary)
            .frame(width: size, height: size)
            .background(.quaternary, in: RoundedRectangle(cornerRadius: size * 0.26))
            .accessibilityHidden(true)
    }
}
