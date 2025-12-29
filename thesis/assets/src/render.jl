using Plots
using StatsPlots
using TOML
using ColorSchemes
using ArgParse
import PyPlot

# ============================================================================
# Configuration and Setup
# ============================================================================

pyplot()

const PLOT_FONT = "Berkeley Mono"
const BERKELEY_MONO_PATH = "/nix/store/yy92c3cq5lkfbcawckwv733rck0lz04d-berkeley-mono-1.0.0/share/fonts/truetype/berkeley-mono"

PyPlot.matplotlib.font_manager.fontManager.addfont(joinpath(BERKELEY_MONO_PATH, "BerkeleyMono-Regular.ttf"))
PyPlot.matplotlib.rcParams["svg.fonttype"] = "path"
PyPlot.matplotlib.rcParams["font.family"] = "monospace"
PyPlot.matplotlib.rcParams["font.monospace"] = ["Berkeley Mono"]

default(fontfamily=PLOT_FONT, linewidth=2, framestyle=:box, grid=true)
scalefontsizes()
scalefontsizes(1.0)

# :lajolla10 or :tofino10 or :vanimo10
const PALETTE = palette(:tofino10)

# ============================================================================
# Data Structures
# ============================================================================

struct Pipeline
    key::String
    label::String
    order::Int
    external::Bool
    sota::Bool
    verified::Bool
end

function Pipeline(key::String, data::Dict)
    Pipeline(
        key,
        data["label"],
        data["order"],
        get(data, "external", false),
        get(data, "sota", false),
        get(data, "verified", true)
    )
end

struct BenchmarkData
    file_path::String
    pipelines::Vector{Pipeline}
    benchmarks::Dict{String, Dict{String, Dict{String, Float64}}}
end

function BenchmarkData(file_path::String)
    data = TOML.parsefile(file_path)

    pipeline_keys = collect(keys(data["pipelines"]))
    pipelines = [Pipeline(k, data["pipelines"][k]) for k in pipeline_keys]
    sort!(pipelines, by = p -> p.order)

    benchmarks = get(data, "benchmark", Dict())

    BenchmarkData(file_path, pipelines, benchmarks)
end

function get_value(bd::BenchmarkData, benchmark::String, pipeline_key::String, metric::String)
    if haskey(bd.benchmarks, benchmark) &&
       haskey(bd.benchmarks[benchmark], pipeline_key) &&
       haskey(bd.benchmarks[benchmark][pipeline_key], metric)
        return bd.benchmarks[benchmark][pipeline_key][metric] * 100
    end
    return 0.0
end

function get_pipeline_label(pipeline::Pipeline, include_asterisk::Bool=true)
    label = pipeline.label
    if include_asterisk && !pipeline.verified
        label *= "*"
    end
    return label
end

# ============================================================================
# Plot Types
# ============================================================================

struct BenchmarkPlot
    benchmark::String
    metric::String
    metric_label::String
    title::Union{String, Nothing}
    output::String
end

function BenchmarkPlot(benchmark::String,
                       metric::String,
                       metric_label::String;
                       title=nothing,
                       output="output.svg")
    BenchmarkPlot(benchmark, metric, metric_label, title, output)
end

function render(plot_config::BenchmarkPlot, data::BenchmarkData)
    n_pipelines = length(data.pipelines)

    values = zeros(n_pipelines)

    for (i, pipeline) in enumerate(data.pipelines)
        values[i] = get_value(data, plot_config.benchmark, pipeline.key, plot_config.metric)
    end

    pipeline_labels = [Label(p.label) for p in data.pipelines]

    title = plot_config.title === nothing ?
            "Performance on $(plot_config.benchmark)\n" :
            plot_config.title

    p = plot(title=Label(title),
             xlabel=Label("Pipeline"),
             ylabel=Label("Score (%)"),
             legend=:topright,
             size=(1400, 800),
             gridalpha=0.3,
             ylims=:auto,
             xticks=(1:n_pipelines, pipeline_labels),
             margins=10Plots.mm,
             fontfamily=PLOT_FONT,
             titlefontsize=12,
             guidefontsize=10,
             tickfontsize=10,
             legendfontsize=10)

    plot!(p, 1:n_pipelines, values,
          label=plot_config.metric_label,
          marker=:circle,
          markersize=8,
          linewidth=2,
          color=PALETTE[1])

    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")

    return p
end

struct MetricComparisonPlot
    metric::String
    metric_label::Union{String, Nothing}
    title::Union{String, Nothing}
    output::String
end

function MetricComparisonPlot(metric::String;
                              metric_label=nothing,
                              title=nothing,
                              output="comparison.svg")
    MetricComparisonPlot(metric, metric_label, title, output)
end

function render(plot_config::MetricComparisonPlot, data::BenchmarkData)
    benchmarks = map(x -> Label(x), collect(keys(data.benchmarks)))
    n_pipelines = length(data.pipelines)
    n_benchmarks = length(benchmarks)

    values = zeros(n_benchmarks, n_pipelines)
    for (i, benchmark) in enumerate(benchmarks)
        for (j, pipeline) in enumerate(data.pipelines)
            values[i, j] = get_value(data, benchmark, pipeline.key, plot_config.metric)
        end
    end

    pipeline_labels = [p.label for p in data.pipelines]

    metric_display = plot_config.metric_label !== nothing ?
                     plot_config.metric_label :
                     plot_config.metric
    title = plot_config.title === nothing ?
            "$metric_display Across Benchmarks" :
            plot_config.title

    p = plot(title=Label(title),
             xlabel=Label("Benchmark"),
             ylabel=Label("Score (%)"),
             legend=:topright,
             size=(1400, 800),
             gridalpha=0.3,
             ylims=(0, 105),
             xticks=(1:n_benchmarks, benchmarks),
             margins=10Plots.mm,
             fontfamily=PLOT_FONT,
             titlefontsize=12,
             guidefontsize=10,
             tickfontsize=10,
             legendfontsize=10)

    for (j, pipeline_label) in enumerate(pipeline_labels)
        color_idx = ((j - 1) % length(PALETTE)) + 1
        plot!(p, 1:n_benchmarks, values[:, j],
              label=pipeline_label,
              marker=:circle,
              markersize=8,
              linewidth=2,
              color=PALETTE[color_idx])
    end

    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")

    return p
end

struct RelativeImprovementPlot
    baseline_key::String
    comparison_keys::Vector{String}
    metric::String
    title::String
    output::String
end

function RelativeImprovementPlot(;
                                 baseline_key="natural-baseline",
                                 comparison_keys=["natural-zeroshot", "natural-full-syn", "natural-full-train", "natural-full-ground"],
                                 metric="execution-accuracy",
                                 title="Relative Performance Improvement Over Baseline",
                                 output="relative-improvement.svg")
    RelativeImprovementPlot(baseline_key, comparison_keys, metric, title, output)
end

function render(plot_config::RelativeImprovementPlot, data::BenchmarkData)
    benchmarks = collect(keys(data.benchmarks))

    baseline_values = Dict{String, Float64}()
    for benchmark in benchmarks
        baseline_values[benchmark] = get_value(data, benchmark, plot_config.baseline_key, plot_config.metric)
    end

    n_comparisons = length(plot_config.comparison_keys)
    n_benchmarks = length(benchmarks)
    improvements = zeros(n_comparisons, n_benchmarks)

    for (i, comp_key) in enumerate(plot_config.comparison_keys)
        for (j, benchmark) in enumerate(benchmarks)
            comp_value = get_value(data, benchmark, comp_key, plot_config.metric)
            improvements[i, j] = comp_value - baseline_values[benchmark]
        end
    end

    comparison_labels = [Label(data.pipelines[findfirst(p -> p.key == k, data.pipelines)].label) for k in plot_config.comparison_keys]

    p = groupedbar(
        benchmarks,
        improvements',
        bar_position=:dodge,
        label=permutedims(comparison_labels),
        xlabel=Label("Benchmark"),
        ylabel=Label("Improvement in EA (%)"),
        title=Label(plot_config.title),
        legend=:topright,
        size=(1400, 800),
        gridalpha=0.3,
        margins=10Plots.mm,
        fontfamily=PLOT_FONT,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=9,
        color_palette=PALETTE
    )

    hline!(p, [0], color=:black, linestyle=:dash, label=Label("Baseline"), linewidth=1)

    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end

struct MetricComparisonBarsPlot
    metric::String
    metric_label::Union{String, Nothing}
    title::Union{String, Nothing}
    include_sota::Bool
    output::String
end

function MetricComparisonBarsPlot(metric::String;
                                  metric_label=nothing,
                                  title=nothing,
                                  include_sota=false,
                                  output="comparison-bars.svg")
    MetricComparisonBarsPlot(metric, metric_label, title, include_sota, output)
end

function render(plot_config::MetricComparisonBarsPlot, data::BenchmarkData)
    pipelines = if plot_config.include_sota
        data.pipelines
    else
        filter(p -> !p.sota, data.pipelines)
    end

    pipeline_labels = [Label(get_pipeline_label(p)) for p in pipelines]
    benchmarks = collect(keys(data.benchmarks))

    n_pipelines = length(pipelines)
    n_benchmarks = length(benchmarks)
    values = zeros(n_pipelines, n_benchmarks)

    for (i, benchmark) in enumerate(benchmarks)
        for (j, pipeline) in enumerate(pipelines)
            values[j, i] = get_value(data, benchmark, pipeline.key, plot_config.metric)
        end
    end

    metric_display = plot_config.metric_label !== nothing ?
                     plot_config.metric_label :
                     plot_config.metric
    title = plot_config.title === nothing ?
            "$metric_display Across Benchmarks" :
            plot_config.title

    p = groupedbar(
        benchmarks,
        values',
        bar_position=:dodge,
        label=permutedims(pipeline_labels),
        xlabel=Label("Benchmark"),
        ylabel=Label("Score (%)"),
        title=Label(title),
        legend=:topright,
        size=(1400, 800),
        gridalpha=0.3,
        ylims=(0, 100),
        margins=10Plots.mm,
        fontfamily=PLOT_FONT,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=9,
        color_palette=PALETTE
    )

    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end

struct SotaComparisonPlot
    natural_configs::Vector{String}
    sota_configs::Vector{String}
    metric::String
    title::String
    output::String
end

function SotaComparisonPlot(;
                            natural_configs=["natural-baseline", "natural-full-ground"],
                            sota_configs=["omnisql-7b", "gpt-4o"],
                            metric="execution-accuracy",
                            title="Performance Comparison: Natural vs SOTA",
                            output="sota-comparison.svg")
    SotaComparisonPlot(natural_configs, sota_configs, metric, title, output)
end

function render(plot_config::SotaComparisonPlot, data::BenchmarkData)
    all_configs = vcat(plot_config.natural_configs, plot_config.sota_configs)
    config_labels = String[]

    for config in all_configs
        pipeline_idx = findfirst(p -> p.key == config, data.pipelines)
        if pipeline_idx !== nothing
            push!(config_labels, Label(get_pipeline_label(data.pipelines[pipeline_idx])))
        end
    end

    benchmarks = collect(keys(data.benchmarks))
    n_configs = length(all_configs)
    n_benchmarks = length(benchmarks)
    values = zeros(n_configs, n_benchmarks)

    for (i, benchmark) in enumerate(benchmarks)
        for (j, config) in enumerate(all_configs)
            values[j, i] = get_value(data, benchmark, config, plot_config.metric)
        end
    end

    p = groupedbar(
        benchmarks,
        values',
        bar_position=:dodge,
        label=permutedims(config_labels),
        xlabel=Label("Benchmark"),
        ylabel=Label("Execution Accuracy (%)"),
        title=Label(plot_config.title),
        legend=:bottomright,
        size=(1400, 800),
        gridalpha=0.3,
        ylims=(0, 100),
        margins=10Plots.mm,
        fontfamily=PLOT_FONT,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=10,
        color_palette=PALETTE
    )

    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end

struct ExampleSourcePlot
    source_keys::Vector{String}
    metric::String
    title::String
    output::String
end

function ExampleSourcePlot(;
                           source_keys=["natural-full-syn", "natural-full-train", "natural-full-ground"],
                           metric="execution-accuracy",
                           title="Impact of Example Source on Performance",
                           output="example-source-comparison.svg")
    ExampleSourcePlot(source_keys, metric, title, output)
end

function render(plot_config::ExampleSourcePlot, data::BenchmarkData)
    source_labels = [Label(data.pipelines[findfirst(p -> p.key == k, data.pipelines)].label) for k in plot_config.source_keys]
    benchmarks = collect(keys(data.benchmarks))

    n_sources = length(plot_config.source_keys)
    n_benchmarks = length(benchmarks)
    values = zeros(n_sources, n_benchmarks)

    for (i, benchmark) in enumerate(benchmarks)
        for (j, source) in enumerate(plot_config.source_keys)
            values[j, i] = get_value(data, benchmark, source, plot_config.metric)
        end
    end

    p = groupedbar(
        benchmarks,
        values',
        bar_position=:dodge,
        label=permutedims(source_labels),
        xlabel=Label("Benchmark"),
        ylabel=Label("Execution Accuracy (%)"),
        title=Label(plot_config.title),
        legend=:topright,
        size=(1400, 800),
        gridalpha=0.3,
        ylims=(0, 100),
        margins=10Plots.mm,
        fontfamily=PLOT_FONT,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=10,
        color_palette=PALETTE
    )

    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end

# ============================================================================
# Utility Functions
# ============================================================================

function Label(s::String)
    return "\n$(s)\n"
end

function plot_all_benchmarks(data::BenchmarkData; output_dir=".")
    benchmarks = keys(data.benchmarks)

    for benchmark in benchmarks
        output_file = joinpath(output_dir, "$(benchmark).svg")
        plot_config = BenchmarkPlot(benchmark, "execution-accuracy", "Execution Accuracy", output=output_file)
        render(plot_config, data)
    end

    println("generated $(length(benchmarks)) plots")
end

# ============================================================================
# CLI and Main Execution
# ============================================================================

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--results"
            help = "Path to results TOML file"
            arg_type = String
            default = "results.toml"
        "--plots"
            help = "Path to plot configuration TOML file"
            arg_type = String
            default = "plot.toml"
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

function main(args::Vector{String})
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
            render(plot_obj, data)
        catch e
            println("Error rendering plot $i: $e")
            showerror(stdout, e, catch_backtrace())
            println()
        end
    end

    println("\nAll plots generated successfully")
    return 0
end

if abspath(PROGRAM_FILE) == @__FILE__
    exit(main(ARGS))
end
