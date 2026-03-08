"""
SourceBarsPlot - Compare different example sources.
"""

struct SourceBarsPlot
    source::Vector{String}
    metric::String
    title::String
    output::String
end

function SourceBarsPlot(;
                           source=["natural-full-syn", "natural-full-train", "natural-full-ground"],
                           metric="execution-accuracy",
                           title="Impact of Example Source on Performance",
                           output="example-source-comparison.svg")
    SourceBarsPlot(source, metric, title, output)
end

function render(plot_config::SourceBarsPlot, data::BenchmarkData; plot_font, palette)
    benchmark_keys = collect(keys(data.results))
    n_benchmarks = length(benchmark_keys)

    # First pass: collect values and filter out sources with no data
    # Preserve original source order from config
    valid_sources = String[]
    valid_pipelines = Pipeline[]
    temp_values = Vector{Vector{Float64}}()

    for source_key in plot_config.source
        pipeline_idx = findfirst(p -> p.key == source_key, data.pipelines)
        if pipeline_idx !== nothing
            pipeline = data.pipelines[pipeline_idx]

            # Collect values for this source across all benchmarks
            source_values = Float64[]
            for benchmark in benchmark_keys
                push!(source_values, get_value(data, benchmark, source_key, plot_config.metric))
            end

            # Only include if at least one non-zero value
            if any(v -> v > 0.0, source_values)
                push!(valid_sources, source_key)
                push!(valid_pipelines, pipeline)
                push!(temp_values, source_values)
            end
        end
    end

    # If no valid sources, skip plotting
    if isempty(valid_sources)
        println("Warning: No data for example source comparison")
        return nothing
    end

    source_pipelines = valid_pipelines
    source_labels = [p.label for p in source_pipelines]
    fillstyles = get_fillstyles(source_pipelines)
    benchmark_labels = [get_benchmark_label(data, b) for b in benchmark_keys]

    n_sources = length(valid_sources)
    values = zeros(n_sources, n_benchmarks)

    for (j, source_vals) in enumerate(temp_values)
        values[j, :] = source_vals
    end

    # Only rotate labels if there are more than 8
    rotation_angle = n_benchmarks > 8 ? 45 : 0

    p = groupedbar(
        benchmark_labels,
        values',
        bar_position=:dodge,
        bar_width=0.8,
        label=permutedims(source_labels),
        fillstyle=permutedims(fillstyles),
        color_palette=readable(source_pipelines, palette),
        xlabel=Label("Benchmark"),
        ylabel=Label("Execution Accuracy (%)"),
        title=Title(plot_config.title),
        legend=:outertop,
        legend_columns=4,
        size=DIMENSIONS,
        gridalpha=0.3,
        ylims=(0, 100),
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
