"""Plots congestion against some parameter such as PLACE_DENSITY"""

def plot_congestion(name, srcs, argument, values):
    native.filegroup(
        name = "{name}_congestion".format(name = name),
        srcs = srcs,
        output_group = "5_global_route.rpt",
    )

    native.genrule(
        name = "{}_pdf".format(name),
        srcs = ["{name}_congestion".format(name = name)],
        outs = ["{}.pdf".format(name)],
        cmd = "$(execpath //flow/util:plot_congestion) {argument} $@ $(locations :{name}_congestion) {values}".format(values = " ".join(values), argument = argument, name = name),
        tools = ["//flow/util:plot_congestion"],
    )

    native.sh_binary(
        name = name,
        srcs = ["//flow/util:open_plots.sh"],
        args = ["$(location :{}.pdf)".format(name)],
        data = ["{}.pdf".format(name)],
    )
