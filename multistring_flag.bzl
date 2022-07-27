# buildifier: disable=module-docstring
load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")

def _multistring_impl(ctx):
    allowed_values = ctx.attr.values
    given_multistring = ctx.build_setting_value
    print("given_multistring = %s" % given_multistring)

    if len(allowed_values) == 0 or all([item in allowed_values for item in given_multistring]):
        return BuildSettingInfo(value = given_multistring)
    else:
        fail("Error setting " + str(ctx.label) + ": invalid value '" + str(given_multistring) + "'. Allowed values are " + str(allowed_values))

multistring_flag = rule(
    implementation = _multistring_impl,
    build_setting = config.string_list(flag = True),
    attrs = {
        "values": attr.string_list(
            doc = "The list of allowed values for this setting. An error is raised if any other value is given.",
        ),
    },
    doc = "A string-typed build setting that can be set on the command line more than once",
)
