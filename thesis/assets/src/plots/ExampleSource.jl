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
    source_pipelines = [data.pipelines[findfirst(p -> p.key == k, data.pipelines)] for k in plot_config.source]
    source_labels = [p.label for p in source_pipelines]
    fillstyles = get_fillstyles(source_pipelines)
    benchmark_keys = collect(keys(data.results))
    benchmark_labels = [get_benchmark_label(data, b) for b in benchmark_keys]

    n_sources = length(plot_config.source)
    n_benchmarks = length(benchmark_keys)
    values = zeros(n_sources, n_benchmarks)

    for (i, benchmark) in enumerate(benchmark_keys)
        for (j, source) in enumerate(plot_config.source)
            values[j, i] = get_value(data, benchmark, source, plot_config.metric)
        end
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
        bottom_margin=20Plots.mm,
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
