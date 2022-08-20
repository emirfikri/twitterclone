part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class AddPost extends PostEvent {
  final String text;

  const AddPost(
    this.text,
  );
}

class GetAllPost extends PostEvent {}

class EditPost extends PostEvent {
  final PostModel post;
  final String newText;
  const EditPost(
    this.post,
    this.newText,
  );
}

class DeletePost extends PostEvent {
  final PostModel post;

  const DeletePost(
    this.post,
  );
}
