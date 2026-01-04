"""
Command-line interface and configuration parsing.
"""

using ArgParse
using TOML

include("data.jl")
include("plots.jl")

function parse()
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

function plottable(config::Dict, data::BenchmarkData)
    plot_type = config["type"]

    if plot_type == "pipeline-bars"
        return PipelineBarsPlot(
            config["benchmark"],
            config["metric"],
            title=get(config, "title", nothing),
            output=config["output"]
        )
    elseif plot_type == "benchmark-bars"
        return BenchmarkBarsPlot(
            config["metric"],
            title=get(config, "title", nothing),
            include_sota=get(config, "include-sota", false),
            output=config["output"]
        )
    elseif plot_type == "baseline-improvement"
        return BaselineImprovementPlot(
            baseline_key=config["baseline-key"],
            comparison_keys=config["comparison-keys"],
            metric=config["metric"],
            title=config["title"],
            output=config["output"]
        )
    elseif plot_type == "sota-bars"
        return SotaBarsPlot(
            natural=config["natural"],
            sota=config["sota"],
            metric=config["metric"],
            title=config["title"],
            output=config["output"]
        )
    elseif plot_type == "source-bars"
        return SourceBarsPlot(
            source=config["source"],
            metric=config["metric"],
            title=config["title"],
            output=config["output"]
        )
    elseif plot_type == "performance-gap"
        return PerformanceGapPlot(
            system1_key=config["pipeline-a"],
            system2_key=config["pipeline-b"],
            metric=config["metric"],
            title=config["title"],
            output=config["output"],
            show_absolute=get(config, "show-absolute", false)
        )
    elseif plot_type == "metric-breakdown"
        return MetricBreakdownPlot(
            metric=config["metric"],
            pipeline_keys=get(config, "pipeline-keys", String[]),
            title=get(config, "title", nothing),
            output=config["output"],
            include_all_pipelines=get(config, "include-all-pipelines", false),
            scale=get(config, "scale", 100)
        )
    else
        error("Unknown plot type: $plot_type")
    end
end

function main(args::Vector{String}; plot_font, palette)
    parsed = parse()

    results_file = parsed["results"]
    plots_file = parsed["plots"]

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
    plots = TOML.parsefile(plots_file)

    if !haskey(plots, "plots")
        println("Error: No 'plots' array found in $plots_file")
        return 1
    end

    for (i, config) in enumerate(plots["plots"])
        try
            plot = plottable(config, data)
            render(plot, data; plot_font=plot_font, palette=palette)
        catch e
            println("Error rendering plot $i: $e")
            showerror(stdout, e, catch_backtrace())
            println()
        end
    end

    println("\nAll plots generated successfully")
    return 0
end
