// Vertex Shader
struct CameraUniform {
    view_proj: mat4x4<f32>,
}

@group(1) @binding(0)
var<uniform> camera: CameraUniform;

struct VertexInput {
    @location(0) position: vec3<f32>,
    @location(1) tex_coords: vec2<f32>
}

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) tex_coords: vec2<f32>,
}

struct InstanceInput {
    @location(5) model_matrix_0: vec4<f32>,    
    @location(6) model_matrix_1: vec4<f32>,
    @location(7) model_matrix_2: vec4<f32>,
    @location(8) model_matrix_3: vec4<f32>,
}

@vertex
fn vs_main(
    model: VertexInput,
    instance: InstanceInput,
) -> VertexOutput {
    let model_matrix = mat4x4<f32>(
        instance.model_matrix_0,
        instance.model_matrix_1,
        instance.model_matrix_2,
        instance.model_matrix_3
    );
    var out: VertexOutput;
    out.tex_coords = model.tex_coords;
    out.clip_position = camera.view_proj * model_matrix * vec4<f32>(model.position, 1.0);
    return out;
}

@group(0) @binding(0)
var t_diffuse: texture_2d<f32>;
@group(0) @binding(1)
var s_diffuse: sampler;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // var kernel: array<f32, 9> = array<f32, 9>(
    //     -1.0, -1.0, -1.0,
    //     -1.0,  8.0, -1.0,
    //     -1.0, -1.0, -1.0
    // );
    var kernel: array<f32, 9> = array<f32, 9>(
        -1.0,  0.0,  1.0,
        -2.0,  0.0,  2.0,
        -1.0,  0.0,  1.0
    );
    var out = 0.0;
    let dims = vec2<f32>(textureDimensions(t_diffuse));
    for (var x: i32 = -1; x <= 1; x++) {
        for (var y: i32 = -1; y <= 1; y++) {
            var coord = in.tex_coords + vec2<f32>(f32(x), f32(y)) / dims;
            var sample = textureSample(t_diffuse, s_diffuse, coord);
            var lum = (sample.r + sample.g + sample.b) / 3.0;
            var mult = kernel[(x+1) + (y+1)*3];
            out += lum * mult;
        }
    }
    return vec4<f32>(out, out, out, 1.0);
}
