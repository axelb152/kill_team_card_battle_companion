import SwiftUI

struct FactionTileView: View {
    let faction: Faction

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "shield.fill")
                .font(.system(size: 32))
                .foregroundColor(.white.opacity(0.6))

            Text(faction.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text("\(faction.operatives.count) operatives")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
}
