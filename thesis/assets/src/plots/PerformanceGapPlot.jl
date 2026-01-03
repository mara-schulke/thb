"""
PerformanceGapPlot - Show the difference between two systems (e.g., measured vs reported).
"""

struct PerformanceGapPlot
    system1_key::String
    system2_key::String
    metric::String
    title::String
    output::String
    show_absolute::Bool
end

function PerformanceGapPlot(;
                             system1_key="natural-model",
                             system2_key="omnisql-7b",
                             metric="execution-accuracy",
                             title="Performance Gap: Measured vs Reported",
                             output="performance-gap.svg",
                             show_absolute=true)
    PerformanceGapPlot(system1_key, system2_key, metric, title, output, show_absolute)
end

function render(plot_config::PerformanceGapPlot, data::BenchmarkData; plot_font, palette)
    benchmark_keys = collect(keys(data.results))
    benchmark_labels = [get_benchmark_label(data, b) for b in benchmark_keys]
    n_benchmarks = length(benchmark_keys)

    system1_values = zeros(n_benchmarks)
    system2_values = zeros(n_benchmarks)
    differences = zeros(n_benchmarks)

    for (i, benchmark) in enumerate(benchmark_keys)
        system1_values[i] = get_value(data, benchmark, plot_config.system1_key, plot_config.metric)
        system2_values[i] = get_value(data, benchmark, plot_config.system2_key, plot_config.metric)
        differences[i] = system2_values[i] - system1_values[i]
    end

    # Get pipeline labels
    system1_pipeline = data.pipelines[findfirst(p -> p.key == plot_config.system1_key, data.pipelines)]
    system2_pipeline = data.pipelines[findfirst(p -> p.key == plot_config.system2_key, data.pipelines)]

    system1_label = get_pipeline_label(system1_pipeline)
    system2_label = get_pipeline_label(system2_pipeline)

    # Get fillstyles
    fillstyle1 = system1_pipeline.verified ? nothing : :/
    fillstyle2 = system2_pipeline.verified ? nothing : :/

    # Get colors for the two systems
    both_pipelines = [system1_pipeline, system2_pipeline]
    colors = readable(both_pipelines, palette)

    # Determine rotation angle
    rotation_angle = n_benchmarks > 8 ? 45 : 0

    if plot_config.show_absolute
        # Show both systems and the difference
        combined_data = hcat(system1_values, system2_values, differences)
        labels = [system1_label system2_label "Difference"]
        fillstyles = [fillstyle1 fillstyle2 nothing]
        bar_colors = [colors[1] colors[2] palette.verified[3]]

        p = groupedbar(
            benchmark_labels,
            combined_data,
            bar_position=:dodge,
            bar_width=0.8,
            label=labels,
            color_palette=bar_colors,
            fillstyle=fillstyles,
            xlabel=Label("Benchmark"),
            ylabel=Label("Score (%)"),
            title=Title(plot_config.title),
            legend=:outertop,
            legend_columns=3,
            size=DIMENSIONS,
            gridalpha=0.3,
            ylims=yautolims(combined_data),
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

        hline!(p, [0], color=:black, linestyle=:dash, label="", linewidth=1)
    else
        # Show only the difference
        p = bar(
            benchmark_labels,
            differences,
            label="Difference ($(system2_label) - $(system1_label))",
            color=palette.verified[3],
            xlabel=Label("Benchmark"),
            ylabel=Label("Difference (%)"),
            title=Title(plot_config.title),
            legend=:outertop,
            size=DIMENSIONS,
            gridalpha=0.3,
            ylims=:auto,
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

        hline!(p, [0], color=:black, linestyle=:dash, label="No difference", linewidth=1)
    end

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end
