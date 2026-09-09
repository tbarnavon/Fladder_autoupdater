// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_download_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateDownloadModel implements DiagnosticableTreeMixin {
  UpdateDownloadStatus get status;
  double get progress;
  String? get errorMessage;

  /// Create a copy of UpdateDownloadModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateDownloadModelCopyWith<UpdateDownloadModel> get copyWith =>
      _$UpdateDownloadModelCopyWithImpl<UpdateDownloadModel>(
          this as UpdateDownloadModel, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'UpdateDownloadModel'))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('progress', progress))
      ..add(DiagnosticsProperty('errorMessage', errorMessage));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UpdateDownloadModel(status: $status, progress: $progress, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $UpdateDownloadModelCopyWith<$Res> {
  factory $UpdateDownloadModelCopyWith(
          UpdateDownloadModel value, $Res Function(UpdateDownloadModel) _then) =
      _$UpdateDownloadModelCopyWithImpl;
  @useResult
  $Res call(
      {UpdateDownloadStatus status, double progress, String? errorMessage});
}

/// @nodoc
class _$UpdateDownloadModelCopyWithImpl<$Res>
    implements $UpdateDownloadModelCopyWith<$Res> {
  _$UpdateDownloadModelCopyWithImpl(this._self, this._then);

  final UpdateDownloadModel _self;
  final $Res Function(UpdateDownloadModel) _then;

  /// Create a copy of UpdateDownloadModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? progress = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as UpdateDownloadStatus,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [UpdateDownloadModel].
extension UpdateDownloadModelPatterns on UpdateDownloadModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UpdateDownloadModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateDownloadModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UpdateDownloadModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateDownloadModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UpdateDownloadModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateDownloadModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            UpdateDownloadStatus status, double progress, String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateDownloadModel() when $default != null:
        return $default(_that.status, _that.progress, _that.errorMessage);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            UpdateDownloadStatus status, double progress, String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateDownloadModel():
        return $default(_that.status, _that.progress, _that.errorMessage);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            UpdateDownloadStatus status, double progress, String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateDownloadModel() when $default != null:
        return $default(_that.status, _that.progress, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _UpdateDownloadModel extends UpdateDownloadModel
    with DiagnosticableTreeMixin {
  _UpdateDownloadModel(
      {this.status = UpdateDownloadStatus.idle,
      this.progress = 0.0,
      this.errorMessage})
      : super._();

  @override
  @JsonKey()
  final UpdateDownloadStatus status;
  @override
  @JsonKey()
  final double progress;
  @override
  final String? errorMessage;

  /// Create a copy of UpdateDownloadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdateDownloadModelCopyWith<_UpdateDownloadModel> get copyWith =>
      __$UpdateDownloadModelCopyWithImpl<_UpdateDownloadModel>(
          this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'UpdateDownloadModel'))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('progress', progress))
      ..add(DiagnosticsProperty('errorMessage', errorMessage));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UpdateDownloadModel(status: $status, progress: $progress, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$UpdateDownloadModelCopyWith<$Res>
    implements $UpdateDownloadModelCopyWith<$Res> {
  factory _$UpdateDownloadModelCopyWith(_UpdateDownloadModel value,
          $Res Function(_UpdateDownloadModel) _then) =
      __$UpdateDownloadModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {UpdateDownloadStatus status, double progress, String? errorMessage});
}

/// @nodoc
class __$UpdateDownloadModelCopyWithImpl<$Res>
    implements _$UpdateDownloadModelCopyWith<$Res> {
  __$UpdateDownloadModelCopyWithImpl(this._self, this._then);

  final _UpdateDownloadModel _self;
  final $Res Function(_UpdateDownloadModel) _then;

  /// Create a copy of UpdateDownloadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? progress = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_UpdateDownloadModel(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as UpdateDownloadStatus,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
