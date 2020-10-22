//
//  EpisodeViewController.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/23.
//

import UIKit

import SnapKit

class EpisodeViewController: UIViewController {
    
    let item: String
    
    init(_ item: String) {
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
//        episodeImage.image = item.image
        episodeImage.backgroundColor = .green
        episodeImage.contentMode = .scaleAspectFill
        episodeImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(episodeImage.snp.width)
        }
        
        func setUpLabel(_ label: UILabel) {
            let font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .justified
            label.textColor = .black
            label.font = font
            label.numberOfLines = 0
        }
        
        let descriptionLabel = UILabel()
        view.addSubview(descriptionLabel)
        setUpLabel(descriptionLabel)
//        descriptionLabel.text = item.description
        descriptionLabel.text = "賺錢光靠自我成長不夠，也要觀察外部的趨勢變化。辛苦賺來的錢，也可能一點一滴的被政府偷偷的「稀釋」甚至「刪除」。許多國家加快推動數位貨幣，如中國的數位人民幣（Digital Currency Electronic Payment）以及台灣的央行數位貨幣（Central Bank Digital Currency），進一步將貨幣轉為政府資料庫上的紀錄。這不僅開創新的機會，解放更多生產力，也將衝擊政府的權力結構。"
        descriptionLabel.snp.makeConstraints { make in
            make.trailing.leading.equalTo(episodeImage)
            make.top.equalTo(episodeImage.snp.bottom).offset(12)
        }
        
        let refLabel = UILabel()
        view.addSubview(refLabel)
        setUpLabel(refLabel)
        refLabel.text = "文章： 如何賺錢、信用與數位貨幣 https://bit.ly/2AwK6JL"
        refLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(episodeImage)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
        }
        
        let remarkLabel = UILabel()
        view.addSubview(remarkLabel)
        setUpLabel(remarkLabel)
        remarkLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(episodeImage)
            make.top.equalTo(refLabel.snp.bottom).offset(8)
        }
        
        let playButton = UIButton()
        view.addSubview(playButton)
        playButton.backgroundColor = .blue
        playButton.addTarget(self, action: #selector(clickPlayButton), for: .touchUpInside)
        playButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(playButton.snp.height)
        }
    }
    
    @objc private func clickPlayButton() {
        //present next page
        print("Play button did click")
    }
}

extension EpisodeViewController {
    static func makeEpisodeVC(_ item: String) -> EpisodeViewController {
        return EpisodeViewController(item)
    }
}
