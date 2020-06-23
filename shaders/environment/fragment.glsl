uniform sampler2D caustics;

varying float lightIntensity;
varying vec3 lightPosition;

const float bias = 0.001;

const vec3 underwaterColor = vec3(0.4, 0.9, 1.0);


void main() {
  // Set the frag color
  float computedLightIntensity = 0.5;

  computedLightIntensity += 0.2 * lightIntensity;

  // Retrieve caustics information
  vec2 causticsInfo = texture2D(caustics, lightPosition.xy).zw;
  float causticsIntensity = causticsInfo.x;
  float causticsDepth = causticsInfo.y;

  if (causticsDepth > lightPosition.z - bias) {
    computedLightIntensity += causticsIntensity * smoothstep(0., 1., lightIntensity);
  }

  // Debug NVidia
  if (computedLightIntensity < 0.5) {
    computedLightIntensity = 0.5;
  }

  gl_FragColor = vec4(underwaterColor * computedLightIntensity, 1.);
}
