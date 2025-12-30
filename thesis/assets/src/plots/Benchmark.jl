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
    n_pipelines = length(data.pipelines)

    values = zeros(n_pipelines)

    for (i, pipeline) in enumerate(data.pipelines)
        values[i] = get_value(data, plot_config.benchmark, pipeline.key, plot_config.metric)
    end

    pipeline_labels = [get_pipeline_label(p) for p in data.pipelines]
    fillstyles = get_fillstyles(data.pipelines)

    title = plot_config.title === nothing ?
            "Performance on $(plot_config.benchmark)\n" :
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
        title=Title(title),
        xlabel=Label("Pipeline"),
        ylabel=Label(metric_label),
        legend=:outertop,
        legend_columns=4,
        size=(2560, 1440),
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
        rotation=rotation_angle,
        color_palette=palette)

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")

    return p
end
