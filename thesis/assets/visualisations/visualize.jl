using Plots
using StatsPlots
using TOML
using ColorSchemes
import PyPlot

pyplot()

const PLOT_FONT = "Berkeley Mono"
berkeley_mono_path = "/nix/store/yy92c3cq5lkfbcawckwv733rck0lz04d-berkeley-mono-1.0.0/share/fonts/truetype/berkeley-mono"
PyPlot.matplotlib.font_manager.fontManager.addfont(joinpath(berkeley_mono_path, "BerkeleyMono-Regular.ttf"))

PyPlot.matplotlib.rcParams["svg.fonttype"] = "path"
PyPlot.matplotlib.rcParams["font.family"] = "monospace"
PyPlot.matplotlib.rcParams["font.monospace"] = ["Berkeley Mono"]

default(fontfamily=PLOT_FONT, linewidth=2, framestyle=:box, grid=true)
scalefontsizes()
scalefontsizes(1.0)

const COLOR_PRIMARY = RGB(42/255, 127/255, 98/255)      # Jungle Teal
const COLOR_TERTIARY = RGB(205/255, 234/255, 192/255)   # Tea Green
const COLOR_SECONDARY = RGB(143/255, 101/255, 147/255)  # Vintage Lavender
const COLOR_QUATERNARY = RGB(174/255, 164/255, 191/255) # Lilac Ash
const COLOR_TEXT = RGB(15/255, 16/255, 32/255)          # Ink Black

# :lajolla10 or :tofino10 or :vanimo10
const PALETTE = cgrad(:tofino10, 4, categorical=true)

function plot_benchmark(
    toml_file::String,
    benchmark::String;
    output="output.svg",
    metrics=["execution-accuracy", "exact-match"],
    metric_labels=["Execution Accuracy", "Exact Match"],
    title=nothing
)
    data = TOML.parsefile(toml_file)

    pipeline_keys = collect(keys(data["pipelines"]))
    sort!(pipeline_keys, by = k -> data["pipelines"][k]["order"])
    pipeline_labels = [
        "\n$(data["pipelines"][k]["label"])\n"
        for k in pipeline_keys
    ]

    if !haskey(data, "benchmark") || !haskey(data["benchmark"], benchmark)
        error("Benchmark '$benchmark' not found in TOML file")
    end

    benchmark_data = data["benchmark"][benchmark]
    n_pipelines = length(pipeline_keys)
    n_metrics = length(metrics)

    values = zeros(n_metrics, n_pipelines)
    for (i, metric) in enumerate(metrics)
        for (j, pipeline) in enumerate(pipeline_keys)
            if haskey(benchmark_data, pipeline) && haskey(benchmark_data[pipeline], metric)
                values[i, j] = benchmark_data[pipeline][metric] * 100
            end
        end
    end

    if title === nothing
        title = "Performance on $(benchmark)\n"
    end

    p = plot(title=title,
             xlabel="Pipeline",
             ylabel="Score (%)",
             legend=:topright,
             size=(1400, 800),
             gridalpha=0.3,
             ylims=(0, 100),
             xticks=(1:n_pipelines, pipeline_labels),
             margins=10Plots.mm,
             fontfamily=PLOT_FONT,
             titlefontsize=12,
             guidefontsize=10,
             tickfontsize=10,
             legendfontsize=10)

    for (i, metric) in enumerate(metrics)
        plot!(p, 1:n_pipelines, values[i, :],
              label=metric_labels[i],
              marker=:circle,
              markersize=8,
              linewidth=2,
              color=PALETTE[i])
    end

    savefig(p, output)
    println("plot saved to: $output")

    return p
end

function plot_all_benchmarks(toml_file::String; output_dir=".")
    data = TOML.parsefile(toml_file)

    if !haskey(data, "benchmark")
        error("No benchmarks found in TOML file")
    end

    benchmarks = keys(data["benchmark"])

    for benchmark in benchmarks
        output_file = joinpath(output_dir, "$(benchmark).svg")
        plot_benchmark(toml_file, benchmark, output=output_file)
    end

    println("generated $(length(benchmarks)) plots")
end

"""
Compare a single metric across all benchmarks for all pipelines.
"""
function plot_metric_comparison(
    toml_file::String,
    metric::String;
    output="comparison.svg",
    metric_label=nothing,
    title=nothing,
    plot_font=PLOT_FONT
)
    data = TOML.parsefile(toml_file)

    pipeline_keys = collect(keys(data["pipelines"]))
    sort!(pipeline_keys, by = k -> data["pipelines"][k]["order"])
    pipeline_labels = [data["pipelines"][k]["label"] for k in pipeline_keys]

    benchmarks = collect(keys(data["benchmark"]))
    n_pipelines = length(pipeline_keys)
    n_benchmarks = length(benchmarks)

    values = zeros(n_benchmarks, n_pipelines)
    for (i, benchmark) in enumerate(benchmarks)
        benchmark_data = data["benchmark"][benchmark]
        for (j, pipeline) in enumerate(pipeline_keys)
            if haskey(benchmark_data, pipeline) && haskey(benchmark_data[pipeline], metric)
                values[i, j] = benchmark_data[pipeline][metric] * 100
            end
        end
    end

    if title === nothing
        metric_display = metric_label !== nothing ? metric_label : metric
        title = "$metric_display Across Benchmarks"
    end

    p = plot(title=title,
             xlabel="Benchmark",
             ylabel="Score (%)",
             legend=:topright,
             size=(1400, 800),
             gridalpha=0.3,
             ylims=(0, 105),
             xticks=(1:n_benchmarks, benchmarks),
             margins=10Plots.mm,
             fontfamily=PLOT_FONT,
             titlefontsize=12,
             guidefontsize=10,
             tickfontsize=10,
             legendfontsize=10)

    for (j, pipeline_label) in enumerate(pipeline_labels)
        color_idx = ((j - 1) % length(PALETTE)) + 1
        plot!(p, 1:n_benchmarks, values[:, j],
              label=pipeline_label,
              marker=:circle,
              markersize=8,
              linewidth=2,
              color=PALETTE[color_idx])
    end

    savefig(p, output)
    println("plot saved to: $output")

    return p
end

plot_all_benchmarks("results.toml")
plot_metric_comparison("results.toml", "execution-accuracy")
