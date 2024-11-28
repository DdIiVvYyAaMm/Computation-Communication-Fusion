module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>} {
  llvm.mlir.global internal @_ZStL8__ioinit() {addr_space = 0 : i32, alignment = 1 : i64, dso_local} : !llvm.struct<"class.std::ios_base::Init", (i8)> {
    %0 = llvm.mlir.constant(0 : i8) : i8
    %1 = llvm.mlir.undef : !llvm.struct<"class.std::ios_base::Init", (i8)>
    %2 = llvm.insertvalue %0, %1[0] : !llvm.struct<"class.std::ios_base::Init", (i8)> 
    llvm.return %2 : !llvm.struct<"class.std::ios_base::Init", (i8)>
  }
  llvm.mlir.global external hidden @__dso_handle() {addr_space = 0 : i32, dso_local} : i8
  llvm.mlir.global external @_ZSt4cout() {addr_space = 0 : i32, alignment = 8 : i64} : !llvm.struct<"class.std::basic_ostream", (ptr, struct<"class.std::basic_ios", (struct<"class.std::ios_base", (ptr, i64, i64, i32, i32, i32, ptr, struct<"struct.std::ios_base::_Words", (ptr, i64)>, array<8 x struct<"struct.std::ios_base::_Words", (ptr, i64)>>, i32, ptr, struct<"class.std::locale", (ptr)>)>, ptr, i8, i8, ptr, ptr, ptr, ptr)>)>
  llvm.mlir.global private unnamed_addr constant @".str"("Hello World\00") {addr_space = 0 : i32, alignment = 1 : i64, dso_local}
  llvm.mlir.global_ctors {ctors = [@_GLOBAL__sub_I_example.cpp], priorities = [65535 : i32]}
  llvm.func internal @__cxx_global_var_init() attributes {dso_local, passthrough = ["noinline", ["uwtable", "2"], ["frame-pointer", "all"], ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["target-features", "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87"], ["tune-cpu", "generic"]], section = ".text.startup"} {
    %0 = llvm.mlir.constant(0 : i8) : i8
    %1 = llvm.mlir.undef : !llvm.struct<"class.std::ios_base::Init", (i8)>
    %2 = llvm.insertvalue %0, %1[0] : !llvm.struct<"class.std::ios_base::Init", (i8)> 
    %3 = llvm.mlir.addressof @_ZStL8__ioinit : !llvm.ptr
    %4 = llvm.mlir.addressof @_ZNSt8ios_base4InitD1Ev : !llvm.ptr
    %5 = llvm.mlir.addressof @__dso_handle : !llvm.ptr
    llvm.call @_ZNSt8ios_base4InitC1Ev(%3) : (!llvm.ptr) -> ()
    %6 = llvm.call @__cxa_atexit(%4, %3, %5) : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
    llvm.return
  }
  llvm.func unnamed_addr @_ZNSt8ios_base4InitC1Ev(!llvm.ptr {llvm.align = 1 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}) attributes {passthrough = [["frame-pointer", "all"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["target-features", "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87"], ["tune-cpu", "generic"]]}
  llvm.func unnamed_addr @_ZNSt8ios_base4InitD1Ev(!llvm.ptr {llvm.align = 1 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}) attributes {passthrough = ["nounwind", ["frame-pointer", "all"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["target-features", "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87"], ["tune-cpu", "generic"]]}
  llvm.func @__cxa_atexit(!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32 attributes {passthrough = ["nounwind"]}
  llvm.func @_Z15PrintHelloWorldv() attributes {passthrough = ["mustprogress", "noinline", "optnone", ["uwtable", "2"], ["frame-pointer", "all"], ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["target-features", "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87"], ["tune-cpu", "generic"]]} {
    %0 = llvm.mlir.addressof @_ZSt4cout : !llvm.ptr
    %1 = llvm.mlir.constant("Hello World\00") : !llvm.array<12 x i8>
    %2 = llvm.mlir.addressof @".str" : !llvm.ptr
    %3 = llvm.mlir.addressof @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_ : !llvm.ptr
    %4 = llvm.call @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%0, %2) : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
    %5 = llvm.call @_ZNSolsEPFRSoS_E(%4, %3) : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
    llvm.return
  }
  llvm.func @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(!llvm.ptr {llvm.align = 8 : i64, llvm.dereferenceable = 8 : i64, llvm.nonnull, llvm.noundef}, !llvm.ptr {llvm.noundef}) -> (!llvm.ptr {llvm.align = 8 : i64, llvm.dereferenceable = 8 : i64, llvm.nonnull, llvm.noundef}) attributes {passthrough = [["frame-pointer", "all"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["target-features", "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87"], ["tune-cpu", "generic"]]}
  llvm.func @_ZNSolsEPFRSoS_E(!llvm.ptr {llvm.align = 8 : i64, llvm.dereferenceable = 8 : i64, llvm.nonnull, llvm.noundef}, !llvm.ptr {llvm.noundef}) -> (!llvm.ptr {llvm.align = 8 : i64, llvm.dereferenceable = 8 : i64, llvm.nonnull, llvm.noundef}) attributes {passthrough = [["frame-pointer", "all"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["target-features", "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87"], ["tune-cpu", "generic"]]}
  llvm.func @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_(!llvm.ptr {llvm.align = 8 : i64, llvm.dereferenceable = 8 : i64, llvm.nonnull, llvm.noundef}) -> (!llvm.ptr {llvm.align = 8 : i64, llvm.dereferenceable = 8 : i64, llvm.nonnull, llvm.noundef}) attributes {passthrough = [["frame-pointer", "all"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["target-features", "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87"], ["tune-cpu", "generic"]]}
  llvm.func @main(%arg0: i32 {llvm.noundef}, %arg1: !llvm.ptr {llvm.noundef}) -> (i32 {llvm.noundef}) attributes {passthrough = ["mustprogress", "noinline", "norecurse", "optnone", ["uwtable", "2"], ["frame-pointer", "all"], ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["target-features", "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87"], ["tune-cpu", "generic"]]} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.alloca %0 x i32 {alignment = 4 : i64} : (i32) -> !llvm.ptr
    %3 = llvm.alloca %0 x i32 {alignment = 4 : i64} : (i32) -> !llvm.ptr
    %4 = llvm.alloca %0 x !llvm.ptr {alignment = 8 : i64} : (i32) -> !llvm.ptr
    llvm.store %1, %2 {alignment = 4 : i64} : i32, !llvm.ptr
    llvm.store %arg0, %3 {alignment = 4 : i64} : i32, !llvm.ptr
    llvm.store %arg1, %4 {alignment = 8 : i64} : !llvm.ptr, !llvm.ptr
    llvm.call @_Z15PrintHelloWorldv() : () -> ()
    llvm.return %1 : i32
  }
  llvm.func internal @_GLOBAL__sub_I_example.cpp() attributes {dso_local, passthrough = ["noinline", ["uwtable", "2"], ["frame-pointer", "all"], ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["target-features", "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87"], ["tune-cpu", "generic"]], section = ".text.startup"} {
    llvm.call @__cxx_global_var_init() : () -> ()
    llvm.return
  }
}

