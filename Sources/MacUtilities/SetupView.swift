import SwiftUI

struct SetupView: View {
    let finish: (CatalogSection) -> Void
    @ViewState private var step = 0
    @ViewState private var startSection: CatalogSection = .explore

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                switch step {
                case 0: welcome
                case 1: choices
                case 2: permissions
                default: ready
                }
            }
            .frame(maxWidth: 560)
            .padding(.horizontal, 28)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) { footer }
        .navigationTitle("Bienvenida a \(Brand.name)")
    }

    private var welcome: some View {
        Group {
            hero(Brand.name, "Un catálogo de utilidades para ajustar tu Mac a tu manera.")

            VStack(alignment: .leading, spacing: 18) {
                feature("Catálogo por categorías", "Explora las fichas de ventanas y audio.", "square.grid.2x2")
                feature("A mano en la barra de menús", "Abre el panel rápido desde el icono de \(Brand.name).", "menubar.rectangle")
                feature("Apariencia de la app", "Usa el tema del sistema o elige un tema claro u oscuro.", "circle.lefthalf.filled")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
        }
    }

    private var choices: some View {
        Group {
            heading("Elige por dónde empezar", "Abriremos esta sección cuando termines la bienvenida.", "square.grid.2x2")

            VStack(spacing: 9) {
                choice(.explore, "Todo el catálogo", "Revisa las tres herramientas previstas.")
                choice(.windows, "Ventanas", "Consulta las propuestas de cierre y maximización.")
                choice(.audio, "Audio", "Consulta la propuesta del mezclador por app.")
            }

            Label("Las herramientas están en preparación.", systemImage: "clock")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }

    private var permissions: some View {
        Group {
            heading("Permisos", "Consulta qué acceso necesita esta versión.", "lock.shield")

            VStack(alignment: .leading, spacing: 14) {
                feature("Todo listo", "Puedes usar la interfaz sin conceder permisos especiales.", "checkmark.circle.fill")
                Divider()
                DisclosureGroup("Permisos en versiones futuras") {
                    Text("Cuando haya una herramienta que requiera acceso a macOS, su ficha explicará para qué se usa antes de activarla.")
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 8)
                }
            }
            .padding(18)
            .background(.quaternary.opacity(0.55), in: RoundedRectangle(cornerRadius: 16))
        }
    }

    private var ready: some View {
        Group {
            hero("Configuración lista", "Ya puedes explorar el catálogo de \(Brand.name).")
            MenuGuide()
            Text("Busca este icono en la parte superior del Mac para volver al panel rápido.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var footer: some View {
        VStack(spacing: 0) {
            Divider()
            ZStack {
                HStack(spacing: 5) {
                    ForEach(0..<4) { index in
                        Capsule()
                            .fill(index == step ? AnyShapeStyle(.tint) : AnyShapeStyle(.secondary.opacity(0.32)))
                            .frame(width: index == step ? 20 : 7, height: 7)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Paso \(step + 1) de 4")

                HStack {
                    Button("Atrás") { step -= 1 }
                        .disabled(step == 0)
                    Spacer()
                    Button(step == 3 ? "Abrir \(Brand.name)" : "Continuar") {
                        if step == 3 {
                            finish(startSection)
                        } else {
                            step += 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.defaultAction)
                }
            }
            .controlSize(.large)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(.bar)
    }

    private func hero(_ title: String, _ subtitle: String) -> some View {
        VStack(spacing: 8) {
            Brand.logo(82)
            Text(title)
                .font(.system(size: 37, weight: .semibold))
                .accessibilityAddTraits(.isHeader)
            Text(subtitle)
                .font(.callout)
                .foregroundStyle(.white.opacity(0.79))
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .background {
            RoundedRectangle(cornerRadius: 22)
                .fill(LinearGradient(colors: [Color(white: 0.12), Color(white: 0.24)],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
        }
    }

    private func heading(_ title: String, _ subtitle: String, _ icon: String) -> some View {
        VStack(spacing: 9) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color(white: 0.20), in: RoundedRectangle(cornerRadius: 16))
                .accessibilityHidden(true)
            Text(title)
                .font(.system(size: 28, weight: .semibold))
                .accessibilityAddTraits(.isHeader)
            Text(subtitle)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding(.top, 12)
    }

    private func choice(_ section: CatalogSection, _ title: String, _ subtitle: String) -> some View {
        Button {
            startSection = section
        } label: {
            HStack {
                feature(title, subtitle, section.icon)
                Spacer()
                Image(systemName: startSection == section ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(startSection == section ? AnyShapeStyle(.tint) : AnyShapeStyle(.secondary))
                    .accessibilityHidden(true)
            }
            .padding(12)
            .background(.quaternary.opacity(0.55), in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(.tint, lineWidth: 1.5)
                    .opacity(startSection == section ? 1 : 0)
                    .allowsHitTesting(false)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(startSection == section ? .isSelected : [])
    }

    private func feature(_ title: String, _ subtitle: String, _ icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .frame(width: 34, height: 34)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 9))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.headline)
                Text(subtitle).font(.callout).foregroundStyle(.secondary)
            }
        }
    }
}

struct MenuGuide: View {
    var body: some View {
        HStack(spacing: 12) {
            Brand.menuGlyph
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(.quaternary, in: Capsule())
            Image(systemName: "wifi")
            Image(systemName: "battery.75percent")
            Text("17:30").monospacedDigit()
        }
        .font(.callout)
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay { RoundedRectangle(cornerRadius: 12).strokeBorder(.quaternary) }
        .accessibilityLabel("Ubicación del icono de \(Brand.name) en la barra de menús")
    }
}
