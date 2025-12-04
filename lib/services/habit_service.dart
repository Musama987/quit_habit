import 'package:cloud_firestore/cloud_firestore.dart';

class HabitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Set the initial start date for the habit
  Future<void> setStartDate(String userId, DateTime date) async {
    // Normalize date to midnight to avoid time issues
    final normalizedDate = DateTime(date.year, date.month, date.day);

    await _firestore.collection('users').doc(userId).set({
      'startDate': Timestamp.fromDate(normalizedDate),
      'relapseDates': [], // Reset relapses when starting fresh
      'lastRelapseDate': null, // Clear last relapse
    }, SetOptions(merge: true));
  }

  // Report a relapse on a specific date
  Future<void> reportRelapse(
    String userId,
    DateTime date, {
    String? reason,
  }) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // We store relapse as an object now to include reason
    final relapseData = {
      'date': Timestamp.fromDate(normalizedDate),
      'reason': reason ?? 'No reason provided',
    };

    await _firestore.collection('users').doc(userId).update({
      // We can't easily use arrayUnion for objects if we don't have the exact object to remove/check uniqueness easily
      // But for now, let's just add it.
      // Actually, to keep it simple with the previous implementation which expected a list of timestamps,
      // we should probably keep 'relapseDates' as a list of timestamps for easy querying,
      // and maybe store 'relapseHistory' as a separate collection or field for detailed info.
      // For this request, let's update 'relapseDates' (timestamps) AND 'relapseHistory' (details).
      'relapseDates': FieldValue.arrayUnion([
        Timestamp.fromDate(normalizedDate),
      ]),
      'relapseHistory': FieldValue.arrayUnion([relapseData]),
    });
  }

  Stream<DocumentSnapshot> getUserHabitStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }
}
