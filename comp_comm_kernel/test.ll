; ModuleID = 'basic-cuda-nvptx64-nvidia-cuda-sm_89.bc'
source_filename = "basic.cu"
target datalayout = "e-i64:64-i128:128-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

%struct.__cuda_builtin_blockIdx_t = type { i8 }
%struct.__cuda_builtin_blockDim_t = type { i8 }
%struct.__cuda_builtin_threadIdx_t = type { i8 }

@blockIdx = extern_weak dso_local addrspace(1) global %struct.__cuda_builtin_blockIdx_t, align 1
@blockDim = extern_weak dso_local addrspace(1) global %struct.__cuda_builtin_blockDim_t, align 1
@threadIdx = extern_weak dso_local addrspace(1) global %struct.__cuda_builtin_threadIdx_t, align 1

; Function Attrs: convergent mustprogress noinline norecurse nounwind optnone
define dso_local void @_Z15matrixMulKernelPKfS0_Pfiii(ptr noundef %A, ptr noundef %B, ptr noundef %C, i32 noundef %M, i32 noundef %N, i32 noundef %K) #0 {
entry:
  %A.addr = alloca ptr, align 8
  %B.addr = alloca ptr, align 8
  %C.addr = alloca ptr, align 8
  %M.addr = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %K.addr = alloca i32, align 4
  %row = alloca i32, align 4
  %col = alloca i32, align 4
  %value = alloca float, align 4
  %i = alloca i32, align 4
  store ptr %A, ptr %A.addr, align 8
  store ptr %B, ptr %B.addr, align 8
  store ptr %C, ptr %C.addr, align 8
  store i32 %M, ptr %M.addr, align 4
  store i32 %N, ptr %N.addr, align 4
  store i32 %K, ptr %K.addr, align 4
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.ctaid.y()
  %1 = call i32 @llvm.nvvm.read.ptx.sreg.ntid.y()
  %mul = mul i32 %0, %1
  %2 = call i32 @llvm.nvvm.read.ptx.sreg.tid.y()
  %add = add i32 %mul, %2
  store i32 %add, ptr %row, align 4
  %3 = call i32 @llvm.nvvm.read.ptx.sreg.ctaid.x()
  %4 = call i32 @llvm.nvvm.read.ptx.sreg.ntid.x()
  %mul5 = mul i32 %3, %4
  %5 = call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
  %add7 = add i32 %mul5, %5
  store i32 %add7, ptr %col, align 4
  %6 = load i32, ptr %row, align 4
  %7 = load i32, ptr %M.addr, align 4
  %cmp = icmp slt i32 %6, %7
  br i1 %cmp, label %land.lhs.true, label %if.end

land.lhs.true:                                    ; preds = %entry
  %8 = load i32, ptr %col, align 4
  %9 = load i32, ptr %N.addr, align 4
  %cmp8 = icmp slt i32 %8, %9
  br i1 %cmp8, label %if.then, label %if.end

if.then:                                          ; preds = %land.lhs.true
  store float 0.000000e+00, ptr %value, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then
  %10 = load i32, ptr %i, align 4
  %11 = load i32, ptr %K.addr, align 4
  %cmp9 = icmp slt i32 %10, %11
  br i1 %cmp9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %12 = load ptr, ptr %A.addr, align 8
  %13 = load i32, ptr %row, align 4
  %14 = load i32, ptr %K.addr, align 4
  %mul10 = mul nsw i32 %13, %14
  %15 = load i32, ptr %i, align 4
  %add11 = add nsw i32 %mul10, %15
  %idxprom = sext i32 %add11 to i64
  %arrayidx = getelementptr inbounds float, ptr %12, i64 %idxprom
  %16 = load float, ptr %arrayidx, align 4
  %17 = load ptr, ptr %B.addr, align 8
  %18 = load i32, ptr %i, align 4
  %19 = load i32, ptr %N.addr, align 4
  %mul12 = mul nsw i32 %18, %19
  %20 = load i32, ptr %col, align 4
  %add13 = add nsw i32 %mul12, %20
  %idxprom14 = sext i32 %add13 to i64
  %arrayidx15 = getelementptr inbounds float, ptr %17, i64 %idxprom14
  %21 = load float, ptr %arrayidx15, align 4
  %mul16 = fmul contract float %16, %21
  %22 = load float, ptr %value, align 4
  %add17 = fadd contract float %22, %mul16
  store float %add17, ptr %value, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %23 = load i32, ptr %i, align 4
  %inc = add nsw i32 %23, 1
  store i32 %inc, ptr %i, align 4
  br label %for.cond, !llvm.loop !8

for.end:                                          ; preds = %for.cond
  %24 = load float, ptr %value, align 4
  %25 = load ptr, ptr %C.addr, align 8
  %26 = load i32, ptr %row, align 4
  %27 = load i32, ptr %N.addr, align 4
  %mul18 = mul nsw i32 %26, %27
  %28 = load i32, ptr %col, align 4
  %add19 = add nsw i32 %mul18, %28
  %idxprom20 = sext i32 %add19 to i64
  %arrayidx21 = getelementptr inbounds float, ptr %25, i64 %idxprom20
  store float %24, ptr %arrayidx21, align 4
  br label %if.end

if.end:                                           ; preds = %for.end, %land.lhs.true, %entry
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef i32 @llvm.nvvm.read.ptx.sreg.ctaid.y() #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef i32 @llvm.nvvm.read.ptx.sreg.ntid.y() #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef i32 @llvm.nvvm.read.ptx.sreg.tid.y() #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef i32 @llvm.nvvm.read.ptx.sreg.ctaid.x() #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef i32 @llvm.nvvm.read.ptx.sreg.ntid.x() #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x() #1

attributes #0 = { convergent mustprogress noinline norecurse nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_89" "target-features"="+ptx81,+sm_89" "uniform-work-group-size"="true" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3}
!nvvm.annotations = !{!4}
!llvm.ident = !{!5, !6}
!nvvmir.version = !{!7}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 1]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 4, !"nvvm-reflect-ftz", i32 0}
!3 = !{i32 7, !"frame-pointer", i32 2}
!4 = !{ptr @_Z15matrixMulKernelPKfS0_Pfiii, !"kernel", i32 1}
!5 = !{!"clang version 18.0.0 (https://github.com/llvm/llvm-project.git 26eb4285b56edd8c897642078d91f16ff0fd3472)"}
!6 = !{!"clang version 3.8.0 (tags/RELEASE_380/final)"}
!7 = !{i32 2, i32 0}
!8 = distinct !{!8, !9}
!9 = !{!"llvm.loop.mustprogress"}
