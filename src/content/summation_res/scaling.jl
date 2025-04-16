function find_timings(n, num_samples, ArrayType)
    timings = zeros(n)
    for i = 1:n
        size = 2^i
        data = ArrayType(ones(size))

        # To precompile the function
        sum(data)

        t = 0

        for i = 1:num_samples
            t += @elapsed sum(data)
        end
        timings[i] = t / num_samples
    end

    return timings
end
