//
//  AudioPlayer.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import Foundation

import AVFoundation

protocol AudioPlayerDelegate: AnyObject {
    func assetDurationIsReady(durationInSec: Double)
    func currentTimeDidChange(_ currentTimeInSec: Double)
    func reachEndAction()
}

class AudioPlayer {
    private var playerItemObserver: NSKeyValueObservation?
    private var periodicTimeObserver: Any?
    private var player: AVPlayer?
    private var isLoop: Bool = false
    private var autoPlay: Bool = false
    
    weak var delegate: AudioPlayerDelegate?

    deinit {
        clearPlayerSetting()
        print("AudioPlayer deinit")
    }

    func configure(delegate: AudioPlayerDelegate, urlString: String, isLoop: Bool = false, autoPlay: Bool = false) {
        let urlPath = "https://s3-ap-northeast-1.amazonaws.com/mid-exam/Video/taeyeon.mp4" // Using fake url, because app cannot get soundcloud streaming url
        //TODO query soundcloud streaming url
        guard let url = URL(string: urlPath) else { return }// handle error
        clearPlayerSetting()
        self.isLoop = isLoop
        self.autoPlay = autoPlay
        self.delegate = delegate
        player = AVPlayer(url: url)
        addObservers()
    }

    private func clearPlayerSetting() {
        removeObservers()
        player = nil
        delegate = nil
        autoPlay = false
        isLoop = false
    }

    private func addObservers() {
        guard let player = player, let playerItem = player.currentItem else { return }
        
        // play to end time action
        NotificationCenter.default.addObserver(self, selector: #selector(reachEndAction(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // auto play
        self.playerItemObserver = playerItem.observe(\.status, options: [.new], changeHandler: { [weak self] playerItem, _ in
            guard let self = self, playerItem.status == .readyToPlay else { return }
            self.delegate?.assetDurationIsReady(durationInSec: playerItem.duration.seconds)
            
            if self.autoPlay {
                self.play()
            }
        })
        
        // update current time
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        self.periodicTimeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            let currentTimeInSec = time.seconds
            self?.delegate?.currentTimeDidChange(currentTimeInSec)
        })
    }

    private func removeObservers() {
        
        if let playerItem = player?.currentItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
        
        playerItemObserver?.invalidate()
        
        if let player = player, let observer = periodicTimeObserver {
            player.removeTimeObserver(observer)
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
        pause()
        if isLoop {
            seek(to: .zero)
            play()
        } else {
            delegate?.reachEndAction()
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
