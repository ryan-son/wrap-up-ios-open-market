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

### Cell styling
우측 상단의 셀 스타일 변경 버튼을 통해 상품 목록 조회 시 보기 모드를 변경할 수 있습니다.

![image](https://user-images.githubusercontent.com/69730931/132921089-a510ce0c-a5b8-458e-b7ac-a844cc830995.png)

기기 방향에 따라 각 행 당 보여주는 상품의 개수가 달라집니다.

<img src="https://user-images.githubusercontent.com/69730931/132921816-06c9e20f-f39e-4d06-ba73-13389466924f.png" alt="CellStyleByDeviceOrientation" width="630"/>


### Infinite scrolling
로드된 잔여 상품 개수를 통해 다음 리스트를 불러와 스크롤링을 통해 전체 상품을 조회할 수 있습니다.

![ezgif com-gif-maker (5)](https://user-images.githubusercontent.com/69730931/132920635-94ccfff6-eb8f-4ed9-be91-a1767e73ef90.gif)
![ezgif com-gif-maker (6)](https://user-images.githubusercontent.com/69730931/132920771-0b00629b-610e-45d3-9fe0-e9f873564e02.gif)


### Refreshing
상품 목록 최상단에서 상품 목록을 잡아 당기거나, 우측 상단의 refresh 버튼을 통해 상품 목록을 갱신할 수 있습니다.  

![ezgif com-gif-maker (7)](https://user-images.githubusercontent.com/69730931/132921496-0c8065af-7de3-4776-aecf-12d9c82b2d59.gif)
![ezgif com-gif-maker (8)](https://user-images.githubusercontent.com/69730931/132921656-1a6c4791-943f-4ede-bcfa-65ff2386d229.gif)


### 로드 시 Activity Indicator를 통한 대기 효과 표시
앱이 최초에 실행되어 상품이 로드될 때까지 대기 효과를 표시합니다.

![ezgif com-gif-maker (9)](https://user-images.githubusercontent.com/69730931/132922068-217ed4b9-a121-4c2b-ab44-c7160ecb69b9.gif)


### Image paging
상품 상세 조회 시 페이징을 통해 여러 이미지를 조회할 수 있습니다.

![ezgif com-gif-maker (10)](https://user-images.githubusercontent.com/69730931/132922364-6036ffe5-314a-4b57-91d1-316b825e3c43.gif)


## 상품 등록
상품 목록 조회 화면 우측 하단의 상품 등록 버튼을 통해 상품을 등록할 수 있습니다.

![image](https://user-images.githubusercontent.com/69730931/132924589-266ac104-51e6-49d2-a246-3388efee4ee0.png)

### 이미지 추가 및 스크롤링을 통한 이미지 확인
사진첩에서 등록할 사진을 선택할 수 있으며 기존에 등록한 사진을 스크롤링을 통해 확인할 수 있습니다.

![ezgif com-gif-maker (15)](https://user-images.githubusercontent.com/69730931/132925063-96130df3-ae01-49dd-bf3f-d8b24d2fad05.gif)

### 등록한 이미지 삭제
등록한 이미지의 우측 상단에 위치한 버튼을 통해 등록한 이미지를 삭제할 수 있습니다.

![ezgif com-gif-maker (16)](https://user-images.githubusercontent.com/69730931/132925383-6f79272a-2604-4d89-aa01-abe18b7af9ca.gif)

### 키보드 프레임을 고려한 레이아웃 설정
입력할 TextView가 키보드에 가리지 않게끔 제약을 조정합니다.

![ezgif com-gif-maker (17)](https://user-images.githubusercontent.com/69730931/132925591-afd22fa4-1d13-49fd-b9b7-e20d89b89056.gif)


### 등록한 상품 바로 보기
상품 등록 후 등록한 상품의 상세 조회 화면으로 바로 이동합니다.

![ezgif com-gif-maker (18)](https://user-images.githubusercontent.com/69730931/132926309-a8172dd2-e818-4173-96f4-a5def0a4a57b.gif)


## 상품 수정
상품 상세 조회 화면 우측 상단의 더보기 버튼을 통해 상품을 수정할 수 있습니다.

![image](https://user-images.githubusercontent.com/69730931/132924566-7394a438-4d86-47e0-b9d0-418bc6176895.png)


### Alert을 이용한 비밀번호 선 확인
상품 수정 시 비밀번호를 먼저 입력하고 수정화면으로 진입합니다. 올바르지 않은 비밀번호를 입력한 경우에는 재시도 또는 취소를 선택할 수 있습니다.

![ezgif com-gif-maker (11)](https://user-images.githubusercontent.com/69730931/132923242-2d7f2fa6-47b0-4f2b-8530-432cebb6f478.gif)

### 수정한 상품 바로 보기
상품 수정 후 수정된 상품을 기존 화면에 바로 업데이트하여 보여줍니다.

![ezgif com-gif-maker (12)](https://user-images.githubusercontent.com/69730931/132923545-26908bbd-c239-49ee-91f7-1e22776c7810.gif)


### 상품 수정 후 상품 목록 refreshing 
상품 수정 후 상품 상세 조회 화면을 벗어나면 상품 목록을 갱신합니다.

![ezgif com-gif-maker (13)](https://user-images.githubusercontent.com/69730931/132923694-f059a85f-9041-4d6f-844f-6c7844d905cc.gif)


## 상품 삭제

### 상품 삭제 후 상품 목록 refreshing
상품 삭제 후에는 확인 버튼 클릭 즉시 상품 상세 조회 화면을 벗어나며 상품 목록을 갱신합니다.

![ezgif com-gif-maker (14)](https://user-images.githubusercontent.com/69730931/132923988-58da7d8b-c897-47c4-83b2-819de72866c1.gif)


# 3. 설계 및 구현

## 상품 조회
![image](https://user-images.githubusercontent.com/69730931/132912758-2e880cf5-b820-4740-9caa-c3c2a6285d8e.png)


## 상품 등록
![image](https://user-images.githubusercontent.com/69730931/132903453-2159699a-25c5-43b5-88f1-0cfff26f9d07.png)

## 상품 수정
![image](https://user-images.githubusercontent.com/69730931/132903714-edaf5ccb-104c-4921-b5fa-ed28a6e7d9b7.png)


## 상품 삭제
![image](https://user-images.githubusercontent.com/69730931/132903777-5027c0e7-3442-46fd-8b11-679e3e80f86a.png)


# 4. 유닛 테스트 및 UI 테스트


# 5. Trouble shooting


# 6. 학습 내용
