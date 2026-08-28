/*
 * Offscreen CAMetalLayer for the WGPU UI benchmark.
 *
 * The WGPU renderer binds through a CAMetalLayer pointer, so the benchmark
 * can render frames without opening a window. Symbols are resolved through
 * dlsym because plain-C native stubs are linked without -lobjc, and the
 * whole file degrades to a no-op on non-Apple platforms.
 */
#include <stdint.h>

#if defined(__APPLE__)
#include <CoreGraphics/CGGeometry.h>
#include <dlfcn.h>
#include <stddef.h>
#endif

void *md_editor_benchmark_u64_to_ptr(uint64_t value) {
  return (void *)(uintptr_t)value;
}

#if defined(__APPLE__)
typedef void *(*md_benchmark_send0)(void *, void *);
typedef void *(*md_benchmark_send_obj)(void *, void *, void *);
typedef void (*md_benchmark_send_cgsize)(void *, void *, CGSize);
typedef void (*md_benchmark_send_double)(void *, void *, double);
typedef void *(*md_benchmark_create_device)(void);
typedef void *(*md_benchmark_lookup)(const char *);
#endif

uint64_t md_editor_benchmark_offscreen_metal_layer(int32_t width,
                                                   int32_t height,
                                                   double scale_factor) {
#if defined(__APPLE__)
  md_benchmark_lookup get_class =
      (md_benchmark_lookup)dlsym(RTLD_DEFAULT, "objc_getClass");
  md_benchmark_lookup sel_register =
      (md_benchmark_lookup)dlsym(RTLD_DEFAULT, "sel_registerName");
  md_benchmark_send0 send =
      (md_benchmark_send0)dlsym(RTLD_DEFAULT, "objc_msgSend");
  md_benchmark_send_obj send_obj =
      (md_benchmark_send_obj)dlsym(RTLD_DEFAULT, "objc_msgSend");
  md_benchmark_send_cgsize send_cgsize =
      (md_benchmark_send_cgsize)dlsym(RTLD_DEFAULT, "objc_msgSend");
  md_benchmark_send_double send_double =
      (md_benchmark_send_double)dlsym(RTLD_DEFAULT, "objc_msgSend");
  md_benchmark_create_device create_device =
      (md_benchmark_create_device)dlsym(RTLD_DEFAULT,
                                        "MTLCreateSystemDefaultDevice");
  if (get_class == NULL || sel_register == NULL || send == NULL ||
      send_obj == NULL || send_cgsize == NULL || send_double == NULL ||
      create_device == NULL) {
    return 0;
  }
  void *layer_class = get_class("CAMetalLayer");
  if (layer_class == NULL) {
    return 0;
  }
  void *layer = send(send(layer_class, sel_register("alloc")),
                     sel_register("init"));
  if (layer == NULL) {
    return 0;
  }
  void *device = create_device();
  if (device == NULL) {
    return 0;
  }
  send_obj(layer, sel_register("setDevice:"), device);
  send_cgsize(layer, sel_register("setDrawableSize:"),
              CGSizeMake((CGFloat)width, (CGFloat)height));
  send_double(layer, sel_register("setContentsScale:"), scale_factor);
  return (uint64_t)(uintptr_t)layer;
#else
  (void)width;
  (void)height;
  (void)scale_factor;
  return 0;
#endif
}
