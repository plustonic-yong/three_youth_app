import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/signup_agreement_provider.dart';
import 'package:three_youth_app/screens/signup/signup_screen.dart';

class SignupAgreementScreen extends StatefulWidget {
  const SignupAgreementScreen({Key? key}) : super(key: key);

  @override
  State<SignupAgreementScreen> createState() => _SignupAgreementScreenState();
}

class _SignupAgreementScreenState extends State<SignupAgreementScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    PageController _pageController = PageController(initialPage: 0);
    bool _isInfoAgreeChecked =
        context.watch<SignupAgreementProvider>().isInfoAgreeChecked;
    bool _isTermsAgreeChecked =
        context.watch<SignupAgreementProvider>().isTermsAgreeChecked;
    int _currentPage = context.watch<SignupAgreementProvider>().currentPage;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          _currentPage == 0 ? '이용약관' : '개인정보 처리방침',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                pageSnapping: false,
                onPageChanged: (page) {
                  context
                      .read<SignupAgreementProvider>()
                      .onChangeAgreementCurrentPage(page: page);
                },
                children: [
                  SingleChildScrollView(
                    child: _useOfTerms(),
                  ),
                  SingleChildScrollView(
                    child: _personalInfoPolicy(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 160.0,
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            decoration: const BoxDecoration(
              color: Color(0xff464646),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_currentPage == 0) {
                      context
                          .read<SignupAgreementProvider>()
                          .onChangeInfoAgree();
                    } else {
                      context
                          .read<SignupAgreementProvider>()
                          .onChangeTermsAgree();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: _currentPage == 0
                            ? Icon(
                                Icons.check,
                                color: _isInfoAgreeChecked
                                    ? Colors.black
                                    : Colors.transparent,
                              )
                            : Icon(
                                Icons.check,
                                color: _isTermsAgreeChecked
                                    ? Colors.black
                                    : Colors.transparent,
                              ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        '위 약관에 동의합니다.',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //이전 버튼
                    _currentPage != 0
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutSine,
                                );
                              });
                            },
                            child: Container(
                              width: width * 0.38,
                              height: height * 0.053,
                              decoration: BoxDecoration(
                                color: const Color(0xffffffff).withOpacity(0.3),
                                boxShadow: const [
                                  BoxShadow(
                                    // ignore: use_full_hex_values_for_flutter_colors
                                    color: Color(0xff00000029),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    // changes position of shadow
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: const Center(
                                child: Text(
                                  '이전',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    _currentPage == 1
                        ? const SizedBox(width: 15.0)
                        : Container(),
                    //다음 버튼
                    GestureDetector(
                      onTap: () {
                        if (_currentPage == 0) {
                          if (!_isInfoAgreeChecked) return;

                          setState(() {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          });
                        } else {
                          if (!_isTermsAgreeChecked) return;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignupScreen()));
                        }
                      },
                      child: Container(
                        width: _currentPage == 0 ? width * 0.68 : width * 0.38,
                        // width: double.infinity,
                        height: height * 0.053,
                        decoration: _currentPage == 0
                            ? _isInfoAgreeChecked
                                ? BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [
                                        0.05,
                                        0.5,
                                      ],
                                      colors: [
                                        Color(0xff46DFFF),
                                        Color(0xff00B1E9),
                                      ],
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        // ignore: use_full_hex_values_for_flutter_colors
                                        color: Color(0xff00000029),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                          0,
                                          3,
                                        ), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(25.0),
                                  )
                                : BoxDecoration(
                                    color: const Color(0xffffffff)
                                        .withOpacity(0.3),
                                    boxShadow: const [
                                      BoxShadow(
                                        // ignore: use_full_hex_values_for_flutter_colors
                                        color: Color(0xff00000029),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        // changes position of shadow
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(25.0),
                                  )
                            : _isTermsAgreeChecked
                                ? BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [
                                        0.05,
                                        0.5,
                                      ],
                                      colors: [
                                        Color(0xff46DFFF),
                                        Color(0xff00B1E9),
                                      ],
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        // ignore: use_full_hex_values_for_flutter_colors
                                        color: Color(0xff00000029),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                          0,
                                          3,
                                        ), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(25.0),
                                  )
                                : BoxDecoration(
                                    color: const Color(0xffffffff)
                                        .withOpacity(0.3),
                                    boxShadow: const [
                                      BoxShadow(
                                        // ignore: use_full_hex_values_for_flutter_colors
                                        color: Color(0xff00000029),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        // changes position of shadow
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                        child: const Center(
                          child: Text(
                            '다음',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget _useOfTerms() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text(
        "제1장 총칙",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "제 1 조 (목적)"
        "\n① 본 이용약관(이하 '약관')은 위드케어시스템 (이하 '시스템')가 제공하는 모든 서비스(이하 '서비스')의 이용조건 및 절차, 이용자와 시스템의 권리, 의무 및 책임사항과 기타 필요한 사항을 규정함을 목적으로 합니다."
        "\n② 이 약관은 이용 기본 약관에 적용됩니다."
        "\n제 2 조 (약관의 효력과 변경)"
        "\n① 시스템은 이 약관의 내용과 주소지, 관리자의 성명, 개인정보보호 담당자의 성명, 연락처(전화, 팩스, 전자우편 주소 등) 등을 이용자가 알 수 있도록 시스템의 초기 서비스화면에 게시합니다."
        "\n② 시스템은 개인정보보호법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률, 약관의규제에관한법률, 전기통신기본법, 전기통신사업법, 정보통신윤리위원회심의규정, 정보통신윤리강령, 프로그램보호법 등 관계법령을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다."
        "\n③ 시스템은 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행약관과 함께 시스템의 초기화면에 그 적용일자 7일이전부터 적용일자 전일까지 공지하며, 적용일에 효력이 발생합니다."
        "\n④ 변경된 약관의 부지로 인한 회원의 피해는 시스템에서 책임지지 않습니다."
        "\n⑤ 회원은 변경된 약관에 동의하지 않을 경우 탈퇴(해지) 할 수 있으며, 변경된 약관의 효력 발생일로부터 7일이내에 거부의사를 표시하지 아니하고 서비스를 계속 사용할 경우 변경된 약관에 동의한 것으로 간주합니다."
        "\n제 3 조 (용어의 정의)"
        "\n① 본 약관에서 사용하는 용어의 정의는 다음과 같습니다."
        "\n(1) 이용자 : 본 약관에 따라 시스템이 제공하는 서비스를 받는 자를 말합니다."
        "\n(2) 이용계약 : 서비스 이용과 관련하여 시스템과 이용자간에 체결하는 계약을 말합니다."
        "\n(3) 회원 : 시스템에 개인정보를 제공하고, 서비스를 이용하기 위해 시스템과 이용계약을 체결하려고 하는 자를 말합니다."
        "\n(4) 이용자번호(ID) : 이용자의 식별과 이용자의 서비스 이용을 위하여 이용자가 선정하고 시스템이 부여하는 문자와 숫자의 조합을 말합니다."
        "\n(5) 비밀번호 : 이용자가 등록회원과 동일인인지 신원을 확인하고 통신상의 자신의 개인정보보호를 위하여 이용자 자신이 선정한 문자와 숫자의 조합을 말합니다."
        "\n(6) 탈퇴(해지) : 시스템 또는 이용자가 이용계약을 해약하는 것을 말합니다."
        "\n② 본 약관에서 사용하는 용어의 정의는 제1항에서 정하는 것을 제외하고는 관계법령, 개별서비스에 대한 별도약관 및 이용규정에서 정의합니다.",
        style: TextStyle(
          color: Color(0xFF505050),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      Text(
        "\n제 2 장 이용계약의 성립 및 해지",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "제 4 조 (이용계약의 성립)"
        "\n① 이용계약은 이용자가 본 약관 내용에 대한 동의와 이용신청에 대하여 시스템의 이용승낙으로 성립합니다."
        "\n② 본 이용약관에 대한 동의는 이용신청 당시 해당 시스템 웹의 '동의함' 을 선택함으로써 의사표시를 합니다."
        '\n③ 이용고객이 이 약관에 따라 서비스 이용을 신청을 하는 것은 시스템이 제정한 "개인정보보호방침", "저작권정책" 등 각종 정책에 대해 동의한 것으로 간주됩니다. ("개인정보보호방침", "저작권정책"에 관한 자세한 내용은 시스템에서 확인하시기 바랍니다).'
        "\n제 5 조 (개인정보의 보호 및 사용)"
        "\n① 시스템은 관계법령이 정하는 바에 따라 이용자 등록정보를 포함한 이용자의 개인정보를 보호하기 위해 노력합니다."
        "\n② 이용자 개인정보는 관련법령 및 시스템의 개인정보 보호방침이 적용됩니다. 단, 시스템이 운영하는 웹페이지에 포함된 링크 또는 배너를 클릭하여 다른 사이트로 옮겨갈 경우 시스템의 개인정보 보호방침이 적용되지 않습니다."
        "\n③ 시스템의 회원 정보는 다음과 같이 수집, 사용, 관리, 보호됩니다."
        "\n(1) 개인정보의 수집 : 시스템은 회원가입 시 회원이 제공하는 정보를 통하여 회원의 정보를 수집합니다. 또한, 이용자의 동의 없이 주민등록번호, 외국인등록번호 등 고유식별정보를 수집·보관하지 않습니다."
        "\n(2) 개인정보의 사용 : 국가기관의 요구 또는 기타 관계법령에서 정한 절차에 따른 요청이 있는 경우를 제외하고 시스템 서비스 제공과 관련하여 수집된 회원의 신상정보를 본인의 승낙 없이 제3자에게 누설, 배포하지 않습니다."
        "\n(3) 개인정보의 관리 : 회원은 개인정보의 보호 및 관리를 위하여 수시로 회원의 개인정보를 수정/삭제할 수 있습니다. 수신되는 정보 중 불필요하다고 생각되는 부분도 변경/조정할 수 있습니다."
        "\n(4) 개인정보의 보호 : 회원의 개인정보는 오직 회원만이 열람/수정/삭제 할 수 있으며, 이는 전적으로 회원의 이용자ID와 비밀번호에 의해 관리되고 있습니다. 따라서 타인에게 회원의 이용자ID와 비밀번호를 알려주어서는 안되며, 작업 종료 시에는 반드시 로그아웃 하고, 웹 브라우저의 창을 닫아야 합니다.(이는 타인과 컴퓨터를 공유하는 인터넷 카페나 도서관 같은 공공장소에서 컴퓨터를 사용하는 경우에 회원의 정보보호를 위하여 필요한 사항입니다)"
        "\n④ 회원이 시스템의 약관에 따라 이용신청을 하는 것은 시스템이 본 약관에 따라 신청서에 기재된 회원정보를 수집, 이용하는 것에 동의하는 것으로 간주됩니다."
        "\n제 6 조 (사용자의 정보 보안)"
        "\n① 시스템은 회원의 귀책사유로 인해 노출된 정보에 대해서 일체의 책임을 지지 않습니다."
        "\n② 회원의 이용자ID나 비밀번호가 부정하게 사용되었다는 사실을 발견한 경우에는 즉시 시스템에 신고하여야 합니다.신고를 하지 않음으로 인해 발생하는 모든 책임은 회원 본인에게 있습니다."
        "\n③ 회원은 시스템 서비스의 사용 종료 시 마다 정확히 로그아웃(Log-out)해야 하며, 로그아웃하지 아니하여 제3자가 회원에 관한 정보를 도용하는 등의 결과로 인해 발생하는 손해 및 손실에 대하여 시스템은 책임을 부담하지 아니합니다."
        "\n제 7 조 (이용 신청 및 제한)"
        "\n① 회원가입은 신청자가 온라인으로 시스템에서 제공하는 소정의 가입신청 양식에서 요구하는 사항을 기록하여 가입을 완료하는 것으로 성립됩니다."
        "\n② 시스템은 만 14세미만의 아동은 회원으로 가입할 수 없습니다."
        "\n③ 시스템은 다음 각 호에 해당하는 회원가입에 대하여는 가입을 취소할 수 있습니다."
        "\n(1) 다른 사람의 명의를 사용하여 신청하였을 때"
        "\n(2) 회원가입 신청서의 내용을 허위로 기재하였거나 신청하였을 때"
        "\n(3) 사회의 안녕 질서 혹은 미풍양속을 저해할 목적으로 신청하였을 때"
        "\n(4) 다른 사람의 시스템 서비스 이용을 방해하거나 그 정보를 도용하는 등의 행위를 하였을 때"
        "\n(5) 시스템을 이용하여 법령과 본 약관이 금지하는 행위를 하는 경우"
        "\n(6) 기타 시스템이 정한 회원가입요건이 미비 되었을 때"
        "\n④ 시스템은 다음 각 항에 해당하는 경우 그 사유가 해소될 때까지 이용계약 성립을 유보할 수 있습니다."
        "\n(1) 서비스 관련 제반 용량이 부족한 경우"
        "\n(2) 기술상 장애 사유가 있는 경우"
        "\n⑤ 시스템은 자체 개발하거나 다른 기관과의 협의 등을 통해 서비스를 제공하며, 서비스의 내용 변경 시 이용자에게 공지하고 변경하여 제공할 수 있습니다."
        "\n제 8 조 (이용자ID 부여 및 변경 등)"
        "\n① 시스템은 이용자에 대하여 약관에 정하는 바에 따라 이용자 ID를 부여합니다."
        "\n② 이용자ID는 원칙적으로 변경이 불가하며 부득이한 사유로 인하여 변경 하고자 하는 경우에는 해당 ID를 해지하고 재가입해야 합니다. 단, 다음 각 호에 해당하는 경우에는 정보주체 또는 시스템의 요청으로 변경할 수 있습니다."
        "\n(1) 이용자ID가 이용자의 전화번호 등으로 등록되어 사생활침해가 우려되는 경우"
        "\n(2) 타인에게 혐오감을 주거나 미풍양속에 저해할 목적으로 신청한 경우"
        "\n(3) 기타 합리적인 사유가 있는 경우"
        "\n③ 서비스 이용자ID 및 비밀번호의 관리책임은 회원에게 있습니다. 이를 소홀히 관리하여 발생하는 서비스 이용상의 손해 또는 제3자에 의한 부정이용 등에 대한 책임은 회원에게 있으며 시스템은 그에 대한 책임을 일절 지지 않습니다."
        "\n④ 기타 이용자 개인정보 관리 및 변경 등에 관한 사항은 시스템이 정하는 바에 의합니다.",
        style: TextStyle(
          color: Color(0xFF505050),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      Text(
        "\n제 3 장 서비스의 이용 및 이용제한",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "제 9 조 (서비스 이용시간)"
        "\n① 서비스 이용시간은 시스템의 업무상 또는 기술상 특별한 지장이 없는 한 연중무휴, 1일 24시간을 원칙으로 합니다."
        "\n② 제1항의 이용시간 중 정기점검 등의 필요로 인하여 시스템이 정한 날 또는 시간은 예외로 합니다."
        "\n제 10 조 (서비스의 중지 및 중지에 대한 공지)"
        "\n① 이용자는 시스템 서비스에 보관/전송된 메시지의 내용이 국가의 비상사태, 시스템의 관리 범위 외의 서비스 설비 장애 및 기타 불가항력에 의하여 보관/삭제/전송/ 손실이 있을 경우에 시스템은 관련 책임을 부담하지 아니합니다."
        "\n② 천재지변, 국가비상사태 등 시스템이 정상적인 서비스 제공이 불가능할 경우 일시적으로 서비스를 제한, 중지시킬 수 있으며 사전 또는 사후 회원에게 중지사유 및 기간을 공지합니다."
        "\n③ 시스템의 사정으로 서비스를 영구적으로 중단하여야 할 경우에는 사전 공지기간은 1개월로 합니다."
        "\n④ 시스템은 긴급한 시스템 점검, 증설 및 교체 등 부득이한 사유로 인하여 예고 없이 일시적으로 서비스를 중단할 수 있으며, 새로운 서비스로의 교체 등 시스템이 적절하다고 판단하는 사유에 의하여 현재 제공되는 서비스를 완전히 중단할 수 있습니다."
        "\n⑤ 시스템은 서비스를 특정범위로 분할하여 각 범위별로 이용가능시간을 별도로 지정할 수 있습니다. 다만 이 경우 그 내용을 공지합니다."
        "\n⑥ 시스템이 통제할 수 없는 사유로 인한 서비스중단의 경우(시스템관리자의 고의, 과실 없는 디스크장애, 시스템다운 등)에 사전통지가 불가능하며 타인(PC통신회사, 기간통신사업자 등)의 고의, 과실로 인한 시스템중단 등의 경우에는 통지하지 않습니다."
        "\n⑦ 시스템은 회원이 본 약관의 내용에 위배되는 행동을 한 경우, 임의로 서비스 사용을 제한 및 중지하거나 회원의 동의 없이 이용계약을 해지할 수 있습니다. 이 경우 시스템은 위 이용자의 접속을 금지할 수 있습니다."
        "\n제 11 조 (서비스 이용제한)"
        "\n① 이용자가 제공하는 정보의 내용이 허위인 것으로 판명되거나, 허위가 있다고 의심할 만한 합리적인 사유가 발생할 경우 시스템은 이용자의 본 서비스 사용을 일부 또는 전부 중지할 수 있으며, 이로 인해 발생하는 불이익에 대해 책임을 부담하지 아니합니다."
        "\n② 시스템은 이용자가 본 약관 제16조(이용자의 의무)등 본 약관의 내용에 위배되는 행동을 한 경우, 임의로 서비스 사용을 제한 및 중지할 수 있습니다. 이 경우 시스템은 이용자의 접속을 금지할 수 있습니다. 단, 시스템이 이용자의 이용권한을 상실시키기 위해서는 사전통지를 해야 하고 회원이 이를 시정하거나 소명할 수 있는 기회를 부여해야 합니다."
        "\n제 12 조 (게시물의 관리)"
        "\n① 이용자가 게시한 게시물의 저작권은 이용자가 소유하며, 시스템은 서비스 내에 이를 게시할 수 있는 권리를 갖습니다."
        "\n② 시스템은 다음 각 호에 해당하는 게시물이나 자료를 사전통지 없이 삭제하거나 이동 또는 등록 거부를 할 수 있습니다."
        "\n(1) 본서비스 약관에 위배되거나 상용 또는 불법, 음란, 저속하다고 판단되는 게시물을 게시한 경우"
        "\n(2) 다른 회원 또는 제 3자에게 심한 모욕을 주거나 명예를 손상시키는 내용인 경우"
        "\n(3) 공공질서 및 미풍양속에 위반되는 내용을 유포하거나 링크시키는 경우"
        "\n(4) 불법복제 또는 해킹을 조장하는 내용인 경우"
        "\n(5) 영리를 목적으로 하는 광고일 경우"
        "\n(6) 범죄와 결부된다고 객관적으로 인정되는 내용일 경우"
        "\n(7) 다른 이용자 또는 제 3자의 저작권 등 기타 권리를 침해하는 내용인 경우"
        "\n(8) 시스템에서 규정한 게시물 원칙에 어긋나거나, 게시판 성격에 부합하지 않는 경우"
        "\n(9) 기타 관계법령에 위배된다고 판단되는 경우 . 서비스를 이용하여 얻은 정보를 회사의 사전 승낙 없이 복사, 복제, 변경, 번역, 출판, 방송 기타의 방법으로 사용하거나 이를 타인에게 제공하는 행위"
        "\n③ 이용자의 게시물이 타인의 저작권을 침해함으로써 발생하는 민, 형사상의 책임은 전적으로 이용자가 부담하여야 합니다."
        "\n제 13 조 (게시물에 대한 저작권)"
        "\n① 이용자가 게시한 게시물의 저작권은 게시한 이용자에게 귀속됩니다. 또한 시스템은 게시자의 동의 없이 게시물을 상업적으로 이용할 수 없습니다. 다만 비영리 목적인 경우는 그러하지 아니하며, 또한 서비스내의 게재권을 갖습니다."
        "\n② 이용자는 서비스를 이용하여 취득한 정보를 임의 가공, 판매하는 행위 등 서비스에 게재된 자료를 상업적으로 사용할 수 없습니다."
        "\n③ 시스템은 회원이 게시하거나 등록하는 서비스 내의 내용물, 게시 내용에 대해 제12조 각 호에 해당된다고 판단되는 경우 사전통지 없이 삭제하거나 이동 또는 등록 거부할 수 있습니다."
        "\n제 14 조 (정보 제공 및 홍보물 게재)"
        "\n① 시스템은 서비스를 운영함에 있어서 각종 정보를 홈페이지에 게재하는 방법, 전자우편이나 서신우편 발송 등으로 회원에게 제공할 수 있습니다."
        "\n② 시스템은 서비스에 적절하다고 판단되거나 공익성이 있는 홍보물을 게재할 수 있습니다.",
        style: TextStyle(
          color: Color(0xFF505050),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      Text(
        "\n제 4 장 의무 및 책임",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "제 15 조 (시스템의 의무)"
        "\n① 시스템은 법령과 본 약관이 금지하거나 미풍양속에 반하는 행위를 하지 않으며, 지속적·안정적으로 서비스를 제공하기 위해 노력할 의무가 있습니다."
        "\n② 시스템은 이용자의 개인 신상 정보를 본인의 승낙 없이 제3자에게 누설, 배포하지 않습니다. 다만, 관계법령에 의해 국가기관의 요구나 정보통신윤리위원회의 요청 등 법률의 규정에 따른 적법한 절차에 의한 경우에는 그러하지 아니합니다."
        "\n③ 시스템은 계속적이고 안정적인 서비스의 제공을 위하여 설비에 장애가 생기거나 멸실된 때에는 부득이한 사유가 없는 한 지체 없이 이를 수리 또는 복구합니다."
        "\n④ 시스템은 이용자의 의견이나 불만이 정당하다고 객관적으로 인정될 경우에는 적절한 절차를 거쳐 즉시 처리하여야 합니다. 다만, 즉시 처리가 곤란한 경우는 이용자에게 그 사유와 처리일정을 통보하여야 합니다."
        "\n⑤ 시스템은 이용자의 개인정보보호를 위한 보안시스템을 갖추어야 합니다."
        "\n⑥ 시스템은 이용자의 귀책사유로 인한 서비스 이용 장애에 대하여 책임을 지지 않습니다."
        "\n제 16 조 (이용자의 의무)"
        "\n① 회원가입 신청 및 회원정보 변경 시 요구되는 정보는 사실에 근거하여 기입하여야 합니다. 만약 허위 또는 타인의 정보를 등록할 경우 일체의 권리를 주장할 수 없습니다."
        "\n② 이용자는 시스템 서비스를 이용하여 얻은 정보를 시스템의 사전승낙 없이 복사, 복제, 변경, 번역, 출판, 방송 기타의 방법으로 사용하거나 이를 타인에게 제공할 수 없습니다."
        "\n③ 이용자는 시스템 서비스 이용과 관련하여 다음 각 호의 행위를 하여서는 안됩니다."
        "\n(1) 회원가입 신청 또는 회원정보 변경 시 허위내용을 기재하거나 다른 회원의 비밀번호와 ID를 도용하여 부정 사용하는 행위"
        "\n(2) 저속, 음란, 모욕적, 위협적이거나 타인의 Privacy를 침해할 수 있는 내용을 전송, 게시, 게재, 전자우편 또는 기타의 방법으로 전송하는 행위"
        "\n(3) 시스템 운영진, 직원 또는 관계자를 사칭하는 행위"
        "\n(4) 서비스를 통하여 전송된 내용의 출처를 위장하는 행위"
        "\n(5) 법률, 계약에 의해 이용할 수 없는 내용을 게시, 게재, 전자우편 또는 기타의 방법으로 전송하는 행위"
        "\n(6) 시스템으로부터 특별한 권리를 부여 받지 않고 시스템의 클라이언트 프로그램을 변경하거나, 서버 해킹 및 컴퓨터바이러스 유포, 웹사이트 또는 게시된 정보의 일부분 또는 전체를 임의로 변경하는 행위"
        "\n(7) 타인의 특허, 상표, 영업비밀, 저작권, 기타 지적재산권을 침해하는 내용을 게시, 게재, 전자우편 또는 기타의 방법으로 전송하는행위"
        "\n(8) 시스템의 승인을 받지 아니한 광고, 판촉물, 스팸메일, 행운의 편지, 피라미드 조직 기타 다른 형태의 권유를 게시, 게재, 전자우편 또는 기타의 방법으로 전송하는 행위"
        "\n(9) 다른 사용자의 개인정보를 수집, 저장, 공개하는 행위"
        "\n(10) 범죄행위를 목적으로 하거나 기타 범죄행위와 관련된 행위"
        "\n(11) 선량한 풍속, 기타 사회질서를 해하는 행위"
        "\n(12) 타인의 명예를 훼손하거나 모욕하는 행위"
        "\n(13) 타인의 지적재산권 등의 권리를 침해하는 행위"
        "\n(14) 타인의 의사에 반하여 광고성 정보 등 일정한 내용을 지속적으로 전송하는 행위"
        "\n(15) 서비스의 안정적인 운영에 지장을 주거나 줄 우려가 있는 일체의 행위"
        "\n(16) 시스템에 게시된 정보의 변경"
        "\n(17) 본 약관을 포함하여 기타 시스템이 정한 제반 규정 또는 이용 조건을 위반하는 행위"
        "\n(18) 기타 관계법령에 위배되는 행위",
        style: TextStyle(
          color: Color(0xFF505050),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      Text(
        "\n제 5 장 계약 변경 및 해지",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "제 17 조 (계약 변경 및 해지)"
        "\n① 회원이 이용계약을 해지하고자 하는 때에는 회원 본인이 시스템 [회원정보관리>회원탈퇴] 메뉴를 통해 가입해지를 해야 합니다."
        "\n② 회원탈퇴를 요청한 경우에는 수집된 개인정보는 개인정보의 수집목적 또는 제공받은 목적이 달성되면 파기하는 것을 원칙으로 합니다."
        "\n③ 관련 법령(산업기술촉진법, 국가연구개발사업의 관리 등에 관한 규정)에서 근거하지 않은 회원 정보를 대상으로 1년을 주기로 정보주체의 재동의 절차를 거쳐 동의한 경우에만 계속적으로 정보를 보유합니다."
        "\n제 18 조 (재동의 절차)"
        "\n① 관련 법령(산업기술촉진법, 국가연구개발사업의 관리 등에 관한 규정)에서 근거하지 않은 회원 정보를 대상으로 조사 당일 최근 1년간 로그인 이력이 없을 경우 재동의 대상자로 구분합니다."
        "\n② 재동의시 해당 내용을 홈페이지에 게재하며 재동의 대상자에게는 전자메일로 안내 합니다. 재동의 기간 동안 홈페이지에 로그인 하여 재동의를 한 경우에만 회원정보를 유지하며, 동의가 없을 경우에는 자동 회원 탈퇴 처리가 진행되며 회원 정보는 영구적으로 파기됩니다. 전자메일 미등록 및 오기재로 인하여 안내 받지 못한 경우 시스템은 책임을 부담하지 아니합니다.",
        style: TextStyle(
          color: Color(0xFF505050),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      Text(
        "\n제 6 장 기 타",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "제 19 조 (시스템 저작권)"
        "\n① 시스템이 제공하는 서비스, 그에 필요한 소프트웨어, 이미지, 마크, 로고, 디자인, 서비스명칭, 정보 및 상표 등과 관련된 지적재산권 및 기타 권리는 시스템에 소유권이 있습니다."
        "\n② 이용자는 시스템이 명시적으로 승인한 경우를 제외하고는 전항의 소정의 각 재산에 대해 전부 혹은 일부 수정, 배포, 상업적 이용 행위 등을 할 수 없으며, 제3자로 하여금 이와 같은 행위를 하도록 허락할 수 없습니다."
        "\n제 20 조 (양도금지)"
        "\n① 회원이 서비스의 이용권한, 기타 이용계약 상 지위를 타인에게 양도, 증여할 수 없으며, 이를 담보로 제공할 수 없습니다."
        "\n제 21 조 (손해배상)"
        "\n① 시스템은 천재지변, 전쟁 및 기타 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 대한 책임이 면제됩니다."
        "\n② 시스템은 기간통신 사업자가 전기통신 서비스를 중지하거나 정상적으로 제공하지 아니하여 손해가 발생한 경우 책임이 면제됩니다."
        "\n③ 시스템은 서비스용 설비의 보수, 교체, 정기점검, 공사 등 부득이한 사유로 발생한 손해에 대한 책임이 면제됩니다."
        "\n④ 시스템은 이용자의 컴퓨터 오류에 의해 손해가 발생한 경우, 또는 회원이 신상정보 및 전자우편 주소를 부실하게 기재하여 손해가 발생한 경우 책임을 지지 않습니다."
        "\n⑤ 시스템은 서비스에 표출된 어떠한 의견이나 정보에 대해 확신이나 대표할 의무가 없으며 이용자나 제3자에 의해 표출된 의견을 승인하거나 반대하거나 수정하지 않습니다."
        "\n⑥ 시스템은 이용자 또는 기타 유관기관이 서비스에 게재한 정보에 대해 정확성, 신뢰도에 대하여 보장하지 않습니다. 따라서 시스템은 이용자가 위 내용을 이용함으로 인해 입게 된 모든 종류의 손실이나 손해에 대하여 책임을 부담하지 아니합니다."
        "\n⑦ 시스템은 이용자가 서비스를 이용하며 타 이용자로 인해 입게 되는 정신적 피해에 대하여 보상할 책임을 지지 않습니다."
        "\n제 22 조 (관할법원)"
        "\n① 이 약관에 명시되지 않은 사항은 관계법령과 상관습에 따릅니다."
        "\n② 본 서비스 이용으로 발생한 분쟁에 대해 소송이 제기될 경우 시스템 소재지를 관할하는 법원으로 합니다."
        "\n부 칙"
        "\n1. (시행일) 본 약관은 2021년 1월 1일부터 적용합니다.",
        style: TextStyle(
          color: Color(0xFF505050),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      )
    ],
  );
}

Widget _personalInfoPolicy() {
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
