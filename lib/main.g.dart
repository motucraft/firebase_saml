// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$samlAuthHash() => r'c6a7a30b858b53396ac1b5e8f1e70594cfa6cf16';

/// See also [samlAuth].
@ProviderFor(samlAuth)
final samlAuthProvider = AutoDisposeProvider<SAMLAuthProvider>.internal(
  samlAuth,
  name: r'samlAuthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$samlAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SamlAuthRef = AutoDisposeProviderRef<SAMLAuthProvider>;
String _$authControllerHash() => r'a48f51c01baeb71066d4562d6c8bca81a7492875';

/// See also [AuthController].
@ProviderFor(AuthController)
final authControllerProvider =
    AutoDisposeAsyncNotifierProvider<AuthController, User?>.internal(
  AuthController.new,
  name: r'authControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthController = AutoDisposeAsyncNotifier<User?>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
