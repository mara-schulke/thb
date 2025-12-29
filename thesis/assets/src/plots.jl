"""
Plot types and rendering functions for thesis visualizations.
"""

using Plots
using StatsPlots

include("data.jl")

# Utility function for label formatting
function Label(s::String)
    return "\n$(s)\n"
end

# Ensure output directory exists before saving
function ensure_output_dir(output_path::String)
    output_dir = dirname(output_path)
    if !isempty(output_dir) && !isdir(output_dir)
        mkpath(output_dir)
    end
end

# ============================================================================
# BenchmarkPlot - Single benchmark line plot
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

function render(plot_config::BenchmarkPlot, data::BenchmarkData; plot_font, palette)
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
             fontfamily=plot_font,
             titlefontsize=12,
             guidefontsize=10,
             tickfontsize=10,
             legendfontsize=10)

    plot!(p, 1:n_pipelines, values,
          label=plot_config.metric_label,
          marker=:circle,
          markersize=8,
          linewidth=2,
          color=palette[1])

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")

    return p
end

# ============================================================================
# MetricComparisonPlot - Compare metric across benchmarks
# ============================================================================

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

function render(plot_config::MetricComparisonPlot, data::BenchmarkData; plot_font, palette)
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
             fontfamily=plot_font,
             titlefontsize=12,
             guidefontsize=10,
             tickfontsize=10,
             legendfontsize=10)

    for (j, pipeline_label) in enumerate(pipeline_labels)
        color_idx = ((j - 1) % length(palette)) + 1
        plot!(p, 1:n_benchmarks, values[:, j],
              label=pipeline_label,
              marker=:circle,
              markersize=8,
              linewidth=2,
              color=palette[color_idx])
    end

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")

    return p
end

# ============================================================================
# RelativeImprovementPlot - Show improvement over baseline
# ============================================================================

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

function render(plot_config::RelativeImprovementPlot, data::BenchmarkData; plot_font, palette)
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
        fontfamily=plot_font,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=9,
        color_palette=palette
    )

    hline!(p, [0], color=:black, linestyle=:dash, label=Label("Baseline"), linewidth=1)

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end

# ============================================================================
# MetricComparisonBarsPlot - Grouped bar chart comparison
# ============================================================================

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

function render(plot_config::MetricComparisonBarsPlot, data::BenchmarkData; plot_font, palette)
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
        fontfamily=plot_font,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=9,
        color_palette=palette
    )

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end

# ============================================================================
# SotaComparisonPlot - Compare with state-of-the-art
# ============================================================================

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

function render(plot_config::SotaComparisonPlot, data::BenchmarkData; plot_font, palette)
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
        fontfamily=plot_font,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=10,
        color_palette=palette
    )

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end

# ============================================================================
# ExampleSourcePlot - Compare different example sources
# ============================================================================

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

function render(plot_config::ExampleSourcePlot, data::BenchmarkData; plot_font, palette)
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
        fontfamily=plot_font,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=10,
        color_palette=palette
    )

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end
