; ModuleID = 'main.cu'
source_filename = "main.cu"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.dim3 = type { i32, i32, i32 }

$_ZN4dim3C2Ejjj = comdat any

; Function Attrs: noinline norecurse optnone uwtable
define dso_local void @_Z31__device_stub__helloWorldKernelv() #0 {
entry:
  %grid_dim = alloca %struct.dim3, align 8
  %block_dim = alloca %struct.dim3, align 8
  %shmem_size = alloca i64, align 8
  %stream = alloca ptr, align 8
  %grid_dim.coerce = alloca { i64, i32 }, align 8
  %block_dim.coerce = alloca { i64, i32 }, align 8
  %kernel_args = alloca ptr, i64 1, align 16
  %0 = call i32 @__cudaPopCallConfiguration(ptr %grid_dim, ptr %block_dim, ptr %shmem_size, ptr %stream)
  %1 = load i64, ptr %shmem_size, align 8
  %2 = load ptr, ptr %stream, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %grid_dim.coerce, ptr align 8 %grid_dim, i64 12, i1 false)
  %3 = getelementptr inbounds { i64, i32 }, ptr %grid_dim.coerce, i32 0, i32 0
  %4 = load i64, ptr %3, align 8
  %5 = getelementptr inbounds { i64, i32 }, ptr %grid_dim.coerce, i32 0, i32 1
  %6 = load i32, ptr %5, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %block_dim.coerce, ptr align 8 %block_dim, i64 12, i1 false)
  %7 = getelementptr inbounds { i64, i32 }, ptr %block_dim.coerce, i32 0, i32 0
  %8 = load i64, ptr %7, align 8
  %9 = getelementptr inbounds { i64, i32 }, ptr %block_dim.coerce, i32 0, i32 1
  %10 = load i32, ptr %9, align 8
  %call = call noundef i32 @cudaLaunchKernel(ptr noundef @_Z31__device_stub__helloWorldKernelv, i64 %4, i32 %6, i64 %8, i32 %10, ptr noundef %kernel_args, i64 noundef %1, ptr noundef %2)
  br label %setup.end

setup.end:                                        ; preds = %entry
  ret void
}

declare i32 @__cudaPopCallConfiguration(ptr, ptr, ptr, ptr)

declare i32 @cudaLaunchKernel(ptr, i64, i32, i64, i32, ptr, i64, ptr)

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #2 {
entry:
  %retval = alloca i32, align 4
  %agg.tmp = alloca %struct.dim3, align 4
  %agg.tmp1 = alloca %struct.dim3, align 4
  %agg.tmp.coerce = alloca { i64, i32 }, align 4
  %agg.tmp1.coerce = alloca { i64, i32 }, align 4
  store i32 0, ptr %retval, align 4
  call void @_ZN4dim3C2Ejjj(ptr noundef nonnull align 4 dereferenceable(12) %agg.tmp, i32 noundef 1, i32 noundef 1, i32 noundef 1)
  call void @_ZN4dim3C2Ejjj(ptr noundef nonnull align 4 dereferenceable(12) %agg.tmp1, i32 noundef 10, i32 noundef 1, i32 noundef 1)
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %agg.tmp.coerce, ptr align 4 %agg.tmp, i64 12, i1 false)
  %0 = getelementptr inbounds { i64, i32 }, ptr %agg.tmp.coerce, i32 0, i32 0
  %1 = load i64, ptr %0, align 4
  %2 = getelementptr inbounds { i64, i32 }, ptr %agg.tmp.coerce, i32 0, i32 1
  %3 = load i32, ptr %2, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %agg.tmp1.coerce, ptr align 4 %agg.tmp1, i64 12, i1 false)
  %4 = getelementptr inbounds { i64, i32 }, ptr %agg.tmp1.coerce, i32 0, i32 0
  %5 = load i64, ptr %4, align 4
  %6 = getelementptr inbounds { i64, i32 }, ptr %agg.tmp1.coerce, i32 0, i32 1
  %7 = load i32, ptr %6, align 4
  %call = call i32 @__cudaPushCallConfiguration(i64 %1, i32 %3, i64 %5, i32 %7, i64 noundef 0, ptr noundef null)
  %tobool = icmp ne i32 %call, 0
  br i1 %tobool, label %kcall.end, label %kcall.configok

kcall.configok:                                   ; preds = %entry
  call void @_Z31__device_stub__helloWorldKernelv() #5
  br label %kcall.end

kcall.end:                                        ; preds = %kcall.configok, %entry
  %call2 = call i32 @cudaDeviceSynchronize()
  ret i32 0
}

declare i32 @__cudaPushCallConfiguration(i64, i32, i64, i32, i64 noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local void @_ZN4dim3C2Ejjj(ptr noundef nonnull align 4 dereferenceable(12) %this, i32 noundef %vx, i32 noundef %vy, i32 noundef %vz) unnamed_addr #4 comdat align 2 {
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

declare i32 @cudaDeviceSynchronize() #3

attributes #0 = { noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "uniform-work-group-size"="true" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { "uniform-work-group-size"="true" }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5}
!llvm.ident = !{!6}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 1]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"PIE Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 2}
!5 = !{i32 7, !"frame-pointer", i32 2}
!6 = !{!"clang version 18.0.0 (https://github.com/llvm/llvm-project.git 26eb4285b56edd8c897642078d91f16ff0fd3472)"}
