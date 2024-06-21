using SymbolicUtils: BasicSymbolic

@testset "Expronicon generated constructors" begin
    s1 = Sym(:abc)
    s2 = Sym(name = :def)
    name = :ghi
    s3 = Sym(; name)
    bs1 = BasicSymbolic{Float64}(impl = s1)
    impl = s2
    bs2 = BasicSymbolic{Int64}(; impl)
    @testset "Sym" begin
        @test_nowarn Sym(Symbol(""))
        @test s1.name == :abc
        @test typeof(s2.name) == Symbol
        @test typeof(s1) == BasicSymbolicImpl
        @test s2.name == :def
        @test s3.name == :ghi
    end
    @testset "Term" begin
        t1 = Term(sin, [bs1])
        @test t1.f == sin
        @test t1.arguments == [bs1]
        @test typeof(t1.arguments) == Vector{BasicSymbolic}
        @test_throws MethodError Term(sin, [s1])
        @test_throws MethodError Term(sin, [1])
        @test_throws MethodError Term(sin, [2.0])
    end
    @testset "Div" begin
        d1 = Div(num = bs1, den = bs2)
        @test typeof(d1.num) == BasicSymbolic{Float64}
        @test typeof(d1.den) == BasicSymbolic{Int64}
        @test d1.num == bs1
        @test d1.den == bs2
        @test typeof(d1.simplified) == Base.RefValue{Bool}
        @test isassigned(d1.simplified)
        @test !d1.simplified[]
        @test typeof(d1.arguments) == Vector{BasicSymbolic}
        @test d1.arguments == [bs1, bs2]
        num = bs1
        den = bs2
        d2 =  Div(; num, den)
        @test d2.num == bs1
        @test d2.den == bs2
        @test_throws MethodError Div(num = s1, den = bs2)
        @test_throws MethodError Div(num = bs1, den = s2)
        @test_throws MethodError Div(num = s1, den = s2)
    end
    @testset "Pow" begin
        p1 = Pow(base = bs1, exp = bs2)
        @test typeof(p1.base) == BasicSymbolic{Float64}
        @test typeof(p1.exp) == BasicSymbolic{Int64}
        @test p1.base == bs1
        @test p1.exp == bs2
        @test typeof(p1.arguments) == Vector{BasicSymbolic}
        @test p1.arguments == [bs1, bs2]
        base = bs1
        exp = bs2
        p2 =  Pow(; base, exp)
        @test p2.base == bs1
        @test p2.exp == bs2
        @test_throws MethodError Pow(base = s1, exp = bs2)
        @test_throws MethodError Pow(base = bs1, exp = s2)
        @test_throws MethodError Pow(base = s1, exp = s2)
    end
    c1 = Const(1)
    bc1 = BasicSymbolic{Int}(impl = c1)
    c2 = Const(val = 3.14)
    bc2 = BasicSymbolic{Float64}(impl = c2)
    @testset "Const" begin
        @test typeof(c1.val) == Int
        @test c1.val == 1
        @test typeof(c2.val) == Float64
        @test c2.val == 3.14
        c3 = Const(big"123456789012345678901234567890")
        @test typeof(c3.val) == BigInt
        @test c3.val == big"123456789012345678901234567890"
        c4 = Const(big"1.23456789012345678901")
        @test typeof(c4.val) == BigFloat
        @test c4.val == big"1.23456789012345678901"
    end
end
