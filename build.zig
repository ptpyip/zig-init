const std = @import("std");

// This function is for declaratively construct a build graph
// that will be executed by an external runner.
pub fn build(b: *std.Build) void {
    // Standard target options => use`zig build` to choose what target.
    // i.e. any target is allowed, and the default is native.
    // Native: zig build  --summary all
    // Windows: zig build -Dtarget=x86_64-windows --summary all
    const target = b.standardTargetOptions(.{});

    // Standard optimization options => use `zig build` to select opt. mode
    // (Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall).
    const optimize = b.standardOptimizeOption(.{});

    // Declare a executable from a zig file that contains a main function
    const exe = b.addExecutable(.{
        .name = "new_project",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    // Add what dependency to be executable
    const raylib_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
        // set options here for the external library
        .shared = true,
    });
    const raylib = raylib_dep.artifact("raylib");

    // Link external libraries
    exe.linkLibC();
    exe.linkLibrary(raylib); // link raylib to the executable

    // Create a Run step in the build graph.
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep()); // run from the installation directory

    // Creates a build step call "run". (`zig build run`)
    // It will be visible in the `zig build --help` menu.
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Creates a step for unit testing.
    // This only builds the test executable but does not run it.
    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Creates a build step call "test". (`zig build test`)
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
