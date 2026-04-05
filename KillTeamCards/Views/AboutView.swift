import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // MARK: - Header
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            Image(systemName: "shield.lefthalf.filled")
                                .font(.system(size: 56))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(hue: 0.08, saturation: 0.8, brightness: 1.0),
                                                 Color(hue: 0.06, saturation: 0.6, brightness: 0.75)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )

                            Text("Kill Team Cards")
                                .font(.title2).bold()
                                .foregroundColor(.white)

                            Text("Unofficial Fan Companion")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        Spacer()
                    }
                    .padding(.top, 8)

                    Divider().background(Color.white.opacity(0.1))

                    // MARK: - Disclaimer
                    infoBlock(
                        icon: "exclamationmark.triangle",
                        iconColor: Color(hue: 0.08, saturation: 0.8, brightness: 1.0),
                        title: "Not Affiliated with Games Workshop",
                        body: "This is an unofficial fan-made app and is not affiliated with, endorsed by, or connected to Games Workshop Ltd. in any way.\n\nKill Team, Warhammer, and all related names, logos, and imagery are trademarks or registered trademarks of Games Workshop Ltd."
                    )

                    // MARK: - PDF Ownership
                    infoBlock(
                        icon: "doc.richtext",
                        iconColor: .white.opacity(0.6),
                        title: "PDF Data Cards",
                        body: "Operative data cards displayed in this app are the intellectual property of Games Workshop Ltd. This app does not distribute, host, or bundle any Games Workshop content.\n\nPDFs are official free downloads from Warhammer Community and must be downloaded and imported by you."
                    )

                    // MARK: - Download link
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Download PDFs", systemImage: "arrow.down.circle")
                            .font(.subheadline).bold()
                            .foregroundColor(.white.opacity(0.85))

                        Text("Get the official free kill team data card PDFs from Warhammer Community:")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.55))

                        Link(destination: URL(string: "https://www.warhammer-community.com/en-gb/downloads/kill-team")!) {
                            HStack(spacing: 8) {
                                Image(systemName: "globe")
                                Text("warhammer-community.com/en-gb/downloads/kill-team")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                            .font(.caption.monospaced())
                            .foregroundColor(Color(hue: 0.08, saturation: 0.8, brightness: 1.0))
                            .padding(10)
                            .background(Color(hue: 0.08, saturation: 0.8, brightness: 1.0).opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)

                    // MARK: - Import instructions
                    infoBlock(
                        icon: "icloud.and.arrow.down",
                        iconColor: .white.opacity(0.6),
                        title: "How to Import PDFs",
                        body: "1. Download the PDF for your faction from the link above.\n2. Return to the faction selection screen.\n3. Tap any tile marked "Tap to import PDF".\n4. Select your downloaded PDF from the Files picker.\n\nThe app saves it to its private Documents folder — no rebuild required."
                    )

                    Divider().background(Color.white.opacity(0.1))

                    Text("No copyright infringement is intended. If you are a representative of Games Workshop and have concerns, please contact the developer.")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.3))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding(20)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Color(hue: 0.08, saturation: 0.8, brightness: 1.0))
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Helpers

    @ViewBuilder
    private func infoBlock(icon: String, iconColor: Color, title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon)
                .font(.subheadline).bold()
                .foregroundColor(iconColor)

            Text(body)
                .font(.caption)
                .foregroundColor(.white.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}
