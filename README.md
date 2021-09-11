# Ryan Market
REST API와의 연동을 통해 상품 리스트 / 상세 조회, 등록, 수정 및 삭제가 가능하도록 구현한 앱

# Table of Contents
1. 프로젝트 개요
2. 기능
3. 설계 및 구현
4. 유닛 테스트 및 UI 테스트
5. Trouble shooting
6. 학습 내용

---

<img src="https://user-images.githubusercontent.com/69730931/132734214-96675a31-78d9-43e5-8830-e8a84cbd0e39.gif" alt="marketItemListView" width="270"/>  <img src="https://user-images.githubusercontent.com/69730931/132735322-88e41e0e-44e1-4410-82f3-5525a6be34a0.gif" alt="marketItemDetailView" width="270"/>  <img src="https://user-images.githubusercontent.com/69730931/132742366-8713888c-4927-4553-acdb-99cb5b818e18.gif" alt="marketItemRegisterView" width="270"/>

---

# 1. 프로젝트 개요
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

### Cell styling ([구현 방식 바로가기](https://github.com/ryan-son/wrap-up-ios-open-market#cell-styling-1))
우측 상단의 셀 스타일 변경 버튼을 통해 상품 목록 조회 시 보기 모드를 변경할 수 있습니다.

![image](https://user-images.githubusercontent.com/69730931/132921089-a510ce0c-a5b8-458e-b7ac-a844cc830995.png)

기기 방향에 따라 각 행 당 보여주는 상품의 개수가 달라집니다.

<img src="https://user-images.githubusercontent.com/69730931/132921816-06c9e20f-f39e-4d06-ba73-13389466924f.png" alt="CellStyleByDeviceOrientation" width="630"/>


### Infinite scrolling ([구현 방식 바로가기](https://github.com/ryan-son/wrap-up-ios-open-market#infinite-scrolling-1))
로드된 잔여 상품 개수를 통해 다음 리스트를 불러와 스크롤링을 통해 전체 상품을 조회할 수 있습니다.

![ezgif com-gif-maker (5)](https://user-images.githubusercontent.com/69730931/132920635-94ccfff6-eb8f-4ed9-be91-a1767e73ef90.gif)
![ezgif com-gif-maker (6)](https://user-images.githubusercontent.com/69730931/132920771-0b00629b-610e-45d3-9fe0-e9f873564e02.gif)


### Refreshing ([구현 방식 바로가기](https://github.com/ryan-son/wrap-up-ios-open-market#refreshing-1))
상품 목록 최상단에서 상품 목록을 잡아 당기거나, 우측 상단의 refresh 버튼을 통해 상품 목록을 갱신할 수 있습니다.  

![ezgif com-gif-maker (7)](https://user-images.githubusercontent.com/69730931/132921496-0c8065af-7de3-4776-aecf-12d9c82b2d59.gif)
![ezgif com-gif-maker (8)](https://user-images.githubusercontent.com/69730931/132921656-1a6c4791-943f-4ede-bcfa-65ff2386d229.gif)


### 최초 상품 목록 로드 시 대기 효과 표시 ([구현 방식 바로가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EC%B5%9C%EC%B4%88-%EC%83%81%ED%92%88-%EB%AA%A9%EB%A1%9D-%EB%A1%9C%EB%93%9C-%EC%8B%9C-%EB%8C%80%EA%B8%B0-%ED%9A%A8%EA%B3%BC-%ED%91%9C%EC%8B%9C-1))
앱이 최초에 실행되어 상품이 로드될 때까지 대기 효과를 표시합니다.

![ezgif com-gif-maker (9)](https://user-images.githubusercontent.com/69730931/132922068-217ed4b9-a121-4c2b-ab44-c7160ecb69b9.gif)


### Image paging ([구현 방식 바로가기](https://github.com/ryan-son/wrap-up-ios-open-market#image-paging-1))
상품 상세 조회 시 페이징을 통해 여러 이미지를 조회할 수 있습니다.

![ezgif com-gif-maker (10)](https://user-images.githubusercontent.com/69730931/132922364-6036ffe5-314a-4b57-91d1-316b825e3c43.gif)


## 상품 등록
상품 목록 조회 화면 우측 하단의 상품 등록 버튼을 통해 상품을 등록할 수 있습니다.

![image](https://user-images.githubusercontent.com/69730931/132924589-266ac104-51e6-49d2-a246-3388efee4ee0.png)

### 이미지 추가 및 스크롤링을 통한 이미지 확인 ([구현 방식 바로가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EC%9D%B4%EB%AF%B8%EC%A7%80-%EC%B6%94%EA%B0%80-%EB%B0%8F-%EC%8A%A4%ED%81%AC%EB%A1%A4%EB%A7%81%EC%9D%84-%ED%86%B5%ED%95%9C-%EC%9D%B4%EB%AF%B8%EC%A7%80-%ED%99%95%EC%9D%B8-1))
사진첩에서 등록할 사진을 선택할 수 있으며 기존에 등록한 사진을 스크롤링을 통해 확인할 수 있습니다.

![ezgif com-gif-maker (15)](https://user-images.githubusercontent.com/69730931/132925063-96130df3-ae01-49dd-bf3f-d8b24d2fad05.gif)

### 등록한 이미지 삭제 ([구현 방식 바로가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EB%93%B1%EB%A1%9D%ED%95%9C-%EC%9D%B4%EB%AF%B8%EC%A7%80-%EC%82%AD%EC%A0%9C-1))
등록한 이미지의 우측 상단에 위치한 버튼을 통해 등록한 이미지를 삭제할 수 있습니다.

![ezgif com-gif-maker (16)](https://user-images.githubusercontent.com/69730931/132925383-6f79272a-2604-4d89-aa01-abe18b7af9ca.gif)

### 키보드 프레임을 고려한 레이아웃 설정 ([구현 방식 바로가기](https://github.com/ryan-son/wrap-up-ios-open-market#%ED%82%A4%EB%B3%B4%EB%93%9C-%ED%94%84%EB%A0%88%EC%9E%84%EC%9D%84-%EA%B3%A0%EB%A0%A4%ED%95%9C-%EB%A0%88%EC%9D%B4%EC%95%84%EC%9B%83-%EC%84%A4%EC%A0%95-1))
입력할 TextView가 키보드에 가리지 않게끔 제약을 조정합니다.

![ezgif com-gif-maker (17)](https://user-images.githubusercontent.com/69730931/132925591-afd22fa4-1d13-49fd-b9b7-e20d89b89056.gif)


### 등록한 상품 바로 보기 ([구현 방식 바로가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EB%93%B1%EB%A1%9D%ED%95%9C-%EC%83%81%ED%92%88-%EB%B0%94%EB%A1%9C-%EB%B3%B4%EA%B8%B0-1))
상품 등록 후 등록한 상품의 상세 조회 화면으로 바로 이동합니다.

![ezgif com-gif-maker (18)](https://user-images.githubusercontent.com/69730931/132926309-a8172dd2-e818-4173-96f4-a5def0a4a57b.gif)


## 상품 수정
상품 상세 조회 화면 우측 상단의 더보기 버튼을 통해 상품을 수정할 수 있습니다.

![image](https://user-images.githubusercontent.com/69730931/132924566-7394a438-4d86-47e0-b9d0-418bc6176895.png)


### Alert을 이용한 비밀번호 선 확인 ([구현 방식 바로가기](https://github.com/ryan-son/wrap-up-ios-open-market#alert%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%9C-%EB%B9%84%EB%B0%80%EB%B2%88%ED%98%B8-%EC%84%A0-%ED%99%95%EC%9D%B8-1))
상품 수정 시 비밀번호를 먼저 입력하고 수정화면으로 진입합니다. 올바르지 않은 비밀번호를 입력한 경우에는 재시도 또는 취소를 선택할 수 있습니다.

![ezgif com-gif-maker (11)](https://user-images.githubusercontent.com/69730931/132923242-2d7f2fa6-47b0-4f2b-8530-432cebb6f478.gif)

### 수정한 상품 바로 보기 ([구현 방식 바로가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EC%88%98%EC%A0%95%ED%95%9C-%EC%83%81%ED%92%88-%EB%B0%94%EB%A1%9C-%EB%B3%B4%EA%B8%B0-1))
상품 수정 후 수정된 상품을 기존 화면에 바로 업데이트하여 보여줍니다.

![ezgif com-gif-maker (12)](https://user-images.githubusercontent.com/69730931/132923545-26908bbd-c239-49ee-91f7-1e22776c7810.gif)


### 상품 수정 후 상품 목록 refreshing ([구현 방식 바로가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EC%83%81%ED%92%88-%EC%88%98%EC%A0%95-%ED%9B%84-%EC%83%81%ED%92%88-%EB%AA%A9%EB%A1%9D-refreshing-1))
상품 수정 후 상품 상세 조회 화면을 벗어나면 상품 목록을 갱신합니다.

![ezgif com-gif-maker (13)](https://user-images.githubusercontent.com/69730931/132923694-f059a85f-9041-4d6f-844f-6c7844d905cc.gif)


## 상품 삭제

### 상품 삭제 후 상품 목록 refreshing ([구현 방식 바로가기]())
상품 삭제 후에는 확인 버튼 클릭 즉시 상품 상세 조회 화면을 벗어나며 상품 목록을 갱신합니다.

![ezgif com-gif-maker (14)](https://user-images.githubusercontent.com/69730931/132923988-58da7d8b-c897-47c4-83b2-819de72866c1.gif)


# 3. 설계 및 구현

최종적으로 활용되는 타입이 아닌 경우 타입 간의 느슨한 결합을 위해 프로토콜을 통해 추상화하여 의존성 주입이 가능하도록 구성하였습니다. 이를 통해 프로토콜을 통해 요구된 인터페이스를 가진 타입을 설계함으로써 테스트를 수행합니다.

escaping closure를 통해 mutating 인스턴스가 강제되는 경우를 제외하고는 값 타입인 struct를 이용하여 타입을 설계함으로써 ARC를 통한 참조 카운팅을 고려하지 않아도 되도록 구성하였습니다.
![image](https://user-images.githubusercontent.com/69730931/132930476-90ff2f57-41d9-41f5-9df1-71895acf74d2.png)


## 상품 조회
![image](https://user-images.githubusercontent.com/69730931/132931082-aba3fb1e-25b3-4d39-92b2-0486a11742f2.png)

![image](https://user-images.githubusercontent.com/69730931/132937600-db880732-938a-49a2-b994-0efab4330c40.png)

![image](https://user-images.githubusercontent.com/69730931/132937906-c245ee5f-3423-4411-96f7-491d1140b8a8.png)

### Cell styling ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#cell-styling))
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

### Infinite scrolling ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#infinite-scrolling))

`collectionView(_:willDisplay:forItemAt:)` 메서드를 이용해 잔여 상품 개수가 특정 개수 이하 (10개)가 되면 다음 목록을 요청합니다 (`list()` 메서드).

```swift
func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if viewModel.marketItems.count <= indexPath.item + Style.numberOfLastItemsToTriggerFetch {
        viewModel.list()
    }
}
```

### Refreshing ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#refreshing))
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

### 최초 상품 목록 로드 시 대기 효과 표시 ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EC%B5%9C%EC%B4%88-%EC%83%81%ED%92%88-%EB%AA%A9%EB%A1%9D-%EB%A1%9C%EB%93%9C-%EC%8B%9C-%EB%8C%80%EA%B8%B0-%ED%9A%A8%EA%B3%BC-%ED%91%9C%EC%8B%9C))
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

### Image paging ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#image-paging))
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

### 이미지 추가 및 스크롤링을 통한 이미지 확인 ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EC%9D%B4%EB%AF%B8%EC%A7%80-%EC%B6%94%EA%B0%80-%EB%B0%8F-%EC%8A%A4%ED%81%AC%EB%A1%A4%EB%A7%81%EC%9D%84-%ED%86%B5%ED%95%9C-%EC%9D%B4%EB%AF%B8%EC%A7%80-%ED%99%95%EC%9D%B8))
이미지를 추가하는 영역은 [UICollectionView](https://github.com/ryan-son/wrap-up-ios-open-market/blob/main/OpenMarket/OpenMarket/Sources/Views/MarketItemRegisterView/MarketItemRegisterViewController%2BDelegates.swift)로 구현되어있으며, 첫번째 셀은 [AddPhotoCollectionViewCell](https://github.com/ryan-son/wrap-up-ios-open-market/blob/main/OpenMarket/OpenMarket/Sources/Views/MarketItemRegisterView/Components/AddPhotoCollectionViewCell/AddPhotoCollectionViewCell.swift), 이후 추가되는 이미지들은 [PhotoCollectionViewCell](https://github.com/ryan-son/wrap-up-ios-open-market/blob/main/OpenMarket/OpenMarket/Sources/Views/MarketItemRegisterView/Components/PhotoCollectionViewCell/PhotoCollectionViewCell.swift)로 구현되어 있습니다. 이미지를 사진첩에서 가져오는 기능은 `UIImagePickerController`를 구현한 [RegisterImagePicker](https://github.com/ryan-son/wrap-up-ios-open-market/blob/main/OpenMarket/OpenMarket/Sources/Views/MarketItemRegisterView/Components/RegisterImagePicker.swift)을 통해 수행하고 있습니다.

### 등록한 이미지 삭제 ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EB%93%B1%EB%A1%9D%ED%95%9C-%EC%9D%B4%EB%AF%B8%EC%A7%80-%EC%82%AD%EC%A0%9C))
`collectionView(_:cellForItemAt:)` 메서드에서 `PhotoCollectionViewCell`을 dequeue할 때 삭제 버튼에 대해 target을 설정함으로써 이미지 삭제를 수행합니다.

```swift
...
guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath)
        as? PhotoCollectionViewCell else { return UICollectionViewCell() }

photoCell.addDeleteButtonTarget(target: self, action: #selector(removePhoto(_:)), for: .touchUpInside)
...
```

### 키보드 프레임을 고려한 레이아웃 설정 ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#%ED%82%A4%EB%B3%B4%EB%93%9C-%ED%94%84%EB%A0%88%EC%9E%84%EC%9D%84-%EA%B3%A0%EB%A0%A4%ED%95%9C-%EB%A0%88%EC%9D%B4%EC%95%84%EC%9B%83-%EC%84%A4%EC%A0%95))
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

### 등록한 상품 바로 보기 ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EB%93%B1%EB%A1%9D%ED%95%9C-%EC%83%81%ED%92%88-%EB%B0%94%EB%A1%9C-%EB%B3%B4%EA%B8%B0))
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

## 상품 수정
![image](https://user-images.githubusercontent.com/69730931/132903714-edaf5ccb-104c-4921-b5fa-ed28a6e7d9b7.png)

### Alert을 이용한 비밀번호 선 확인 ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#alert%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%9C-%EB%B9%84%EB%B0%80%EB%B2%88%ED%98%B8-%EC%84%A0-%ED%99%95%EC%9D%B8))
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

### 수정한 상품 바로 보기 ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EC%88%98%EC%A0%95%ED%95%9C-%EC%83%81%ED%92%88-%EB%B0%94%EB%A1%9C-%EB%B3%B4%EA%B8%B0))
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

### 상품 수정 후 상품 목록 refreshing ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EC%83%81%ED%92%88-%EC%88%98%EC%A0%95-%ED%9B%84-%EC%83%81%ED%92%88-%EB%AA%A9%EB%A1%9D-refreshing))
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

### 상품 삭제 후 상품 목록 refreshing ([기능으로 돌아가기](https://github.com/ryan-son/wrap-up-ios-open-market#%EC%83%81%ED%92%88-%EC%82%AD%EC%A0%9C-%ED%9B%84-%EC%83%81%ED%92%88-%EB%AA%A9%EB%A1%9D-refreshing))
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

# 4. 유닛 테스트 및 UI 테스트


# 5. Trouble shooting


# 6. 학습 내용
