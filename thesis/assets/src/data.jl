"""
Data structures for benchmark results and pipelines.
"""

using TOML

struct Metric
    key::String
    label::String
    unit::String
end

function Metric(key::String, data::Dict)
    if !haskey(data, "label")
        error("Metric '$key' missing required 'label' field")
    end
    Metric(key, String(data["label"]), String(get(data, "unit", "")))
end

struct Benchmark
    key::String
    label::String
    order::Int
end

function Benchmark(key::String, data::Dict)
    if !haskey(data, "label")
        error("Benchmark '$key' missing required 'label' field")
    end
    if !haskey(data, "order")
        error("Benchmark '$key' missing required 'order' field")
    end
    Benchmark(key, String(data["label"]), Int(data["order"]))
end

struct Pipeline
    key::String
    label::String
    order::Int
    external::Bool
    sota::Bool
    verified::Bool
end

function Pipeline(key::String, data::Dict)
    if !haskey(data, "label")
        error("Pipeline '$key' missing required 'label' field")
    end
    if !haskey(data, "order")
        error("Pipeline '$key' missing required 'order' field")
    end

    Pipeline(
        key,
        String(data["label"]),
        Int(data["order"]),
        Bool(get(data, "external", false)),
        Bool(get(data, "sota", false)),
        Bool(get(data, "verified", true))
    )
end

struct PipelineMetrics
    data::Dict{String, Float64}
    PipelineMetrics(data::Dict) = new(Dict{String, Float64}(k => Float64(v) for (k, v) in data))
end

Base.haskey(pm::PipelineMetrics, key) = haskey(pm.data, key)
Base.getindex(pm::PipelineMetrics, key) = pm.data[key]
Base.keys(pm::PipelineMetrics) = keys(pm.data)

struct BenchmarkPipelines
    data::Dict{String, PipelineMetrics}
    BenchmarkPipelines(data::Dict) = new(
        Dict{String, PipelineMetrics}(k => PipelineMetrics(v::Dict) for (k, v) in data)
    )
end

Base.haskey(bp::BenchmarkPipelines, key) = haskey(bp.data, key)
Base.getindex(bp::BenchmarkPipelines, key) = bp.data[key]
Base.keys(bp::BenchmarkPipelines) = keys(bp.data)

struct BenchmarkResults
    data::Dict{String, BenchmarkPipelines}
    BenchmarkResults(data::Dict) = new(
        Dict{String, BenchmarkPipelines}(k => BenchmarkPipelines(v::Dict) for (k, v) in data)
    )
end

Base.haskey(br::BenchmarkResults, key) = haskey(br.data, key)
Base.getindex(br::BenchmarkResults, key) = br.data[key]
Base.keys(br::BenchmarkResults) = keys(br.data)

struct BenchmarkData
    path::String
    pipelines::Vector{Pipeline}
    results::BenchmarkResults
    benchmarks::Dict{String, Benchmark}
    metrics::Dict{String, Metric}
end

function BenchmarkData(file::String)
    if !isfile(file)
        error("Config file not found: $file")
    end

    data = TOML.parsefile(file)

    # Validate and parse pipelines
    if !haskey(data, "pipelines")
        error("Missing required 'pipelines' section in $file")
    end
    pipeline_data = data["pipelines"]::Dict
    pipelines = [Pipeline(k, pipeline_data[k]::Dict) for k in keys(pipeline_data)]
    sort!(pipelines, by = p -> p.order)

    # Parse benchmark info (labels)
    benchmarks_data = get(data, "benchmarks", Dict())::Dict
    benchmarks = Dict{String, Benchmark}(
        k => Benchmark(k, v::Dict) for (k, v) in benchmarks_data
    )

    # Parse results using nested constructors
    results_data = get(data, "results", Dict())::Dict
    results = BenchmarkResults(results_data)

    # Parse metrics using constructor
    metric_data = get(data, "metrics", Dict())::Dict
    metrics = Dict{String, Metric}(
        k => Metric(k, v::Dict) for (k, v) in metric_data
    )

    BenchmarkData(file, pipelines, results, benchmarks, metrics)
end

function get_value(bd::BenchmarkData, benchmark::String, pipeline_key::String, metric::String, scale::Number=100)
    if haskey(bd.results, benchmark) &&
       haskey(bd.results[benchmark], pipeline_key) &&
       haskey(bd.results[benchmark][pipeline_key], metric)
        return bd.results[benchmark][pipeline_key][metric] * scale
    end
    return 0.0
end

function get_pipeline_label(pipeline::Pipeline, include_asterisk::Bool=true)
    label = pipeline.label
    if include_asterisk && !pipeline.verified
        label *= "*"
    end
    return label
end

function get_benchmark_label(bd::BenchmarkData, benchmark_key::String)
    if haskey(bd.benchmarks, benchmark_key)
        return bd.benchmarks[benchmark_key].label
    end
    return benchmark_key
end

function get_metric_label(data::BenchmarkData, metric::String)
    if haskey(data.metrics, metric) 
        return data.metrics[metric].label
    end

    return metric
end
