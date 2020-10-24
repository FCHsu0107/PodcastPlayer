//
//  HomePageTableViewCell.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/22.
//

import UIKit

import SnapKit

class HomePageTableViewCell: UITableViewCell {
    private let podcastImage = UIImageView()
    private let titleLabel = UILabel()
    private let publicDateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.addSubview(podcastImage)
        podcastImage.backgroundColor = .yellow
        podcastImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(podcastImage.snp.width)
            make.leading.equalToSuperview().offset(12)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(podcastImage.snp.trailing).offset(12)
            make.top.equalTo(podcastImage).offset(2)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        contentView.addSubview(publicDateLabel)
        publicDateLabel.textAlignment = .left
        publicDateLabel.font = UIFont.systemFont(ofSize: 14)
        publicDateLabel.textColor = .black
        publicDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(podcastImage).offset(-2)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    func cofigure(_ item: EpisodeItem) {
        podcastImage.backgroundColor = .red
        titleLabel.text = item.title
        publicDateLabel.text = "2020/10/22"
    }
}
