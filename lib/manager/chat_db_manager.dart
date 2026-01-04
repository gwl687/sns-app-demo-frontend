import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/group_message_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatDbManager {
  static Database? _db;

  //测试用删除
  static void deleteDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat.db');
    await deleteDatabase(path);
  }

  //获取版本号
  static void getDbVersion() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat.db');
    final db = await openDatabase(path, version: 1);
    int version = await db.getVersion();
    print("当前数据库版本号: $version");
  }

  //创建，更新库
  static void createDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat.db');

    _db = await openDatabase(
      path,
      version: 2,
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
        // 群聊消息表
        await db.execute('''
          CREATE TABLE group_messages(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          groupId TEXT,
          fromUser TEXT,
          content TEXT,
          time TEXT
         )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print("更新数据库_插入group_messages");
        // 老用户升级数据库
        await db.execute('''
          CREATE TABLE IF NOT EXISTS group_messages(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          groupId TEXT,
          fromUser TEXT,
          content TEXT,
          time TEXT
        )
      ''');
      },
    );
  }

  //初始化数据库
  static Future<Database> getDb() async {
    if (_db != null) {
      return _db!;
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat.db');
    _db = await openDatabase(
      path,
      version: 2,
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
        // 群聊消息表
        await db.execute('''
          CREATE TABLE group_messages(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          groupId TEXT,
          fromUser TEXT,
          content TEXT,
          time TEXT
         )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print("更新数据库_插入group_messages");
        // 老用户升级数据库
        await db.execute('''
          CREATE TABLE IF NOT EXISTS group_messages(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          groupId TEXT,
          fromUser TEXT,
          content TEXT,
          time TEXT
        )
      ''');
      },
    );
    return _db!;
  }

  // 保存消息
  static Future<void> insertMessage(
    int fromUser,
    int toUser,
    String content, {
    String? createTime,
  }) async {
    final db = await getDb();
    await db.insert('messages', {
      'fromUser': fromUser,
      'toUser': toUser,
      'content': content,
      'time': createTime ?? DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 查询两个人之间的聊天记录
  static Future<List<Map<String, dynamic>>> getPrivateMessages(
    int user1,
    int user2,
  ) async {
    final db = await getDb();
    return await db.query(
      'messages',
      where: '(fromUser = ? AND toUser = ?) OR (fromUser = ? AND toUser = ?)',
      whereArgs: [user1, user2, user2, user1],
      orderBy: 'time ASC',
    );
  }

  //插入群聊消息
  static Future<void> insertGroupMessage(
    int fromUser,
    int groupId,
    String content,
  ) async {
    final db = await getDb();
    await db.insert('group_messages', {
      'fromUser': fromUser,
      'groupId': groupId,
      'content': content,
      'time': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //清空表
  static Future<void> deleteFromTable(String table) async {
    final db = await getDb();
    await db.delete(table);
  }

  //获取某个群的所有消息（按时间升序）
  static Future<List<Map<String, dynamic>>> getGroupMessages(
    int? groupId,
  ) async {
    //本地获取
    final db = await getDb();
    return await db.query(
      'group_messages',
      where: 'groupId = ?',
      whereArgs: [groupId],
      orderBy: 'time ASC',
    );
  }

  //获取最新群消息的时间
  static Future<int?> getGroupMessageLatestId(int? groupId) async {
    final db = await getDb();

    final result = await db.query(
      'group_messages',
      columns: ['id'],
      where: 'groupId = ?',
      whereArgs: [groupId],
      orderBy: 'time DESC',
      // 按时间倒序
      limit: 1, // 只要最新一条
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return null;
    }
  }

  //查询全部
  static Future<List<Map<String, dynamic>>> selectAll(String table) async {
    final db = await getDb();
    return await db.query(table);
  }
}
