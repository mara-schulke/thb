"""
MetricBreakdownPlot - Show a single metric across selected pipelines and benchmarks.
"""

struct MetricBreakdownPlot
    metric::String
    pipeline_keys::Vector{String}
    title::Union{String, Nothing}
    output::String
    include_all_pipelines::Bool
end

function MetricBreakdownPlot(;
                              metric="execution-accuracy",
                              pipeline_keys=String[],
                              title=nothing,
                              output="metric-breakdown.svg",
                              include_all_pipelines=false)
    MetricBreakdownPlot(metric, pipeline_keys, title, output, include_all_pipelines)
end

function render(plot_config::MetricBreakdownPlot, data::BenchmarkData; plot_font, palette)
    # Determine which pipelines to include
    pipelines = if plot_config.include_all_pipelines
        data.pipelines
    elseif !isempty(plot_config.pipeline_keys)
        filter(p -> p.key in plot_config.pipeline_keys, data.pipelines)
    else
        # Default: include all internal pipelines
        filter(p -> !p.external, data.pipelines)
    end

    pipeline_labels = [get_pipeline_label(p) for p in pipelines]
    fillstyles = get_fillstyles(pipelines)
    benchmark_keys = collect(keys(data.results))
    benchmark_labels = [get_benchmark_label(data, b) for b in benchmark_keys]

    n_pipelines = length(pipelines)
    n_benchmarks = length(benchmark_keys)
    values = zeros(n_pipelines, n_benchmarks)

    for (i, benchmark) in enumerate(benchmark_keys)
        for (j, pipeline) in enumerate(pipelines)
            values[j, i] = get_value(data, benchmark, pipeline.key, plot_config.metric)
        end
    end

    # Get metric label
    metric_label = haskey(data.metrics, plot_config.metric) ?
                   data.metrics[plot_config.metric].label :
                   plot_config.metric

    # Generate title
    title = plot_config.title === nothing ?
            "$metric_label Across Systems" :
            plot_config.title

    # Determine rotation angle
    rotation_angle = n_benchmarks > 8 ? 45 : 0

    p = groupedbar(
        benchmark_labels,
        values',
        bar_position=:dodge,
        bar_width=0.8,
        label=permutedims(pipeline_labels),
        fillstyle=permutedims(fillstyles),
        color_palette=readable(pipelines, palette),
        xlabel=Label("Benchmark"),
        ylabel=Label("$metric_label (%)"),
        title=Title(title),
        legend=:outertop,
        legend_columns=4,
        size=DIMENSIONS,
        gridalpha=0.3,
        ylims=(0, 100),
        margins=10Plots.mm,
        top_margin=5Plots.mm,
        bottom_margin=20Plots.mm,
        fontfamily=plot_font,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=8,
        rotation=rotation_angle
    )

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end
