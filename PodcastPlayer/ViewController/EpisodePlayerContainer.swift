//
//  EpisodePlayerContainer.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import UIKit

class EpisodePlayerContainer: UIView {

    weak var delegate: EpisodeContainerDelegate?
    
    private let titleLabel = UILabel()
    
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
    
    func updateEpisodeItem(_ newItem: EpisodeItem) {
        guard newItem.title != item.title else { return }
        self.item = newItem
        titleLabel.text = item.title
    }
    
    private func setUpUI() {
        let pauseButton = UIButton()
        addSubview(pauseButton)
        pauseButton.setImage(UIImage.asset(.pause), for: .normal)
        pauseButton.addTarget(self, action: #selector(clickPlayButton), for: .touchUpInside)
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
        
        // slider to change time
    }
    
    @objc private func clickPlayButton() {
        //present next page
        print("pause button did click")
        delegate?.playbackBtnDidClick(btnStatus: .pause)
    }

}
