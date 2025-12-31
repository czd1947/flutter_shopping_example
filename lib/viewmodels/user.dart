/*
{
  "id": "11",
  "account": "ceshi01",
  "mobile": "13200000001",
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJuYW1lXCI6XCLmvZjnu5_kuIDlj6_niLHmjY9cIixcImlkXCI6XCIxMVwiLFwidXNlcm5hbWVcIjpcImNlc2hpMDFcIn0iLCJpYXQiOjE3NjcxMTA4NjMsImV4cCI6MTc2NzM3MDA2M30.4ZwT8ASgw_RaZLv_qTVcwBkJ5jaDDVPnXAWy_12_69o",
  "avatar": "http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/avatar/2025-08-01/d265d9df-4e88-4c37-8961-150ae7d97759.jpeg",
  "nickname": "潘统一可爱捏",
  "gender": "未知",
  "birthday": "1981-03-11",
  "cityCode": "120100",
  "provinceCode": "120000",
}
*/
// 根据上面的json 定义类型
class UserModel {
  String id;
  String account;
  String mobile;
  String token;
  String avatar;
  String nickname;
  String gender;
  String birthday;
  String cityCode;
  String provinceCode;

  UserModel({
    required this.id,
    required this.account,
    required this.mobile,
    required this.token,
    required this.avatar,
    required this.nickname,
    required this.gender,
    required this.birthday,
    required this.cityCode,
    required this.provinceCode,
  });

  // 定义工厂类
  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      account: json['account'] ?? '',
      mobile: json['mobile'] ?? '',
      token: json['token'] ?? '',
      avatar: json['avatar'] ?? '',
      nickname: json['nickname'] ?? '',
      gender: json['gender'] ?? '',
      birthday: json['birthday'] ?? '',
      cityCode: json['cityCode'] ?? '',
      provinceCode: json['provinceCode'] ?? '',
    );
  }

  // 定义 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account': account,
      'mobile': mobile,
      'token': token,
      'avatar': avatar,
      'nickname': nickname,
      'gender': gender,
      'birthday': birthday,
      'cityCode': cityCode,
      'provinceCode': provinceCode,
    };
  }
}
