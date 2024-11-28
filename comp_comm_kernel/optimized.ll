; ModuleID = 'optimized.cu'
source_filename = "optimized.cu"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"class.std::ios_base::Init" = type { i8 }
%"class.std::basic_ostream" = type { ptr, %"class.std::basic_ios" }
%"class.std::basic_ios" = type { %"class.std::ios_base", ptr, i8, i8, ptr, ptr, ptr, ptr }
%"class.std::ios_base" = type { ptr, i64, i64, i32, i32, i32, ptr, %"struct.std::ios_base::_Words", [8 x %"struct.std::ios_base::_Words"], i32, ptr, %"class.std::locale" }
%"struct.std::ios_base::_Words" = type { ptr, i64 }
%"class.std::locale" = type { ptr }
%struct.dim3 = type { i32, i32, i32 }

$_ZN4dim3C2Ejjj = comdat any

@_ZStL8__ioinit = internal global %"class.std::ios_base::Init" zeroinitializer, align 1
@__dso_handle = external hidden global i8
@_ZSt4cout = external global %"class.std::basic_ostream", align 8
@.str = private unnamed_addr constant [14 x i8] c"Mismatch at (\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c", \00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"): \00", align 1
@.str.3 = private unnamed_addr constant [14 x i8] c"GPU result = \00", align 1
@.str.4 = private unnamed_addr constant [14 x i8] c", Expected = \00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.6 = private unnamed_addr constant [35 x i8] c"Matrix multiplication successful!\0A\00", align 1
@.str.7 = private unnamed_addr constant [31 x i8] c"Matrix multiplication failed!\0A\00", align 1
@llvm.global_ctors = appending global [1 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 65535, ptr @_GLOBAL__sub_I_optimized.cu, ptr null }]

; Function Attrs: noinline uwtable
define internal void @__cxx_global_var_init() #0 section ".text.startup" {
entry:
  call void @_ZNSt8ios_base4InitC1Ev(ptr noundef nonnull align 1 dereferenceable(1) @_ZStL8__ioinit)
  %0 = call i32 @__cxa_atexit(ptr @_ZNSt8ios_base4InitD1Ev, ptr @_ZStL8__ioinit, ptr @__dso_handle) #3
  ret void
}

declare void @_ZNSt8ios_base4InitC1Ev(ptr noundef nonnull align 1 dereferenceable(1)) unnamed_addr #1

; Function Attrs: nounwind
declare void @_ZNSt8ios_base4InitD1Ev(ptr noundef nonnull align 1 dereferenceable(1)) unnamed_addr #2

; Function Attrs: nounwind
declare i32 @__cxa_atexit(ptr, ptr, ptr) #3

; Function Attrs: noinline norecurse optnone uwtable
define dso_local void @_Z35__device_stub__tiledMatrixMulKernelPKfS0_Pfiii(ptr noundef %A, ptr noundef %B, ptr noundef %C, i32 noundef %M, i32 noundef %N, i32 noundef %K) #4 {
entry:
  %A.addr = alloca ptr, align 8
  %B.addr = alloca ptr, align 8
  %C.addr = alloca ptr, align 8
  %M.addr = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %K.addr = alloca i32, align 4
  %grid_dim = alloca %struct.dim3, align 8
  %block_dim = alloca %struct.dim3, align 8
  %shmem_size = alloca i64, align 8
  %stream = alloca ptr, align 8
  %grid_dim.coerce = alloca { i64, i32 }, align 8
  %block_dim.coerce = alloca { i64, i32 }, align 8
  store ptr %A, ptr %A.addr, align 8
  store ptr %B, ptr %B.addr, align 8
  store ptr %C, ptr %C.addr, align 8
  store i32 %M, ptr %M.addr, align 4
  store i32 %N, ptr %N.addr, align 4
  store i32 %K, ptr %K.addr, align 4
  %kernel_args = alloca ptr, i64 6, align 16
  %0 = getelementptr ptr, ptr %kernel_args, i32 0
  store ptr %A.addr, ptr %0, align 8
  %1 = getelementptr ptr, ptr %kernel_args, i32 1
  store ptr %B.addr, ptr %1, align 8
  %2 = getelementptr ptr, ptr %kernel_args, i32 2
  store ptr %C.addr, ptr %2, align 8
  %3 = getelementptr ptr, ptr %kernel_args, i32 3
  store ptr %M.addr, ptr %3, align 8
  %4 = getelementptr ptr, ptr %kernel_args, i32 4
  store ptr %N.addr, ptr %4, align 8
  %5 = getelementptr ptr, ptr %kernel_args, i32 5
  store ptr %K.addr, ptr %5, align 8
  %6 = call i32 @__cudaPopCallConfiguration(ptr %grid_dim, ptr %block_dim, ptr %shmem_size, ptr %stream)
  %7 = load i64, ptr %shmem_size, align 8
  %8 = load ptr, ptr %stream, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %grid_dim.coerce, ptr align 8 %grid_dim, i64 12, i1 false)
  %9 = getelementptr inbounds { i64, i32 }, ptr %grid_dim.coerce, i32 0, i32 0
  %10 = load i64, ptr %9, align 8
  %11 = getelementptr inbounds { i64, i32 }, ptr %grid_dim.coerce, i32 0, i32 1
  %12 = load i32, ptr %11, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %block_dim.coerce, ptr align 8 %block_dim, i64 12, i1 false)
  %13 = getelementptr inbounds { i64, i32 }, ptr %block_dim.coerce, i32 0, i32 0
  %14 = load i64, ptr %13, align 8
  %15 = getelementptr inbounds { i64, i32 }, ptr %block_dim.coerce, i32 0, i32 1
  %16 = load i32, ptr %15, align 8
  %call = call noundef i32 @cudaLaunchKernel(ptr noundef @_Z35__device_stub__tiledMatrixMulKernelPKfS0_Pfiii, i64 %10, i32 %12, i64 %14, i32 %16, ptr noundef %kernel_args, i64 noundef %7, ptr noundef %8)
  br label %setup.end

setup.end:                                        ; preds = %entry
  ret void
}

declare i32 @__cudaPopCallConfiguration(ptr, ptr, ptr, ptr)

declare i32 @cudaLaunchKernel(ptr, i64, i32, i64, i32, ptr, i64, ptr)

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #5

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main(i32 noundef %argc, ptr noundef %argv) #6 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca ptr, align 8
  %M = alloca i32, align 4
  %N = alloca i32, align 4
  %K = alloca i32, align 4
  %sizeA = alloca i64, align 8
  %sizeB = alloca i64, align 8
  %sizeC = alloca i64, align 8
  %h_A = alloca ptr, align 8
  %h_B = alloca ptr, align 8
  %h_C = alloca ptr, align 8
  %rand_max = alloca float, align 4
  %i = alloca i32, align 4
  %i13 = alloca i32, align 4
  %d_A = alloca ptr, align 8
  %d_B = alloca ptr, align 8
  %d_C = alloca ptr, align 8
  %blockSize = alloca %struct.dim3, align 4
  %gridSize = alloca %struct.dim3, align 4
  %agg.tmp = alloca %struct.dim3, align 4
  %agg.tmp37 = alloca %struct.dim3, align 4
  %agg.tmp.coerce = alloca { i64, i32 }, align 4
  %agg.tmp37.coerce = alloca { i64, i32 }, align 4
  %correct = alloca i8, align 1
  %i41 = alloca i32, align 4
  %j = alloca i32, align 4
  %expected = alloca float, align 4
  %k = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  store i32 %argc, ptr %argc.addr, align 4
  store ptr %argv, ptr %argv.addr, align 8
  store i32 512, ptr %M, align 4
  store i32 512, ptr %N, align 4
  store i32 512, ptr %K, align 4
  %0 = load i32, ptr %M, align 4
  %1 = load i32, ptr %K, align 4
  %mul = mul nsw i32 %0, %1
  %conv = sext i32 %mul to i64
  %mul1 = mul i64 %conv, 4
  store i64 %mul1, ptr %sizeA, align 8
  %2 = load i32, ptr %K, align 4
  %3 = load i32, ptr %N, align 4
  %mul2 = mul nsw i32 %2, %3
  %conv3 = sext i32 %mul2 to i64
  %mul4 = mul i64 %conv3, 4
  store i64 %mul4, ptr %sizeB, align 8
  %4 = load i32, ptr %M, align 4
  %5 = load i32, ptr %N, align 4
  %mul5 = mul nsw i32 %4, %5
  %conv6 = sext i32 %mul5 to i64
  %mul7 = mul i64 %conv6, 4
  store i64 %mul7, ptr %sizeC, align 8
  %6 = load i64, ptr %sizeA, align 8
  %call = call noalias ptr @malloc(i64 noundef %6) #11
  store ptr %call, ptr %h_A, align 8
  %7 = load i64, ptr %sizeB, align 8
  %call8 = call noalias ptr @malloc(i64 noundef %7) #11
  store ptr %call8, ptr %h_B, align 8
  %8 = load i64, ptr %sizeC, align 8
  %call9 = call noalias ptr @malloc(i64 noundef %8) #11
  store ptr %call9, ptr %h_C, align 8
  store float 0x41E0000000000000, ptr %rand_max, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %9 = load i32, ptr %i, align 4
  %10 = load i32, ptr %M, align 4
  %11 = load i32, ptr %K, align 4
  %mul10 = mul nsw i32 %10, %11
  %cmp = icmp slt i32 %9, %mul10
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %call11 = call i32 @rand() #3
  %conv12 = sitofp i32 %call11 to float
  %12 = load float, ptr %rand_max, align 4
  %div = fdiv float %conv12, %12
  %13 = load ptr, ptr %h_A, align 8
  %14 = load i32, ptr %i, align 4
  %idxprom = sext i32 %14 to i64
  %arrayidx = getelementptr inbounds float, ptr %13, i64 %idxprom
  store float %div, ptr %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %15 = load i32, ptr %i, align 4
  %inc = add nsw i32 %15, 1
  store i32 %inc, ptr %i, align 4
  br label %for.cond, !llvm.loop !7

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %i13, align 4
  br label %for.cond14

for.cond14:                                       ; preds = %for.inc23, %for.end
  %16 = load i32, ptr %i13, align 4
  %17 = load i32, ptr %K, align 4
  %18 = load i32, ptr %N, align 4
  %mul15 = mul nsw i32 %17, %18
  %cmp16 = icmp slt i32 %16, %mul15
  br i1 %cmp16, label %for.body17, label %for.end25

for.body17:                                       ; preds = %for.cond14
  %call18 = call i32 @rand() #3
  %conv19 = sitofp i32 %call18 to float
  %19 = load float, ptr %rand_max, align 4
  %div20 = fdiv float %conv19, %19
  %20 = load ptr, ptr %h_B, align 8
  %21 = load i32, ptr %i13, align 4
  %idxprom21 = sext i32 %21 to i64
  %arrayidx22 = getelementptr inbounds float, ptr %20, i64 %idxprom21
  store float %div20, ptr %arrayidx22, align 4
  br label %for.inc23

for.inc23:                                        ; preds = %for.body17
  %22 = load i32, ptr %i13, align 4
  %inc24 = add nsw i32 %22, 1
  store i32 %inc24, ptr %i13, align 4
  br label %for.cond14, !llvm.loop !9

for.end25:                                        ; preds = %for.cond14
  %23 = load i64, ptr %sizeA, align 8
  %call26 = call noundef i32 @_ZL10cudaMallocIfE9cudaErrorPPT_m(ptr noundef %d_A, i64 noundef %23)
  %24 = load i64, ptr %sizeB, align 8
  %call27 = call noundef i32 @_ZL10cudaMallocIfE9cudaErrorPPT_m(ptr noundef %d_B, i64 noundef %24)
  %25 = load i64, ptr %sizeC, align 8
  %call28 = call noundef i32 @_ZL10cudaMallocIfE9cudaErrorPPT_m(ptr noundef %d_C, i64 noundef %25)
  %26 = load ptr, ptr %d_A, align 8
  %27 = load ptr, ptr %h_A, align 8
  %28 = load i64, ptr %sizeA, align 8
  %call29 = call i32 @cudaMemcpy(ptr noundef %26, ptr noundef %27, i64 noundef %28, i32 noundef 1)
  %29 = load ptr, ptr %d_B, align 8
  %30 = load ptr, ptr %h_B, align 8
  %31 = load i64, ptr %sizeB, align 8
  %call30 = call i32 @cudaMemcpy(ptr noundef %29, ptr noundef %30, i64 noundef %31, i32 noundef 1)
  call void @_ZN4dim3C2Ejjj(ptr noundef nonnull align 4 dereferenceable(12) %blockSize, i32 noundef 16, i32 noundef 16, i32 noundef 1)
  %32 = load i32, ptr %N, align 4
  %x = getelementptr inbounds %struct.dim3, ptr %blockSize, i32 0, i32 0
  %33 = load i32, ptr %x, align 4
  %add = add i32 %32, %33
  %sub = sub i32 %add, 1
  %x31 = getelementptr inbounds %struct.dim3, ptr %blockSize, i32 0, i32 0
  %34 = load i32, ptr %x31, align 4
  %div32 = udiv i32 %sub, %34
  %35 = load i32, ptr %M, align 4
  %y = getelementptr inbounds %struct.dim3, ptr %blockSize, i32 0, i32 1
  %36 = load i32, ptr %y, align 4
  %add33 = add i32 %35, %36
  %sub34 = sub i32 %add33, 1
  %y35 = getelementptr inbounds %struct.dim3, ptr %blockSize, i32 0, i32 1
  %37 = load i32, ptr %y35, align 4
  %div36 = udiv i32 %sub34, %37
  call void @_ZN4dim3C2Ejjj(ptr noundef nonnull align 4 dereferenceable(12) %gridSize, i32 noundef %div32, i32 noundef %div36, i32 noundef 1)
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %agg.tmp, ptr align 4 %gridSize, i64 12, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %agg.tmp37, ptr align 4 %blockSize, i64 12, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %agg.tmp.coerce, ptr align 4 %agg.tmp, i64 12, i1 false)
  %38 = getelementptr inbounds { i64, i32 }, ptr %agg.tmp.coerce, i32 0, i32 0
  %39 = load i64, ptr %38, align 4
  %40 = getelementptr inbounds { i64, i32 }, ptr %agg.tmp.coerce, i32 0, i32 1
  %41 = load i32, ptr %40, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %agg.tmp37.coerce, ptr align 4 %agg.tmp37, i64 12, i1 false)
  %42 = getelementptr inbounds { i64, i32 }, ptr %agg.tmp37.coerce, i32 0, i32 0
  %43 = load i64, ptr %42, align 4
  %44 = getelementptr inbounds { i64, i32 }, ptr %agg.tmp37.coerce, i32 0, i32 1
  %45 = load i32, ptr %44, align 4
  %call38 = call i32 @__cudaPushCallConfiguration(i64 %39, i32 %41, i64 %43, i32 %45, i64 noundef 0, ptr noundef null)
  %tobool = icmp ne i32 %call38, 0
  br i1 %tobool, label %kcall.end, label %kcall.configok

kcall.configok:                                   ; preds = %for.end25
  %46 = load ptr, ptr %d_A, align 8
  %47 = load ptr, ptr %d_B, align 8
  %48 = load ptr, ptr %d_C, align 8
  %49 = load i32, ptr %M, align 4
  %50 = load i32, ptr %N, align 4
  %51 = load i32, ptr %K, align 4
  call void @_Z35__device_stub__tiledMatrixMulKernelPKfS0_Pfiii(ptr noundef %46, ptr noundef %47, ptr noundef %48, i32 noundef %49, i32 noundef %50, i32 noundef %51) #12
  br label %kcall.end

kcall.end:                                        ; preds = %kcall.configok, %for.end25
  %call39 = call i32 @cudaDeviceSynchronize()
  %52 = load ptr, ptr %h_C, align 8
  %53 = load ptr, ptr %d_C, align 8
  %54 = load i64, ptr %sizeC, align 8
  %call40 = call i32 @cudaMemcpy(ptr noundef %52, ptr noundef %53, i64 noundef %54, i32 noundef 2)
  store i8 1, ptr %correct, align 1
  store i32 0, ptr %i41, align 4
  br label %for.cond42

for.cond42:                                       ; preds = %for.inc91, %kcall.end
  %55 = load i32, ptr %i41, align 4
  %56 = load i32, ptr %M, align 4
  %cmp43 = icmp slt i32 %55, %56
  br i1 %cmp43, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %for.cond42
  %57 = load i8, ptr %correct, align 1
  %tobool44 = trunc i8 %57 to i1
  br label %land.end

land.end:                                         ; preds = %land.rhs, %for.cond42
  %58 = phi i1 [ false, %for.cond42 ], [ %tobool44, %land.rhs ]
  br i1 %58, label %for.body45, label %for.end93

for.body45:                                       ; preds = %land.end
  store i32 0, ptr %j, align 4
  br label %for.cond46

for.cond46:                                       ; preds = %for.inc88, %for.body45
  %59 = load i32, ptr %j, align 4
  %60 = load i32, ptr %N, align 4
  %cmp47 = icmp slt i32 %59, %60
  br i1 %cmp47, label %land.rhs48, label %land.end50

land.rhs48:                                       ; preds = %for.cond46
  %61 = load i8, ptr %correct, align 1
  %tobool49 = trunc i8 %61 to i1
  br label %land.end50

land.end50:                                       ; preds = %land.rhs48, %for.cond46
  %62 = phi i1 [ false, %for.cond46 ], [ %tobool49, %land.rhs48 ]
  br i1 %62, label %for.body51, label %for.end90

for.body51:                                       ; preds = %land.end50
  store float 0.000000e+00, ptr %expected, align 4
  store i32 0, ptr %k, align 4
  br label %for.cond52

for.cond52:                                       ; preds = %for.inc64, %for.body51
  %63 = load i32, ptr %k, align 4
  %64 = load i32, ptr %K, align 4
  %cmp53 = icmp slt i32 %63, %64
  br i1 %cmp53, label %for.body54, label %for.end66

for.body54:                                       ; preds = %for.cond52
  %65 = load ptr, ptr %h_A, align 8
  %66 = load i32, ptr %i41, align 4
  %67 = load i32, ptr %K, align 4
  %mul55 = mul nsw i32 %66, %67
  %68 = load i32, ptr %k, align 4
  %add56 = add nsw i32 %mul55, %68
  %idxprom57 = sext i32 %add56 to i64
  %arrayidx58 = getelementptr inbounds float, ptr %65, i64 %idxprom57
  %69 = load float, ptr %arrayidx58, align 4
  %70 = load ptr, ptr %h_B, align 8
  %71 = load i32, ptr %k, align 4
  %72 = load i32, ptr %N, align 4
  %mul59 = mul nsw i32 %71, %72
  %73 = load i32, ptr %j, align 4
  %add60 = add nsw i32 %mul59, %73
  %idxprom61 = sext i32 %add60 to i64
  %arrayidx62 = getelementptr inbounds float, ptr %70, i64 %idxprom61
  %74 = load float, ptr %arrayidx62, align 4
  %75 = load float, ptr %expected, align 4
  %76 = call float @llvm.fmuladd.f32(float %69, float %74, float %75)
  store float %76, ptr %expected, align 4
  br label %for.inc64

for.inc64:                                        ; preds = %for.body54
  %77 = load i32, ptr %k, align 4
  %inc65 = add nsw i32 %77, 1
  store i32 %inc65, ptr %k, align 4
  br label %for.cond52, !llvm.loop !10

for.end66:                                        ; preds = %for.cond52
  %78 = load ptr, ptr %h_C, align 8
  %79 = load i32, ptr %i41, align 4
  %80 = load i32, ptr %N, align 4
  %mul67 = mul nsw i32 %79, %80
  %81 = load i32, ptr %j, align 4
  %add68 = add nsw i32 %mul67, %81
  %idxprom69 = sext i32 %add68 to i64
  %arrayidx70 = getelementptr inbounds float, ptr %78, i64 %idxprom69
  %82 = load float, ptr %arrayidx70, align 4
  %83 = load float, ptr %expected, align 4
  %sub71 = fsub float %82, %83
  %conv72 = fpext float %sub71 to double
  %84 = call double @llvm.fabs.f64(double %conv72)
  %cmp73 = fcmp ogt double %84, 1.000000e-05
  br i1 %cmp73, label %if.then, label %if.end

if.then:                                          ; preds = %for.end66
  store i8 0, ptr %correct, align 1
  %call74 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str)
  %85 = load i32, ptr %i41, align 4
  %call75 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8) %call74, i32 noundef %85)
  %call76 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) %call75, ptr noundef @.str.1)
  %86 = load i32, ptr %j, align 4
  %call77 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8) %call76, i32 noundef %86)
  %call78 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) %call77, ptr noundef @.str.2)
  %call79 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) %call78, ptr noundef @.str.3)
  %87 = load ptr, ptr %h_C, align 8
  %88 = load i32, ptr %i41, align 4
  %89 = load i32, ptr %N, align 4
  %mul80 = mul nsw i32 %88, %89
  %90 = load i32, ptr %j, align 4
  %add81 = add nsw i32 %mul80, %90
  %idxprom82 = sext i32 %add81 to i64
  %arrayidx83 = getelementptr inbounds float, ptr %87, i64 %idxprom82
  %91 = load float, ptr %arrayidx83, align 4
  %call84 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEf(ptr noundef nonnull align 8 dereferenceable(8) %call79, float noundef %91)
  %call85 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) %call84, ptr noundef @.str.4)
  %92 = load float, ptr %expected, align 4
  %call86 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEf(ptr noundef nonnull align 8 dereferenceable(8) %call85, float noundef %92)
  %call87 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) %call86, ptr noundef @.str.5)
  br label %if.end

if.end:                                           ; preds = %if.then, %for.end66
  br label %for.inc88

for.inc88:                                        ; preds = %if.end
  %93 = load i32, ptr %j, align 4
  %inc89 = add nsw i32 %93, 1
  store i32 %inc89, ptr %j, align 4
  br label %for.cond46, !llvm.loop !11

for.end90:                                        ; preds = %land.end50
  br label %for.inc91

for.inc91:                                        ; preds = %for.end90
  %94 = load i32, ptr %i41, align 4
  %inc92 = add nsw i32 %94, 1
  store i32 %inc92, ptr %i41, align 4
  br label %for.cond42, !llvm.loop !12

for.end93:                                        ; preds = %land.end
  %95 = load i8, ptr %correct, align 1
  %tobool94 = trunc i8 %95 to i1
  br i1 %tobool94, label %if.then95, label %if.else

if.then95:                                        ; preds = %for.end93
  %call96 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str.6)
  br label %if.end98

if.else:                                          ; preds = %for.end93
  %call97 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str.7)
  br label %if.end98

if.end98:                                         ; preds = %if.else, %if.then95
  %96 = load ptr, ptr %d_A, align 8
  %call99 = call i32 @cudaFree(ptr noundef %96)
  %97 = load ptr, ptr %d_B, align 8
  %call100 = call i32 @cudaFree(ptr noundef %97)
  %98 = load ptr, ptr %d_C, align 8
  %call101 = call i32 @cudaFree(ptr noundef %98)
  %99 = load ptr, ptr %h_A, align 8
  call void @free(ptr noundef %99) #3
  %100 = load ptr, ptr %h_B, align 8
  call void @free(ptr noundef %100) #3
  %101 = load ptr, ptr %h_C, align 8
  call void @free(ptr noundef %101) #3
  ret i32 0
}

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #7

; Function Attrs: nounwind
declare i32 @rand() #2

; Function Attrs: mustprogress noinline optnone uwtable
define internal noundef i32 @_ZL10cudaMallocIfE9cudaErrorPPT_m(ptr noundef %devPtr, i64 noundef %size) #8 {
entry:
  %devPtr.addr = alloca ptr, align 8
  %size.addr = alloca i64, align 8
  store ptr %devPtr, ptr %devPtr.addr, align 8
  store i64 %size, ptr %size.addr, align 8
  %0 = load ptr, ptr %devPtr.addr, align 8
  %1 = load i64, ptr %size.addr, align 8
  %call = call i32 @cudaMalloc(ptr noundef %0, i64 noundef %1)
  ret i32 %call
}

declare i32 @cudaMemcpy(ptr noundef, ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local void @_ZN4dim3C2Ejjj(ptr noundef nonnull align 4 dereferenceable(12) %this, i32 noundef %vx, i32 noundef %vy, i32 noundef %vz) unnamed_addr #9 comdat align 2 {
entry:
  %this.addr = alloca ptr, align 8
  %vx.addr = alloca i32, align 4
  %vy.addr = alloca i32, align 4
  %vz.addr = alloca i32, align 4
  store ptr %this, ptr %this.addr, align 8
  store i32 %vx, ptr %vx.addr, align 4
  store i32 %vy, ptr %vy.addr, align 4
  store i32 %vz, ptr %vz.addr, align 4
  %this1 = load ptr, ptr %this.addr, align 8
  %x = getelementptr inbounds %struct.dim3, ptr %this1, i32 0, i32 0
  %0 = load i32, ptr %vx.addr, align 4
  store i32 %0, ptr %x, align 4
  %y = getelementptr inbounds %struct.dim3, ptr %this1, i32 0, i32 1
  %1 = load i32, ptr %vy.addr, align 4
  store i32 %1, ptr %y, align 4
  %z = getelementptr inbounds %struct.dim3, ptr %this1, i32 0, i32 2
  %2 = load i32, ptr %vz.addr, align 4
  store i32 %2, ptr %z, align 4
  ret void
}

declare i32 @__cudaPushCallConfiguration(i64, i32, i64, i32, i64 noundef, ptr noundef) #1

declare i32 @cudaDeviceSynchronize() #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #10

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fabs.f64(double) #10

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8), ptr noundef) #1

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8), i32 noundef) #1

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEf(ptr noundef nonnull align 8 dereferenceable(8), float noundef) #1

declare i32 @cudaFree(ptr noundef) #1

; Function Attrs: nounwind
declare void @free(ptr noundef) #2

declare i32 @cudaMalloc(ptr noundef, i64 noundef) #1

; Function Attrs: noinline uwtable
define internal void @_GLOBAL__sub_I_optimized.cu() #0 section ".text.startup" {
entry:
  call void @__cxx_global_var_init()
  ret void
}

attributes #0 = { noinline uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }
attributes #4 = { noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "uniform-work-group-size"="true" }
attributes #5 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #6 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { nounwind allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { mustprogress noinline optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #10 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #11 = { nounwind allocsize(0) }
attributes #12 = { "uniform-work-group-size"="true" }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5}
!llvm.ident = !{!6}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 1]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"PIE Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 2}
!5 = !{i32 7, !"frame-pointer", i32 2}
!6 = !{!"clang version 18.0.0 (https://github.com/llvm/llvm-project.git 26eb4285b56edd8c897642078d91f16ff0fd3472)"}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.mustprogress"}
!9 = distinct !{!9, !8}
!10 = distinct !{!10, !8}
!11 = distinct !{!11, !8}
!12 = distinct !{!12, !8}
