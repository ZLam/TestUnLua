local Test = ClassEX("Test")

function Test:ctor(params)
    print("Test:ctor")

    -- Lua 中的变量全是全局变量，那怕是语句块或是函数里，除非用 local 显式声明为局部变量。
    -- 用不了unpack()，2020/7/20

    params = params or {}

    self._bTest = true
    self._Num = 123
    self._Desc = "Hello UnLua"
    self._Arr = {0, 3, -123.456, 789.123, 666}
    self._Map = {["a"] = "haha", ["b"] = "xixi", ["c"] = "wawa"}
    self._BP = params.BP

    self:OnEnter()
end

function Test:OnEnter()
    math.randomseed(os.time())

    self:TestBase()
    self:TestFunc()
    self:TestString()
    self:TestTable()
    self:TestMetatable()
    self:TestCoroutine()
end

function Test:TestBase()
    print("===Test:TestBase_Begin===")

    print(type(nil))
    print(type(self._bTest))
    print(type(self._Num))
    print(type(self._Desc))
    print(type(self._Arr))
    print(type(self._Map))
    print(type(self._BP))
    print(type(self.OnEnter))
    print(type(self._BP:K2_GetActorLocation()))

    local tArr1 = {}
    for i = 1, 10, 1 do
        tArr1[i] = i * 2 - 1
    end
    print(self:ConvertArr2Str(tArr1))

    print(self:ConvertArr2Str(self:FibonacciSequence(10)))

    for i = 1, 3 do
        self:Choose(math.random(1, 3))
    end

    print("===Test:TestBase_End===")
end

function Test:TestFunc()
    print("===Test:TestFunc_Begin===")

    self:MoreParams("more", "params", "a", "b", "c")

    local r1, r2, r3 = self:MoreReturn()
    print(r1)
    print(r2)
    print(self:ConvertArr2Str(r3))

    print("===Test:TestFunc_End===")
end

function Test:TestString()
    print("===Test:TestString_Begin===")

    local s1 = "Test_String"

    print("s1 is : ", s1)
    print("s1 length is : ", #s1)
    print("s1 find 'Str' : ", string.find(s1, "Str"))
    print(string.format("s1 sub from %d to %d", string.find(s1, "Str")), string.sub(s1, string.find(s1, "Str")))
    print("s1 match by '%a_%a' : ", string.match(s1, "%a_%a"))
    print(string.format("string format : %02d | %.2f | %s", 7, 6.666, "xixi"))

    print("===Test:TestString_End===")
end

function Test:TestTable()
    print("===Test:TestTable_Begin===")

    local data1 = {3, 0, -5, 1, 9, 2, 6, 8, 7, 4, 10}
    local data2 = {
        {
            ["Order"] = 3,
            ["Desc"] = "haha",
        },
        {
            ["Order"] = 5,
            ["Desc"] = "wawa",
        },
        {
            ["Order"] = 1,
            ["Desc"] = "xixi",
        },
        {
            ["Order"] = 4,
            ["Desc"] = "lala",
        },
        {
            ["Order"] = 2,
            ["Desc"] = "zaza",
        },
    }

    print("data1 : ", self:ConvertArr2Str(data1))
    table.insert(data1, 3, -6)
    print("data1 insert -6 to pos 3 : ", self:ConvertArr2Str(data1))
    table.remove(data1, 4)
    print("data1 remove pos 4 : ", self:ConvertArr2Str(data1))
    print("data2 :")
    dump(data2)
    print("data2 sorted :")
    table.sort(
        data2,
        function(a, b)
            return a.Order < b.Order
        end
    )
    dump(data2)

    print("===Test:TestTable_End===")
end

--[[
    元表，个人觉得就是一个可以重载table的行为的功能
--]]
function Test:TestMetatable()
    print("===Test:TestMetatable_Begin===")

    --[[
        Lua 查找一个表元素时的规则，其实就是如下 3 个步骤:
        1.在表中查找，如果找到，返回该元素，找不到则继续
        2.判断该表是否有元表，如果没有元表，返回 nil，有元表则继续。
        3.判断元表有没有 __index 方法，如果 __index 方法为 nil，则返回 nil；如果 __index 方法是一个表，则重复 1、2、3；如果 __index 方法是一个函数，则返回该函数的返回值。
    --]]

    local tb_index = {}
    print(tb_index.data)
    setmetatable(tb_index, {["__index"] = {["data"] = 789}})
    print(tb_index.data)
    setmetatable(
        tb_index,
        {
            ["__index"] = function(tb, key)
                return string.format("not found value by '%s'", key)
            end
        }
    )
    print(tb_index.item)

    --[[
        __newindex 元方法用来对表更新，__index则用来对表访问 。
        当你给表的一个缺少的索引赋值，解释器就会查找__newindex 元方法：如果存在则调用这个函数而不进行赋值操作。
    --]]

    local tb_newindex = {}
    tb_newindex.a = "aaa"
    dump(tb_newindex)
    setmetatable(
        tb_newindex,
        {
            ["__newindex"] = function(tb, key, value)
                print(string.format("want set '%s' key with '%s' value", key, value))
            end
        }
    )
    tb_newindex.a = "AAA"
    dump(tb_newindex)
    tb_newindex.b = "bbb"
    dump(tb_newindex)

    print("===Test:TestMetatable_End===")
end

function Test:TestCoroutine()
    print("===Test:TestCoroutine_Begin===")

    local co1 = coroutine.create(
        function(num)
            print(num)
            coroutine.yield(num * 2)
            print(num * 3)
            return 0
        end
    )
    
    print(coroutine.status(co1))
    print(coroutine.resume(co1, 2))
    print(coroutine.status(co1))
    print(coroutine.resume(co1))
    print(coroutine.status(co1))

    function foo (a)
        print("foo 函数输出", a)
        return coroutine.yield(2 * a) -- 返回  2*a 的值
    end
     
    local co2 = coroutine.create(function (a , b)
        print("第一次协同程序执行输出", a, b) -- co-body 1 10
        local r = foo(a + 1)        -- 此处yield返回，参数是resume的参数
         
        print("第二次协同程序执行输出", r)
        local r, s = coroutine.yield(a + b, a - b)  -- a，b的值为第一次调用协同程序时传入
         
        print("第三次协同程序执行输出", r, s)
        return b, "结束协同程序"
    end)
           
    print("main", coroutine.resume(co2, 1, 10)) -- true, 4
    print("--分割线----")
    print("main", coroutine.resume(co2, "r")) -- true 11 -9
    print("---分割线---")
    print("main", coroutine.resume(co2, "x", "y")) -- true 10 end
    print("---分割线---")
    print("main", coroutine.resume(co2, "x", "y")) -- cannot resume dead coroutine
    print("---分割线---")

    print("===Test:TestCoroutine_End===")
end

function Test:ConvertArr2Str(Arr)
    if (not Arr or #Arr <= 0) then
        return ""
    end
    return table.concat(Arr, ", ")
end

function Test:FibonacciSequence(Num)
    if (Num <= 1) then
        return {0}
    end
    if (Num == 2) then
        return {0, 1}
    end
    local Arr = {0, 1}
    local Index = 3;
    while (Index <= Num) do
        Arr[Index] = Arr[Index - 1] + Arr[Index - 2]
        Index = Index + 1
    end
    return Arr
end

function Test:Choose(Num)
    if (Num <= 1) then
        print("Choose : One")
    elseif (Num == 2) then
        print("Choose : Two")
    else
        print("Choose : Three")
    end
end

function Test:MoreParams(a, b, ...)
    print("a : ", a)
    print("b : ", b)
    local Args = {...}
    print(self:ConvertArr2Str(Args))
end

function Test:MoreReturn()
    return 1.23, "haha", {3, 4, 5}
end

return Test