//
//  EpisodePlayerContainer.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import CoreMedia.CMTime
import UIKit

class EpisodePlayerContainer: UIView {

    weak var delegate: EpisodeContainerDelegate?
    
    private let titleLabel = UILabel()
    private let timecodeSlider = UISlider()
    private let player = AudioPlayer()
    
    private var item: EpisodeItem
    
    init(delegate: EpisodeContainerDelegate, item: EpisodeItem) {
        self.delegate = delegate
        self.item = item
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        let pauseButton = UIButton()
        addSubview(pauseButton)
        pauseButton.setImage(UIImage.asset(.pause), for: .normal)
        pauseButton.addTarget(self, action: #selector(pauseButtonDidClick), for: .touchUpInside)
        pauseButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        
        addSubview(titleLabel)
        titleLabel.text = item.title
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
        }
        
        addSubview(timecodeSlider)
        timecodeSlider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)
        timecodeSlider.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pauseButton.snp.top).offset(-20)
        }
        
        let forwardButton = UIButton()
        addSubview(forwardButton)
        forwardButton.setImage(UIImage.asset(.forward), for: .normal)
        forwardButton.addTarget(self, action: #selector(forwardButtonDidClick), for: .touchUpInside)
        forwardButton.snp.makeConstraints { make in
            make.centerY.equalTo(pauseButton)
            make.leading.equalTo(pauseButton.snp.trailing).offset(12)
            make.width.height.equalTo(80)
        }
        
        let rewindButton = UIButton()
        addSubview(rewindButton)
        rewindButton.setImage(UIImage.asset(.rewind), for: .normal)
        rewindButton.addTarget(self, action: #selector(rewindButtonDidClick), for: .touchUpInside)
        rewindButton.snp.makeConstraints { make in
            make.centerY.equalTo(pauseButton)
            make.trailing.equalTo(pauseButton.snp.leading).offset(-12)
            make.width.height.equalTo(80)
        }
        
        configurePlayer()
    }
    
    private func setSliderMaxValue(_ maxValue: Float) {
        timecodeSlider.minimumValue = 0.0
        timecodeSlider.maximumValue = maxValue
    }
    
    private func updateSliderValue(_ newValue: Float) {
        guard newValue <= timecodeSlider.maximumValue else { return }
        timecodeSlider.value = newValue
    }
    
    private func configurePlayer(autoPlay: Bool = false) {
        //TODO: query soundcloud streaming url SCSoundCloudAPIDelegate
        //https://steelkiwi.com/blog/how-integrate-soundcloud-project-swift/
        //https://soundcloud.com/you/apps
        player.configure(delegate: self, urlString: item.link, autoPlay: autoPlay)
    }
    
    @objc private func pauseButtonDidClick() {
        //present next page
        print("pause button did click")
        delegate?.playbackBtnDidClick(btnStatus: .pause)
    }
    
    @objc private func sliderValueDidChange(sender: UISlider) {
        let value = sender.value
        guard value > 0 else { return }
        let newTime = CMTimeMake(value: Int64(value * 1000), timescale: 1000)
        player.seek(to: newTime)
    }
    
    @objc private func forwardButtonDidClick() {
        player.forward(time: 10.0)
    }
    
    @objc private func rewindButtonDidClick() {
        player.rewind(time: 10.0)
    }
}

extension EpisodePlayerContainer: EpisodePageContainer {
    func playbackStatusDidChange(_ newStatus: EpisodeViewController.PlaybackStatus) {
        switch newStatus {
        case .play:
            player.play()
        case .pause:
            player.pause()
        }
    }
    
    func updateEpisodeItem(_ newItem: EpisodeItem) {
        guard newItem.title != item.title else { return }
        self.item = newItem
        titleLabel.text = item.title
        configurePlayer(autoPlay: true)
    }
}

extension EpisodePlayerContainer: AudioPlayerDelegate {
    func assetDurationIsReady(durationInSec: Double) {
        let duration = Float(durationInSec)
        setSliderMaxValue(duration)
    }
    
    func currentTimeDidChange(_ currentTime: Double) {
        let time = Float(currentTime)
        updateSliderValue(time)
    }
    
    func reachEndAction() {
        if item.index > 0 {
            let nextIndex = item.index - 1
            delegate?.changeEpisode(toNext: nextIndex)
        }
    }
}
