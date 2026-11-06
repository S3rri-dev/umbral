import SwiftUI

enum CatalogSection: String, Identifiable, CaseIterable {
    case general
    case menuBar
    case explore
    case windows
    case audio
    case library

    var id: Self { self }

    var title: String {
        switch self {
        case .general: "General"
        case .menuBar: "Barra de menús"
        case .explore: "Explorar"
        case .windows: "Ventanas"
        case .audio: "Audio"
        case .library: "Mis herramientas"
        }
    }

    var icon: String {
        switch self {
        case .general: "gearshape"
        case .menuBar: "menubar.rectangle"
        case .explore: "square.grid.2x2"
        case .windows: "macwindow"
        case .audio: "waveform"
        case .library: "tray"
        }
    }

    var tools: [Utility] {
        switch self {
        case .explore: Utility.allCases
        case .windows, .audio: Utility.allCases.filter { $0.category == self }
        case .general, .menuBar, .library: []
        }
    }
}

enum Utility: String, Identifiable, CaseIterable {
    case quitOnClose
    case maximize
    case mixer

    var id: Self { self }

    var category: CatalogSection {
        switch self {
        case .quitOnClose, .maximize: .windows
        case .mixer: .audio
        }
    }

    var title: String {
        switch self {
        case .quitOnClose: "Salir al cerrar"
        case .maximize: "Maximizar ventana"
        case .mixer: "Mezclador de audio"
        }
    }

    var icon: String {
        switch self {
        case .quitOnClose: "xmark"
        case .maximize: "arrow.up.left.and.arrow.down.right"
        case .mixer: "slider.horizontal.3"
        }
    }

    var summary: String {
        switch self {
        case .quitOnClose: "Sal de una app al cerrar su última ventana."
        case .maximize: "Llena el escritorio con el botón verde, sin abrir otro espacio."
        case .mixer: "Ajusta el volumen de cada app por separado."
        }
    }

    var example: String {
        switch self {
        case .quitOnClose:
            "Por ejemplo, elige que Vista Previa salga cuando cierres su último documento. Las demás apps conservarán su comportamiento habitual."
        case .maximize:
            "Por ejemplo, usa el botón verde para ampliar una ventana del navegador sin perder de vista el Dock ni la barra de menús."
        case .mixer:
            "Por ejemplo, baja la música sin tocar el volumen de la videollamada ni el volumen general del Mac."
        }
    }
}
