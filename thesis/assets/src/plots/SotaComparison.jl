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
    all_configs = vcat(plot_config.natural, plot_config.sota)
    config_pipelines = Pipeline[]
    config_labels = String[]

    for config in all_configs
        pipeline_idx = findfirst(p -> p.key == config, data.pipelines)
        if pipeline_idx !== nothing
            pipeline = data.pipelines[pipeline_idx]
            push!(config_pipelines, pipeline)
            push!(config_labels, get_pipeline_label(pipeline))
        end
    end

    fillstyles = get_fillstyles(config_pipelines)
    benchmark_keys = sort_benchmarks_by_order(data, collect(keys(data.results)))
    benchmark_labels = [get_benchmark_label(data, b) for b in benchmark_keys]
    n_configs = length(all_configs)
    n_benchmarks = length(benchmark_keys)
    values = zeros(n_configs, n_benchmarks)

    for (i, benchmark) in enumerate(benchmark_keys)
        for (j, config) in enumerate(all_configs)
            values[j, i] = get_value(data, benchmark, config, plot_config.metric)
        end
    end

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
