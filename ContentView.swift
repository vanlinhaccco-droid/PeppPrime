import SwiftUI

struct ContentView: View {
    @State private var style: CrosshairStyle = .plus
    @State private var size: Double = 42
    @State private var thickness: Double = 3
    @State private var opacity: Double = 1
    @State private var gap: Double = 8
    @State private var color: Color = .red
    @State private var enabled = true

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    header
                    preview
                    stylePicker
                    controls
                    resetButton
                }
                .padding(20)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        VStack(spacing: 6) {
            Text("PEPPA AIM")
                .font(.system(size: 30, weight: .black))
                .foregroundStyle(.white)

            HStack(spacing: 7) {
                Circle()
                    .fill(enabled ? Color.green : Color.gray)
                    .frame(width: 9, height: 9)

                Text(enabled ? "AIM ENABLED" : "AIM DISABLED")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var preview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.08, green: 0.08, blue: 0.1))
                .frame(height: 280)
                .overlay {
                    Text("PREVIEW")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.25))
                        .offset(y: -110)
                }

            if enabled {
                Crosshair(
                    style: style,
                    size: size,
                    thickness: thickness,
                    gap: gap,
                    color: color
                )
                .opacity(opacity)
            }
        }
    }

    private var stylePicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("KIỂU TÂM")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            Picker("Kiểu tâm", selection: $style) {
                ForEach(CrosshairStyle.allCases) { item in
                    Text(item.title).tag(item)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var controls: some View {
        VStack(spacing: 16) {
            ControlSlider(title: "Kích thước", value: $size, range: 10...100, suffix: "\(Int(size))")
            ControlSlider(title: "Độ dày", value: $thickness, range: 1...10, suffix: "\(Int(thickness))")
            ControlSlider(title: "Khoảng cách", value: $gap, range: 0...30, suffix: "\(Int(gap))")
            ControlSlider(title: "Độ trong suốt", value: $opacity, range: 0.1...1, suffix: "\(Int(opacity * 100))%")

            HStack {
                Text("Màu tâm")
                    .font(.headline)

                Spacer()

                ColorPicker("", selection: $color, supportsOpacity: false)
                    .labelsHidden()
            }
            .padding()
            .background(.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Toggle("Bật tâm ảo", isOn: $enabled)
                .tint(.red)
                .padding()
                .background(.white.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var resetButton: some View {
        Button {
            style = .plus
            size = 42
            thickness = 3
            opacity = 1
            gap = 8
            color = .red
            enabled = true
        } label: {
            Text("KHÔI PHỤC MẶC ĐỊNH")
                .font(.headline.weight(.bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

enum CrosshairStyle: String, CaseIterable, Identifiable {
    case plus
    case dot
    case circle

    var id: String { rawValue }

    var title: String {
        switch self {
        case .plus: return "+"
        case .dot: return "•"
        case .circle: return "○"
        }
    }
}

struct Crosshair: View {
    let style: CrosshairStyle
    let size: Double
    let thickness: Double
    let gap: Double
    let color: Color

    var body: some View {
        ZStack {
            switch style {
            case .plus:
                Rectangle()
                    .fill(color)
                    .frame(width: thickness, height: size)
                    .mask(
                        VStack(spacing: gap) {
                            Rectangle().frame(height: (size - gap) / 2)
                            Rectangle().frame(height: (size - gap) / 2)
                        }
                    )

                Rectangle()
                    .fill(color)
                    .frame(width: size, height: thickness)
                    .mask(
                        HStack(spacing: gap) {
                            Rectangle().frame(width: (size - gap) / 2)
                            Rectangle().frame(width: (size - gap) / 2)
                        }
                    )

            case .dot:
                Circle()
                    .fill(color)
                    .frame(width: thickness * 2.5, height: thickness * 2.5)

            case .circle:
                Circle()
                    .stroke(color, lineWidth: thickness)
                    .frame(width: size, height: size)
            }
        }
    }
}

struct ControlSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let suffix: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                Spacer()
                Text(suffix)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            Slider(value: $value, in: range)
                .tint(.red)
        }
        .padding()
        .background(.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ContentView()
}
