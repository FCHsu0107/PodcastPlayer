//
//  HomeViewController.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/22.
//

import UIKit

import SnapKit

class HomeViewController: UIViewController {
    
    var tableView: UITableView!
    var channelItem: ChannelItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getRSSFeedInfo()
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .white
        tableView = UITableView(frame: .zero, style: .plain)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(self.view.safeArea.top)
            make.bottom.equalTo(self.view.safeArea.bottom)
        }
        tableView.register(cellType: HomePageTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func getRSSFeedInfo() {
        // TODO: save url string in plist
//        let rssFeedPath = "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss"
//        let parser = RSSParser()
//        parser.request(urlPath: rssFeedPath) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .failure(let error):
//                print("get data fail \(error)")// toast message
//            case .success(let item):
//                self.channelItem = item
//                self.tableView.reloadData()
//            }
//        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelItem?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(HomePageTableViewCell.self, for: indexPath)
        guard let channelItem = channelItem else { return cell }
        let item = channelItem.items[indexPath.row]
        cell.cofigure(item)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard channelItem != nil else { return .zero }
        return UIScreen.main.bounds.width * 3/5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let channel = channelItem else { return nil }
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.loadImage(channel.imageUrlString)
        return imageView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let channel = channelItem else { return }
        let episodePage = EpisodeViewController(channel.items[indexPath.row], channelName: channel.title)
        navigationController?.pushViewController(episodePage, animated: true)
    }
}
