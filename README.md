# 🍔 LookForRealBurger - 진짜 맛있는 버거를 찾아서
<br>
<div align=center>
    <img src="https://img.shields.io/badge/Swift-v5.10-F05138?style=plastic&logo=swift&logoColor=F05138">
    <img src="https://img.shields.io/badge/Xcode-v15.4-147EFB?style=plastic&logo=swift&logoColor=147EFB">
    <img src="https://img.shields.io/badge/iOS-15.0+-F05138?style=plastic&logo=apple&logoColor=#000000">
</div>
<br>
<p align="center">
    <img src="./images/icon.png"> 
</p>

<p align="center"> 
    <img src="./images/map.gif" align="center" width="19%">
    <img src="./images/write.gif" align="center" width="19%"> 
    <img src="./images/post.gif" align="center" width="19%"> 
    <img src="./images/profile.gif" align="center" width="19%"> 
    <img src="./images/cost.gif" align="center" width="19%">   
</p>
<br> 

# 앱 한 줄 소개
`🍔 진짜 맛있는 햄버거를 찾기 위해 유저들과 함께 리뷰를 작성하여 지도를 채워나가는 앱`

<br>

# 주요기능
- 지도 기반 리뷰 확인
  - 사용자는 지도를 통해 주변 햄버거 맛집을 탐색하고, 해당 식당에 작성된 리뷰를 확인할 수 있습니다.
  - 식당 위치를 나타내는 핀을 선택하면, 리뷰와 함께 이미지를 시작적으로 제공합니다.
  
- 리뷰 작성 및 상호작용
  - 사용자는 텍스트와 이미지로 리뷰를 남기며, 리뷰에 대해 좋아요 혹은 북마크를 통해 상호작용을 할 수 있습니다.
  - 작성된 리뷰에 댓글을 남겨, 다른 사용자들과 소통이 가능합니다.
   
- 팔로우 및 유저 피드
  - 원하는 유저를 팔로우할 수 있고, 팔로우한 유저들의 프로필을 방문하여 최신 리뷰를 피드에서 손쉽게 확인할 수 있습니다.
  
- 다국어 지원
  - 한국어, 영어, 일본어를 지원하며, 사용자의 기기에 설정된 언어에 맞춰 자동으로 설정됩니다.
<br>

# 주요기술
- 지도 기반 리뷰
  - Mapkit의 MKMapViewDelegate 활용해 사용자 리뷰가 있는 햄버거 식당 위치를 지도에 표시했습니다.
  - Custom MKAnnotationView를 사용해 Pin의 모양을 햄버거 아이콘으로 커스터마이징하여<br>사용자가 한눈에 위치를 인식할 수 있도록 구현했습니다.
  
- 효율적인 데이터 로딩
  - 전체 리뷰를 조회하는 경우, Cursor Based Pagination을 통해 데이터를 효율적으로 로드하도록 구현했습니다.
  
- 이미지 데이터 업로드
  - 리뷰 작성 시 이미지와 텍스트를 함께 서버에 전송하기 위해 HTTP Request(Post)의 Content-type을<br>multipart/form-data로 설정하였으며, 이미지를 JPEG로 압축 후 HTTP Request의 Body에 포함하여<br>서버에 업로드하였습니다.
<br>

# 프로젝트 환경
- 인원
  - iOS 1명
- 기간
  - 2024.08.14 - 2024.09.01 (약 19일)
- 버전
  -  iOS 15.0 +

<br>

# 프로젝트 기술스택
- 활용기술
  - UIKit, Mapkit
  - MVVM, Input-Output, Clean Architecture
  - CodeBasedUI
  - Cursor Based Pagination
  
- 라이브러리

|라이브러리|사용목적|
|-|-|
|RxSwift|반응형 프로그래밍, 코드 가독성 향상 및 일관성 유지|
|RxCocoa|UI와 관련된 반응형 프로그래밍, 코드 가독성 향상 및 일관성 유지|
|RxDataSources|RxSwift 및 RxCocoa와 함께 일관성있는 컴포넌트 구성|
|RxGesture|RxSwift 및 RxCocoa와 함께 일관성있는 Gesture 처리|
|RxCoreLocation|RxSwift 및 RxCocoa와 함께 일관성있는 위치 데이터 관리|
|Snapkit|CodeBasedUI를 좀 더 편하고 빠르게 구성|
|Moya|추상화된 네트워크 통신 활용|
|Toast|간편한 토스트 메시지UI 구성|
|Lottie|간편하면서 적절한 애니메이션 적용|
|Tabman|간편하고 빠르게 Paging 탭바를 구성|
|iamport-ios|WebView 기반의 간편결제 적용|
|IQKeyboardManagerSwift|키보드 처리 활용|
|Kingfisher|API 이미지 처리|

<br>

# 앱 아키텍쳐
<p align="center"> 
    <img src="./images/architecture.png" align="center" width="80%"> 
</p>

> MVVM(Input/Output) + Clean Architecture
<details>
<summary>설명</summary>
<div>

### 1. 계층구조
- **ViewModel** ([관련코드](https://github.com/bdrsky2010/LookForRealBurger/blob/main/LookForRealBurger/Scene/WriteReview/Presentation/WriteReviewViewModel.swift))
    - RxSwift와 RxCocoa를 활용하여 ViewController와의 데이터 바인딩을 담당하는 계층
    - Input과 Output을 정의하여 View와 통신을 관리
    - UseCase를 통해 비즈니스 로직을 처리하고, UI 업데이트에 필요한 데이터를 제공
    
- **UseCase** ([관련코드](https://github.com/bdrsky2010/LookForRealBurger/blob/main/LookForRealBurger/Scene/WriteReview/Domain/UseCase/UploadPostUseCase.swift))
    - 비즈니스 로직을 담당하는 계층으로, 특정 작업을 처리하기 위해 데이터를 요청 및 제공하는 역할
    - Repository를 통해 데이터를 요청 및 제공
    - 네트워크 통신 시, RxSwift의 Single trait을 활용 및 Result 타입으로<br>한 번 더 래핑하여 error가 발생해도 구독이 끊기지 않고 Stream이 유지되도록 구현
    
- **Repository** ([관련코드](https://github.com/bdrsky2010/LookForRealBurger/blob/main/LookForRealBurger/Common/Data/Repository/PostRepository.swift))
    - Network에 API를 요청하여 데이터를 받아오는 역할을 담당
    - 요청에 대한 데이터를 DTO로 변환하여 API에 요청
    - 응답에 대한 DTO 데이터를 Entity로 변환하여 UseCase에 전달 
    
- **Network** ([Manager 관련코드](https://github.com/bdrsky2010/LookForRealBurger/blob/main/LookForRealBurger/Common/Data/Network/LFRBNetworkManager.swift)) / [Router 관련코드](https://github.com/bdrsky2010/LookForRealBurger/blob/main/LookForRealBurger/Common/Data/Network/Router/AuthRouter.swift))
    - Network Manager와 Network Router를 활용하여 실질적으로 네트워크를 담당하는 계층 
    - Network Manager: Moya의 MoyaProvider를 활용하여 네트워크 요청을 보내 응답을 받아 데이터를 반환하는 객체 
    - Network Router: Moya의 TargetType을 더 추상화한 형태의 TargetType을 새로 정의하여 채택한<br>enum의 case와 연관값을 활용하여 API의 BaseURL, HTTPMethod, Parameter, Header 등을 설정
    - RequestDTO와 ResposeDTO를 통해 데이터를 요청 및 응답
    
- **Data Storage** ([관련코드](https://github.com/bdrsky2010/LookForRealBurger/blob/main/LookForRealBurger/Common/Data/AccessTokenStorage/AccessStorage.swift))
    - UserDefaults를 활용하여 Local DB를 관리하는 계층
    - 간단한 데이터 저장 및 조회

### 2. 의존성 역전 원칙
> 하위 모듈을 프로토콜 타입으로서 의존성을 외부에서 주입하여 의존성의 방향을 역전시켰으며,<br>그로인해 유지보수성이 향상, Testable한 코드를 작성 

- DIP를 적용하기 위해 계층 간 결합도를 낮추도록 SOLID 원칙을 고려하며 모듈을 구현
    - **단일 책임의 원칙**: 역할에 따른 기능 분리로 인한 계층 모듈화<br>(예: 액션을 담당하는 ViewModel, 비즈니스 로직을 담당하는 UseCase, 인증에 대한 API를 담당하는 Repository 등등)
    
    - **개방-폐쇄의 원칙**: 추상화된 protocol을 채택하여 외부에서 사용되지 않는 메서드는 Class 내부에서 private하게 구현
    
    - **리스코프 치환 원칙**: ViewController를 자식 Class로 바라보며 공통적으로 필요한 View(Navigation, Hierarchy, Layout, UI 등) 설정 메서드를 정의하여 ViewDidLoad에서 호출해 자식 Class인 ViewController에서<br>재정의해 구현할 수 있도록 구성
    
    - **인터페이스 분리 원칙**: Input, Output, UseCase, Repository 등 역할에 따른 상위 모듈에서 사용되는 메서드 및<br>프로퍼티만 요구사항으로서 프로토콜에 정의
    
    - **의존성 역전 원칙**: 상위 모듈이 하위 모듈에 의존하지 않는, 추상화된 프로토콜에 의존하는 방식으로 모듈을 구현

### 3. Input/Output 패턴
- 추상화된 형태의 프로토콜로 Input과 Output을 구성하였으며, 두 프로토콜을 병합한 형태로 typealias를 통해 별칭을 ViewModel로 설정
- View에서 일어나는 액션을 Input을 통해 ViewModel에 전달
- ViewModel에서 처리된 데이터를 Output을 통해 View로 전달하여 UI를 업데이트
- Input/Output 패턴을 활용하여 MVVM 구조에서 View와 ViewModel 간에 양방향 통신에 대한 데이터의 흐름을<br>직관적으로 파악 및 관리 

### 4. DTO(Data Transfer Object)구조 및 데이터 흐름
> API 호출로 인한 네트워크 요청 시 요청에 필요한 데이터를 RequestDTO로 요청, 응답으로 받은 데이터를<br>ResponseDTO로 받으며, ResposeDTO를 Entity로 변환하여 관리
- **RequestDTO**: API 호출 시 ViewModel과 UseCase를 통해 받아온 Query 객체 데이터를 Repository 계층에서<br>RequestDTO 객체로 변환하여 Network Manager에 전달

- **ResponseDTO**: 서버 API로부터 전달받은 JSON 데이터를 ResponseDTO 객체 데이터로 변환 후 앱에서 사용하는<br>데이터의 형태로 가공된 Entity 객체 데이터로 변환하여 UseCase로 전달

- **Entity**: 앱 내 도메인 즉, 비즈니스 로직에 사용되는 데이터 객체로, ResposeDTO에서 변환된 후 UseCase로 전달되어<br>UI 업데이트를 위해 ViewModel로 전달

### 5. Unit Test ([관련코드](https://github.com/bdrsky2010/LookForRealBurger/blob/main/LookForRealBurgerTests/WriteReviewUnitTest.swift))
- **목적 및 설계**: Input/Output에 대한 데이터 흐름 및 API 호출에 대한 성공/실패 시나리오를 테스트

- **기대 효과**: 비즈니스 로직의 성공과 에러에 대한 핸들링에 대한 안정적인 작동 확인을 통해 신뢰성 확인

- **테스트 진행**: Mock 객체(UseCase, LocalStorge)를 통한 네트워크 통신 및 Local DB 접근을 하였으며,<br>Protocol 타입으로 선언된 ViewModel에 실제 사용되는 ViewModel 객체를 대입하여 실질적인<br>Input/Output에 대한 안정적인 데이터 흐름 테스트 완료.

### 6. 아키텍쳐의 데이터 흐름 예시
<p align="center"> 
    <img src="./images/join.png" align="center" width="50%"> 
</p>

</div>
</details>

<br>

# 트러블 슈팅
<details>
<summary>Access Token 자동갱신</summary>
<div>

### Access Token 자동갱신

해당 프로젝트의 모든 API(게시물, 팔로잉/팔로우 등등)는
<br>
로그인 API를 통해 발급받은 Access Token을 요구한다.

이 Access Token의 유효 시간은 약 5분으로 짧았는데
<br>
그로 인해 사용자는 계속 Access Token이 만료되는 문제를 직면하게 된다.

이 문제를 해결하기 위해 두 가지 방법을 고민하게 되었다.
1. Access Token이 만료될 때마다 재로그인을 하는 방식
2. Refresh Token을 통해 Access Token을 자동으로 갱신하는 방식

<p align="center"> 
    <img src="./images/token_1.png" align="center" width="80%"> 
</p>

이 두 방식이 고민이 됐던 이유는 Access Token을 갱신하는데 필요한 Refresh Token도 만료되는 경우 다시 
<br>
로그인을 해야하기 때문에 바로 재로그인을 하는 것이 어떨까 라는 고민을 했던 것이다.

그렇다면 이 부분에서 또 고민을 해야했던 부분이 두 가지가 더 존재했다.
1. 재로그인 방식: Access Token이 만료될 때마다 사용자가 직접 재로그인하게 한다면 사용자의 경험이 매우 나빠질 것이다.
2. 자동 로그인 구현: 자동 로그인의 경우 유저의 아이디와 비밀번호를 저장해줘야 하지만 이를 UserDefaults인 로컬 저장소에 저장하는 것은 보안상으로 매우 위험하다고 판단이 됐다.

결론적으로, 재로그인을 하더라도 사용자가 직접 로그인을 해야하기 때문에 Access Token이 만료될 때마다 
<br>
재로그인을 하게 하는 것 또한 사용자에게 엄청난 불편함을 줄 수 있기 때문에
<br> 
Refresh Token을 통한 Access Token 자동 갱신 방식을 선택하게 되었다.

결론적으로, 사용자가 직접 재로그인하는 불편함을 줄이기 위해 Refresh Token을 통한 자동 갱신 방식을 선택하였다.
<br>
즉, Refresh Token이 만료될 경우에만 사용자에게 재로그인을 요구함으로써 보안과 사용자 경험의 균형을 맞추게 되었다.

최종적으로 작성된 로직은 아래 코드와 같다.
<p align="center"> 
    <img src="./images/token_2.png" align="center" width="80%"> 
</p>
<p align="center"> 
    <img src="./images/token_3.png" align="center" width="80%"> 
</p>

</div>
</details>

<details>
<summary>하위 ViewController 모두 뷰 계층구조에서 사라지는 상황</summary>
<div>

### 하위 ViewController 모두 뷰 계층구조에서 사라지는 상황

<p align="center"> 
    <img src="./images/error.png" align="center" width="80%"> 
</p>

- `TabBarController` 의 세번째 탭을 탭하게 되면 `EmptyViewContoller` 즉 빈 ViewController가 load가 되고 해당 ViewController가 로드되면 Modal이 Present 되는 상황
- Modal이 Present 가 된 상황에서 뷰의 계층구조를 Xcode Hierarchy 확인해보니 하위 ViewController 모두 뷰의 계층구조에서 사라진 상황
- 그리고 위 경고 message가 Console 에 출력
- 경고 message를 부족한 영어실력으로 해석해보면
  -  먼저 `EmptyPresentViewController` 가 뷰의 계층구조에서 분리되었다!
  - 이 분리된 뷰컨트롤러에서 `UINavigationController` 를 Present 하는 것을 좀 아닌 것 같다.
  - 손상된 결과물이 보여질 수 있다.
  - 그러니 `EmptyViewController`가 보여지기 전에 뷰의 계층구조에 있는지부터 확인해라
  - 안그러면 먼훗날 언젠가 `hard exception`이 일어나 앱이 crash 될 수 있다.

<br>
<p align="center"> 
    <img src="./images/will.png" align="center" width="80%"> 
</p>
<br>

- 위 경고 message를 해석한 후 `Modal`이 `Present` 되는 위치를 확인해보니
- `viewWillAppear(_ animated: Bool)` 생명주기 메서드 내에 작성
- 해당 코드를 보며 생각해봤을 때, `viewWillAppear(_ animated: Bool)` 에서 `ViewController` 를 `Present` 하게되면 뷰가 다 보여지지 않은 상태에서 `Modal`에서 보여지는 `ViewController`가 계층구조에 올라가는 것이 아닐까 라는 생각이 들며
- 이러한 이유로 `EmptyViewController` 가 뷰의 계층구조에서 사라진 것이 아닌 뷰의 계층구조에 올라가기도 전에 분리가 되어 버린 것이라고 판단

<br>
<p align="center"> 
    <img src="./images/did.png" align="center" width="80%"> 
</p>
<br>

- 그렇다면 `ViewController` 가 다 보여진 상태에서 `Modal` 을 `Present` 하게되면 해결될 것이라는 확신이 들었으며
- `Modal` 이 `Present` 되는 코드를 `viewDidAppear(_ animated: Bool)` 내에 작성
- 그 후, 빌드해서 확인해보니 에러 message가 사라지고 뷰의 계층구조도 잘 올라가있는 것을 확인할 수 있었다.

<br>

> 느낀점
> 뷰의 생명주기 메서드를 활용할 땐, 생각을 좀 하면서 해야겠다 라고 생각했다.

<br>

</div>
</details>

<details>
<summary>Pull To Refresh</summary>
<div>

### Pull To Refresh

<br>
<p align="center"> 
     <img src="./images/endRefreshing.gif" align="center" width="34%">
</p>
<br>

- 전체 리뷰 게시글을 확인하는 화면에서 `Pull To Refresh` 기능을 구성해놓은 상황
- 이 기능을 내가 사용자의 입장에서 계속해서 사용해본 경험으로는 게시글이 `Refresh` 가 되고 있는 지 아닌 지 구분이 되지 않을 정도로 너무 빠르게 사라졌으며
- 이 부분이 내 입장에서는 어색함과 답답함이 느껴졌다.

<br>
<p align="center"> 
    <img src="./images/endRefreshing.png" align="center" width="80%"> 
</p>
<br>

- 물론 코드를 내가 그렇게 작동하도록 구현을 해놨기 때문이다.
- 즉, 데이터에 대한 패치를 요청하고 바로 Refreshing을 끝내버린 것이다.
- 그래서 API 통신이 완료되면 end Refreshing 되도록 로직을 수정해봐도 데이터 패치 속도가 빨라 애니메이션이 끝나는 시점이 거의 유사했다.

<br>
<p align="center"> 
    <img src="./images/delayEndRefreshing.png" align="center" width="80%"> 
</p>
<br>

- 결국에는 `refreshing` 을 끝내라는 `Output Action` 이 일어나게 되면 `2초 Delay` 를 주고 `End Refreshing` 되도록 변경
- 물론 이건 너무 억지라고 할 수도 있지만 어쨌든 개발자도 사용자의 입장에서 생각을 해봐야 한다고 생각해봤을 때 이게 더 나은 선택이라고 느껴졌다.

<br>
<p align="center">  
    <img src="./images/delayEndRefreshing.gif" align="center" width="34%">
</p>
<br>

- 실 기기에 빌드해 본 결과 어색함과 답답함은 해소가 되었다.

<br>

</div>
</details>

# 회고

[블로그 참고](https://minjae1995.tistory.com/52)

<br>
