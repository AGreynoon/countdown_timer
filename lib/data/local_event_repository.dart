import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event.dart';

class LocalEventRepository {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        target_date TEXT NOT NULL,
        category TEXT NOT NULL,
        display_units TEXT NOT NULL
      )
    ''');
    
    // Insert initial events as shown in the UI mockup
    final parisEvent = Event(
      id: "paris_adventure",
      title: "Paris Adventure",
      targetDate: DateTime.now().add(const Duration(days: 154, hours: 14, minutes: 32, seconds: 45)),
      category: "Orange",
      displayUnits: {
        "Years": true,
        "Months": true,
        "Weeks": true,
        "Days": true,
        "Hours": true,
        "Minutes": true,
        "Seconds": true,
      },
    );
    await db.insert('events', parisEvent.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    
    final graduationEvent = Event(
      id: "graduation_day",
      title: "Graduation Day",
      targetDate: DateTime.now().add(const Duration(days: 35, hours: 8)),
      category: "White",
      displayUnits: {
        "Years": false,
        "Months": false,
        "Weeks": false,
        "Days": true,
        "Hours": true,
        "Minutes": false,
        "Seconds": false,
      },
    );
    await db.insert('events', graduationEvent.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    final weddingEvent = Event(
      id: "wedding_anniversary",
      title: "Wedding Anniversary",
      targetDate: DateTime.now().add(const Duration(days: 148, hours: 2)),
      category: "Orange",
      displayUnits: {
        "Years": false,
        "Months": false,
        "Weeks": false,
        "Days": true,
        "Hours": true,
        "Minutes": false,
        "Seconds": false,
      },
    );
    await db.insert('events', weddingEvent.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Event?> getEvent(String id) async {
    final db = await database;
    final maps = await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Event>> getEvents() async {
    final db = await database;
    final result = await db.query('events');
    return result.map((map) => Event.fromMap(map)).toList();
  }

  Future<void> insertEvent(Event event) async {
    final db = await database;
    await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEvent(Event event) async {
    final db = await database;
    await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(String id) async {
    final db = await database;
    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
