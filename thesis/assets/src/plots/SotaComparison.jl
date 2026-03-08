"""
SotaBarsPlot - Compare with state-of-the-art.
"""

struct SotaBarsPlot
    natural::Vector{String}
    sota::Vector{String}
    metric::String
    title::String
    output::String
end

function SotaBarsPlot(;
    natural=["natural-baseline", "natural-full-ground"],
    sota=["omnisql-7b", "gpt-4o"],
    metric="execution-accuracy",
    title="Performance Comparison: Natural vs SOTA",
    output="sota-comparison.svg")
    SotaBarsPlot(natural, sota, metric, title, output)
end

function render(plot_config::SotaBarsPlot, data::BenchmarkData; plot_font, palette)
    # Preserve order: natural configs first, then sota configs
    all_configs = vcat(plot_config.natural, plot_config.sota)
    benchmark_keys = sort_benchmarks_by_order(data, collect(keys(data.results)))
    benchmark_labels = [get_benchmark_label(data, b) for b in benchmark_keys]
    n_benchmarks = length(benchmark_keys)

    # First pass: collect values and filter out configs with no data
    # Preserve original config order
    valid_configs = String[]
    valid_pipelines = Pipeline[]
    valid_labels = String[]
    temp_values = Vector{Vector{Float64}}()

    for config in all_configs
        pipeline_idx = findfirst(p -> p.key == config, data.pipelines)
        if pipeline_idx !== nothing
            pipeline = data.pipelines[pipeline_idx]

            # Collect values for this config across all benchmarks
            config_values = Float64[]
            for benchmark in benchmark_keys
                push!(config_values, get_value(data, benchmark, config, plot_config.metric))
            end

            # Only include if at least one non-zero value
            if any(v -> v > 0.0, config_values)
                push!(valid_configs, config)
                push!(valid_pipelines, pipeline)
                push!(valid_labels, get_pipeline_label(pipeline))
                push!(temp_values, config_values)
            end
        end
    end

    # If no valid configs, skip plotting
    if isempty(valid_configs)
        println("Warning: No data for SOTA comparison on metric $(plot_config.metric)")
        return nothing
    end

    n_configs = length(valid_configs)
    values = zeros(n_configs, n_benchmarks)
    for (j, config_vals) in enumerate(temp_values)
        values[j, :] = config_vals
    end

    config_pipelines = valid_pipelines
    config_labels = valid_labels
    fillstyles = get_fillstyles(config_pipelines)

    benchmark_label_objs = map(Label, benchmark_labels)

    rotation = n_benchmarks > 8 ? 45 : 0

    p = groupedbar(
        benchmark_label_objs,
        values',
        bar_position=:dodge,
        bar_width=0.8,
        label=permutedims(config_labels),
        fillstyle=permutedims(fillstyles),
        color_palette=readable(config_pipelines, palette),
        xlabel=Label("Benchmark"),
        ylabel=Label("Execution Accuracy (%)"),
        title=Title(plot_config.title),
        legend=:outertop,
        legend_columns=4,
        size=DIMENSIONS,
        gridalpha=0.3,
        ylims=(0, 105),
        margins=10Plots.mm,
        top_margin=5Plots.mm,
        bottom_margin=5Plots.mm,
        fontfamily=plot_font,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=10,
        rotation=rotation
    )

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end
