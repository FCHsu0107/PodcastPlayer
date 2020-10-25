//
//  EpisodeViewController.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/23.
//

import UIKit

import SnapKit

protocol EpisodeContainerDelegate: AnyObject {
    func playbackBtnDidClick(btnStatus: EpisodeViewController.PlaybackStatus)
}

class EpisodeViewController: UIViewController {
    
    private var detailContainer: EpisodeDetailContainer!
    private var playerContainer: EpisodePlayerContainer!
    
    private let episodeImage = UIImageView()
    private let channelNameLabel = UILabel()
    private let titleLabel = UILabel()
    
    enum PlaybackStatus {
        case pause
        case play
    }
    
    private let channelName: String
    private var item: EpisodeItem
    private var currentPlaybackStatus: PlaybackStatus = .pause
    
    init(_ item: EpisodeItem, channelName: String) {
        self.item = item
        self.channelName = channelName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        
        view.addSubview(episodeImage)
        episodeImage.loadImage(item.imageUrlString)
        episodeImage.backgroundColor = .gray
        episodeImage.contentMode = .scaleAspectFill
        episodeImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(self.view.safeArea.top).offset(8)
            make.height.equalTo(episodeImage.snp.width)
        }
        
        view.addSubview(channelNameLabel)
        channelNameLabel.textColor = .black
        channelNameLabel.font = UIFont.systemFont(ofSize: 22)
        channelNameLabel.text = channelName
        channelNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(episodeImage).offset(10)
            make.trailing.equalTo(episodeImage).offset(-10)
            make.top.equalTo(episodeImage)
            make.height.equalTo(episodeImage.snp.height).multipliedBy(0.22)
        }
        
        
        view.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        titleLabel.numberOfLines = 0
        titleLabel.text = item.title
        titleLabel.snp.makeConstraints { make in
            make.trailing.leading.equalTo(channelNameLabel)
            make.top.equalTo(channelNameLabel.snp.bottom)
        }
        
        detailContainer = EpisodeDetailContainer(delegate: self, item: item)
        view.addSubview(detailContainer)
        detailContainer.snp.makeConstraints { make in
            make.top.equalTo(episodeImage.snp.bottom).offset(12)
            make.leading.trailing.equalTo(episodeImage)
            make.bottom.equalTo(view.safeArea.bottom).offset(-8)
        }
        
        playerContainer = EpisodePlayerContainer(delegate: self, item: item)
        view.addSubview(playerContainer)
        playerContainer.snp.makeConstraints { make in
            make.top.equalTo(episodeImage.snp.bottom).offset(12)
            make.leading.trailing.equalTo(episodeImage)
            make.bottom.equalTo(self.view.safeArea.bottom).offset(-8)
        }
        
        switchContainer(currentPlaybackStatus)
    }
    
    private func playbackStatusDidChange(_ newStatus: PlaybackStatus) {
        guard currentPlaybackStatus != newStatus else { return }
        currentPlaybackStatus = newStatus
        let hideString = newStatus == .play
        titleLabel.isHidden = hideString
        channelNameLabel.isHidden = hideString
        switchContainer(newStatus)
        playerContainer.startToPlayAudio(newStatus == .play)
    }
    
    private func switchContainer(_ newStatus: PlaybackStatus) {
        let hidePlayStatus = newStatus == .pause
        detailContainer.isHidden = !hidePlayStatus
        playerContainer.isHidden = hidePlayStatus
    }
}

extension EpisodeViewController: EpisodeContainerDelegate {
    func playbackBtnDidClick(btnStatus: PlaybackStatus) {
        playbackStatusDidChange(btnStatus)
    }
}
