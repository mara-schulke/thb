"""
Command-line interface and configuration parsing.
"""

using ArgParse
using TOML

include("data.jl")
include("plots.jl")

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--results"
            help = "Path to results TOML file"
            arg_type = String
            default = "var/conf/benchmark.toml"
        "--plots"
            help = "Path to plot configuration TOML file"
            arg_type = String
            default = "var/conf/plots.toml"
    end

    return parse_args(s)
end

function create_plot_from_config(config::Dict)
    plot_type = config["type"]

    if plot_type == "benchmark"
        return BenchmarkPlot(
            config["benchmark"],
            config["metric"],
            config["metric_label"],
            title=get(config, "title", nothing),
            output=config["output"]
        )
    elseif plot_type == "metric_comparison"
        return MetricComparisonPlot(
            config["metric"],
            metric_label=get(config, "metric_label", nothing),
            title=get(config, "title", nothing),
            output=config["output"]
        )
    elseif plot_type == "relative_improvement"
        return RelativeImprovementPlot(
            baseline_key=config["baseline_key"],
            comparison_keys=config["comparison_keys"],
            metric=config["metric"],
            title=config["title"],
            output=config["output"]
        )
    elseif plot_type == "metric_comparison_bars"
        return MetricComparisonBarsPlot(
            config["metric"],
            metric_label=get(config, "metric_label", nothing),
            title=get(config, "title", nothing),
            include_sota=get(config, "include_sota", false),
            output=config["output"]
        )
    elseif plot_type == "sota_comparison"
        return SotaComparisonPlot(
            natural_configs=config["natural_configs"],
            sota_configs=config["sota_configs"],
            metric=config["metric"],
            title=config["title"],
            output=config["output"]
        )
    elseif plot_type == "example_source"
        return ExampleSourcePlot(
            source_keys=config["source_keys"],
            metric=config["metric"],
            title=config["title"],
            output=config["output"]
        )
    else
        error("Unknown plot type: $plot_type")
    end
end

function main(args::Vector{String}; plot_font, palette)
    parsed_args = parse_commandline()

    results_file = parsed_args["results"]
    plots_file = parsed_args["plots"]

    if !isfile(results_file)
        println("Error: Results file '$results_file' not found")
        return 1
    end

    if !isfile(plots_file)
        println("Error: Plots config file '$plots_file' not found")
        return 1
    end

    println("Generating visualizations")
    println("  Results: $results_file")
    println("  Plots config: $plots_file")
    println()

    data = BenchmarkData(results_file)
    plot_configs = TOML.parsefile(plots_file)

    if !haskey(plot_configs, "plots")
        println("Error: No 'plots' array found in $plots_file")
        return 1
    end

    for (i, config) in enumerate(plot_configs["plots"])
        try
            plot_obj = create_plot_from_config(config)
            render(plot_obj, data; plot_font=plot_font, palette=palette)
        catch e
            println("Error rendering plot $i: $e")
            showerror(stdout, e, catch_backtrace())
            println()
        end
    end

    println("\nAll plots generated successfully")
    return 0
end
