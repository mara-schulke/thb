"""
Data structures for benchmark results and pipelines.
"""

using TOML

struct Metric
    key::String
    label::String
end

function Metric(key::String, data::Dict)
    if !haskey(data, "label")
        error("Metric '$key' missing required 'label' field")
    end
    Metric(key, String(data["label"]))
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
    benchmarks::BenchmarkResults
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

    # Parse benchmarks using nested constructors
    benchmark_data = get(data, "benchmark", Dict())::Dict
    benchmarks = BenchmarkResults(benchmark_data)

    # Parse metrics using constructor
    metric_data = get(data, "metrics", Dict())::Dict
    metrics = Dict{String, Metric}(
        k => Metric(k, v::Dict) for (k, v) in metric_data
    )

    BenchmarkData(file, pipelines, benchmarks, metrics)
end

function get_value(bd::BenchmarkData, benchmark::String, pipeline_key::String, metric::String)
    if haskey(bd.benchmarks, benchmark) &&
       haskey(bd.benchmarks[benchmark], pipeline_key) &&
       haskey(bd.benchmarks[benchmark][pipeline_key], metric)
        return bd.benchmarks[benchmark][pipeline_key][metric] * 100
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
