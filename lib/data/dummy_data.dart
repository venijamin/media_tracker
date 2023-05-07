import 'package:media_tracker/models/book.dart';
import 'package:media_tracker/models/movie.dart';
import 'package:media_tracker/repository/repository.dart';
import 'package:media_tracker/repository/repository_impl.dart';

class DummyData {
  late Repository<Book> bookRepository;
  late Repository<Movie> movieRepository;

  DummyData() {
    bookRepository = RepositoryImpl<Book>();
    movieRepository = RepositoryImpl<Movie>();

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
