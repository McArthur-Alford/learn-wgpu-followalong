// Vertex Shader

struct VertexInput {
    @location(0) position: vec3<f32>,
    @location(1) tex_coords: vec2<f32>
}

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) tex_coords: vec2<f32>,
}

@vertex
fn vs_main(
    model: VertexInput,
) -> VertexOutput {
    var out: VertexOutput;
    out.tex_coords = model.tex_coords;
    out.clip_position = vec4<f32>(model.position, 1.0);
    return out;
}

@group(0) @binding(0)
var t_diffuse: texture_2d<f32>;
@group(0) @binding(1)
var s_diffuse: sampler;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    var kernel: array<f32, 9> = array<f32, 9>(
        -1.0, -1.0, -1.0,
        -1.0,  8.0, -1.0,
        -1.0, -1.0, -1.0
    );
    var out = 0.0;
    for (var x: i32 = -1; x <= 1; x++) {
        for (var y: i32 = -1; y <= 1; y++) {
            var coord = in.tex_coords + vec2<f32>(f32(x), f32(y));
            var sample = textureSample(t_diffuse, s_diffuse, coord);
            var lum = sample.r * 0.2126 + sample.g * 0.7152 + sample.b * 0.0722;
            var mult = kernel[(x+1) + (y+1)*3];
            out += lum * mult;
        }
    }
    if out > 0.5 {
        out = 1.0;
    } else {
        out = 0.0;
    }
    // var out = textureSample(t_diffuse, s_diffuse, in.tex_coords);
    return vec4<f32>(out, out, out, 1.0);

    // let li = in.clip_position.xy / 255.;

    // let y = sin(li.x) + 1.0;

    // let color = smoothstep(0., 0.1, abs(y - li.y));

    // return vec4(vec3(color), 1.0);
    
    // return vec4<f32>(pow(((in.color / 255.0 + 0.055) / 1.055), vec3<f32>(2.4, 2.4, 2.4)), 1.0);
}
