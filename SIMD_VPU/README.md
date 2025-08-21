A tiny, academic Vector Processing Unit (VPU) that accelerates matrix multiply (GEMM) using a 1×VL micro-kernel. It computes one output row by VL columns in parallel per launch, streaming along the K dimension.

Core idea: each cycle, read one scalar from A and one VL-wide vector from B, perform VL parallel MACs (int16×int16→int32), and accumulate into C registers. Simple scratchpad memories feed the ALU; a lightweight DMA moves tiles in/out of external memory. Control is via a small CSR/FSM block.

Key Specs

SIMD lanes (VL): 4

Datatypes: A,B: int16, C: int32 accumulators

Clock target: 100–150 MHz (FPGA friendly)

Throughput: 4 MACs/cycle (8 ops/cycle if mul+add counted)

Memory: dual-port, banked A_sp (scalar per k) and B_sp (VL-wide per k) scratchpads; optional double-buffering

Addressing: row-major with affine (base + stride) indexing; contiguous K for A, contiguous columns for B vectors

Blocks

Vector ALU (V-MAC): VL parallel int16 multipliers + int32 adders

Vector registers: 4× int32 accumulators for C

Scratchpads: A_sp and B_sp sized for tile; C written back via DMA

DMA (2D): base/stride/width/height registers for A/B/C tiles

Control unit (CSRs+FSM): start, done, clear_acc, K, bases/strides, optional cycle counter

Dataflow (per launch)

DMA loads A row-tile and K×VL B slab into scratchpads.

For k=0..K-1: read A[i,k] and B[k, j..j+VL-1], accumulate into C[j..j+VL-1].

DMA writes 1×VL C results to memory.

Out of scope (by design): caches/coherence, exceptions, complex interconnects, FP32.
Easy extensions: 2×VL micro-kernel (two A reads/cycle), perf counters, saturation on writeback.