# buildifier: disable=module-docstring
def _dummy_rule_impl(ctx):
    return []

dummy_rule = rule(
    implementation = _dummy_rule_impl,
)

def _transistor_transition_impl(settings, _):
    target_platforms = settings["@//:target_platforms"]
    print("target_platforms = %s" % target_platforms)

    flavors = settings["@//:flavors"]
    print("flavors = %s" % flavors)

    configurations = []
    for target_platform in target_platforms:
        for flavor in flavors:
            configurations.append(
                {
                    "//command_line_option:platforms": "//:" + target_platform,
                    "//command_line_option:compilation_mode": flavor,
                },
            )

    return configurations

transistor_transition = transition(
    implementation = _transistor_transition_impl,
    inputs = [
        "@//:target_platforms",
        "@//:flavors",
    ],
    outputs = [
        "//command_line_option:platforms",
        "//command_line_option:compilation_mode",
    ],
)

def _transistor_rule_impl(ctx):
    depsets = []
    for dep in ctx.attr.deps:
        depsets.append(dep.files)
    return DefaultInfo(files = depset(transitive = depsets))

transistor_rule = rule(
    implementation = _transistor_rule_impl,
    attrs = {
        "deps": attr.label_list(cfg = transistor_transition),
        # "_flavors": attr.label(default = "//:flavors"),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)
