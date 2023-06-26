//
//  EmbedView.swift
//  Accord
//
//  Created by evelyn on 2021-10-24.
//

import AVKit
import SwiftUI

extension CGFloat {
    init?(optional: Int?) {
        if let optional {
            self.init(optional)
        } else {
            return nil
        }
    }
}

struct EmbedView: View, Equatable {
    @Binding var embed: Embed

    static func == (_: EmbedView, _: EmbedView) -> Bool {
        true
    }

    var columns: [GridItem] = GridItem.multiple(count: 4)

    @ViewBuilder
    private var colorLine: some View {
        if let color = embed.color {
            if #available(macOS 13.0, *) {
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color(int: color).gradient)
                    .frame(width: 5)
                    .padding(.trailing, 5)
            } else {
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color(int: color))
                    .frame(width: 5)
                    .padding(.trailing, 5)
            }
        } else {
            RoundedRectangle(cornerRadius: 1)
                .fill(Color.black)
                .frame(width: 5)
                .padding(.trailing, 5)
        }
    }
    
    @ViewBuilder
    var mediaEmbed: some View {
        if let image = embed.image {
            Attachment(image.url, size: CGSize(width: image.width ?? 400, height: image.width ?? 300))
                .equatable()
                .cornerRadius(7)
                .maxFrame(width: 380, height: 300, originalWidth: image.width ?? 0, originalHeight: image.height ?? 0)
                .padding(.vertical, 2)
        }
        if let video = embed.video,
           let urlString = video.proxy_url ?? video.url,
           let url = URL(string: urlString)
        {
            VideoPlayerController(url: url)
                .cornerRadius(5)
                .maxFrame(width: 380, height: 300, originalWidth: video.width ?? 0, originalHeight: video.height ?? 0)
                .padding(.vertical, 2)
        } else if let image = embed.thumbnail {
            Attachment(image.url)
                .equatable()
                .maxFrame(width: 380, height: 300, originalWidth: image.width ?? 0, originalHeight: image.height ?? 0)
                .cornerRadius(7)
                .padding(.vertical, 2)
        }
    }
    
    @ViewBuilder
    var body: some View {
        if embed.type == "gifv" || embed.type == "image" || embed.type == "video" {
            self.mediaEmbed
        } else {
            GroupBox {
                HStack(spacing: 0) {
                    colorLine.padding(.leading, -5).padding(.vertical, -5)
                    
                    VStack(alignment: .leading) {
                        if let author = embed.author {
                            HStack {
                                if let iconURL = author.proxy_icon_url ?? author.icon_url {
                                    Attachment(iconURL, size: CGSize(width: 48, height: 48))
                                        .equatable()
                                        .frame(width: 25, height: 25)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                                if let urlString = author.url, let url = URL(string: urlString) {
                                    Button(action: {
                                        NSWorkspace.shared.open(url)
                                    }) {
                                        Text(author.name)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15.5))
                                            .foregroundColor(Color.primary)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                } else {
                                    Text(author.name)
                                        .fontWeight(.semibold)
                                        .font(.system(size: 15.5))
                                }
                            }
                            .padding(.bottom, 2)
                        }
                        VStack(alignment: .leading) {
                            if let title = embed.title {
                                Text(title)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 13.5))
                                    .padding(.vertical, 2)
                                    .lineLimit(0)
                            }
                            if let description = embed.description {
                                AsyncMarkdown(description, linkShortening: true)
                                    .lineSpacing(3)
                                    .padding(.vertical, 2)
                            }
                        }
                        if let image = embed.image {
                            Attachment(image.url, size: CGSize(width: image.width ?? 400, height: image.width ?? 300))
                                .equatable()
                                .cornerRadius(7)
                                .maxFrame(width: 380, height: 300, originalWidth: image.width ?? 0, originalHeight: image.height ?? 0)
                                .padding(.vertical, 2)
                        }
                        if let video = embed.video,
                           let urlString = video.proxy_url ?? video.url,
                           let url = URL(string: urlString)
                        {
                            VideoPlayerController(url: url)
                                .cornerRadius(5)
                                .maxFrame(width: 380, height: 300, originalWidth: video.width ?? 0, originalHeight: video.height ?? 0)
                                .padding(.vertical, 2)
                        } else if let image = embed.thumbnail {
                            Attachment(image.url)
                                .equatable()
                                .maxFrame(width: 380, height: 300, originalWidth: image.width ?? 0, originalHeight: image.height ?? 0)
                                .cornerRadius(7)
                                .padding(.vertical, 2)
                        }
                        if let fields = embed.fields {
                            GridStack(fields, rowAlignment: .leading, columns: 4) { field in
                                VStack(alignment: .leading) {
                                    Text(field.name)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .lineLimit(0)
                                    AsyncMarkdown(field.value, linkShortening: true)
                                        .equatable()
                                        .font(.system(size: 12))
                                }
                            }
                            .equatable()
                            .padding(.vertical, 2)
                        }
                    }
                    .padding(5)
                }
            }

        }
    }
}
