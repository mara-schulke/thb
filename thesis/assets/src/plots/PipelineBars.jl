"""
PipelineBarsPlot - Bar chart showing all pipelines for a single benchmark.
"""

struct PipelineBarsPlot
    benchmark::String
    metric::String
    title::Union{String, Nothing}
    output::String
end

function PipelineBarsPlot(benchmark::String,
                          metric::String;
                          title=nothing,
                          output="output.svg")
    PipelineBarsPlot(benchmark, metric, title, output)
end

function render(plot_config::PipelineBarsPlot, data::BenchmarkData; plot_font, palette)
    # Collect values for all pipelines, preserving order
    all_values = Float64[]
    valid_pipelines = Pipeline[]

    # Iterate through pipelines in their original order
    for pipeline in data.pipelines
        value = get_value(data, plot_config.benchmark, pipeline.key, plot_config.metric)
        # Only include pipelines with non-zero values
        if value > 0.0
            push!(all_values, value)
            push!(valid_pipelines, pipeline)
        end
    end

    # If no valid pipelines, skip plotting
    if isempty(valid_pipelines)
        println("Warning: No data for $(plot_config.benchmark) on metric $(plot_config.metric)")
        return nothing
    end

    n_pipelines = length(valid_pipelines)
    values = all_values
    pipeline_labels = [get_pipeline_label(p) for p in valid_pipelines]
    fillstyles = get_fillstyles(valid_pipelines)

    title = plot_config.title === nothing ?
            "Performance on $(get_benchmark_label(data, plot_config.benchmark))\n" :
            plot_config.title

    metric_label = haskey(data.metrics, plot_config.metric) ?
                   data.metrics[plot_config.metric].label :
                   plot_config.metric

    data_matrix = zeros(n_pipelines, n_pipelines)
    for i in 1:n_pipelines
        data_matrix[i, i] = values[i]
    end

    # Only rotate labels if there are more than 8
    rotation_angle = n_pipelines > 8 ? 45 : 0

    p = groupedbar(
        pipeline_labels,
        data_matrix,
        bar_position=:stack,
        bar_width=0.8,
        label=permutedims(pipeline_labels),
        fillstyle=permutedims(fillstyles),
        color_palette=readable(valid_pipelines, palette),
        title=Title(title),
        xlabel=Label("Pipeline"),
        ylabel=Label(metric_label),
        legend=:outertop,
        legend_columns=4,
        size=DIMENSIONS,
        gridalpha=0.3,
        ylims=(0, 100),
        margins=10Plots.mm,
        top_margin=5Plots.mm,
        bottom_margin=rotation_angle > 0 ? 20Plots.mm : 5Plots.mm,
        fontfamily=plot_font,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=10,
        rotation=rotation_angle)

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")

    return p
end
