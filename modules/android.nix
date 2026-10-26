# ============================================================================
# Android SDK (declarative, reproducible)
# ============================================================================
#
# Pins the exact SDK components this machine's Android/Gradle projects need and
# exports ANDROID_HOME / ANDROID_SDK_ROOT so builds find the SDK without a
# project-local `local.properties`.
#
# Component ids (SDK package syntax -> nixpkgs argument):
#   platforms;android-37.0   -> platformVersions   [ "37.0" ]   (compileSdk 37)
#   build-tools;36.0.0       -> buildToolsVersions [ "36.0.0" ] (AGP 9 default)
#   build-tools;37.0.0       -> buildToolsVersions [ "37.0.0" ] (current)
#   platform-tools;37.0.1    -> platformToolsVersion "37.0.1"   (adb, fastboot)
#   cmdline-tools;22.0       -> cmdLineToolsVersion  "22.0"      (sdkmanager, lint)
#
# Requires the nixpkgs instance to accept the Android SDK license:
#   android_sdk.accept_license = true;   # set for pkgs-unstable in flake.nix
#
# The JDK is NOT pinned here — it comes from Arch:
#   sudo archlinux-java set java-21-openjdk
{ pkgs-unstable, ... }:

let
  androidSdk = pkgs-unstable.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "22.0";
    platformToolsVersion = "37.0.1";
    platformVersions = [ "37.0" ];
    buildToolsVersions = [ "36.0.0" "37.0.0" ];

    # Keep the closure lean: the physical device is used instead of an emulator,
    # and none of the projects need the NDK, sources, CMake or extras.
    includeEmulator = false;
    includeSystemImages = false;
    includeSources = false;
    includeNDK = false;
    includeCmake = false;
    includeExtras = [ ];
  };

  # The aggregate SDK tree lives under libexec/android-sdk; this is the path
  # Gradle expects in ANDROID_HOME (it contains platforms/, build-tools/, ...).
  androidSdkRoot = "${androidSdk.androidsdk}/libexec/android-sdk";
in
{
  # Puts adb, fastboot, sdkmanager, avdmanager and lint on PATH.
  home.packages = [ androidSdk.androidsdk ];

  home.sessionVariables = {
    ANDROID_HOME = androidSdkRoot;
    ANDROID_SDK_ROOT = androidSdkRoot;
  };
}
