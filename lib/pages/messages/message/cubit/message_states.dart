
import '../../../../common/entities/message.dart';

class MessageStates {
  const MessageStates({this.message = const <Message>[], this.loadStatus = true});

  final List<Message>message; //You could add the late modifier to it ie late final....., or you could simply initialize them this.message..... etc. as shown above with const MessageStates();.
  final bool loadStatus;

  MessageStates copyWith({List<Message>? message,  bool? loadStatus}){
    return MessageStates(message: message??this.message, loadStatus: loadStatus??this.loadStatus);
  }
}
