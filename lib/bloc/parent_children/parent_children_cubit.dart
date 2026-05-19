import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/api_service/api_services.dart';
import 'package:kido/config/children_store.dart';
import 'package:kido/data/lesson_catalog.dart';

part 'parent_children_state.dart';

class ParentChildrenCubit extends Cubit<ParentChildrenState> {
  ParentChildrenCubit() : super(ParentChildrenInitial());

  Future<void> loadChildren() async {
    emit(ParentChildrenLoading());

    try {
      // نجيب الـ API أولاً عشان نضمن إن allowedLevel محدث دايماً
      final api = await ApiService.fetchMyChildren();
      print('API Response: $api');

      if (api != null && api['success'] == true && api['data'] is List) {
        final local = await ChildrenStore.load();
        final merged = _mergeApiWithLocal(api['data'] as List<dynamic>, local);
        await ChildrenStore.save(merged);
        emit(ParentChildrenReady(merged));
        return;
      }

      // API فشل — fallback للـ local
      final local = await ChildrenStore.load();
      final notice =
          api == null
              ? 'Could not refresh. Showing saved children.'
              : (api['message'] is String ? api['message'] as String : null);
      emit(ParentChildrenReady(local, notice: notice));
    } catch (e) {
      final local = await ChildrenStore.load();
      emit(
        ParentChildrenReady(
          local,
          notice: 'Error loading children: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> saveAndEmit(List<Map<String, dynamic>> children) async {
    await ChildrenStore.save(children);
    emit(ParentChildrenReady(children));
  }

  List<Map<String, dynamic>> _mergeApiWithLocal(
    List<dynamic> rawList,
    List<Map<String, dynamic>> local,
  ) {
    return rawList.map((raw) {
      final m = Map<String, dynamic>.from(raw as Map);
      final id = m['id'];
      Map<String, dynamic>? prev;
      for (final c in local) {
        if (c['id'] == id) {
          prev = c;
          break;
        }
      }

      final progressMap = m['progress'];
      final completedCount =
          progressMap is Map && progressMap['completedLessons'] != null
              ? (progressMap['completedLessons'] as num).toInt()
              : 0;

      // allowedLevel بييجي من الـ API مباشرة
      final level =
          (m['allowedLevel'] as num?)?.toInt() ??
          (prev?['allowedLevel'] as int?) ??
          (prev?['level'] as int?) ??
          1;

      final expectedLessons = LessonCatalog.totalLessonsUpToLevel(level);
      double score01 =
          expectedLessons > 0
              ? (completedCount / expectedLessons).clamp(0.0, 1.0)
              : 0.0;

      final assessment = m['latestAssessment'];
      if (assessment is Map && assessment['score'] != null && score01 == 0) {
        score01 =
            ((assessment['score'] as num).toDouble()).clamp(0, 100) / 100.0;
      }

      return <String, dynamic>{
        'id': id,
        'name': m['name'] as String? ?? '',
        'username': m['username'],
        'level': level,
        'allowedLevel':
            level, // ← التعديل: نحفظه بالاسمين عشان أي widget يلاقيه
        'avatar': prev?['avatar'] as String?,
        'score': score01,
        'completedLessons': completedCount,
        'expectedLessons': expectedLessons,
        if (assessment is Map) 'latestAssessment': assessment,
        if (m['progress'] is Map) 'progress': m['progress'],
      };
    }).toList();
  }
}
