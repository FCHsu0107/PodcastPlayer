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
    func changeEpisode(toNext index: Int)
}

protocol EpisodePageContainer {
    func playbackStatusDidChange(_ newStatus: EpisodeViewController.PlaybackStatus)
    func updateEpisodeItem(_ newItem: EpisodeItem)
}

class EpisodeViewController: UIViewController {
    
    weak var delegate: EpisodePageDelegate?
    
    private var detailContainer: EpisodeDetailContainer!
    private var playerContainer: EpisodePlayerContainer!
    lazy var containers: [EpisodePageContainer] = [detailContainer, playerContainer]
    
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
    
    init(_ delegate: EpisodePageDelegate, item: EpisodeItem, channelName: String) {
        self.delegate = delegate
        self.item = item
        self.channelName = channelName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("EpisodeViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        
        view.addSubview(episodeImage)
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
        
        updateUIWithEpisodeItem()
        switchContainer(currentPlaybackStatus)
    }
    
    private func playbackStatusDidChange(_ newStatus: PlaybackStatus) {
        guard currentPlaybackStatus != newStatus else { return }
        currentPlaybackStatus = newStatus
        updateUIWithPlaybackStatus()
        switchContainer(newStatus)
    }
    
    private func switchContainer(_ newStatus: PlaybackStatus) {
        let hidePlayStatus = newStatus == .pause
        detailContainer.isHidden = !hidePlayStatus
        playerContainer.isHidden = hidePlayStatus
        containers.forEach { container in
            container.playbackStatusDidChange(newStatus)
        }
    }
    
    private func updateUIWithPlaybackStatus() {
        let hideString = currentPlaybackStatus == .play
        titleLabel.isHidden = hideString
        channelNameLabel.isHidden = hideString
    }
    
    private func updateUIWithEpisodeItem() {
        episodeImage.loadImage(item.imageUrlString)
        titleLabel.text = item.title
    }
}

extension EpisodeViewController: EpisodeContainerDelegate {
    func changeEpisode(toNext index: Int) {
        guard index >= 0 else { return }
        guard let episodeItem = delegate?.getEpisodeItem(with: index) else { return }
        self.item = episodeItem
        updateUIWithEpisodeItem()
        containers.forEach { container in
            container.updateEpisodeItem(episodeItem)
        }
    }
    
    func playbackBtnDidClick(btnStatus: PlaybackStatus) {
        playbackStatusDidChange(btnStatus)
    }
}
