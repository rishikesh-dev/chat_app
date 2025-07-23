import 'package:chat_app/feature/home/domain/entity/chat_entity.dart';
import 'package:chat_app/feature/home/domain/use_cases/send_message_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;

  ChatBloc(this.sendMessageUseCase) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await sendMessageUseCase.call(event.message);
    result.fold(
      (failure) => emit(ChatError(message: failure)),
      (chat) => emit(SendMessageSuccess(chat: chat)),
    );
  }
}
