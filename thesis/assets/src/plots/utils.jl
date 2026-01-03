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

struct PaletteScheme
    verified::Any
    unverified::Any
end

"""
Compute y-axis bounds with 10% padding on upper bound only.
Lower bound is always 0.
Returns a tuple (ymin, ymax) suitable for use with ylims.
"""
function yautolims(data)
    # Flatten if it's a matrix
    values = vec(data)

    # Filter out any NaN or Inf values
    values = filter(x -> isfinite(x), values)

    if isempty(values)
        return (0, 100)  # Default fallback
    end

    ymax = maximum(values)

    # Calculate padding (10% of max value, only on upper bound)
    padding = ymax * 0.1

    # Return bounds with 0 as lower bound and padding on upper bound
    return (0, ymax + padding)
end

"""
Get fillstyle for pipelines (striped pattern for unverified).
Returns a vector of fillstyles corresponding to each pipeline.
"""
function get_fillstyles(pipelines::Vector{Pipeline})
    return [p.verified ? nothing : :/ for p in pipelines]
end

"""
Get colors for pipelines, using different palettes for verified vs unverified.
Verified: Uses palette.verified
Unverified: Uses palette.unverified
"""
function readable(pipelines::Vector{Pipeline}, palette::PaletteScheme)
    n_pipelines = length(pipelines)
    colors = Vector{Any}(undef, n_pipelines)

    verified_indices = findall(p -> p.verified, pipelines)
    unverified_indices = findall(p -> !p.verified, pipelines)

    verified_size = length(palette.verified)
    unverified_size = length(palette.unverified)

    for (i, idx) in enumerate(verified_indices)
        color_idx = ((i - 1) % verified_size) + 1
        colors[idx] = palette.verified[color_idx]
    end

    for (i, idx) in enumerate(unverified_indices)
        color_idx = ((i - 1) % unverified_size) + 1
        colors[idx] = palette.unverified[color_idx]
    end

    return colors
end
