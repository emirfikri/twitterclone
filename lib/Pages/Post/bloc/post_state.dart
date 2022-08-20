part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class Loading extends PostState {}

class GetPostLoaded extends PostState {
  final Stream allpost;
  const GetPostLoaded({required this.allpost});
}

class PostAdd extends PostState {}

class PostEdit extends PostState {}

class PostDelete extends PostState {}

// If any error occurs the state is changed to AuthError.
class PostError extends PostState {
  final String error;

  const PostError({required this.error});
}
