//
//  EpisodeViewController.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/23.
//

import UIKit

import SnapKit

class EpisodeViewController: UIViewController {
    
    let item: EpisodeItem
    
    init(_ item: EpisodeItem) {
        self.item = item
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
        
        let descriptionLabel = UILabel()
        view.addSubview(descriptionLabel)
        let font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .natural
        descriptionLabel.textColor = .black
        descriptionLabel.font = font
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = item.description
        descriptionLabel.snp.makeConstraints { make in
            make.trailing.leading.equalTo(episodeImage)
            make.top.equalTo(episodeImage.snp.bottom).offset(12)
            make.bottom.lessThanOrEqualTo(playButton.snp.top)
        }
    }
    
    @objc private func clickPlayButton() {
        //present next page
        print("Play button did click")
    }
}
