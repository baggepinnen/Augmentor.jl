@testset "Amplify" begin
    @test typeof(@inferred(Amplify(2))) <: Amplify <: Augmentor.ArrayOperation
    @testset "constructor" begin
        @test str_show(Amplify(2)) == "Augmentor.Amplify(2)"
        @test str_showconst(Amplify(2)) == "Amplify(2)"
        @test str_showcompact(Amplify(2)) == "Amplify signal"
    end
    @testset "eager" begin
        @test_throws MethodError Augmentor.applyeager(Amplify(2), nothing)
        @test Augmentor.supports_eager(Amplify) === true
        res1 = rect .* 2
        imgs = [
            (rect, res1),
            (OffsetArray(rect, -2, -1), res1),
            (view(rect, IdentityRange(1:2), IdentityRange(1:3)), res1),
        ]
        @testset "single image" begin
            for (img_in, img_out) in imgs
                res = @inferred(Augmentor.applyeager(Amplify(2), img_in))
                @test res == img_out
                @test typeof(res) == typeof(img_out)
            end
        end
        @testset "multiple images" begin
            for (img_in1, img_out1) in imgs, (img_in2, img_out2) in imgs
                img_in = (img_in1, img_in2)
                img_out = (img_out1, img_out2)
                res = @inferred(Augmentor.applyeager(Amplify(2), img_in))
                @test res == img_out
                @test typeof(res) == typeof(img_out)
            end
        end
    end
    @testset "lazy" begin
        @test Augmentor.supports_lazy(Amplify) === true
        @testset "single image" begin
            v = @inferred Augmentor.applylazy(Amplify(2), rect)
            @test v == 2 .* rect
            @test typeof(v) <: MappedArrays.ReadonlyMappedArray
        end
        @testset "multiple images" begin
            img_in = (rgb_rect, square)
            res1, res2 = @inferred(Augmentor.applylazy(Amplify(2), img_in))
            @test res1 == 2 .* rgb_rect
            @test res2 == 2 .* square
            @test typeof(res1) <: ReadonlyMappedArray
            @test typeof(res2) <: ReadonlyMappedArray
        end
    end
    @testset "view" begin
        @test Augmentor.supports_view(Amplify) === false
    end
    @testset "stepview" begin
        @test Augmentor.supports_stepview(Amplify) === false
    end
    @testset "permute" begin
        @test Augmentor.supports_permute(Amplify) === false
    end
end








@testset "LinearFilter" begin
    sig = collect(1.:100)
    df = digitalfilter(Lowpass(0.4), Butterworth(2))
    @test typeof(@inferred(LinearFilter(df))) <: LinearFilter <: Augmentor.ArrayOperation
    @testset "constructor" begin
        @test str_show(LinearFilter(df)) == "Augmentor.LinearFilter(ZeroPoleGain{Complex{Float64},Complex{Float64},Float64}(Complex{Float64}[-1.0 + 0.0im, -1.0 + 0.0im], Complex{Float64}[0.18476368867562076 + 0.40209214367208346im, 0.18476368867562076 - 0.40209214367208346im], 0.20657208382614792))"
    end
    @testset "eager" begin
        @test_throws MethodError Augmentor.applyeager(LinearFilter(df), nothing)
        @test Augmentor.supports_eager(LinearFilter) === true
        @testset "single image" begin
            res = Augmentor.applyeager(LinearFilter(df), sig)
            @test all(res .< sig)
            @test all(>(0), res)
            @test res == filt(df, sig)
            @test typeof(res) == typeof(sig)
        end
    end
    @testset "lazy" begin
        @test Augmentor.supports_lazy(LinearFilter) === false
    end
    @testset "view" begin
        @test Augmentor.supports_view(LinearFilter) === false
    end
    @testset "stepview" begin
        @test Augmentor.supports_stepview(LinearFilter) === false
    end
    @testset "permute" begin
        @test Augmentor.supports_permute(LinearFilter) === false
    end
end
