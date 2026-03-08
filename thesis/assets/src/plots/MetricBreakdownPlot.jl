"""
MetricBreakdownPlot - Show a single metric across selected pipelines and benchmarks.
"""

struct MetricBreakdownPlot
    metric::String
    pipeline_keys::Vector{String}
    benchmark_keys::Vector{String}
    title::Union{String, Nothing}
    output::String
    include_all_pipelines::Bool
    scale::Number
end

function MetricBreakdownPlot(;
    metric="execution-accuracy",
    pipeline_keys=String[],
    benchmark_keys=String[],
    title=nothing,
    output="metric-breakdown.svg",
    include_all_pipelines=false,
    scale=100)
    MetricBreakdownPlot(metric, pipeline_keys, benchmark_keys, title, output, include_all_pipelines, scale)
end

function render(plot_config::MetricBreakdownPlot, data::BenchmarkData; plot_font, palette)
    # Determine which pipelines to include
    all_pipelines = if plot_config.include_all_pipelines
        data.pipelines
    elseif !isempty(plot_config.pipeline_keys)
        filter(p -> p.key in plot_config.pipeline_keys, data.pipelines)
    else
        # Default: include all internal pipelines
        filter(p -> !p.external, data.pipelines)
    end

    all_benchmark_keys = sort_benchmarks_by_order(data, collect(keys(data.results)))
    benchmark_keys = if !isempty(plot_config.benchmark_keys)
        filter(k -> k in plot_config.benchmark_keys, all_benchmark_keys)
    else
        all_benchmark_keys
    end

    # First pass: collect values and filter out pipelines with no data
    # Preserve original pipeline order
    n_benchmarks = length(benchmark_keys)
    pipelines = Pipeline[]
    pipeline_value_rows = Vector{Vector{Float64}}()

    for pipeline in all_pipelines
        pipeline_values = Float64[]
        for benchmark in benchmark_keys
            push!(pipeline_values, get_value(data, benchmark, pipeline.key, plot_config.metric, plot_config.scale))
        end
        # Only include pipelines with at least one non-zero value
        if any(v -> v > 0.0, pipeline_values)
            push!(pipelines, pipeline)
            push!(pipeline_value_rows, pipeline_values)
        end
    end

    # If no valid pipelines, skip plotting
    if isempty(pipelines)
        println("Warning: No data for metric $(plot_config.metric)")
        return nothing
    end

    # Build values matrix from collected rows
    n_pipelines = length(pipelines)
    values = zeros(n_pipelines, n_benchmarks)

    for (j, pipeline_vals) in enumerate(pipeline_value_rows)
        values[j, :] = pipeline_vals
    end

    pipeline_labels = [get_pipeline_label(p) for p in pipelines]
    fillstyles = get_fillstyles(pipelines)
    benchmark_labels = [get_benchmark_label(data, b) for b in benchmark_keys]

    # Get metric label and unit
    metric_label = haskey(data.metrics, plot_config.metric) ?
                   data.metrics[plot_config.metric].label :
                   plot_config.metric

    metric_unit = haskey(data.metrics, plot_config.metric) ?
                  data.metrics[plot_config.metric].unit :
                  "%"

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
        ylabel=Label("$metric_label ($metric_unit)"),
        title=Title(title),
        legend=:outertop,
        legend_columns=4,
        size=DIMENSIONS,
        gridalpha=0.3,
        ylims=yautolims(values),
        margins=10Plots.mm,
        top_margin=5Plots.mm,
        bottom_margin=5Plots.mm,
        fontfamily=plot_font,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=10,
        rotation=rotation_angle
    )

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end
