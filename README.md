# Hướng Dẫn Sử Dụng Dự Án OCR

## Giới Thiệu

Dự án này sử dụng Flutter để phát hiện văn bản từ hình ảnh thông qua một pipeline OCR. Nó cho phép người dùng chọn hình ảnh từ thư viện hoặc chụp ảnh mới và hiển thị kết quả nhận diện văn bản.

## Cách Sử Dụng

Dưới đây là một ví dụ về cách sử dụng các lớp chính trong dự án:

### Khởi Tạo Pipeline OCR

```dart
final OcrPipeline _ocrPipeline = OcrPipeline();
await _ocrPipeline.init();
```

### Xử Lý Hình Ảnh

```dart
Future<void> detectionText(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return ;
    final ocrResult = await _ocrPipeline.processOcrImage(image.path);
}
```

## Lưu Ý

- Đảm bảo rằng bạn đã cấp quyền truy cập camera và bộ nhớ cho ứng dụng.
- Kiểm tra các mô hình OCR cần thiết đã được tải về và cấu hình đúng.

<h1 align="center">Hi 👋, I'm Van Minh Tuan</h1>
<h3 align="center">Looking for a ambitious and professional working environment to perform and exlpore my more than 8-year experience in fullstack and mobile development.</h3>

- 📫 How to reach me **leetuanbmt@gmail.com**

<h3 align="left">Connect with me:</h3>
<p align="left">
<a href="https://twitter.com/leetuanbmtgmail" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/twitter.svg" alt="leetuanbmtgmail" height="30" width="40" /></a>
<a href="https://linkedin.com/in/leetuanbmt" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg" alt="leetuanbmt" height="30" width="40" /></a>
<a href="https://fb.com/leetuanbmt" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/facebook.svg" alt="leetuanbmt" height="30" width="40" /></a>
<a href="https://instagram.com/leetuanbmt2019" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/instagram.svg" alt="leetuanbmt2019" height="30" width="40" /></a>
<a href="https://www.hackerrank.com/leetuanbmt" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/hackerrank.svg" alt="leetuanbmt" height="30" width="40" /></a>
</p>

<h3 align="left">Languages and Tools:</h3>
<p align="left"> <a href="https://aws.amazon.com/amplify/" target="_blank" rel="noreferrer"> <img src="https://docs.amplify.aws/assets/logo-dark.svg" alt="amplify" width="40" height="40"/> </a> <a href="https://angular.io" target="_blank" rel="noreferrer"> <img src="https://angular.io/assets/images/logos/angular/angular.svg" alt="angular" width="40" height="40"/> </a> <a href="https://aws.amazon.com" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/amazonwebservices/amazonwebservices-original-wordmark.svg" alt="aws" width="40" height="40"/> </a> <a href="https://azure.microsoft.com/en-in/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/microsoft_azure/microsoft_azure-icon.svg" alt="azure" width="40" height="40"/> </a> <a href="https://dart.dev" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/dartlang/dartlang-icon.svg" alt="dart" width="40" height="40"/> </a> <a href="https://www.docker.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg" alt="docker" width="40" height="40"/> </a> <a href="https://firebase.google.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/firebase/firebase-icon.svg" alt="firebase" width="40" height="40"/> </a> <a href="https://flutter.dev" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="40" height="40"/> </a> <a href="https://git-scm.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="40" height="40"/> </a> <a href="https://ionicframework.com" target="_blank" rel="noreferrer"> <img src="https://upload.wikimedia.org/wikipedia/commons/d/d1/Ionic_Logo.svg" alt="ionic" width="40" height="40"/> </a> <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/javascript/javascript-original.svg" alt="javascript" width="40" height="40"/> </a> <a href="https://materializecss.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/prplx/svg-logos/5585531d45d294869c4eaab4d7cf2e9c167710a9/svg/materialize.svg" alt="materialize" width="40" height="40"/> </a> <a href="https://www.mongodb.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mongodb/mongodb-original-wordmark.svg" alt="mongodb" width="40" height="40"/> </a> <a href="https://www.microsoft.com/en-us/sql-server" target="_blank" rel="noreferrer"> <img src="https://www.svgrepo.com/show/303229/microsoft-sql-server-logo.svg" alt="mssql" width="40" height="40"/> </a> <a href="https://www.mysql.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mysql/mysql-original-wordmark.svg" alt="mysql" width="40" height="40"/> </a> <a href="https://postman.com" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/getpostman/getpostman-icon.svg" alt="postman" width="40" height="40"/> </a> <a href="https://www.python.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="40" height="40"/> </a> <a href="https://tailwindcss.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/tailwindcss/tailwindcss-icon.svg" alt="tailwind" width="40" height="40"/> </a> </p>
