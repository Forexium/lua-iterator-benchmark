-- Helper functions to create more complex tables for benchmarking
local function create_sequential_array()
    local t = {}
    for i = 1, 1000 do  -- Reduced to 1000 elements
        t[i] = math.random(1, 1000)
    end
    return t
end

local function create_sparse_array()
    local t = {}
    for i = 1, 1000 do  -- Reduced to 1000 elements
        if i % 2 == 0 then
            t[i] = math.random(1, 1000)
        end
    end
    return t
end

local function create_non_numeric_table()
    local t = {}
    for i = 1, 1000 do  -- Reduced to 1000 elements
        t["key" .. i] = math.random(1, 1000)
    end
    return t
end

-- Benchmarking functions for each loop method
local iterations = 100  -- Reduced iterations for quicker tests

-- Helper function to add a timeout mechanism
local function timeout_function(limit, func)
    local start_time = os.clock()
    local success, result = pcall(func)
    local elapsed_time = os.clock() - start_time
    if elapsed_time > limit then
        print("Timeout exceeded: " .. elapsed_time .. " seconds.")
    end
    return success, result
end

-- Helper function for benchmarking each loop method
local function benchmark_loop_method(t, method)
    local start_time = os.clock()
    for _ = 1, iterations do
        if method == "ipairs" then
            for i = 1, #t do
                local value = t[i]
            end
        elseif method == "pairs" then
            for _, value in pairs(t) do
                -- Do nothing
            end
        elseif method == "next" then
            for _, value in next, t do
                -- Do nothing
            end
        end
    end
    return os.clock() - start_time
end

-- Run the benchmarks for a given table type and find the winner
local function run_single_method_benchmark(table_type, method)
    print("\n[/] Running benchmark for " .. table_type .. " with method " .. method)

    local test_table
    -- Create table based on the type
    if table_type == "sequential" then
        test_table = create_sequential_array()
    elseif table_type == "sparse" then
        test_table = create_sparse_array()
    elseif table_type == "non_numeric" then
        test_table = create_non_numeric_table()
    else
        print("Unknown table type!")
        return
    end

    -- Run the benchmark and measure time
    local start_time = os.clock()
    for _ = 1, iterations do
        if method == "ipairs" then
            for i = 1, #test_table do
                local value = test_table[i]
            end
        elseif method == "pairs" then
            for _, value in pairs(test_table) do
                -- Do nothing
            end
        elseif method == "next" then
            for _, value in next, test_table do
                -- Do nothing
            end
        end
    end
    print(table_type .. " with " .. method .. " took: " .. os.clock() - start_time .. " seconds.")
end

-- Run benchmarks only for applicable methods (ipairs for sequential, pairs/next for others)
timeout_function(10, function() run_single_method_benchmark("sequential", "ipairs") end)
timeout_function(10, function() run_single_method_benchmark("sequential", "pairs") end)

timeout_function(10, function() run_single_method_benchmark("sparse", "pairs") end)
timeout_function(10, function() run_single_method_benchmark("sparse", "next") end)

timeout_function(10, function() run_single_method_benchmark("non_numeric", "pairs") end)
timeout_function(10, function() run_single_method_benchmark("non_numeric", "next") end)
