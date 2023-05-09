import 'package:media_tracker/models/book.dart';
import 'package:media_tracker/models/game.dart';
import 'package:media_tracker/models/movie.dart';
import 'package:media_tracker/models/tvshow.dart';
import 'package:media_tracker/repository/entry_repository.dart';
import 'package:media_tracker/repository/impl/entry_repository_impl.dart';

class DummyData {
  late EntryRepository<Book> bookRepository;
  late EntryRepository<Movie> movieRepository;
  late EntryRepository<Show> showRepository;
  late EntryRepository<Game> gameRepository;
  List<String> tags = ['tag1', 'tag2', 'tag3'];

  DummyData() {
    bookRepository = EntryRepositoryImpl<Book>();
    movieRepository = EntryRepositoryImpl<Movie>();
    gameRepository = EntryRepositoryImpl<Game>();
    showRepository = EntryRepositoryImpl<Show>();
    bookRepository.add(
      new Book(
          title: 'bookTitle1',
          author: 'author1',
          comment: 'comment',
          description: ' asdasd',
          isbn: '123321123',
          numberOfPages: 20000,
          publisher: 'okpublishing',
          rating: 1203.3038,
          tags: [],
          image:
              'https://mig-mbh.de/en-GB/wp-content/uploads/sites/4/2019/05/MIG-65-Putz-800px-200x200.jpg'),
    );
    bookRepository.add(
      new Book(
          title: 'bookTitle2',
          author: 'author1',
          comment: 'comment',
          description: ' asdasd',
          isbn: '123321123',
          numberOfPages: 20000,
          publisher: 'okpublishing',
          rating: 2.38,
          tags: [],
          image:
              'https://mig-mbh.de/en-GB/wp-content/uploads/sites/4/2019/05/MIG-65-Putz-800px-200x200.jpg'),
    );
    movieRepository.add(
      new Movie(
        title: 'broo',
        description: 'description',
        comment: 'comment',
        rating: 0,
        image: 'image',
        tags: const [],
        director: 'director',
      ),
    );
  }
}
