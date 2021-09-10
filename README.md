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

### Infinite scrolling

### Cell styling

### Refreshing

### 기기 방향에 따른 Collection View 스타일링

### 로드 시 Activity Indicator를 통한 대기 효과 표시

### Image paging

### Actionsheet를 이용한 상품 수정 및 삭제


## 상품 등록

### 이미지 추가 및 스크롤링을 통한 이미지 확인

### 키보드 프레임을 고려한 레이아웃 설정

### TextView Placeholder


## 상품 수정

### Alert을 이용한 비밀번호 선 확인

### 수정한 상품 바로 보기

### 상품 수정 후 상품 목록 refreshing 


## 상품 삭제

### 상품 삭제 후 상품 목록 refreshing


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
