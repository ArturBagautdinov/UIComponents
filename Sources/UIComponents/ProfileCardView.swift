#if canImport(UIKit)
import UIKit

public final class ProfileCardView: UIView {
    public struct ViewData: Equatable {
        public let fullName: String
        public let email: String
        public let imageURL: URL?
        public let isFollowing: Bool

        public init(
            fullName: String,
            email: String,
            imageURL: URL?,
            isFollowing: Bool
        ) {
            self.fullName = fullName
            self.email = email
            self.imageURL = imageURL
            self.isFollowing = isFollowing
        }
    }

    public var onFollowTap: (() -> Void)?

    private let cardView = UIView()
    private let avatarImageView = UserAvatarImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let followButton = UIButton(type: .system)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupHierarchy()
        setupLayout()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with viewData: ViewData) {
        nameLabel.text = viewData.fullName
        emailLabel.text = viewData.email

        var configuration = followButton.configuration ?? .filled()
        configuration.title = viewData.isFollowing ? "Following" : "Follow"
        configuration.baseBackgroundColor = viewData.isFollowing ? .systemGreen : .systemBlue
        followButton.configuration = configuration

        avatarImageView.configure(
            imageURL: viewData.imageURL,
            size: CGSize(width: 104, height: 104),
            cornerRadius: 52,
            showsIndicator: true
        )
    }

    private func setupView() {
        backgroundColor = .clear

        cardView.backgroundColor = UIColor(named: "SurfacePrimary") ?? .secondarySystemBackground
        cardView.layer.cornerRadius = 28
        cardView.layer.cornerCurve = .continuous
        cardView.layer.shadowColor = (UIColor(named: "CardShadow") ?? UIColor.black).cgColor
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowRadius = 22
        cardView.layer.shadowOffset = CGSize(width: 0, height: 12)
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = (UIColor(named: "SurfaceStroke") ?? UIColor.white.withAlphaComponent(0.2)).cgColor

        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2

        emailLabel.font = .systemFont(ofSize: 17, weight: .medium)
        emailLabel.textColor = .secondaryLabel
        emailLabel.textAlignment = .center
        emailLabel.numberOfLines = 2

        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .large
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 26, bottom: 14, trailing: 26)
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 17, weight: .bold)
            return outgoing
        }
        followButton.configuration = configuration
        followButton.layer.cornerRadius = 16
        followButton.layer.cornerCurve = .continuous
        followButton.addTarget(self, action: #selector(handleFollowTap), for: .touchUpInside)
    }

    private func setupHierarchy() {
        addSubview(cardView)

        cardView.addSubview(avatarImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(emailLabel)
        cardView.addSubview(followButton)
    }

    private func setupLayout() {
        [cardView, avatarImageView, nameLabel, emailLabel, followButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),

            avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 28),
            avatarImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 104),
            avatarImageView.heightAnchor.constraint(equalToConstant: 104),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            emailLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),

            followButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 22),
            followButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            followButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -28),
            followButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 52)
        ])
    }

    @objc
    private func handleFollowTap() {
        onFollowTap?()
    }
}
