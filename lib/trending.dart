class Trending {
  late final int page;
  late final List<Results> results;
  late final int totalPages;
  late final int totalResults;

  Trending(
      {required this.page,
      required this.results,
      required this.totalPages,
      required this.totalResults});

  Trending.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results.add(Results.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }
}

class Results {
  late final bool adult;
  late final String backdropPath;
  late final int id;
  late final String title;
  late final String originalLanguage;
  late final String originalTitle;
  late final String overview;
  late final String posterPath;
  late final String mediaType;
  late final List<int> genreIds;
  late final double popularity;
  late final String releaseDate;
  late final bool video;
  late final double voteAverage;
  late final int voteCount;

  Results(
      {required this.adult,
      required this.backdropPath,
      required this.id,
      required this.title,
      required this.originalLanguage,
      required this.originalTitle,
      required this.overview,
      required this.posterPath,
      required this.mediaType,
      required this.genreIds,
      required this.popularity,
      required this.releaseDate,
      required this.video,
      required this.voteAverage,
      required this.voteCount});

  Results.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    id = json['id'];
    title = json['title'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    mediaType = json['media_type'];
    genreIds = json['genre_ids'].cast<int>();
    popularity = json['popularity'];
    releaseDate = json['release_date'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }
}
