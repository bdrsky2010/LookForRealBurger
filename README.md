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
- 지도에서 햄버거 식당을 선택해 유저들의 리뷰를 확인
  - 지도 위에 등록되어 있는 햄버거 식당(햄버거 이미지)을 선택
  - 해당 식당에 대한 유저들의 리뷰를 확인
- 전체 리뷰 조회
  - 스크롤하여 더 많은 리뷰를 조회
- 리뷰 작성 및 상호작용
  - 리뷰 작성
  - 리뷰에 좋아요/북마크
  - 리뷰에 댓글 작성
- 유저 프로필
  - 유저 팔로우/팔로잉
  - 다른 유저 프로필(피드) 확인
  - 팔로우/팔로잉 유저 프로필(피드) 확인
- 다국어 지원
  - 한국어, 영어, 일본어 다국어 지원
  - 사용자의 국가에 맞는 앱 언어 자동 설정
<br>

# 주요기술
- 지도에서 햄버거 식당을 선택해 유저들의 리뷰를 확인
  - Mapkit의 MKMapViewDelegate 활용
  - Custom MKAnnotationView로 지도 위 커스터마이징된 핀 표시
- 전체 리뷰 조회
  - Cursor Based Pagination을 활용
- 리뷰 작성 및 상호작용
  - HTTP Request(Post)의 Content-type을 multipart/form-data로 설정 
  - 이미지를 JPEG로 압축 후 HTTP Request의 Body에 포함하여 서버에 업로드
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
- Input/Output 패턴을 활용하여 양방향 데이터바인딩
- ViewModel, UseCase, Repository 로 나눠지는 역할에 따른 로직 모듈화
- Router 패턴을 활용하여 반복되는 네트워크 작업을 추상화
- DIP(의존성 역전 원칙)을 준수
  - 추상화된 Protocol을 채택하여 객체의 생성과 사용을 분리
  - 이를 통하여 하위모듈에서 구현체가 아닌 추상화된 타입에 의존 

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
