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

  // 오늘의 질문 조회
  static Future<Map<String, dynamic>> fetchTodayQuestion({String? jwt}) async {
    try {
      final url = Uri.parse('$baseUrl/questions/today');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };
      if (jwt != null) {
        headers['Authorization'] = 'Bearer $jwt';
      }

      print('오늘의 질문 조회 요청:');
      print('- URL: $url');
      print('- JWT: $jwt');
      print('- JWT is null: ${jwt == null}');
      print('- JWT isEmpty: ${jwt?.isEmpty}');
      if (jwt != null && jwt.isNotEmpty) {
        print('- Authorization 헤더: Bearer $jwt');
      }

      final response = await http.get(url, headers: headers);

      print('오늘의 질문 조회 응답 상태: ${response.statusCode}');
      print('오늘의 질문 조회 응답 바디: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('서버에서 빈 응답을 반환했습니다.');
        }
        return jsonDecode(response.body);
      } else {
        throw Exception(
          '오늘의 질문 조회 실패: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('오늘의 질문 조회 예외: $e');
      throw Exception('오늘의 질문 조회 오류: $e');
    }
  }

  // 답변 저장
  static Future<void> submitAnswer({
    required int questionId,
    required String content,
    String? jwt,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/questions/answer');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };
      if (jwt != null) {
        headers['Authorization'] = 'Bearer $jwt';
      }

      final body = {'questionId': questionId, 'content': content};

      print('답변 저장 요청:');
      print('- URL: $url');
      print('- JWT: ${jwt != null ? "있음" : "없음"}');
      print('- Body: $body');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print('답변 저장 응답 상태: ${response.statusCode}');
      print('답변 저장 응답 바디: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('답변 저장 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('답변 저장 예외: $e');
      throw Exception('답변 저장 오류: $e');
    }
  }

  // 오늘의 메모 조회
  static Future<Map<String, dynamic>?> fetchTodayMemo({String? jwt}) async {
    try {
      final url = Uri.parse('$baseUrl/memos/today/latest');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };

      // JWT 토큰이 있으면 헤더에 추가
      if (jwt != null) {
        headers['Authorization'] = 'Bearer $jwt';
      }

      print('오늘의 메모 조회 요청:');
      print('- URL: $url');
      print('- JWT: ${jwt != null ? "있음" : "없음"}');
      if (jwt != null && jwt.isNotEmpty) {
        print('- Authorization 헤더: Bearer $jwt');
      }

      final response = await http.get(url, headers: headers);
      print('오늘의 메모 조회 응답 상태: ${response.statusCode}');
      print('오늘의 메모 조회 응답 바디: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('오늘의 메모 조회 예외: $e');
      return null;
    }
  }

  // 히스토리(메모&답변) 리스트 조회
  static Future<List<Map<String, dynamic>>> fetchHistoryList({
    String type = 'all',
    String? jwt,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/history?type=$type');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };

      // JWT 토큰이 있으면 헤더에 추가
      if (jwt != null) {
        headers['Authorization'] = 'Bearer $jwt';
      }

      print('/history 리스트 조회 요청: type=$type');
      print('- URL: $url');
      print('- JWT: ${jwt != null ? "있음" : "없음"}');
      if (jwt != null && jwt.isNotEmpty) {
        print('- Authorization 헤더: Bearer $jwt');
      }

      final response = await http.get(url, headers: headers);
      print('/history 리스트 응답 상태: ${response.statusCode}');
      print('/history 리스트 응답 바디: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print('/history 리스트 조회 예외: $e');
      return [];
    }
  }
}
