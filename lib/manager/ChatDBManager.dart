import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatDbManager {
  static Database? _db;

  // 初始化数据库
  static Future<Database> getDb() async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fromUser TEXT,
            toUser TEXT,
            content TEXT,
            time TEXT
          )
        ''');
      },
    );

    return _db!;
  }

  //获取当前用户id
  // static String getUserId() async{
  //
  // }

  // 保存消息
  static Future<void> insertMessage(
    String fromUser,
    String toUser,
    String content,
  ) async {
    final db = await getDb();
    await db.insert('messages', {
      'fromUser': fromUser,
      'toUser': toUser,
      'content': content,
      'time': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 查询两个人之间的聊天记录
  static Future<List<Map<String, dynamic>>> getMessages(
    String user1,
    String user2,
  ) async {
    final db = await getDb();
    return await db.query(
      'messages',
      where: '(fromUser = ? AND toUser = ?) OR (fromUser = ? AND toUser = ?)',
      whereArgs: [user1, user2, user2, user1],
      orderBy: 'time ASC',
    );
  }
  //查询全部
  static Future<List<Map<String, dynamic>>> selectAll() async {
    final db = await getDb();
    return await db.query('messages');
  }
}
