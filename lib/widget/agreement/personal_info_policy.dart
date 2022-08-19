import 'package:flutter/material.dart';

Widget personalInfoPolicy() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text(
        "가. 수집목적",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "1. 정보주체의 동의하에 회원제 서비스 이용 및 제한적 본인 확인제에 따른 본인확인, 개인식별, 불량회원의 부정 이용방지와 비인가 사용방지, 가입의사 확인, 가입 및 가입횟수 제한, 분쟁 조정을 위한 기록보존, 불만처리 등 민원처리, 고지사항 전달"
        "\n2. 정보주체의 동의하에 관련법령에 의거하여 운영정보로 활용",
        style: TextStyle(
          color: Color(0xFF505050),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      Text(
        "\n나. 수집항목",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "\n1. 회원가입, 원활한 상담, 각종 서비스의 제공을 위해 최초 회원가입 당시 아래와 같은 최소한의 개인정보를 필수항목으로 수집하고 있습니다."
        "\n1) 내국인 정보"
        "\n2) 기관정보",
        style: TextStyle(
          color: Color(0xFF505050),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      Text(
        "\n다. 이용 및 보유기간",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "\n1. 정보주체의 동의로 받은날로부터 회원탈퇴시 까지"
        "\n- 단, 관련 법령에서 근거하지 않은 회원 정보일 경우에는 약관에서 명시한 바와 같이 정보주체의 재동의 절차를 거쳐 동의한 경우에만 계속적으로 정보를 보유합니다."
        "\n2. 이용자의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다.",
        style: TextStyle(
          color: Color(0xFF505050),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      Text(
        "\n라. 동의 거부권 및 거부에 대한 불이익",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "정보주체는 개인정보 수집에 대해 동의를 거부할 권리가 있으며, 회원가입에 필요한 최소한의 정보 외의 개인정보 수집에 동의하지 아니한다는 이유로 회원에게 회원가입 불가 및 홈페이지 서비스 거부와 같은 불이익을 주지 않습니다."
        "\n또한 정보주체는 다음과 같은 권리를 행사 할 수 있으며, 만14세 미만 아동의 법정대리인은 그 아동의 개인정보에 대한 열람, 정정·삭제, 처리정지를 요구할 수 있습니다."
        '\n기본적인 개인정보 조회, 수정시에는 "회원정보수정"을 선택하며, 가입해지를 위해서는 "회원탈퇴"를 선택하여 본인확인 절차를 거치신 후 직접 열람, 정정 또는 탈퇴가 가능합니다.',
        style: TextStyle(
          color: Color(0xFF505050),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      Text(
        "\n마. 기타 개인정보보호에 관한 사항은 홈페이지에 공개된 개인정보처리방침을 준수합니다.\n",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
