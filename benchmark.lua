-- [ @focat ]
-- [ designed to run on Lua5.4 - NOT Luau ]
local collectgarbage = collectgarbage
local math = math
local os = os
local pairs = pairs
local ipairs = ipairs
local next = next
local print = print
local table = table
local tostring = tostring

local TABLE_SIZE = 5000
local ITERATIONS = 500
local TRIALS = 3
local WARMUP = 2 -- [ for JIT ]

local test_data = {}
math.randomseed(42)

for i = 1, TABLE_SIZE do
    test_data[i] = math.random(1, 1000)
end

local function create_sequential_array(size)
    local t = {}
    for i = 1, size do
        t[i] = test_data[i]
    end
    return t
end

local function create_sparse_array(size)
    local t = {}
    for i = 1, size do
        if i % 5 == 0 then
            t[i] = test_data[i]
        end
    end
    return t
end

local function create_non_numeric_table(size)
    local t = {}
    for i = 1, size do
        t["key_" .. tostring(i)] = test_data[i]
    end
    return t
end

local function run_benchmark(name, setup_func, methods)
    print("\n=== Benchmarking " .. name .. " (" .. TABLE_SIZE .. " elements, " .. 
          ITERATIONS .. " iterations) ===")
    
    collectgarbage()
    local test_table = setup_func(TABLE_SIZE)
    
    for _, method in next, methods do
        local total_time = 0
        local min_time = math.huge
        local max_time = 0
        
        for _ = 1, WARMUP do
            local sum = 0
            if method == "ipairs" then
                for i, v in ipairs(test_table) do sum = sum + v end
            elseif method == "pairs" then
                for k, v in pairs(test_table) do sum = sum + v end
            elseif method == "next" then
                for k, v in next, test_table do sum = sum + v end
            elseif method == "numeric_for" then
                for i = 1, #test_table do sum = sum + test_table[i] end
            end
        end
        
        for _ = 1, TRIALS do
            collectgarbage()
            local start_time = os.clock()
            local sum = 0
            
            for _ = 1, ITERATIONS do
                if method == "ipairs" then
                    for i, v in ipairs(test_table) do sum = sum + v end
                elseif method == "pairs" then
                    for k, v in pairs(test_table) do sum = sum + v end
                elseif method == "next" then
                    for k, v in next, test_table do sum = sum + v end
                elseif method == "numeric_for" then
                    for i = 1, #test_table do sum = sum + test_table[i] end
                end
            end
            
            local elapsed = os.clock() - start_time
            total_time = total_time + elapsed
            min_time = math.min(min_time, elapsed)
            max_time = math.max(max_time, elapsed)
        end
        
        local avg_time = total_time / TRIALS
        print(string.format("%-12s: avg %.6fs | min %.6fs | max %.6fs", 
              method, avg_time, min_time, max_time))
    end
end

print("Lua Table Iteration Benchmark")
print("========================================================")

-- [ negro ]
run_benchmark("Sequential Array", create_sequential_array, {
    "ipairs", "pairs", "next", "numeric_for"
})
run_benchmark("Sparse Array", create_sparse_array, {
    "pairs", "next", "numeric_for"
})

run_benchmark("Non-Numeric Table", create_non_numeric_table, {
    "pairs", "next"
})
