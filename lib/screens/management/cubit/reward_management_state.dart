part of 'reward_management_cubit.dart';

@freezed
class RewardManagementState with _$RewardManagementState {
  const factory RewardManagementState.initial() = _Initial;
  const factory RewardManagementState.loading() = _Loading;
  const factory RewardManagementState.loaded(HistoryPointModel historyPoints) =
      _Loaded;
  const factory RewardManagementState.error(String message) = _Error;
  const factory RewardManagementState.unauthorized() = _Unauthorized;
}
