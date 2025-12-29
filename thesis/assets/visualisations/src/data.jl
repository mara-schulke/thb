"""
Data structures for benchmark results and pipelines.
"""

using TOML

struct Pipeline
    key::String
    label::String
    order::Int
    external::Bool
    sota::Bool
    verified::Bool
end

function Pipeline(key::String, data::Dict)
    Pipeline(
        key,
        data["label"],
        data["order"],
        get(data, "external", false),
        get(data, "sota", false),
        get(data, "verified", true)
    )
end

struct BenchmarkData
    file_path::String
    pipelines::Vector{Pipeline}
    benchmarks::Dict{String, Dict{String, Dict{String, Float64}}}
end

function BenchmarkData(file_path::String)
    data = TOML.parsefile(file_path)

    pipeline_keys = collect(keys(data["pipelines"]))
    pipelines = [Pipeline(k, data["pipelines"][k]) for k in pipeline_keys]
    sort!(pipelines, by = p -> p.order)

    benchmarks = get(data, "benchmark", Dict())

    BenchmarkData(file_path, pipelines, benchmarks)
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
