import 'package:a_reader/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String notes;
  final String photoUrl;
  final String previewLink;
  final String categories;
  final String publishedDate;
  final double rating;
  final String description;
  final int pageCount;
  final Timestamp startedReading;
  final Timestamp finishedReading;
  final String userId;

  Book({
    this.id,
    this.title,
    this.author,
    this.notes,
    this.photoUrl,
    this.previewLink,
    this.categories,
    this.publishedDate,
    this.rating,
    this.description,
    this.pageCount,
    this.startedReading,
    this.finishedReading,
    this.userId,
  });

  factory Book.fromDocument(QueryDocumentSnapshot data) {
    
    return Book(
        id: data.id,
        title: data.get('title'),
        author: data.get('author'),
        notes: data.get('notes'),
        photoUrl: data.get('photo_url'),
        previewLink: data.get('preview_link'),
        categories: data.get('categories'),
        publishedDate: data.get('published_date'),
        rating: parseDouble(data.get('rating')),
        description: data.get('description'),
        pageCount: data.get('page_count'),
        startedReading: data.get('started_reading_at'),
        finishedReading: data.get('finished_reading_at'),
        userId: data.get('user_id')

        //  title: info['title'],
        // author: info['author'],
        // notes: info['notes'],
        // photoUrl: info['photo_url'],
        // categories: info['categories'],
        // publishedDate: info['published_date'],
        // rating: parseDouble(info['rating']),

        // description: info['description'],
        // pageCount: info['page_count'],
        // startedReading: info['started_reading_at'],
        // finishedReading: info['finished_reading_at'],
        // userId: info['user_id']

        );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'user_id': userId,
      'author': author,
      'notes': notes,
      'photo_url': photoUrl,
      'preview_link': previewLink,
      'published_date': publishedDate,
      'rating': rating,
      'description': description,
      'page_count': pageCount,
      'started_reading_at': startedReading,
      'finished_reading_at': finishedReading,
      'categories': categories,
    };
  }
}
