import 'package:dio/dio.dart';

const kBaseUrl = 'https://api.themoviedb.org/3';
const kApiKey =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMTdmYjI5NzM2MTBkMmUyYTNlNjk2NDc5ZDNjZDMxZCIsInN1YiI6IjYwNDYzYThiZmFiM2ZhMDA1NzIxOWRhMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.k97-3Q_bnC_G2CBV2bo_rfbFRQ7Z2TYesc2RBgsm_xk';
const kLanguage = 'pt-BR';

const kServerError =
    'Falha ao conectar com o servidor. Tente novamente mais tarde.';
final kDioOptions = BaseOptions(
  baseUrl: kBaseUrl,
  connectTimeout: 5000,
  receiveTimeout: 3000,
  contentType: 'application/json;charset=utf-8',
  headers: {'Authorization': 'Bearer $kApiKey'},
);
