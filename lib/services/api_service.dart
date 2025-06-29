import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://870f-211-59-211-217.ngrok-free.app'; // HTTPS로 변경

  // 카카오 로그인 API
  static Future<Map<String, dynamic>> kakaoLogin(String accessToken) async {
    try {
      final url = Uri.parse('$baseUrl/auth/kakao');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true', // ngrok 경고 무시
        },
        body: jsonEncode({'accessToken': accessToken}),
      );

      print('카카오 로그인 응답 상태: ${response.statusCode}');
      print('카카오 로그인 응답 바디: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 307) {
        // 리다이렉트 처리
        final location = response.headers['location'];
        if (location != null) {
          print('리다이렉트 URL: $location');
          final redirectResponse = await http.post(
            Uri.parse(location),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode({'accessToken': accessToken}),
          );

          if (redirectResponse.statusCode == 200) {
            return jsonDecode(redirectResponse.body);
          } else {
            throw Exception(
              '리다이렉트 후 카카오 로그인 실패: ${redirectResponse.statusCode}',
            );
          }
        } else {
          throw Exception('리다이렉트 URL이 없습니다');
        }
      } else {
        throw Exception(
          '카카오 로그인 실패: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('카카오 로그인 예외: $e');
      throw Exception('카카오 로그인 오류: $e');
    }
  }

  // 사용자 추가 정보 업데이트 API
  static Future<Map<String, dynamic>> updateExtraInfo({
    required int userId,
    required int animalId,
    required List<int> categoryIds,
    required String nickname,
    String? jwt,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/auth/extra-info?userId=$userId');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true', // ngrok 경고 무시
      };

      // JWT 토큰이 있으면 헤더에 추가
      if (jwt != null) {
        headers['Authorization'] = 'Bearer $jwt';
      }

      // categoryIds null 체크 및 기본값 설정
      final safeCategoryIds =
          categoryIds.isNotEmpty ? categoryIds : [1, 2, 3, 4, 5, 6];

      // categoryIds를 Long으로 변환하여 서버와 매칭
      final categoryIdsAsLong =
          safeCategoryIds.map((id) => id.toDouble()).toList();

      print('API 서비스 - categoryIds 처리:');
      print('- 원본: $categoryIds');
      print('- 안전한 값: $safeCategoryIds');
      print('- Long 변환: $categoryIdsAsLong');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'animal_id': animalId,
          'category_ids': categoryIdsAsLong, // Long으로 변환된 값 사용
          'nickname': nickname,
        }),
      );

      print('사용자 정보 업데이트 응답 상태: ${response.statusCode}');
      print('사용자 정보 업데이트 응답 바디: ${response.body}');

      if (response.statusCode == 200) {
        // 빈 응답 처리
        if (response.body.isEmpty) {
          return {'success': true, 'message': '사용자 정보가 성공적으로 업데이트되었습니다.'};
        }

        try {
          return jsonDecode(response.body);
        } catch (e) {
          // JSON 파싱 실패 시에도 성공으로 처리
          return {'success': true, 'message': '사용자 정보가 성공적으로 업데이트되었습니다.'};
        }
      } else {
        throw Exception(
          '사용자 정보 업데이트 실패: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('사용자 정보 업데이트 예외: $e');
      throw Exception('사용자 정보 업데이트 오류: $e');
    }
  }
}
