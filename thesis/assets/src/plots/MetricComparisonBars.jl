"""
BenchmarkBarsPlot - Grouped bar chart comparing pipelines across benchmarks.
"""

struct BenchmarkBarsPlot
    metric::String
    title::Union{String, Nothing}
    include_sota::Bool
    output::String
end

function BenchmarkBarsPlot(metric::String;
                           title=nothing,
                           include_sota=false,
                           output="comparison-bars.svg")
    BenchmarkBarsPlot(metric, title, include_sota, output)
end

function render(plot_config::BenchmarkBarsPlot, data::BenchmarkData; plot_font, palette)
    all_pipelines = if plot_config.include_sota
        data.pipelines
    else
        filter(p -> !p.sota, data.pipelines)
    end

    benchmark_keys = sort_benchmarks_by_order(data, collect(keys(data.results)))
    benchmark_labels = [get_benchmark_label(data, b) for b in benchmark_keys]

    # First, collect all values to determine which pipelines have data
    # Preserve original pipeline order
    n_benchmarks = length(benchmark_keys)
    pipelines = Pipeline[]
    pipeline_value_rows = Vector{Vector{Float64}}()

    for pipeline in all_pipelines
        pipeline_values = Float64[]
        for benchmark in benchmark_keys
            push!(pipeline_values, get_value(data, benchmark, pipeline.key, plot_config.metric))
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

    metric_label = get_metric_label(data, plot_config.metric);

    title = plot_config.title === nothing ?
            "$metric_label Across Benchmarks" :
            plot_config.title

    # Only rotate labels if there are more than 8
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
        ylabel=Label("Score (%)"),
        title=Title(title),
        legend=:outertop,
        legend_columns=4,
        size=DIMENSIONS,
        gridalpha=0.3,
        ylims=yautolims(values'),
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
