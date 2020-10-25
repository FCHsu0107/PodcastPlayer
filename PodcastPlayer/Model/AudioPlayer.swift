//
//  AudioPlayer.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import Foundation

import AVFoundation

class AudioPlayer {
    private var observer: NSKeyValueObservation?
    private var player: AVPlayer?
    private var isLoop: Bool = false
    private var autoPlay: Bool = false
    private var playToEndAction: (() -> Void)?

    deinit {
        clearPlayerSetting()
        print("JQ AudioPlayer deinit")
    }

    func configure(urlString: String, isLoop: Bool = false, autoPlay: Bool = false) {
        let urlPath = "https://s3-ap-northeast-1.amazonaws.com/mid-exam/Video/taeyeon.mp4"
        guard let url = URL(string: urlPath) else { return }// handle error
        clearPlayerSetting()
        self.isLoop = isLoop
        self.autoPlay = autoPlay
        player = AVPlayer(url: url)
        addObservers()
    }

    private func clearPlayerSetting() {
        removeObservers()
        player = nil
    }

    private func addObservers() {
        guard let player = player, let playerItem = player.currentItem else { return }
        NotificationCenter.default.addObserver(self, selector: #selector(reachEndAction(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        self.observer = playerItem.observe(\.status, options: [.new], changeHandler: { [weak self] playerItem, _ in
            guard let self = self, playerItem.status == .readyToPlay, self.autoPlay else { return }
                self.play()
        })
    }

    private func removeObservers() {
        observer?.invalidate()
        if let playerItem = player?.currentItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
    }

    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }

    func pause() {
        player?.pause()
    }

    func stop() {
        pause()
        seek(to: CMTime.zero)
    }

    func seek(to time: CMTime) {
        player?.seek(to: time)
    }

    func forward(time: Double){
        guard let player = player else { return }
        guard let duration = player.currentItem?.duration else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + time

        if newTime < CMTimeGetSeconds(duration) - 10.0 {
            let newTime: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
            player.seek(to: newTime)
        } else { return }
    }

    func backward(time: Double){
        guard let player = player else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime - time

        if newTime < 0 {
            player.seek(to: CMTime.zero)

        } else {
            let newTime: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
            player.seek(to: newTime)
        }
    }

    @objc func reachEndAction(_ notification: Notification) {
        if isLoop {
            stop()
            play()
        } else {
            playToEndAction?()
        }
    }

    func getTimeString(from time: CMTime) -> String {
        let totalSecond = CMTimeGetSeconds(time)
        let hours = Int(totalSecond/3600)
        let minutes = Int(totalSecond/60) % 60
        let seconds = Int(totalSecond.truncatingRemainder(dividingBy: 60))

        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
}
