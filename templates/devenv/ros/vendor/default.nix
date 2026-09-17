# Overlay for one-off package overrides/patches (e.g. patching a Nix-packaged
# ROS dependency's exported CMake config, or overriding a library's build
# options). Applied after nix-ros-overlay in devenv.nix's `overlays` list, so
# `self`/`super` here see (and can override) anything nix-ros-overlay defines.
#
# Keep it empty until you actually need it -- an override here is easy to
# reach for as a fix when the *real* problem is somewhere else entirely (e.g.
# a bare, unconstrained `find_package(PCL)` in one of your own CMakeLists.txt
# files pulling in components you don't need -- fix that in the CMakeLists.txt
# instead of trying to rebuild the dependency around it).
self: super: {
}
