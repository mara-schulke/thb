"""
BaselineImprovementPlot - Show improvement over baseline.
"""

struct BaselineImprovementPlot
    baseline_key::String
    comparison_keys::Vector{String}
    metric::String
    title::String
    output::String
end

function BaselineImprovementPlot(;
                                 baseline_key="natural-baseline",
                                 comparison_keys=["natural-zeroshot", "natural-full-syn", "natural-full-train", "natural-full-ground"],
                                 metric="execution-accuracy",
                                 title="Relative Performance Improvement Over Baseline",
                                 output="relative-improvement.svg")
    BaselineImprovementPlot(baseline_key, comparison_keys, metric, title, output)
end

function render(plot_config::BaselineImprovementPlot, data::BenchmarkData; plot_font, palette)
    all_benchmark_keys = sort_benchmarks_by_order(data, collect(keys(data.results)))

    # Collect baseline values
    baseline_values = Dict{String, Float64}()
    for benchmark in all_benchmark_keys
        baseline_values[benchmark] = get_value(data, benchmark, plot_config.baseline_key, plot_config.metric)
    end

    # First pass: determine which comparisons have at least one non-zero value
    valid_comparison_keys = String[]
    for comp_key in plot_config.comparison_keys
        has_data = false
        for benchmark in all_benchmark_keys
            comp_value = get_value(data, benchmark, comp_key, plot_config.metric)
            # Include if either baseline or comparison has data
            if comp_value > 0.0 || baseline_values[benchmark] > 0.0
                has_data = true
                break
            end
        end
        if has_data
            push!(valid_comparison_keys, comp_key)
        end
    end

    # If no valid comparisons, skip plotting
    if isempty(valid_comparison_keys)
        println("Warning: No data for baseline improvement comparison")
        return nothing
    end

    # Filter benchmarks: only include if at least one comparison or baseline has data
    valid_benchmarks = String[]
    for benchmark in all_benchmark_keys
        has_data = baseline_values[benchmark] > 0.0
        for comp_key in valid_comparison_keys
            comp_value = get_value(data, benchmark, comp_key, plot_config.metric)
            if comp_value > 0.0
                has_data = true
                break
            end
        end
        if has_data
            push!(valid_benchmarks, benchmark)
        end
    end

    benchmark_keys = valid_benchmarks
    benchmark_labels = [get_benchmark_label(data, b) for b in benchmark_keys]

    n_comparisons = length(valid_comparison_keys)
    n_benchmarks = length(benchmark_keys)
    improvements = zeros(n_comparisons, n_benchmarks)

    for (i, comp_key) in enumerate(valid_comparison_keys)
        for (j, benchmark) in enumerate(benchmark_keys)
            comp_value = get_value(data, benchmark, comp_key, plot_config.metric)
            improvements[i, j] = comp_value - baseline_values[benchmark]
        end
    end

    comparison_pipelines = [data.pipelines[findfirst(p -> p.key == k, data.pipelines)] for k in valid_comparison_keys]
    comparison_labels = [p.label for p in comparison_pipelines]
    fillstyles = get_fillstyles(comparison_pipelines)

    # Only rotate labels if there are more than 8
    rotation_angle = n_benchmarks > 8 ? 45 : 0

    p = groupedbar(
        benchmark_labels,
        improvements',
        bar_position=:dodge,
        bar_width=0.8,
        label=permutedims(comparison_labels),
        fillstyle=permutedims(fillstyles),
        color_palette=readable(comparison_pipelines, palette),
        xlabel=Label("Benchmark"),
        ylabel=Label("Improvement in EA (%)"),
        title=Title(plot_config.title),
        legend=:outertop,
        legend_columns=4,
        ylims=yautolims(improvements),
        size=DIMENSIONS,
        gridalpha=0.3,
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

    hline!(p, [0], color=:black, linestyle=:dash, label="Baseline", linewidth=1)

    ensure_output_dir(plot_config.output)
    savefig(p, plot_config.output)
    println("plot saved to: $(plot_config.output)")
    return p
end
