// Vertex Shader

struct VertexInput {
    @location(0) position: vec3<f32>,
    @location(1) color: vec3<f32>
}

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) color: vec3<f32>,
}

@vertex
fn vs_main(
    model: VertexInput,
) -> VertexOutput {
    var out: VertexOutput;
    out.color = model.color;
    out.clip_position = vec4<f32>(model.position, 1.0);
    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let li = in.clip_position.xy / 255.;

    let y = sin(li.x) + 1.0;

    let color = smoothstep(0., 0.1, abs(y - li.y));

    return vec4(vec3(color), 1.0);
    
    // return vec4<f32>(pow(((in.color / 255.0 + 0.055) / 1.055), vec3<f32>(2.4, 2.4, 2.4)), 1.0);
}
