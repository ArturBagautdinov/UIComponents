import Kingfisher
import SwiftUI
import UIKit

public struct UserAvatarView: UIViewRepresentable {
    let imageURL: URL?
    let size: CGSize
    let cornerRadius: CGFloat
    let showsIndicator: Bool

    public init(
        imageURL: URL?,
        size: CGSize,
        cornerRadius: CGFloat,
        showsIndicator: Bool = false
    ) {
        self.imageURL = imageURL
        self.size = size
        self.cornerRadius = cornerRadius
        self.showsIndicator = showsIndicator
    }

    public func makeUIView(context: Context) -> UserAvatarImageView {
        UserAvatarImageView()
    }

    public func updateUIView(_ uiView: UserAvatarImageView, context: Context) {
        uiView.configure(
            imageURL: imageURL,
            size: size,
            cornerRadius: cornerRadius,
            showsIndicator: showsIndicator
        )
    }
}

public final class UserAvatarImageView: UIView {
    private let imageView = UIImageView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(
        imageURL: URL?,
        size: CGSize,
        cornerRadius: CGFloat,
        showsIndicator: Bool = false
    ) {
        imageView.layer.cornerRadius = cornerRadius
        imageView.kf.indicatorType = showsIndicator ? .activity : .none
        imageView.kf.cancelDownloadTask()
        imageView.image = placeholderImage

        guard let imageURL else {
            return
        }

        imageView.kf.setImage(
            with: imageURL,
            placeholder: placeholderImage,
            options: [
                .processor(DownsamplingImageProcessor(size: size)),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }

    private func setupView() {
        clipsToBounds = false

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .tertiarySystemFill
        imageView.tintColor = .secondaryLabel
        imageView.image = placeholderImage
    }

    private func setupLayout() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private var placeholderImage: UIImage? {
        UIImage(systemName: "person.fill")
    }
}
