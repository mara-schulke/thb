"""
Utility functions for plot rendering.
"""

function Title(s::String)
    return "$(s)"
end

function Label(s::String)
    return "$(s)"
end

function ensure_output_dir(output_path::String)
    output_dir = dirname(output_path)
    if !isempty(output_dir) && !isdir(output_dir)
        mkpath(output_dir)
    end
end

"""
Get fillstyle for pipelines (striped pattern for unverified).
Returns a vector of fillstyles corresponding to each pipeline.
"""
function get_fillstyles(pipelines::Vector{Pipeline})
    return [p.verified ? nothing : :// for p in pipelines]
end
