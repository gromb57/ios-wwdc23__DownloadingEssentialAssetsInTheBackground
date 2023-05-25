/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The thumbnail view of a WWDC session video.
*/

import SwiftUI

let thumbnailWidth: CGFloat = 96.0
let thumbnailHeight = CGFloat(thumbnailWidth) / (16.0 / 9.0)

struct Thumbnail: View {
    @ObservedObject var localSession: LocalSession
    
    var body: some View {
        if localSession.state == .remote {
            ProgressView(value: localSession.downloadProgress)
                .progressViewStyle(GaugeProgressStyle())
                .frame(width: thumbnailWidth, height: thumbnailHeight)
        } else if let image = localSession.thumbnailImage {
            Image(image, scale: 1.0, label: Text("Thumbnail image for developer session video."))
                .resizable()
                .aspectRatio(16.0 / 9.0, contentMode: .fit)
                .frame(width: thumbnailWidth)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
        } else {
            ProgressView()
                .frame(width: thumbnailWidth, height: thumbnailHeight)
        }
    }

    struct GaugeProgressStyle: ProgressViewStyle {
        let strokeColor = Color(white: 0)
        let strokeWidth = 6.0

        public func makeBody(configuration: Configuration) -> some View {
            let fractionCompleted = configuration.fractionCompleted ?? 0

            return Circle()
                .fill(Color(white: 0.85,
                            opacity: 0.85))
                .frame(width: 30, height: 30)
                .overlay {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: CGFloat(fractionCompleted))
                            .stroke(strokeColor, style: StrokeStyle(lineWidth: CGFloat(strokeWidth), lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 20, height: 20)
                            .animation(.linear, value: fractionCompleted)
                    }
                }
        }
    }
}

struct Thumbnail_Previews: PreviewProvider {
    @State static var sessionManager = SessionManager()

    static var previews: some View {
        if let session = sessionManager.sessions.first {
            Thumbnail(localSession: session)
        } else {
            ProgressView()
        }
    }
}
