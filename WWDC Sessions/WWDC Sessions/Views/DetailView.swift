/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The detail view for a Session.
*/

import Foundation
import SwiftUI
import AVKit

struct DetailView: View {
    @Binding var selection: LocalSession?
    @State private var avPlayer = AVPlayer()

    func playCurrentSelection() {
        if let selection = self.selection {
            self.avPlayer.replaceCurrentItem(with: AVPlayerItem(url: selection.fileURL))
            self.avPlayer.play()
        }
    }
    
    var body: some View {
        if let selection = selection {
            VStack {
                videoPlayer
                
                Spacer()
                Divider()
                
                SessionDescription(session: selection, style: .detailed)
            }
            .padding()
        } else {
            Text("Select a session.")
        }
    }
    
    var videoPlayer: some View {
        VideoPlayer(player: self.avPlayer)
            .onAppear {
                self.playCurrentSelection()
            }
            .onDisappear {
                self.avPlayer.pause()
            }
            .onChange(of: selection) { _ in
                self.playCurrentSelection()
            }
            .aspectRatio(16.0 / 9.0, contentMode: .fit)
    }
}

struct DetailView_Previews: PreviewProvider {
    @ObservedObject static var previewSessionManager = PreviewSessionManager()

    static var previews: some View {
        DetailView(selection: previewSessionManager.session)
    }
}
