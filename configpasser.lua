local configString = [[
    memorySize: 30000
    debug: true
    ]]
    
local config = function(Input, Output)
      assert(type(Input) == "string", "Argument 1 (Input) must be a string")
    
                            Output = type(Output) == "table" and Output or {}
    
         for Key, Value in string.gmatch(Input, "%s*(.-)%s*:%s*(.-)%s*\n") do
                   if string.lower(Value) == "nil" or string.lower(Value) == "null" or string.lower(Value) == "none" or string.lower(Value) == "nothing" or string.lower(Value) == "undefined" then
                                    Output[Key] = nil
              elseif string.lower(Value) == "true" then
                      Output[Key] = true
                       elseif string.lower(Value) == "false" then
                                    Output[Key] = false
                   elseif tonumber(Value) then
                                    Output[Key] = tonumber(Value)
                                else
                                    Output[Key] = Value
                                end
                            end
    
                            return Output
                        end
    
                        local settings = config(configString)
    
                        -- Użycie ustawień do konfiguracji BrainfuckRunner
                        function createBrainfuckRunner(settings)
                            local tape = {}
                            local ptr = 1
                            local output = ""
                            local memorySize = settings.memorySize or 30000
                            local debug = settings.debug or false
    
                            -- Initialize tape with zeros
                            for i = 1, memorySize do
                                tape[i] = 0
                            end
    
                            local function increment()
                                tape[ptr] = (tape[ptr] + 1) % 256
                                if debug then print("Increment:", tape[ptr]) end
                            end
    
                            local function decrement()
                                tape[ptr] = (tape[ptr] - 1) % 256
                                if debug then print("Decrement:", tape[ptr]) end
                            end
    
                            local function moveRight()
                                ptr = ptr + 1
                                if tape[ptr] == nil then
                                    tape[ptr] = 0
                                end
                                if debug then print("Move Right:", ptr) end
                            end
    
                            local function moveLeft()
                                ptr = ptr - 1
                                if ptr < 1 then
                                    ptr = 1
                                end
                                if debug then print("Move Left:", ptr) end
                            end
    
                            local function printChar()
                                output = output .. string.char(tape[ptr])
                                if debug then print("Output:", output) end
                            end
    
                            local function runCode(code)
                                local loopStack = {}
                                local pc = 1
                                while pc <= #code do
                                    local command = code:sub(pc, pc)
                                    if command == "+" then
                                        increment()
                                    elseif command == "-" then
                                        decrement()
                                    elseif command == ">" then
                                        moveRight()
                                    elseif command == "<" then
                                        moveLeft()
                                    elseif command == "." then
                                        printChar()
                                    elseif command == "[" then
                                        if tape[ptr] == 0 then
                                            local loopEnd = 1
                                            while loopEnd > 0 do
                                                pc = pc + 1
                                                if code:sub(pc, pc) == "[" then
                                                    loopEnd = loopEnd + 1
                                                elseif code:sub(pc, pc) == "]" then
                                                    loopEnd = loopEnd - 1
                                                end
                                            end
                                        else
                                            table.insert(loopStack, pc)
                                        end
                                    elseif command == "]" then
                                        if tape[ptr] ~= 0 then
                                            pc = loopStack[#loopStack]
                                        else
                                            table.remove(loopStack)
                                        end
                                    end
                                    pc = pc + 1
                                end
    
                                print("Brainfuck Output:", output)
                            end
    
                            -- Return a table with the runCode function
                            return {
                                run = runCode
                            }
                        end
    
                        -- Create a Brainfuck runner with the settings
                        local bfRunner = createBrainfuckRunner(settings)
                        bfRunner:run(bfCode1)