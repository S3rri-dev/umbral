import AppKit

let input = URL(fileURLWithPath: CommandLine.arguments[1])
let directory = URL(fileURLWithPath: CommandLine.arguments[2], isDirectory: true)
guard let mark = NSImage(contentsOf: input) else { exit(1) }

for scale in [1, 2] {
    let side = 20 * scale
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil, pixelsWide: side, pixelsHigh: side,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB,
        bytesPerRow: 0, bitsPerPixel: 0
    ), let context = NSGraphicsContext(bitmapImageRep: bitmap) else { exit(1) }
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context
    NSColor.clear.setFill()
    NSRect(x: 0, y: 0, width: side, height: side).fill(using: .copy)
    context.imageInterpolation = .high
    let inset = 2 * scale
    mark.draw(in: NSRect(x: inset, y: inset, width: side - 2 * inset, height: side - 2 * inset))
    NSGraphicsContext.restoreGraphicsState()
    let name = scale == 1 ? "MenuBarIcon.png" : "MenuBarIcon@2x.png"
    guard let data = bitmap.representation(using: .png, properties: [:]) else { exit(1) }
    try data.write(to: directory.appendingPathComponent(name))
}
