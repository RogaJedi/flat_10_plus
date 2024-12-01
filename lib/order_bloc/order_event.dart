import 'package:equatable/equatable.dart';
import 'package:flat_10plus/models/order.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadOrders extends OrderEvent {
  final int userId;

  const LoadOrders(this.userId);

  @override
  List<Object> get props => [userId];
}

class CreateOrder extends OrderEvent {}