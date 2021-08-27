#include "api/image_filter.h"
#include "api/intime.h"
#include "api/module.h"
#include "api/operator.h"
// #include "api/operator_gpu.h"
#include "api/program.h"
#include "api/setup.h"
#include "api/stream.h"
#include "api/tensor.h"
#include "api/workbench.h"

/// common.h
const char *ts_last_error_message() { return "Using fake tennis library."; }
void ts_set_error_message(const char *) {}
/// image_filter.h
ts_ImageFilter *ts_new_ImageFilter(const ts_Device *) { return nullptr; }
void ts_free_ImageFilter(const ts_ImageFilter *) {}
ts_bool ts_ImageFilter_clear(ts_ImageFilter *) { return 0; }
ts_bool ts_ImageFilter_compile(ts_ImageFilter *) { return 0; }
ts_bool ts_ImageFilter_to_float(ts_ImageFilter *) { return 0; }
ts_bool ts_ImageFilter_scale(ts_ImageFilter *, float) { return 0; }
ts_bool ts_ImageFilter_sub_mean(ts_ImageFilter *, const float *, int32_t) { return 0; }
ts_bool ts_ImageFilter_div_std(ts_ImageFilter *, const float *, int32_t) { return 0; }
ts_bool ts_ImageFilter_resize(ts_ImageFilter *, int32_t, int32_t) { return 0; }
ts_bool ts_ImageFilter_resize_scalar(ts_ImageFilter *, int32_t) { return 0; }
ts_bool ts_ImageFilter_center_crop(ts_ImageFilter *, int32_t, int32_t) { return 0; }
ts_bool ts_ImageFilter_channel_swap(ts_ImageFilter *, const int32_t *, int32_t) { return 0; }
ts_bool ts_ImageFilter_to_chw(ts_ImageFilter *) { return 0; }
ts_bool ts_ImageFilter_prewhiten(ts_ImageFilter *) { return 0; }
ts_bool ts_ImageFilter_letterbox(ts_ImageFilter *, int32_t, int32_t, float) { return 0; }
ts_bool ts_ImageFilter_divided(ts_ImageFilter *, int32_t, int32_t, float) { return 0; }
ts_Tensor *ts_ImageFilter_run(ts_ImageFilter *, const ts_Tensor *) { return nullptr; }
ts_bool ts_ImageFilter_letterbox_v2(ts_ImageFilter *, int32_t, int32_t, float, ts_ResizeMethod) { return 0; }
ts_bool ts_ImageFilter_resize_v2(ts_ImageFilter *, int32_t, int32_t, ts_ResizeMethod) { return 0; }
ts_bool ts_ImageFilter_resize_scalar_v2(ts_ImageFilter *, int32_t,ts_ResizeMethod) { return 0; }
ts_bool ts_ImageFilter_force_color(ts_ImageFilter *) { return 0; }
ts_bool ts_ImageFilter_force_gray(ts_ImageFilter *) { return 0; }
ts_bool ts_ImageFilter_force_gray_v2(ts_ImageFilter *, const float *, int32_t) { return 0; }
ts_bool ts_ImageFilter_norm_image(ts_ImageFilter *, float) { return 0; }
ts_Module *ts_ImageFilter_module(const ts_ImageFilter *) { return nullptr; }
/// intime.h
ts_Tensor *ts_intime_transpose(const ts_Tensor *, const int32_t *, int32_t) { return nullptr; }
ts_Tensor *ts_intime_sigmoid(const ts_Tensor *) { return nullptr; }
ts_Tensor *ts_intime_gather(const ts_Tensor *, const ts_Tensor *, int32_t) { return nullptr; }
ts_Tensor *ts_intime_concat(const ts_Tensor *const *, int32_t, int32_t) { return nullptr; }
ts_Tensor *ts_intime_softmax(const ts_Tensor *, int32_t, ts_bool) { return nullptr; }
ts_Tensor *ts_intime_pad(const ts_Tensor *, const ts_Tensor *, float) { return nullptr; }
ts_Tensor *ts_intime_cast(const ts_Tensor *, ts_DTYPE) { return nullptr; }
ts_Tensor *ts_intime_resize2d(const ts_Tensor *, const ts_Tensor *, int32_t) { return nullptr; }
ts_Tensor *ts_intime_affine_sample2d( const ts_Tensor *, const ts_Tensor *, const ts_Tensor *, int32_t, float, int32_t) { return nullptr; }
ts_Tensor *ts_intime_affine_on_sample2d( const ts_Tensor *, const ts_Tensor *, const ts_Tensor *, int32_t, int32_t) { return nullptr; }
int64_t ts_intime_memcpy( ts_Tensor *, void *, int64_t, const ts_Tensor *, const void *, int64_t, int64_t) { return 0; }
ts_Tensor *ts_intime_matmul(const ts_Tensor *, const ts_Tensor *, ts_bool) { return nullptr; }
/// module.h
ts_Module *ts_Module_Load(const char *, ts_SerializationFormat) { return nullptr; }
ts_Module *ts_Module_LoadV2(const char *, const void *, int32_t, ts_SerializationFormat) { return nullptr; }
ts_Module *ts_Module_LoadFromStream(void *, ts_stream_read *, ts_SerializationFormat) { return nullptr; }
ts_Module *ts_Module_LoadFromStreamV2(void *, ts_stream_read *, ts_stream_rewind *, const void *, int32_t, ts_SerializationFormat) { return nullptr; }
void ts_free_Module(const ts_Module *) {}
ts_Module *ts_Module_Fusion(const ts_Module *, int32_t, const ts_Module *, int32_t) { return nullptr; }
/// operator.h
ts_Tensor *ts_OperatorParams_get(const ts_OperatorParams *, const char *) { return nullptr; }
void ts_Operator_Register( const char *, const char *, ts_new_Operator *, ts_free_Operator *, ts_Operator_init *, ts_Operator_infer *, ts_Operator_run *) {}
void ts_Operator_RegisterEx( const char *, const char *, ts_new_Operator *, ts_free_Operator *, ts_Operator_init_ex *, ts_Operator_infer *, ts_Operator_run *) {}
void ts_Operator_Throw(const char *) {}
void ts_Operator_ThrowV2(const char *, const char *, int32_t) {}
/// operator_gpu.h
void *ts_OperatorContext_cuda_stream(ts_OperatorContext *) { return nullptr; }
/// program.h
ts_Program *ts_Program_Compile(const ts_Module *, const ts_Device *) { return nullptr; }
void ts_free_Program(const ts_Program *) {}
ts_Program *ts_Program_clone(ts_Program *) { return nullptr; }
int32_t ts_Program_input_count(ts_Program *) { return 0; }
int32_t ts_Program_output_count(ts_Program *) { return 0; }
ts_Program *ts_Program_Compile_v2(const ts_Module *, const ts_Device *, const char *) { return nullptr; }
ts_bool ts_Program_set_operator_param(ts_Program *, const char *, const char *, const ts_Tensor *) { return 0; }
/// setup.h
ts_bool ts_setup() { return 0; }
/// tensor.h
ts_Tensor *ts_new_Tensor(const int32_t *, int32_t, ts_DTYPE, const void *) { return nullptr; }
void ts_free_Tensor(const ts_Tensor *) {}
const int32_t *ts_Tensor_shape(ts_Tensor *) { return nullptr; }
int32_t ts_Tensor_shape_size(ts_Tensor *) { return 0; }
ts_DTYPE ts_Tensor_dtype(ts_Tensor *) { return TS_VOID; }
void* ts_Tensor_data(ts_Tensor *) { return nullptr; }
ts_Tensor *ts_Tensor_clone(ts_Tensor *) { return nullptr; }
ts_bool ts_Tensor_sync_cpu(ts_Tensor *) { return 0; }
ts_Tensor *ts_Tensor_cast(ts_Tensor *, ts_DTYPE) { return nullptr; }
ts_Tensor *ts_Tensor_reshape(ts_Tensor *, const int32_t *, int32_t) { return nullptr; }
ts_Tensor *ts_new_Tensor_in_flow(ts_InFlow, const int32_t *, int32_t, ts_DTYPE, const void *) { return nullptr; }
ts_Tensor *ts_Tensor_view_in_flow(ts_Tensor *, ts_InFlow) { return nullptr; }
ts_Tensor *ts_Tensor_field(ts_Tensor *, int32_t) { return nullptr; }
ts_bool ts_Tensor_packed(ts_Tensor *) { return 0; }
int32_t ts_Tensor_fields_count(ts_Tensor *) { return 0; }
ts_Tensor *ts_Tensor_pack(ts_Tensor **, int32_t) { return nullptr; }
ts_Tensor *ts_Tensor_slice(ts_Tensor *, int32_t) { return nullptr; }
ts_Tensor *ts_Tensor_slice_v2(ts_Tensor *, int32_t, int32_t) { return nullptr; }
ts_bool ts_Tensor_save(const char *, const ts_Tensor *) { return 0; }
ts_Tensor *ts_Tensor_load(const char *) { return nullptr; }
/// workbench.h
ts_Workbench *ts_Workbench_Load(const ts_Module *, const ts_Device *) { return nullptr; }
void ts_free_Workbench(const ts_Workbench *) {}
ts_Workbench *ts_Workbench_clone(ts_Workbench *) { return nullptr; }
ts_bool ts_Workbench_input(ts_Workbench *, int32_t, const ts_Tensor *) { return 0; }
ts_bool ts_Workbench_input_by_name(ts_Workbench *, const char *, const ts_Tensor *) { return 0; }
ts_bool ts_Workbench_run(ts_Workbench *) { return 0; }
ts_bool ts_Workbench_output(ts_Workbench *, int32_t, ts_Tensor *) { return 0; }
ts_bool ts_Workbench_output_by_name(ts_Workbench *, const char *, ts_Tensor *) { return 0; }
ts_bool ts_Workbench_set_computing_thread_number(ts_Workbench *, int32_t) { return 0; }
ts_bool ts_Workbench_bind_filter(ts_Workbench *, int32_t, const ts_ImageFilter *) { return 0; }
ts_bool ts_Workbench_bind_filter_by_name(ts_Workbench *, const char *, const ts_ImageFilter *) { return 0; }
ts_Workbench *ts_new_Workbench(const ts_Device *) { return nullptr; }
ts_bool ts_Workbench_setup(ts_Workbench *, const ts_Program *) { return 0; }
ts_bool ts_Workbench_setup_context(ts_Workbench *) { return 0; }
ts_Program *ts_Workbench_compile(ts_Workbench *, const ts_Module *) { return nullptr; }
ts_bool ts_Workbench_setup_device(ts_Workbench *) { return 0; }
ts_bool ts_Workbench_setup_runtime(ts_Workbench *) { return 0; }
int32_t ts_Workbench_input_count(ts_Workbench *) { return 0; }
int32_t ts_Workbench_output_count(ts_Workbench *) { return 0; }
ts_bool ts_Workbench_run_hook(ts_Workbench *, const char **, int32_t) { return 0; }
ts_Workbench *ts_Workbench_Load_v2(const ts_Module *, const ts_Device *, const char *) { return nullptr; }
ts_Program *ts_Workbench_compile_v2(ts_Workbench *, const ts_Module *, const char *) { return nullptr; }
ts_bool ts_Workbench_set_operator_param(ts_Workbench *, const char *, const char *, const ts_Tensor *) { return 0; }
const char *ts_Workbench_summary(ts_Workbench *) { return nullptr; }
ts_bool ts_Workbench_set_cpu_mode(ts_Workbench *, ts_CpuPowerMode) { return 0; }
