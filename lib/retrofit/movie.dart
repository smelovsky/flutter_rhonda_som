import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

//terminal> flutter pub run build_runner build
//terminal> dart run build_runner build

part 'movie.g.dart';

@RestApi()
abstract class MovieRestClient {
  factory MovieRestClient(Dio dio, {String baseUrl}) = _MovieRestClient;

  @GET('/marvel')
  Future<List<MovieData>> getMovieList();
}

@JsonSerializable()
class MovieData {
  const MovieData({
    this.name,
    this.realname,
    this.team,
    this.firstappearance,
    this.createdby,
    this.publisher,
    this.imageurl,
    this.bio, });

  factory MovieData.fromJson(Map<String, dynamic> json) => _$MovieDataFromJson(json);

  final String? name;
  final String? realname;
  final String? team;
  final String? firstappearance;
  final String? createdby;
  final String? publisher;
  final String? imageurl;
  final String? bio;



  Map<String, dynamic> toJson() => _$MovieDataToJson(this);
}