//
//  EpisodeDetailContainer.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import UIKit

class EpisodeDetailContainer: UIView {
    
    weak var delegate: EpisodeContainerDelegate?
    
    private let descriptionTextView = UITextView()
    
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
        let playButton = UIButton()
        addSubview(playButton)
        playButton.setImage(UIImage.asset(.play), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonDidClick), for: .touchUpInside)
        playButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        addSubview(descriptionTextView)
        descriptionTextView.textAlignment = .left
        descriptionTextView.textColor = .black
        descriptionTextView.font = UIFont.systemFont(ofSize: 14)
        descriptionTextView.isEditable = false
        descriptionTextView.text = item.description
        descriptionTextView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(playButton.snp.top).offset(-8)
        }
    }
    
    @objc private func playButtonDidClick() {
        delegate?.playbackBtnDidClick(btnStatus: .play)
    }
}

extension EpisodeDetailContainer: EpisodePageContainer {
    func playbackStatusDidChange(_ newStatus: EpisodeViewController.PlaybackStatus) {
        // do nothing
    }
    
    func updateEpisodeItem(_ newItem: EpisodeItem) {
        guard newItem.title != item.title else { return }
        self.item = newItem
        descriptionTextView.text = item.description
    }
}
