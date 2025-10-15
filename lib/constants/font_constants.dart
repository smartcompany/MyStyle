/// 폰트 사이즈 상수 정의
/// UI 일관성과 유지보수성을 위해 모든 폰트 사이즈를 중앙에서 관리합니다.
class FontConstants {
  FontConstants._();

  // === AI 스타일링 결과 화면 ===

  // 섹션 타이틀 (예: "체형 분석 결과", "현재 스타일 분석", "추천 아이템" 등)
  static const double aiResultSectionTitle = 18.0;

  // 상세 내용 (예: "체형: 직사각형 • 키: 중간", "현재 스타일: ...", 추천 아이템 목록 등)
  static const double aiResultDetailText = 16.0;

  // 신뢰도, 소제목 등 작은 텍스트
  static const double aiResultSubText = 16.0;

  // === 공통 UI ===

  // 앱바 타이틀
  static const double appBarTitle = 20.0;

  // 버튼 텍스트
  static const double buttonText = 16.0;

  // 일반 본문 텍스트
  static const double bodyText = 15.0;

  // 작은 텍스트 (캡션, 부가 정보 등)
  static const double captionText = 14.0;
}
