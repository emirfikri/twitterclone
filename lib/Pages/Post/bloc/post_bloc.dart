import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twitterclone/Models/postModel.dart';
import 'package:twitterclone/Pages/Post/Repo/post_repo.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({
    PostModel? initialData,
  }) : super(PostInitial()) {
    on<PostEvent>((event, emit) {
      // TODO: implement event handler
    });

    PostRepo _postRepo = PostRepo();

    on<GetAllPost>((event, emit) {
      emit(Loading());
      try {
        Stream data = _postRepo.getFeed();
        emit(GetPostLoaded(allpost: data));
      } catch (e) {
        emit(PostError(error: e.toString()));
      }
    });

    on<AddPost>((event, emit) async {
      emit(Loading());
      try {
        await _postRepo.savePost(event.text);
      } catch (e) {
        emit(PostError(error: e.toString()));
      }
    });

    on<EditPost>((event, emit) async {
      emit(Loading());
      try {
        await _postRepo.editPost(event.post, event.newText);
      } catch (e) {
        emit(PostError(error: e.toString()));
      }
    });

    on<DeletePost>((event, emit) async {
      emit(Loading());
      try {
        await _postRepo.deletePost(event.post);
        Stream data = _postRepo.getFeed();
        emit(GetPostLoaded(allpost: data));
      } catch (e) {
        emit(PostError(error: e.toString()));
      }
    });
  }
}
