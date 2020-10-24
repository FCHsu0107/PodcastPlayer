//
//  EpisodeViewController.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/23.
//

import UIKit

import SnapKit

class EpisodeViewController: UIViewController {
    
    private let item: EpisodeItem
    private let channelName: String
    
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
        let episodeImage = UIImageView()
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
        
        let channelNameLabel = UILabel()
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
        
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        titleLabel.numberOfLines = 0
        titleLabel.text = item.title
        titleLabel.snp.makeConstraints { make in
            make.trailing.leading.equalTo(channelNameLabel)
            make.top.equalTo(channelNameLabel.snp.bottom)
        }
        
        let playButton = UIButton()
        view.addSubview(playButton)
        playButton.backgroundColor = .blue
        playButton.addTarget(self, action: #selector(clickPlayButton), for: .touchUpInside)
        playButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeArea.bottom).offset(-8)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(playButton.snp.height)
        }
        
        let descriptionTextView = UITextView()
        view.addSubview(descriptionTextView)
        descriptionTextView.textAlignment = .left
        descriptionTextView.textColor = .black
        descriptionTextView.font = UIFont.systemFont(ofSize: 14)
        descriptionTextView.isEditable = false
        descriptionTextView.text = item.description
        descriptionTextView.snp.makeConstraints { make in
            make.trailing.leading.equalTo(episodeImage)
            make.top.equalTo(episodeImage.snp.bottom).offset(12)
            make.bottom.equalTo(playButton.snp.top).offset(8)
        }
    }
    
    @objc private func clickPlayButton() {
        //present next page
        print("Play button did click")
    }
}
