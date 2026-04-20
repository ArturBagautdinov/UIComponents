import SwiftUI
import UIKit

struct LoadingView: UIViewRepresentable {
    var title: String?
    var rowCount = 0
    var rowHeight: CGFloat = 104
    var centersTitle = false

    func makeUIView(context: Context) -> LoadingContentView {
        LoadingContentView()
    }

    func updateUIView(_ uiView: LoadingContentView, context: Context) {
        uiView.configure(
            title: title,
            rowCount: rowCount,
            rowHeight: rowHeight,
            centersTitle: centersTitle
        )
    }
}

final class LoadingContentView: UIView {
    private let stackSpacing: CGFloat = 16
    private let titleRowHeight: CGFloat = 24
    private let stackView = UIStackView()
    private var currentTitle: String?
    private var currentRowCount = 0
    private var currentRowHeight: CGFloat = 104

    override var intrinsicContentSize: CGSize {
        let titleHeight = currentTitle.map { _ in titleRowHeight } ?? 0
        let rowsHeight = CGFloat(currentRowCount) * currentRowHeight

        let titleSpacing: CGFloat
        if currentTitle != nil && currentRowCount > 0 {
            titleSpacing = stackSpacing
        } else {
            titleSpacing = 0
        }

        let rowsSpacing = CGFloat(max(currentRowCount - 1, 0)) * stackSpacing
        let totalHeight = titleHeight + titleSpacing + rowsHeight + rowsSpacing

        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String?, rowCount: Int, rowHeight: CGFloat, centersTitle: Bool) {
        currentTitle = title
        currentRowCount = rowCount
        currentRowHeight = rowHeight

        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        if let title, !title.isEmpty {
            stackView.addArrangedSubview(makeTitleRow(title: title, centered: centersTitle))
        }

        guard rowCount > 0 else {
            invalidateIntrinsicContentSize()
            return
        }

        for _ in 0..<rowCount {
            stackView.addArrangedSubview(makePlaceholderRow(height: rowHeight))
        }

        invalidateIntrinsicContentSize()
    }

    private func setupView() {
        backgroundColor = .clear

        stackView.axis = .vertical
        stackView.spacing = stackSpacing
        stackView.alignment = .fill
        stackView.distribution = .fill
    }

    private func setupLayout() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func makeTitleRow(title: String, centered: Bool) -> UIView {
        let container = UIView()

        let progressView = UIActivityIndicatorView(style: .medium)
        progressView.startAnimating()
        progressView.color = .secondaryLabel

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        titleLabel.numberOfLines = 0

        container.addSubview(progressView)
        container.addSubview(titleLabel)

        [progressView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        if centered {
            let contentStack = UIStackView(arrangedSubviews: [progressView, titleLabel])
            contentStack.axis = .horizontal
            contentStack.spacing = 12
            contentStack.alignment = .center

            container.addSubview(contentStack)
            contentStack.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                contentStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                contentStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                contentStack.topAnchor.constraint(equalTo: container.topAnchor),
                contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor),
                contentStack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor),
                contentStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                progressView.topAnchor.constraint(equalTo: container.topAnchor),
                progressView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                progressView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

                titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 12),
                titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),

                progressView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            ])
        }

        return container
    }

    private func makePlaceholderRow(height: CGFloat) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(named: "PlaceholderSurface") ?? .tertiarySystemFill
        container.layer.cornerRadius = 28
        container.layer.cornerCurve = .continuous

        let progressView = UIActivityIndicatorView(style: .medium)
        progressView.startAnimating()
        progressView.color = .secondaryLabel

        container.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: height),
            progressView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            progressView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])

        return container
    }
}
