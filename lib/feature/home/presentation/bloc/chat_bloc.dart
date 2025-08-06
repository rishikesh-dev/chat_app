import 'package:chat_app/feature/home/domain/entity/chat_entity.dart';
import 'package:chat_app/feature/home/domain/use_cases/send_message_use_case.dart';
import 'package:chat_app/feature/home/domain/use_cases/stream_messages_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final StreamMessagesUseCase streamMessagesUseCase;

  ChatBloc(this.sendMessageUseCase, this.streamMessagesUseCase)
    : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<StreamMessageEvent>(_onStreamMessage);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final result = await sendMessageUseCase.call(event.message);

    result.fold(
      (failure) => emit(ChatError(message: failure)), // Only emit error
      (_) => null, // 🔥 Let Firestore stream handle updates
    );
  }

  Future<void> _onStreamMessage(
    StreamMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading()); // Only once when the stream starts

    await emit.forEach<Either<String, List<ChatEntity>>>(
      streamMessagesUseCase.call(),
      onData: (result) {
        return result.fold(
          (failure) => ChatError(message: failure),
          (chats) => StreamMessageSuccess(chats: chats),
        );
      },
      onError: (error, _) => ChatError(message: error.toString()),
    );
  }
}
