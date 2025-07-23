part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String message;

  ChatError({required this.message});
}

class SendMessageSuccess extends ChatState {
  final ChatEntity chat;

  SendMessageSuccess({required this.chat});
}


