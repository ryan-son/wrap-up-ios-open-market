# Ryan Market
REST API와의 연동을 통해 상품 리스트 / 상세 조회, 등록, 수정 및 삭제가 가능하도록 구현한 앱

# Table of Contents
- [1. 프로젝트 개요](#1-프로젝트-개요)
    + [프로젝트 관리](#프로젝트-관리)
    + [Linting tool을 이용한 일관성 있는 코드 품질 유지](#linting-tool을-이용한-일관성-있는-코드-품질-유지)
    + [MVVM](#mvvm)
    + [코드를 통한 레이아웃 구성](#코드를-통한-레이아웃-구성)
    + [적용된 기술 스택 일람](#적용된-기술-스택-일람)
- [2. 기능](#2-기능)
- [3. 설계 및 구현](#3-설계-및-구현)
- [4. 구현 완료 후 개선 또는 수정된 사항](#4-구현-완료-후-개선-또는-수정된-사항)
  - [등록한 상품으로 바로 이동 (Issue #16)](#등록한-상품으로-바로-이동-issue-16)
  - [수정한 상품으로 바로 이동 (Issue #16)](#수정한-상품으로-바로-이동-issue-16)
  - [상품 수정 시 기존 게시글의 내용 확인 및 금번에 수정한 내용을 구분할 수 있게끔 화면 구성 (Issue #17)](#상품-수정-시-기존-게시글의-내용-확인-및-금번에-수정한-내용을-구분할-수-있게끔-화면-구성-issue-17)
  - [상품 수정 시 비밀번호를 아는 이용자만 수정 화면으로 진입할 수 있도록 구성 (Issue #18)](#상품-수정-시-비밀번호를-아는-이용자만-수정-화면으로-진입할-수-있도록-구성-issue-18)
  - [상품 목록 화면 스크롤링 사용자 경험 향상 (Issue #19)](#상품-목록-화면-스크롤링-사용자-경험-향상-issue-19)
- [5. 유닛 테스트 및 UI 테스트](#5-유닛-테스트-및-ui-테스트)
  * [필자가 테스트를 하는 이유](#필자가-테스트를-하는-이유)
  * [유닛 테스트](#유닛-테스트)
    + [네트워크에 의존하지 않는 테스트 구현](#네트워크에-의존하지-않는-테스트-구현)
  * [UI 테스트](#ui-테스트)
- [6. Trouble shooting](#6-trouble-shooting)
  * [상품 상세 조회 화면 이미지 로드 시 비동기 동작으로 인해 이미지가 로드되지 않는 문제](#상품-상세-조회-화면-이미지-로드-시-비동기-동작으로-인해-이미지가-로드되지-않는-문제)
  * [상품 등록 또는 수정 후 즉시 게시글 조회 시 서버 업로드 시간으로 인해 이미지가 보이지 않던 문제](#상품-등록-또는-수정-후-즉시-게시글-조회-시-서버-업로드-시간으로-인해-이미지가-보이지-않던-문제)
  * [상품 등록 또는 수정 시 textView가 firstResponder일 때 완료 버튼을 누르면 내용이 반영되지 않는 문제](#상품-등록-또는-수정-시-textview가-firstresponder일-때-완료-버튼을-누르면-내용이-반영되지-않는-문제)


---

<img src="https://user-images.githubusercontent.com/69730931/132734214-96675a31-78d9-43e5-8830-e8a84cbd0e39.gif" alt="marketItemListView" width="270"/>  <img src="https://user-images.githubusercontent.com/69730931/132735322-88e41e0e-44e1-4410-82f3-5525a6be34a0.gif" alt="marketItemDetailView" width="270"/>  <img src="https://user-images.githubusercontent.com/69730931/132742366-8713888c-4927-4553-acdb-99cb5b818e18.gif" alt="marketItemRegisterView" width="270"/>

---

# 1. 프로젝트 개요
### 프로젝트 관리
- 구현 사항을 단계별로 정의 후 필요 기능을 이슈로 남기고 GitHub Project로 관리함으로써 체계적으로 요구기능명세에 따른 개발을 할 수 있도록 목표를 잡았습니다 ([구현 Project](https://github.com/ryan-son/wrap-up-ios-open-market/projects/1), [issue board](https://github.com/ryan-son/wrap-up-ios-open-market/issues?q=is%3Aissue+is%3Aclosed)).
- 앱을 사용해보며 사용자 관점에서 필요한 편의성 기능을 구현하고 예상치 못한 버그를 추적하여 수정함으로써 지속적인 유지보수를 하고 있습니다 ([기능 개선 Project](https://github.com/ryan-son/wrap-up-ios-open-market/projects/2), [on-going issue board](https://github.com/ryan-son/wrap-up-ios-open-market/issues), [resolved issue board](https://github.com/ryan-son/wrap-up-ios-open-market/issues?q=is%3Aissue+is%3Aclosed)).
- 지금까지 개선된 사항들은 [여기](#4-구현-완료-후-개선-또는-수정된-사항)에서 간편히 확인하실 수 있습니다.

### Linting tool을 이용한 일관성 있는 코드 품질 유지
일관된 코드 스타일 및 컨벤션을 유지하기 위해 개발 간 SwiftLint를 적용하였습니다.

### MVVM
향후 기능 수정 및 추가가 이루어지더라도 요구한 기능 명세에 따라 동작함을 보장하기 위해 MVVM 아키텍쳐를 적용하여 뷰-로직을 분리 후 각 View Model에 대해 유닛테스트를 수행하였습니다.

### 코드를 통한 레이아웃 구성
각 View 요소가 어떠한 속성을 가지고 초기화되어 있고, auto-layout을 통해 View들 간 어떠한 제약 관계를 가지고 있는지를 명확히 표현하기 위해 스토리보드 대신 코드를 통해 UI를 구성하였습니다.

### 적용된 기술 스택 일람
| Category            | Stacks                                                                   |
|---------------------|--------------------------------------------------------------------------|
| UI                  | - UIKit                                                                  |
| Networking          | - URLSession                                                             |
| Encoding / Decoding | - Codable<br>- JSONEncoder / JSONDecoder<br>- Data (multipart/form-data) |
| Caching             | - NSCache                                                                |
| Test                | - XCTest<br>- Quick<br>- Nimble                                          |

# 2. 기능
## 상품 조회

### Cell styling ([구현 방식 바로가기](#cell-styling-기능으로-돌아가기))
우측 상단의 셀 스타일 변경 버튼을 통해 상품 목록 조회 시 보기 모드를 변경할 수 있습니다.

![image](https://user-images.githubusercontent.com/69730931/132921089-a510ce0c-a5b8-458e-b7ac-a844cc830995.png)

기기 방향에 따라 각 행 당 보여주는 상품의 개수가 달라집니다.

<img src="https://user-images.githubusercontent.com/69730931/132921816-06c9e20f-f39e-4d06-ba73-13389466924f.png" alt="CellStyleByDeviceOrientation" width="630"/>


### Infinite scrolling ([구현 방식 바로가기](#infinite-scrolling-기능으로-돌아가기))
로드된 잔여 상품 개수를 통해 다음 리스트를 불러와 스크롤링을 통해 전체 상품을 조회할 수 있습니다.

![ezgif com-gif-maker (5)](https://user-images.githubusercontent.com/69730931/132920635-94ccfff6-eb8f-4ed9-be91-a1767e73ef90.gif)
![ezgif com-gif-maker (6)](https://user-images.githubusercontent.com/69730931/132920771-0b00629b-610e-45d3-9fe0-e9f873564e02.gif)


### Refreshing ([구현 방식 바로가기](#refreshing-기능으로-돌아가기))
상품 목록 최상단에서 상품 목록을 잡아 당기거나, 우측 상단의 refresh 버튼을 통해 상품 목록을 갱신할 수 있습니다.  

![ezgif com-gif-maker (7)](https://user-images.githubusercontent.com/69730931/132921496-0c8065af-7de3-4776-aecf-12d9c82b2d59.gif)
![ezgif com-gif-maker (8)](https://user-images.githubusercontent.com/69730931/132921656-1a6c4791-943f-4ede-bcfa-65ff2386d229.gif)


### 최초 상품 목록 로드 시 대기 효과 표시 ([구현 방식 바로가기](#최초-상품-목록-로드-시-대기-효과-표시-기능으로-돌아가기))
앱이 최초에 실행되어 상품이 로드될 때까지 대기 효과를 표시합니다.

![ezgif com-gif-maker (9)](https://user-images.githubusercontent.com/69730931/132922068-217ed4b9-a121-4c2b-ab44-c7160ecb69b9.gif)


### Image paging ([구현 방식 바로가기](#image-paging-기능으로-돌아가기))
상품 상세 조회 시 페이징을 통해 여러 이미지를 조회할 수 있습니다.

![ezgif com-gif-maker (10)](https://user-images.githubusercontent.com/69730931/132922364-6036ffe5-314a-4b57-91d1-316b825e3c43.gif)


## 상품 등록
상품 목록 조회 화면 우측 하단의 상품 등록 버튼을 통해 상품을 등록할 수 있습니다.

![image](https://user-images.githubusercontent.com/69730931/132924589-266ac104-51e6-49d2-a246-3388efee4ee0.png)

### 이미지 추가 및 스크롤링을 통한 이미지 확인 ([구현 방식 바로가기](#이미지-추가-및-스크롤링을-통한-이미지-확인-기능으로-돌아가기))
사진첩에서 등록할 사진을 선택할 수 있으며 기존에 등록한 사진을 스크롤링을 통해 확인할 수 있습니다.

![ezgif com-gif-maker (15)](https://user-images.githubusercontent.com/69730931/132925063-96130df3-ae01-49dd-bf3f-d8b24d2fad05.gif)

### 등록한 이미지 삭제 ([구현 방식 바로가기](#등록한-이미지-삭제-기능으로-돌아가기))
등록한 이미지의 우측 상단에 위치한 버튼을 통해 등록한 이미지를 삭제할 수 있습니다.

![ezgif com-gif-maker (16)](https://user-images.githubusercontent.com/69730931/132925383-6f79272a-2604-4d89-aa01-abe18b7af9ca.gif)

### 키보드 프레임을 고려한 레이아웃 설정 ([구현 방식 바로가기](#키보드-프레임을-고려한-레이아웃-설정-기능으로-돌아가기))
입력할 TextView가 키보드에 가리지 않게끔 제약을 조정합니다.

![ezgif com-gif-maker (17)](https://user-images.githubusercontent.com/69730931/132925591-afd22fa4-1d13-49fd-b9b7-e20d89b89056.gif)


## 상품 수정
상품 상세 조회 화면 우측 상단의 더보기 버튼을 통해 상품을 수정할 수 있습니다.

![image](https://user-images.githubusercontent.com/69730931/132924566-7394a438-4d86-47e0-b9d0-418bc6176895.png)


### 상품 수정 후 상품 목록 refreshing ([구현 방식 바로가기](#상품-수정-후-상품-목록-refreshing-기능으로-돌아가기))
상품 수정 후 상품 상세 조회 화면을 벗어나면 상품 목록을 갱신합니다.

![ezgif com-gif-maker (13)](https://user-images.githubusercontent.com/69730931/132923694-f059a85f-9041-4d6f-844f-6c7844d905cc.gif)


## 상품 삭제

### 상품 삭제 후 상품 목록 refreshing ([구현 방식 바로가기](#상품-삭제-후-상품-목록-refreshing-기능으로-돌아가기))
상품 삭제 후에는 확인 버튼 클릭 즉시 상품 상세 조회 화면을 벗어나며 상품 목록을 갱신합니다.

![ezgif com-gif-maker (14)](https://user-images.githubusercontent.com/69730931/132923988-58da7d8b-c897-47c4-83b2-819de72866c1.gif)


# 3. 설계 및 구현

최종적으로 활용되는 타입이 아닌 경우 타입 간의 느슨한 결합을 위해 프로토콜을 통해 추상화하여 의존성 주입이 가능하도록 구성하였습니다. 이를 통해 프로토콜을 통해 요구된 인터페이스를 가진 타입을 설계함으로써 테스트를 수행합니다.

escaping closure를 통해 mutating 인스턴스가 강제되는 경우를 제외하고는 값 타입인 struct를 이용하여 타입을 설계함으로써 ARC를 통한 참조 카운팅을 고려하지 않아도 되도록 구성하였습니다.
![image](https://user-images.githubusercontent.com/69730931/133281772-d2cdfcd1-af56-4568-9858-8dc953ca0e2c.png)


## 상품 조회
![image](https://user-images.githubusercontent.com/69730931/132931082-aba3fb1e-25b3-4d39-92b2-0486a11742f2.png)

![image](https://user-images.githubusercontent.com/69730931/132949446-0114cada-1585-4909-bc3d-6f3252961676.png)

![image](https://user-images.githubusercontent.com/69730931/132949458-d43822e3-5566-48d5-8e39-37c722568899.png)

![image](https://user-images.githubusercontent.com/69730931/132937906-c245ee5f-3423-4411-96f7-491d1140b8a8.png)

### Cell styling ([기능으로 돌아가기](#cell-styling-구현-방식-바로가기))
`UICollectionViewFlowLayoutDelegate` 메서드를 이용해 case별 Item의 사이즈를 달리하는 방식으로 구현하였습니다.

```swift
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch cellStyle {
    case .list:
        return CGSize(width: collectionView.bounds.width, height: Style.listCellHeight)
    case .grid:
        return cellSize(viewWidth: collectionView.bounds.width, viewHeight: collectionView.bounds.height)
    }
}
```

행 당 셀 개수는 `cellSize(viewWidth:viewHeight:)` 메서드를 통해 계산하며, 기기의 방향을 감지하여 행 당 지정된 셀 개수가 화면에 나타나도록 조정합니다. 

```swift
private func cellSize(viewWidth: CGFloat, viewHeight: CGFloat) -> CGSize {
    let itemsPerRow: CGFloat = UIWindow.isLandscape
        ? Style.landscapeGridItemsPerRow
        : Style.portraitGridItemsPerRow
    let widthPadding = Style.gridSectionInset.left * (itemsPerRow + 1)
    let itemsPerColumn: CGFloat = UIWindow.isLandscape
        ? Style.landscapeGridItemsPerColumn
        : Style.portraitGridItemsPerColumn
    let heightPadding = Style.gridSectionInset.top * (itemsPerColumn + 1)

    let cellWidth = (viewWidth - widthPadding) / itemsPerRow
    let cellHeight = (viewHeight - heightPadding) / itemsPerColumn
    return CGSize(width: cellWidth, height: cellHeight)
}
```

셀 스타일 변경은 각 케이스를 toggle하는 메서드를 작동함으로써 수행하고, 케이스 변경에 따라 이미지를 변경합니다.

```swift
private func toggleCellStyle() {
    cellStyle = cellStyle == .list ? .grid : .list
}
```

### Infinite scrolling ([기능으로 돌아가기](#infinite-scrolling-구현-방식-바로가기))

`collectionView(_:willDisplay:forItemAt:)` 메서드를 이용해 잔여 상품 개수가 특정 개수 이하 (10개)가 되면 다음 목록을 요청합니다 (`list()` 메서드).

```swift
func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if viewModel.marketItems.count <= indexPath.item + Style.numberOfLastItemsToTriggerFetch {
        viewModel.list()
    }
}
```

### Refreshing ([기능으로 돌아가기](#refreshing-구현-방식-바로가기))
Refresh는 `MarketItemListViewModel`의 `refresh()` 메서드를 작동시킴으로써 수행합니다. 

viewModel의 refresh는 현재까지 불러온 상품 목록 정보, 페이지 번호, 캐시에 저장된 이미지들을 모두 초기 상태로 초기화하고 다시 상품 목록을 불러옵니다. 

```swift
@objc private func refreshMarketItems() {
    collectionView.refreshControl?.beginRefreshing()
    activityIndicator.startAnimating()
    viewModel.refresh()
}

// viewModel

func refresh() {
    useCase.refresh()
    ThumbnailUseCase.sharedCache.removeAllObjects()
    marketItems.removeAll()
    list()
}
```

Pull-to-refresh 기능은 `viewDidLoad(_:)` 단계에서 각 View들을 set up할 때 refresh control을 collectionView에 추가하는 형식으로 구현되어 있습니다.

```swift
private func setupViews() {
    ...
    collectionView.refreshControl = UIRefreshControl()
    collectionView.refreshControl?.addTarget(self, action: #selector(refreshMarketItems), for: .valueChanged)
}
```

### 최초 상품 목록 로드 시 대기 효과 표시 ([기능으로 돌아가기](#최초-상품-목록-로드-시-대기-효과-표시-구현-방식-바로가기))
최초 앱 실행 시 `MarketItemListViewController`는 `bindWithViewModel()` 데이터 바인딩 메서드를 통해 서버로부터 상품 리스트를 불러왔을 때 collectionView를 리로드하고 refreshControl의 애니메이션 효과를 중지합니다.

```swift
private func bindWithViewModel() {
    viewModel.bind { [weak self] state in
        switch state {
        case .fetched(let indexPaths):
            self?.collectionView.insertItems(at: indexPaths)
            self?.activityIndicator.stopAnimating()
        ...
        }
    }
}
```

### Image paging ([기능으로 돌아가기](#image-paging-구현-방식-바로가기))
서버로부터 이미지를 비동기적으로 불러와 viewModel에 반영되면 viewModel의 상태가 `.fetchImage` 상태로 변경되어 해당 상태에 등록된 viewController의 코드 블럭이 실행됩니다.

```swift
func bind(with viewModel: MarketItemDetailViewModel) {
    self.viewModel = viewModel

    viewModel.bind { [weak self] state in
        switch state {
        ...
        case .fetchImage(let image, let index):
        self?.addImageViewToImageScrollView(image, at: index)
        ...
        }
    }
}
```

viewModel으로부터 전달받은 image를 `imageView`를 통해 추가합니다. 이 때 페이징 지원을 위해 `frame` 조정을 통해 `superView` 내에서의 위치를 잡고, `scrollView`의 contentSize를 조정합니다.

```swift
private func addImageViewToImageScrollView(_ image: UIImage, at index: Int) {
    let imageView = UIImageView()
    let xPosition: CGFloat = view.frame.width * CGFloat(index)
    imageView.frame = CGRect(x: xPosition, y: .zero, width: imageScrollView.bounds.width, height: imageScrollView.bounds.height)
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
    imageView.alpha = .zero
    imageView.accessibilityIdentifier = "itemDetail\(index)"
    imageScrollView.insertSubview(imageView, belowSubview: imageScrollViewPageControl)
    imageScrollView.contentSize.width = imageView.frame.width * CGFloat(index + 1)
    imageViews.append(imageView)

    UIView.animate(withDuration: Style.imageDissolveAnimationTime) {
        imageView.alpha = 1
    }
}
```

`pageControl`의 현재 페이지 설정은 `UIScrollViewDelegate`의 `scrollViewDidScroll(_:)`을 통해 수행합니다.
```swift
extension MarketItemDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.x / scrollView.frame.size.width
        let destinationPage = Int(round(position))
        setPageControlPage(to: destinationPage)
    }
}
```

### 상품 상세 이미지 로딩 및 View 반영
서버에 상품 상세 정보를 요청하면 image가 위치한 인터넷 URL 배열을 반환해줍니다. 이를 통해 비동기적으로 image data를 서버에 요청하는 과정에서 각 작업의 수행 순서 (상세정보 로드 → 이미지 로드)를 보장하기 위해 value가 1인 Semaphore를 적용하였습니다. 이를 구현하는데 `NSLock`을 사용할 수도 있습니다.

```swift
// 상품 상세 조회 화면의 데이터 로드를 위한 메서드 (viewModel)
func fire() {
    let serialQueue = DispatchQueue(label: Style.serialQueueName)
    serialQueue.async {
        self.fetchMarketItemDetail()

        self.semaphore.wait()
        guard let images = self.marketItem?.images else { return }
        self.semaphore.signal()

        for (index, path) in images.enumerated() {
            self.fetchImage(for: index, from: path)
        }
    }
}
```

상품 상세 정보와 이미지를 비동기적으로 불러오는 과정에서 동시다발적으로 데이터를 로드하면 view를 업데이트하기 위한 코드 블럭인 viewModel의 상태가 미처 이전 상태의 코드 블럭이 완료되지 않은 상태에서 변경될 수 있습니다. 이를 방지하기 위해 value가 1인 semaphore를 적용하였습니다. 

```swift
private var state: State = .empty {
    willSet {
        listenerSemaphore.wait()
    }
    didSet {
        DispatchQueue.main.async {
            self.listener?(self.state)
            self.listenerSemaphore.signal()
        }
    }
}

// viewModel의 상태에 따른 view 업데이트 로직의 일부

func bind(with viewModel: MarketItemDetailViewModel) {
    self.viewModel = viewModel

    viewModel.bind { [weak self] state in
        switch state {
        case .fetch(let metaData):
            self?.setPageControlNumberOfPages(to: metaData.numberOfImages)
            self?.titleLabel.text = metaData.title
            self?.stockLabel.text = metaData.stock
            self?.stockLabel.textColor = metaData.stock == Style.outOfStockString ? Style.outOfStockLabelColor : self?.stockLabel.textColor
            self?.discountedPriceLabel.attributedText = metaData.discountedPrice
            self?.priceLabel.text = metaData.price
            self?.bodyTextLabel.text = metaData.descriptions
        case .fetchImage(let image, let index):
            self?.addImageViewToImageScrollView(image, at: index)
        ...
        }
    }
}
```


## 상품 등록
![image](https://user-images.githubusercontent.com/69730931/132903453-2159699a-25c5-43b5-88f1-0cfff26f9d07.png)

![image](https://user-images.githubusercontent.com/69730931/132938526-070945c3-1e15-4057-96dd-dcd3841b466c.png)

### 이미지 추가 및 스크롤링을 통한 이미지 확인 ([기능으로 돌아가기](#이미지-추가-및-스크롤링을-통한-이미지-확인-구현-방식-바로가기))
이미지를 추가하는 영역은 [UICollectionView](https://github.com/ryan-son/wrap-up-ios-open-market/blob/main/OpenMarket/OpenMarket/Sources/Views/MarketItemRegisterView/MarketItemRegisterViewController%2BDelegates.swift)로 구현되어있으며, 첫번째 셀은 [AddPhotoCollectionViewCell](https://github.com/ryan-son/wrap-up-ios-open-market/blob/main/OpenMarket/OpenMarket/Sources/Views/MarketItemRegisterView/Components/AddPhotoCollectionViewCell/AddPhotoCollectionViewCell.swift), 이후 추가되는 이미지들은 [PhotoCollectionViewCell](https://github.com/ryan-son/wrap-up-ios-open-market/blob/main/OpenMarket/OpenMarket/Sources/Views/MarketItemRegisterView/Components/PhotoCollectionViewCell/PhotoCollectionViewCell.swift)로 구현되어 있습니다. 이미지를 사진첩에서 가져오는 기능은 `UIImagePickerController`를 구현한 [RegisterImagePicker](https://github.com/ryan-son/wrap-up-ios-open-market/blob/main/OpenMarket/OpenMarket/Sources/Views/MarketItemRegisterView/Components/RegisterImagePicker.swift)을 통해 수행하고 있습니다.

### 등록한 이미지 삭제 ([기능으로 돌아가기](#등록한-이미지-삭제-구현-방식-바로가기))
`collectionView(_:cellForItemAt:)` 메서드에서 `PhotoCollectionViewCell`을 dequeue할 때 삭제 버튼에 대해 target을 설정함으로써 이미지 삭제를 수행합니다.

```swift
...
guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath)
        as? PhotoCollectionViewCell else { return UICollectionViewCell() }

photoCell.addDeleteButtonTarget(target: self, action: #selector(removePhoto(_:)), for: .touchUpInside)
...
```

### 키보드 프레임을 고려한 레이아웃 설정 ([기능으로 돌아가기](#키보드-프레임을-고려한-레이아웃-설정-구현-방식-바로가기))
키보드가 나타날 때 `NotificationCenter`를 통해 전달되는 Notification을 통해 `keyboardWillShow`, `keyboardWillHide` 이벤트에 대응합니다. 키보드가 나타날 때는 스크롤뷰의 `contentInset`을 추가하며 스크롤뷰의 하단 제약을 조정하고, 사라질 때는 추가한 `contentInset`과 하단 제약을 기존 상태로 되돌립니다.

```swift
@objc private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    contentScrollView.contentInset.bottom = keyboardFrame.height / 2
    contentScrollViewBottomAnchor?.constant = -keyboardFrame.height

    guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
    UIView.animate(withDuration: duration) {
        self.view.layoutIfNeeded()
    }
}

@objc private func keyboardWillHide(_ notification: Notification) {
    let contentInset: UIEdgeInsets = .zero
    contentScrollView.contentInset = contentInset
    contentScrollView.scrollIndicatorInsets = contentInset
    contentScrollViewBottomAnchor?.constant = .zero

    guard let userInfo = notification.userInfo,
          let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
    UIView.animate(withDuration: duration) {
        self.view.layoutIfNeeded()
    }
}
```

## 상품 수정
![image](https://user-images.githubusercontent.com/69730931/132903714-edaf5ccb-104c-4921-b5fa-ed28a6e7d9b7.png)

### 상품 수정 후 상품 목록 refreshing ([기능으로 돌아가기](#상품-수정-후-상품-목록-refreshing-구현-방식-바로가기))
상품이 수정되면 상품 리스트를 서버로부터 다시 받아와야 합니다. 이를 판별하기 위해 `MarketItemDetailViewController`는 `isUpdated`라는 Bool 타입의 변수를 가지고 있으며, 이는 상품이 수정되었을 때 상태가 `true`로 변경됩니다. 이 경우 `back` 버튼을 통해 상품 목록으로 이동하면 아래의 `backButtonDidTapped()` 메서드가 실행되어 상품 정보를 서버로부터 다시 받아오게 됩니다.

```swift
@objc private func backButtonDidTapped() {
    if isUpdated {
        delegate?.didChangeMarketItem()
    }
    navigationController?.popViewController(animated: true)
}
```


## 상품 삭제
![image](https://user-images.githubusercontent.com/69730931/132903777-5027c0e7-3442-46fd-8b11-679e3e80f86a.png)

### 상품 삭제 후 상품 목록 refreshing ([기능으로 돌아가기](#상품-삭제-후-상품-목록-refreshing-구현-방식-바로가기))
상품 수정의 경우와 유사한 로직으로, 상품의 삭제가 완료되면 viewModel의 `marketItem`이 새로 할당되며 viewModel의 상태가 `.delete`로 변경되며 바인딩된 아래의 코드블럭이 실행됩니다.

```swift
func bind(with viewModel: MarketItemDetailViewModel) {
    self.viewModel = viewModel

    viewModel.bind { [weak self] state in
        switch state {
        ...
        case .delete:
            self?.presentSuccessfullyDeletedAlert()
        ...
    }
}
```

바인딩된 메서드는 상품이 성공적으로 삭제되었다는 알림을 나타내며 확인을 선택하면 `delegate`를 통해 `didChangeMarketItem()`메서드를 호출하여 상품 목록을 갱신합니다.
```swift
private func presentSuccessfullyDeletedAlert() {
    let alert = UIAlertController(title: Style.Alert.marketItemDeletedTitle, message: nil, preferredStyle: .alert)
    let okAction = UIAlertAction(title: Style.Alert.okActionTitle, style: .default) { _ in
        self.navigationController?.popViewController(animated: true)
        self.delegate?.didChangeMarketItem()
    }
    alert.addAction(okAction)
    present(alert, animated: true)
}

// MARK: - MarketItemDetailViewControllerDelegate

extension MarketItemListViewController: MarketItemDetailViewControllerDelegate {

    func didChangeMarketItem() {
        refreshMarketItems()
    }
}
```

# 4. 구현 완료 후 개선 또는 수정된 사항

## 등록한 상품으로 바로 이동 ([Issue #16](https://github.com/ryan-son/wrap-up-ios-open-market/issues/16))
상품 등록 후 등록한 상품의 상세 조회 화면으로 바로 이동합니다.

![ezgif com-gif-maker (18)](https://user-images.githubusercontent.com/69730931/132926309-a8172dd2-e818-4173-96f4-a5def0a4a57b.gif)

### 구현
상품 등록이 완료되면 등록 완료 응답으로 서버로부터 등록된 상품 정보를 반환 받습니다. 이를 통해 viewModel의 상태가 `.register` 케이스로 변경되어 view가 등록된 상황에 맞는 코드 블럭을 실행할 수 있는 기회를 가집니다.
```swift
func bind(with viewModel: MarketItemRegisterViewModel) {
    self.viewModel = viewModel

    viewModel.bind { [weak self] state in
        switch state {
        ...
        case .register(let marketItem):
            self?.pushToRegisteredPost(with: marketItem)
            self?.activityIndicator.stopAnimating()
        ...
        }
    }
}

private func pushToRegisteredPost(with marketItem: MarketItem) {
    navigationController?.popViewController(animated: false)
    delegate?.didEndEditing(with: marketItem)
}
```

이후 기존화면을 pop 시키며 상품 목록 화면으로 잠시 이동한 후 `MarketItemRegisterViewControllerDelegate` 타입인 `delegate`를 통해 등록한 상품의 상세화면으로 이동하게끔 만들어주는 `didEndEditing(with:)` 메서드를 실행하여 등록한 상품 상세 화면으로 이동합니다.

```swift
extension MarketItemListViewController: MarketItemRegisterViewControllerDelegate {

    func didEndEditing(with marketItem: MarketItem) {
	let marketItemDetailViewModel = MarketItemDetailViewModel(marketItemID: marketItem.id)
	let marketItemDetailViewController = MarketItemDetailViewController()
	marketItemDetailViewController.delegate = self
	marketItemDetailViewController.bind(with: marketItemDetailViewModel)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.pushViewController(marketItemDetailViewController, animated: true)
            marketItemDetailViewModel.fire()
        }
    }
}
```

## 수정한 상품으로 바로 이동 ([Issue #16](https://github.com/ryan-son/wrap-up-ios-open-market/issues/16))
상품 수정 후 수정된 상품을 기존 화면에 바로 업데이트하여 보여줍니다.

![ezgif com-gif-maker (12)](https://user-images.githubusercontent.com/69730931/132923545-26908bbd-c239-49ee-91f7-1e22776c7810.gif)

### 구현
상품 등록 섹션의 '등록한 상품 바로 보기' 기능과 마찬가지로 상품이 수정되어 viewModel에 수정된 상품 정보가 할당되면 viewModel이 `.updated` 상태로 변화되어 이에 적합하게 view가 업데이트 될 수 있는 코드 블럭이 실행됩니다.

```swift
func bind(with viewModel: MarketItemRegisterViewModel) {
    self.viewModel = viewModel

    viewModel.bind { [weak self] state in
        switch state {
        ...
        case .update(let marketItem):
            self?.popToUpdatedPost(with: marketItem)
        ...
        }
    }
}
```

이후 `delegate`를 통해 `didEndEditing(with:)` 메서드가 실행되어 수정된 상품 화면으로 이동합니다.

```swift
private func popToUpdatedPost(with marketItem: MarketItem) {
    navigationController?.popViewController(animated: false)
    delegate?.didEndEditing(with: marketItem)
}
```


## 상품 수정 시 기존 게시글의 내용 확인 및 금번에 수정한 내용을 구분할 수 있게끔 화면 구성 ([Issue #17](https://github.com/ryan-son/wrap-up-ios-open-market/issues/17))
금번에 수정한 사항을 강조하여 표시함으로써 계획한 변경사항을 모두 반영할 수 있도록 편의성을 제공합니다. 

<img src="https://user-images.githubusercontent.com/69730931/133865304-d271da8d-6fb7-43f3-8755-ae1cce27e0df.png" alt="text-color-before-editing" width="270"/>

### 구현
`UITextViewDelegate` 메서드인 `textViewDidBeginEditing(_:)`을 이용하여 변경이 일어나기 전에는 placeholder text 색상으로 표현하게끔 구성합니다.

```swift
// MARK: - UITextViewDelegate

extension PlaceholderTextView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        text = text == placeholderText ? "" : text
        textColor = Style.textColor
    }
}
```

## 상품 수정 시 비밀번호를 아는 이용자만 수정 화면으로 진입할 수 있도록 구성 ([Issue #18](https://github.com/ryan-son/wrap-up-ios-open-market/issues/18))

상품 수정 시 비밀번호를 먼저 입력하고 수정화면으로 진입합니다. 올바르지 않은 비밀번호를 입력한 경우에는 재시도 또는 취소를 선택할 수 있습니다.

- 도입 목적
  + 현재는 서버에 수정할 사항들과 함께 비밀번호를 PATCH 방식으로 요청하면 비밀번호가 맞고 틀림에 따라 성공, 실패가 정해져 권한을 가지지 않은 사용자가 게시물의 수정 기능에 접근할 수 있음.
  + 게시물 작성자가 접근했다고 하더라도 비밀번호를 모를 경우 반영되지 못할 수정 작업을 하는 등 불필요한 낭비가 이루어질 수 있음.

![ezgif com-gif-maker (11)](https://user-images.githubusercontent.com/69730931/132923242-2d7f2fa6-47b0-4f2b-8530-432cebb6f478.gif)

### 구현
상품 수정을 위해서는 수정 사항과 함께 multipart/form-data 형식으로 password를 전송하여야 합니다. alert을 통해 password를 미리 입력 받아 서버에 PATCH 메서드를 통해 password 검증을 수행하여 password를 알지 못하면 수정화면으로 진입할 수 없도록하는 기능을 제공합니다.

```swift
func verifyPassword(
    itemID: Int,
    password: String,
    completion: @escaping ((Result<MarketItem, MarketItemDetailUseCaseError>) -> Void)
) {
    let path = EndPoint.item(id: itemID).path
    let marketItem = PatchMarketItem(title: nil, descriptions: nil, price: nil, currency: nil, stock: nil, discountedPrice: nil, images: nil, password: password)

    networkManager.multipartUpload(marketItem, to: path, method: .patch) { result in
        switch result {
        case .success(let data):
            do {
                let marketItem = try decoder.decode(MarketItem.self, from: data)
                completion(.success((marketItem)))
            } catch {
                completion(.failure(.unknown(error)))
            }
        case .failure(let error):
            completion(.failure(.networkError(error)))
        }
    }
}
```

## 상품 목록 화면 스크롤링 사용자 경험 향상 (Issue #19)
이미지 로딩 취소, caching, prefetching 기술을 이용해 프로세싱, 네트워킹에 필요한 제한된 리소스를 최대한 균일하게 사용할 수 있도록 구성하여 프레임 드랍을 최대한 억제함으로써 사용자의 스크롤링 경험을 향상합니다.

### 이미지 로드 취소
CollectionViewCell이 재사용되는 과정에서 재사용되기 전의 이미지 로드 작업이 완료되지 않았다면 해당 `URLSessionDataTask`를 취소합니다. 이 작업은 재사용큐에 등록된 셀이 로드되기 전에 호출되는 메서드인 `prepareForReuse()`에서 수행됩니다.

```swift
override func prepareForReuse() {
    super.prepareForReuse()
    reset()
}

private func reset() {
    viewModel?.cancelThumbnailRequest()
    thumbnailImageView.image = nil
    titleLabel.text = nil
    stockLabel.text = nil
    discountedPriceLabel.attributedText = nil
    priceLabel.text = nil
}
```

### 이미지 caching
서버에 한 번 요청한 이미지를 재요청하지 않고 캐시에서 가져옴으로써 서버 부담을 줄이고 사용자의 스크롤링 경험을 향상합니다.
캐싱은 오직 메모리에서만 수행하여 앱이 과도한 메모리를 사용하지 않도록 합니다.

```swift
func fetchThumbnail(from path: String, completion: @escaping (Result<UIImage?, ThumbnailUseCaseError>) -> Void) -> URLSessionDataTask? {
    guard let cacheKey = NSURL(string: path) else {
        completion(.failure(.emptyPath))
        return nil
    }

    if let cachedThumbnail = ThumbnailUseCase.sharedCache.object(forKey: cacheKey) {
        completion(.success(cachedThumbnail))
        return nil
    }

    let task = networkManager.fetch(from: path) { result in
        switch result {
        case .success(let data):
            guard let thumbnail = UIImage(data: data) else {
                completion(.failure(.emptyData))
                return
            }
            completion(.success(thumbnail))
            ThumbnailUseCase.sharedCache.setObject(thumbnail, forKey: cacheKey)
        case .failure(let error):
            completion(.failure(.networkError(error)))
        }
    }
    task?.resume()
    return task
}
```


### 이미지 prefetch
사용자의 스크롤링 경험 향상을 위해 이미지 요청 작업을 미리 수행합니다.

```swift
extension MarketItemListViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            DispatchQueue.global(qos: .utility).async {
                let marketItem = self.viewModel.marketItems[indexPath.item]
                let marketItemCellViewModel = MarketItemCellViewModel(marketItem: marketItem)
                marketItemCellViewModel.prefetchThumbnail()
            }
        }
    }
}
```


# 5. 유닛 테스트 및 UI 테스트

테스트는 Behavior-Driven Development (BDD)과 Matcher 프레임워크인 [Quick](https://github.com/Quick/Quick)과 [Nimble](https://github.com/Quick/Nimble)을 이용하여 수행하였습니다.

- `Quick`을 이용하면 `XCTest` 프레임워크에서 제목 또는 주석을 이용하여 Given-When-Then의 흐름 구분을 하던 방식을 describe-context-it의 흐름으로 충분히 표현할 수 있고, `XCTest`의 `setUpWithError()`, `tearDownWithError()`와 같이 매 테스트 케이스 전후로 이루어지는 초기화 작업을 `beforeEach(_:)`, `afterEach(_:)` 메서드로 수행할 수 있습니다.
- 반면 `Quick`을 사용하며 불편했던 점은 describe-when-it의 흐름으로 잘 구분되어 있지만 `beforeEach(_:)`와 `afterEach(_:)`가 매 검증 메서드인 `it(_:)` 전후로만 실행된다는 점이었습니다. 테스트 상황에 따라 테스트 대상인 `System-Under-Test (SUT)`이 다른 조건으로 주어져야 할 경우가 있는데, 이 경우에는 어쩔 수 없이 검증 메서드인 `it(_:)`에 given-when-then의 상황을 제공하여야 했습니다.
- `Nimble`은 `XCTest` 프레임워크에서 `XCTAssertEqual(_:)`, `XCTAssertTrue(_:)` 등으로 빈약하게 주어졌던 matcher를 Nimble의 `expect(_:)`, `to(_:)`, `equal(_:)` 등의 메서드와 조합하여 사용함으로써 예상하는 바를 명확하게 표현할 수 있게 해줍니다. 추가로 `XCTest` 프레임워크에서 비동기적으로 동작하는 메서드를 검증하고자 할 때 expectation을 정의하고 `fulfill()`을 통해 만족 상황을 별도로 정의해주었던 불편함을 `toEventually(_:)`, `toNotEventually(_:)`를 정의하여 사용함으로써 해소하고 있습니다.

## 필자가 테스트를 하는 이유

제가 유닛 테스트를 수행하는 이유는 주변 코드가 끊임 없이 변경되는 상황에서도 작성한 테스트 케이스를 바탕으로 '주어진 명세'를 만족하는지 여부를 지속적으로 추적할 수 있고, 타 타입 또는 메서드가 의존하는, '나도 내 코드를 믿지 못하는 상황'에서 '내가 작성한 코드가 믿을만한가'를 검증할 수 있기 때문입니다. Test 시 Code Coverage를 목표로 작성한 테스트는 요구 기능 명세보다 코드 검증 여부에 중점을 두고 있어 코드 변경 시 테스트도 함께 변경하게 되어 손실이 클 수 있지만, 요구 기능 명세를 바탕으로 한 테스트는 이러한 변화에 강하여 개발 공수 등의 자원 손실을 최소화할 수 있기 때문입니다. Quick과 같은 BDD 프레임워크를 사용한 이유도 행동 기반으로 명세를 정의하여 변경에 강한 테스트 케이스를 만들고 싶었기 때문입니다.


## 유닛 테스트

네트워킹 등 앱의 핵심 로직을 구성하는 15개의 타입의 유닛 테스트를 62개의 명세를 통해 검증하였습니다. 타 타입에 대한 의존성이 있는 타입의 경우에는 Mock, Stub, Spy 등의 Test Double을 작성하여 의존성을 제거한 상태로 독립적인 기능 테스트가 가능하도록 구성하였습니다. 로직을 대상으로 한 유닛 테스트의 Code Coverage는 46%이며 예시는 아래와 같습니다.

![image](https://user-images.githubusercontent.com/69730931/132947541-96c0393d-bfd0-4cd0-9385-39d96f2cda1f.png)
<img src="https://user-images.githubusercontent.com/69730931/132947650-6583735f-e7c2-4064-93de-772e75ef104f.png" alt="marketItemRegisterView" width="270"/>

```swift
// NetworkManager 테스트 케이스 중 일부 발췌. sut은 NetworkManager를 의미함.

describe("multipartUpload post") {
    let postMarketItem: PostMarketItem = TestAssets.Dummies.postMarketItem
    
    context("지정된 path에 PostMarketItem 인스턴스를 전달하면") {
        let path = EndPoint.uploadItem.path

        it("등록된 상품이 MarketItem json 형태로 반환된다") {
            let expected: Data = TestAssets.Expected.postMarketItemData
            let expectedEncodeCallCount: Int = 1
            self.setLoadingHandler(shouldSuccessNetwork: true, expected)

            sut.multipartUpload(postMarketItem, to: path, method: .post) { result in
                switch result {
                case .success(let data):
                    expect(data).to(equal(expected))
                case .failure(let error):
                    XCTFail("응답이 예상과 다릅니다. Error: \(error)")
                }
            }
            expect(spyMultipartFormData.encodeCallCount).to(equal(expectedEncodeCallCount))
            expect(spyMultipartFormData.body).to(beEmpty())
        }

        it("통신에 실패하면 Result 타입으로 래핑된 NetworkManagerError를 반환한다") {
            let failedInput = TestAssets.Expected.postMarketItemData
            self.setLoadingHandler(shouldSuccessNetwork: false, failedInput)
            let expected: NetworkManagerError = TestAssets.Expected.Post.error

            sut.multipartUpload(postMarketItem, to: path, method: .post) { result in
                switch result {
                case .success:
                    XCTFail("응답이 예상과 다릅니다.")
                case .failure(let error):
                    expect(error).to(equal(expected))
                }
            }
            expect(spyMultipartFormData.body).to(beEmpty())
        }
    }
}
```

### 네트워크에 의존하지 않는 테스트 구현
본 프로젝트의 유닛 테스트에서 한 가지 강조할 수 있는 부분은 `MockURLProtocol`을 정의하여 의도적인 응답을 설정할 수 있게 만듦으로써 네트워크 가용 여부와 무관한 테스트를 구현했다는 것입니다. 이 방식은 [WWDC18 - Testing tips & tricks](https://developer.apple.com/videos/play/wwdc2018/417/)에서 소개된 방식으로 Request를 처리하는 `URLSessionConfiguration`의 프로퍼티인 `protocolClasses`에 커스텀 프로토콜을 주입함으로써 의도된 방식으로 request에 응답하는 `URLSessionConfiguration`을 만들고, 이를 `URLSession(configuration:)` 이니셜라이저를 통해 주입함으로써 구현합니다.

본 프로젝트에서 정의하여 사용한 [MockURLProtocol](https://github.com/ryan-son/wrap-up-ios-open-market/blob/main/OpenMarket/OpenMarketTests/Helpers/TestDoubles/MockURLProtocol.swift)과 이를 이용한 [유닛 테스트](https://github.com/ryan-son/wrap-up-ios-open-market/blob/main/OpenMarket/OpenMarketTests/Networking/NetworkManagerSpec.swift)는 각 링크를 통해 확인하실 수 있습니다.

## UI 테스트
의도한 흐름으로 각 View별 앱 사용 시나리오를 정의하여 UI 테스트를 수행하였으며, 주로 View 단의 코드를 검증할 수 있었습니다. 총 3 개의 뷰에 대해 21 개의 테스트 케이스 또는 사용 시나리오를 정의하여 테스트를 수행하였으며 Test를 통한 Code Coverage는 93.8%입니다.

<img src="https://user-images.githubusercontent.com/69730931/132947994-8d120936-dae0-4b49-8227-9869f8ef5e69.png" alt="marketItemRegisterView" width="500"/>
<img src="https://user-images.githubusercontent.com/69730931/132948009-65268ab9-ce0b-4327-97f6-07448eae8492.png" alt="marketItemRegisterView" width="270"/>

```swift
// 상품 셀을 탭하면 상세 페이지로 전환되는지 검증하는 UI 테스트

describe("상품 셀") {
    context("list cell tap") {
        it("상품 상세 페이지로 이동한다") {
            let marketItemListCollectionView = app.collectionViews["marketItemList"]
            let cell = marketItemListCollectionView
                .children(matching: .cell)
                .matching(identifier: "listMarketItem")
                .element(boundBy: .zero)
            guard cell.waitForExistence(timeout: 3) else {
                throw XCTSkip("등록된 상품이 없습니다")
            }

            cell.tap()

            let itemDetailNavigationBar = app.navigationBars["Item Detail"]
            expect(itemDetailNavigationBar.exists).to(beTrue())
        }
    }

    context("grid cell tap") {
        it("상품 상세 페이지로 이동한다") {
            let marketItemListCollectionView = app.collectionViews["marketItemList"]
            let cell = marketItemListCollectionView
                .children(matching: .cell)
                .matching(identifier: "listMarketItem")
                .element(boundBy: .zero)
            guard cell.waitForExistence(timeout: 3) else {
                throw XCTSkip("등록된 상품이 없습니다")
            }

            let ryanMarketNavigationBar = app.navigationBars["Ryan Market"]
            let changeCellStyleButton = ryanMarketNavigationBar.buttons["changeCellStyle"]
            changeCellStyleButton.tap()

            let gridCell = marketItemListCollectionView
                .children(matching: .cell)
                .matching(identifier: "gridMarketItem")
                .element(boundBy: .zero)
            gridCell.tap()

            let itemDetailNavigationBar = app.navigationBars["Item Detail"]
            expect(itemDetailNavigationBar.exists).to(beTrue())
        }
    }
}
```

# 6. Trouble shooting
## 상품 상세 조회 화면 이미지 로드 시 비동기 동작으로 인해 이미지가 로드되지 않는 문제
서버에 GET 요청으로 상세 정보를 요청하면 JSON은 아래와 같이 상품 상세 정보를 제공합니다. 주목해야할 부분은 `images`로, 이미지가 위치한 인터넷 URL을 반환합니다.

```json
{
  "registration_date": 1620634155.476605,
  "stock": 1500000000,
  "id": 49,
  "descriptions": "MagSafe 충전기를 사용하면 무선 충전이 더욱 간편해집니다.\n완벽하게 정렬된 자석이 iPhone 12 또는 iPhone 12 Pro에 딱 들어맞아 최대 15W 출력으로 더욱 빠른 무선 충전을 제공하죠.",
  "currency": "KRW",
  "images": [
    "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/2B42F97E-96F4-4778-B8A5-826C4E44D670.png",
    "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/486BE1B1-7C3C-4F8D-8B11-2AECB3F759BC.png",
    "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/C2C14AA2-A6EF-4934-B71E-D12FC1E79C9B.png",
    "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/C8FFC8BF-C991-476B-8208-A068DF27254F.png"
  ],
  "price": 55000,
  "title": "MagSafe 충전기"
}
```

그렇다면 이미지를 `Data` 형태로 받아오기 위해서는 이미지가 위치한 인터넷 URL에 다시 GET 요청을 보내야 합니다. 문제는 여기서 발생합니다. 상품 상세정보를 불러오는 `URLSessionDataTask`와 이미지를 불러오는 `URLSessionDataTask`가 각각 비동기적으로 동작하기 때문에 별도의 동작 제어를 하지 않는 이상 이미지를 불러오는 task는 아직 상품 상세 정보 요청에 대한 응답을 받기 전, 이미지 URL들을 서버로부터 받지 못한 상태에서 task를 실행하게 됩니다.

```swift
// 상품 상세정보 및 이미지 불러오기를 동작하게 하는 메서드

func fire() {
    fetchMarketItemDetail() // 아직 서버로부터 response를 받지 않음 (이미지 URL 없음)

    // fetchMarketItemDetail()의 결과가 marketItem 프로퍼티에 반영되지 않았으므로 `marketItem == nil` 상태임
    guard let images = marketItem?.images else { return } 

    // `marketItem == nil` 이었으므로 아래는 실행되지 않고 위의 코드에서 early exit함
    for (index, path) in images.enumerated() {
        fetchImage(for: index, from: path)
    }
}
```

이를 해결하기 위해서는 `fetchMarketItemDetail()`이 실행되고 서버로부터 response를 받아 해당 내용이 디코딩되어 `marketItem` 프로퍼티에 반영된 후 `marketItem?.images`에 접근하여 URL들을 받아와 각각 서버에 이미지 요청을 하여야 합니다.

이 때 적용할 수 있는 쉬운 방법으로 `NSLock`과 `DispatchSemaphore`가 있습니다. 둘 모두 수행할 작업에 대한 컨트롤을 할 수 있지만, semaphore는 동시에 처리할 작업의 수를 `value`를 통해 지정할 수 있습니다.

```swift
private let semaphore = DispatchSemaphore(value: 1)
```

저는 상품 상세 정보를 받아오는 작업을 먼저 수행 한 후 이미지 요청 작업을 수행하려 하니 상품 상세정보 시작시 semaphore의 상태를 `wait()`, 서버로부터 응답을 받아 completion handler가 실행될 때 다음 작업을 수행할 수 있도록 `signal()`으로 표시했습니다.

```swift
private func fetchMarketItemDetail() {
    semaphore.wait()
    itemDetailTask = useCase.fetchMarketItemDetail(itemID: marketItemID) { [weak self] result in
        self?.semaphore.signal()
        switch result {
        case .success(let marketItem):
            self?.marketItem = marketItem
            guard let metaData = self?.setupMetaData(with: marketItem) else { return }
            self?.state = .fetch(metaData)
        case .failure(let error):
            self?.state = .error(error)
        }
    }
}
```

이제 이미지를 받아오는 작업도 semaphore의 영향을 받을 수 있게끔 전후로 semaphore의 상태를 제어해주고, 이 비용이 큰 작업들이 별도의 queue에서 처리되어 결과만 받아올 수 있게끔 queue를 구성했습니다.

```swift
func fire() {
    let serialQueue = DispatchQueue(label: Style.serialQueueName)
    serialQueue.async {
        self.fetchMarketItemDetail()

        self.semaphore.wait()
        guard let images = self.marketItem?.images else { return }
        self.semaphore.signal()

        for (index, path) in images.enumerated() {
            self.fetchImage(for: index, from: path)
        }
    }
}
```

이제 또 한가지 중요한 점은 이미지도 URL 배열 순으로 로드해야한다는 것입니다. 따라서 순서를 지켜주기 위해 이미지를 가져오는 작업에도 semaphore를 적용합니다.

```swift
private func fetchImage(for index: Int, from path: String) {
    semaphore.wait()
    let imageTask = useCase.fetchImage(from: path) { [weak self] result in
        self?.semaphore.signal()
        switch result {
        case .success(let image):
            self?.images.append(image)
            self?.state = .fetchImage(image, index)
        case .failure(let error):
            self?.state = .error(.networkError(error))
        }
    }
    detailImageTasks.append(imageTask)
}
```

마지막으로 서버로부터 받아온 데이터들을 view에 반영할 때 view 동기화 작업을 위해 반드시 main queue에서 UI 작업을 수행하여야 합니다. 이 때 viewModel이 UI를 업데이트 하는 작업을 호출하는 과정에서 기존 작업이 미처 끝나지 않은 상태에서 다른 상태로 덮어씌워질 수 있습니다. 이를 제어하기 위해 main queue의 UI 업데이트 작업을 위한 semaphore를 별도로 정의하여 적용합니다.

```swift
private let listenerSemaphore = DispatchSemaphore(value: 1)

// viewModel의 view를 업데이트하기 위한 상태. listener 클로저를 통해 변경된 상태에 적합한 view 업데이트를 수행한다.
private var state: State = .empty {
    willSet {
        listenerSemaphore.wait()
    }
    didSet {
        DispatchQueue.main.async {
            self.listener?(self.state)
            self.listenerSemaphore.signal()
        }
    }
}
```

이제 비동기 작업으로 인한 문제가 해결되었습니다.


## 상품 등록 또는 수정 후 즉시 게시글 조회 시 서버 업로드 시간으로 인해 이미지가 보이지 않던 문제
이미지 파일이 가볍지 않은 만큼 서버에 등록되기까지 시간이 필요하여 발생했던 문제입니다. 서버에 등록 요청을 보내고 이에 바로 접근하려하면 서버가 `404 Not Found` 응답을 반환합니다.

`asyncAfter`를 통해 등록 또는 수정된 상품에의 접근을 의도적으로 늦춤으로써 이러한 상황을 방지하였습니다.

아래와 같은 방식으로 이미지가 서버에 등록되는 동안 의도적으로 시간을 지연시킵니다.

```swift
extension MarketItemListViewController: MarketItemRegisterViewControllerDelegate {

    func didEndEditing(with marketItem: MarketItem) {
	let marketItemDetailViewModel = MarketItemDetailViewModel(marketItemID: marketItem.id)
	let marketItemDetailViewController = MarketItemDetailViewController()
	marketItemDetailViewController.delegate = self
	marketItemDetailViewController.bind(with: marketItemDetailViewModel)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.pushViewController(marketItemDetailViewController, animated: true)
            marketItemDetailViewModel.fire()
        }
    }
}
```

## 상품 등록 또는 수정 시 textView가 firstResponder일 때 완료 버튼을 누르면 내용이 반영되지 않는 문제
최초 상품 등록 화면을 구현할 때 `UITextViewDelegate`의 `textViewDidEndEditing(_:)` API를 통해 textView의 내용을 viewModel에 반영하였습니다. 하지만 해당 API는 textView를 탭하여 수정한 이후 `firstResponder`에서 해제될 때 호출되기 때문에 상품 등록버튼을 누르기 전 반드시 textView를 firstResponder에서 해제해야한다는 번거로움이 있었습니다. 저는 이 작동양식이 사용자가 예상하는 앱의 동작과 다르다고 판단하여 textView에 수정사항이 발생할 때마다 viewModel에 변경 내용이 반영될 수 있게끔 `textViewDidChange(_:)` API로 변경하여 문제를 해결하였습니다.

```swift
func textViewDidChange(_ textView: UITextView) {
    placeholderTextViewDelegate?.didFillTextView(category: type, with: text)
}

// delegate 메서드
extension MarketItemRegisterViewController: PlaceholderTextViewDelegate {

    func didFillTextView(category: PlaceholderTextView.TextViewType, with text: String) {
	viewModel?.setMarketItemInfo(of: category, with: text)
    }
}
```
