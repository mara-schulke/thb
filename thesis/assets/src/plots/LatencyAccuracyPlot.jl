"""
LatencyAccuracyPlot - Scatter plot showing the latency vs. accuracy trade-off
across pipeline configurations and benchmarks.

Each point represents a (pipeline, benchmark) pair, with candidate latency on
the x-axis and execution accuracy on the y-axis. Benchmarks are distinguished
by marker shape; pipelines by color.
"""

struct LatencyAccuracyPlot
    pipeline_keys::Vector{String}
    benchmark_keys::Vector{String}
    title::Union{String, Nothing}
    output::String
end

function LatencyAccuracyPlot(;
    pipeline_keys=String[],
    benchmark_keys=String[],
    title=nothing,
    output="latency-accuracy-tradeoff.svg")
    LatencyAccuracyPlot(pipeline_keys, benchmark_keys, title, output)
end

function render(plot_config::LatencyAccuracyPlot, data::BenchmarkData; plot_font, palette)
    # Determine pipelines to show
    pipelines = if !isempty(plot_config.pipeline_keys)
        filter(p -> p.key in plot_config.pipeline_keys, data.pipelines)
    else
        filter(p -> p.verified && !p.external, data.pipelines)
    end

    # Determine benchmarks to show
    all_benchmark_keys = sort_benchmarks_by_order(data, collect(keys(data.results)))
    benchmark_keys = if !isempty(plot_config.benchmark_keys)
        filter(k -> k in plot_config.benchmark_keys, all_benchmark_keys)
    else
        all_benchmark_keys
    end

    # Marker shapes per benchmark (cycle through available shapes)
    marker_shapes = [:circle, :diamond, :utriangle, :square, :star5, :hexagon]
    benchmark_markers = Dict(k => marker_shapes[mod1(i, length(marker_shapes))]
                             for (i, k) in enumerate(benchmark_keys))

    # Build the plot
    title_str = plot_config.title === nothing ?
                "Candidate Latency vs. Execution Accuracy" :
                plot_config.title

    colors = readable(pipelines, palette)

    p = plot(
        xlabel=Label("Candidate Latency (s)"),
        ylabel=Label("Execution Accuracy (%)"),
        title=Title(title_str),
        legend=:outertop,
        legend_columns=3,
        size=DIMENSIONS,
        gridalpha=0.3,
        margins=10Plots.mm,
        top_margin=5Plots.mm,
        bottom_margin=5Plots.mm,
        fontfamily=plot_font,
        titlefontsize=12,
        guidefontsize=10,
        tickfontsize=10,
        legendfontsize=9,
    )

    # Plot each pipeline as a series (one point per benchmark)
    for (pi, pipeline) in enumerate(pipelines)
        latencies  = Float64[]
        accuracies = Float64[]
        labels_ann = String[]

        for bk in benchmark_keys
            cl = get_value(data, bk, pipeline.key, "candidate-latency", 1)  # seconds, no scaling
            ea = get_value(data, bk, pipeline.key, "execution-accuracy", 100)  # percent
            if cl > 0 && ea > 0
                push!(latencies, cl)
                push!(accuracies, ea)
                push!(labels_ann, get_benchmark_label(data, bk))
            end
        end

        if isempty(latencies)
            continue
        end

        # Use varying marker shapes per benchmark within this pipeline series
        bk_filtered = [bk for bk in benchmark_keys
                       if get_value(data, bk, pipeline.key, "candidate-latency", 1) > 0 &&
                          get_value(data, bk, pipeline.key, "execution-accuracy", 100) > 0]

        for (bi, bk) in enumerate(bk_filtered)
            cl = latencies[bi]
            ea = accuracies[bi]
            mkr = benchmark_markers[bk]
            # Only label pipeline on the first benchmark to avoid duplicate legend entries
            lbl = bi == 1 ? get_pipeline_label(pipeline) : ""
            scatter!(p,
                [cl], [ea],
                label=lbl,
                color=colors[pi],
                marker=mkr,
                markersize=8,
                markerstrokewidth=1.5,
            )
        end
    end

    # Add a separate legend block for benchmark marker shapes
    # We annotate in the lower-right corner with a small legend
    for (i, bk) in enumerate(benchmark_keys)
        mkr = benchmark_markers[bk]
        # Add a dummy invisible series so the marker shape appears in the legend
        scatter!(p,
            [NaN], [NaN],
            label=get_benchmark_label(data, bk),
            color=:black,
            marker=mkr,
            markersize=8,
            markerstrokewidth=1.5,
        )
    end

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end
