GDPC                                                                               <   res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex?D      ?      &?y???ڞu;>??.p   res://Root.tscn @      @      ??????k^1?ǽ;_q?   res://default_env.tres  `B      ?       um?`?N??<*ỳ?8   res://gdexample.gdnsC      ?       J??"b?X???	?8?   res://gdexample.tres?C      ?       <????7&?6x?8c   res://icon.png  `M      ?      G1???z?c??vN???   res://icon.png.import   ?J      ?      ??fe??6?B??^ U?   res://project.binaryPZ      ?      ?'?q	???yEJ?[gd_scene load_steps=8 format=2]

[ext_resource path="res://gdexample.gdns" type="Script" id=1]

[sub_resource type="GDScript" id=3]
script/source = "extends Spatial

func _ready():
	#var x = $BVHBuilder.getTriangles()
	#var a = $BVHBuilder.triangles_count
	#var bbb = $BVHBuilder.triangles_tex
	#var y = 2
	#$ColorRect.material.set_shader_param(\"triangles\", bbb)
	#$ColorRect.material.set_shader_param(\"triangles_count\", a)
	
	$BVHBuilder.material = $ColorRect.material
	var suc = $BVHBuilder.getTriangles()
	pass

class Triangle_ecoded:
	var p1: Vector3 # Vertex coordinates
	var p2: Vector3
	var p3: Vector3
	var n1: Vector3 # Vertex normal
	var n2: Vector3
	var n3: Vector3
	var emmisive: Vector3 # Self luminous parameters
	var baseColor: Vector3 # color
	var param1: Vector3 # subsurface, metallic, specular
	var param2: Vector3 # specularTint, roughness, anisotropic
	var param3: Vector3 # sheen, sheenTint, clearcoat
	var param4: Vector3 # clearcoatGloss, IOR, transmission
	var center: Vector3

var triangles_img = Image.new()
var triangles_tex = ImageTexture.new()
var nodes_img = Image.new()
var nodes_tex = ImageTexture.new()

var call_once = true
func _process(delta):
	updateFPS()
	#buildTriangles()
	if call_once:
		#$BVHBuilder.setMaterial($ColorRect.material)
		#$BVHBuilder.material = $ColorRect.material
		#var suc = $BVHBuilder.getTriangles()
		call_once = false
	var suc = $BVHBuilder.getTriangles()
	#$ColorRect.material.set_shader_param(\"triangles\", $BVHBuilder.triangles_tex)
	#$ColorRect.material.set_shader_param(\"triangles_count\", $BVHBuilder.triangles_count)

func _physics_process(delta):
	$MeshInstance2.rotate_y(delta)
	$MeshInstance3.rotate_y(-delta * 0.1)

var triangles = []
func buildTriangles():
	var triangles = []
	var triangle_meshes = get_tree().get_nodes_in_group(\"T\")
	for m in triangle_meshes:
		var vertices = m.mesh.surface_get_arrays(0)[ArrayMesh.ARRAY_VERTEX]
		var normals = m.mesh.surface_get_arrays(0)[ArrayMesh.ARRAY_NORMAL]
		var indices = m.mesh.surface_get_arrays(0)[ArrayMesh.ARRAY_INDEX]
		var transform = m.get_global_transform_interpolated()
		var idx = 3
		var triang
		for i in indices:
			if idx == 3:
				idx = 0
				triang = Triangle_ecoded.new()
				triang.baseColor = Vector3(fmod(randf(), 1.0), fmod(randf(), 1.0), fmod(randf(), 1.0))
			idx += 1
			var vert = vertices[i]
			var norm = normals[i]
			vert = transform.xform(vert)
			norm = transform.basis.xform(norm)
			if idx == 1:
				triang.p1 = vert
				triang.n1 = norm
			elif idx == 2:
				triang.p2 = vert
				triang.n2 = norm
			elif idx == 3:
				triang.p3 = vert
				triang.n3 = norm
				triang.center = (triang.p1 + triang.p2 + triang.p3) / Vector3(3, 3, 3)
				triangles.append(triang)
	triangles_img.create(2048, 2, false, Image.FORMAT_RGBAF)
	triangles_img.lock()
	for i in range(0, triangles.size()):
		triangles_img.set_pixelv(idx_to_coord(12 * i + 0), Color(triangles[i].p1.x, triangles[i].p1.y, triangles[i].p1.z))
		triangles_img.set_pixelv(idx_to_coord(12 * i + 1), Color(triangles[i].p2.x, triangles[i].p2.y, triangles[i].p2.z))
		triangles_img.set_pixelv(idx_to_coord(12 * i + 2), Color(triangles[i].p3.x, triangles[i].p3.y, triangles[i].p3.z))
		triangles_img.set_pixelv(idx_to_coord(12 * i + 3), Color(triangles[i].n1.x, triangles[i].n1.y, triangles[i].n1.z))
		triangles_img.set_pixelv(idx_to_coord(12 * i + 4), Color(triangles[i].n2.x, triangles[i].n2.y, triangles[i].n2.z))
		triangles_img.set_pixelv(idx_to_coord(12 * i + 5), Color(triangles[i].n3.x, triangles[i].n3.y, triangles[i].n3.z))
		triangles_img.set_pixelv(idx_to_coord(12 * i + 6), Color(triangles[i].emmisive.x, triangles[i].emmisive.y, triangles[i].emmisive.z))
		triangles_img.set_pixelv(idx_to_coord(12 * i + 7), Color(triangles[i].baseColor.x, triangles[i].baseColor.y, triangles[i].baseColor.z))
		triangles_img.set_pixelv(idx_to_coord(12 * i + 8), Color(triangles[i].param1.x, triangles[i].param1.y, triangles[i].param1.z))
		triangles_img.set_pixelv(idx_to_coord(12 * i + 9), Color(triangles[i].param2.x, triangles[i].param2.y, triangles[i].param2.z))
		triangles_img.set_pixelv(idx_to_coord(12 * i + 10), Color(triangles[i].param3.x, triangles[i].param3.y, triangles[i].param3.z))
		triangles_img.set_pixelv(idx_to_coord(12 * i + 11), Color(triangles[i].param4.x, triangles[i].param4.y, triangles[i].param4.z))
	triangles_img.unlock()
	if call_once:
		triangles_tex.create_from_image(triangles_img)
	else:
		triangles_tex.set_data(triangles_img)
	
	bvh_nodes = []
	buildBVH(0, triangles.size())
	nodes_img.create(2048, 2, false, Image.FORMAT_RGBAF)
	nodes_img.lock()
	for i in range(0, bvh_nodes.size()):
		nodes_img.set_pixelv(idx_to_coord(3 * i + 0), Color(0, 0, 0, 0))
		nodes_img.set_pixelv(idx_to_coord(3 * i + 1), Color(0, 0, 0, 0))
		nodes_img.set_pixelv(idx_to_coord(3 * i + 2), Color(bvh_nodes[i].left, bvh_nodes[i].right, bvh_nodes[i].n, bvh_nodes[i].index))
	nodes_img.unlock()
	if call_once:
		nodes_tex.create_from_image(nodes_img)
	else:
		nodes_tex.set_data(nodes_img)
	
	if call_once:
		$ColorRect.material.set_shader_param(\"triangles\", triangles_tex)
		$ColorRect.material.set_shader_param(\"triangles_count\", triangles.size())
		$ColorRect.material.set_shader_param(\"nodes\", nodes_tex)
		$ColorRect.material.set_shader_param(\"nodes_count\", bvh_nodes.size())
	pass

func idx_to_coord(idx: int) -> Vector2:
	return Vector2(idx & 2047, idx >> 11)

class BVHNode:
	var left: int
	var right: int
	var n: int
	var index: int
	var AA: Vector3
	var BB: Vector3

var bvh_nodes = []
const n = 8
func buildBVH(l, r) -> int:
	if l > r:
		return 0
	bvh_nodes.append(BVHNode.new())
	var id = bvh_nodes.size() - 1
	# bvh_nodes[id] init ...
	for i in range(l, r):
		var x = 2 # triangle AABB calculation ...
	if r - l <= n:
		bvh_nodes[id].n = r - l
		bvh_nodes[id].index = l
		return id
	# sort ...
	var mid: int = (r + l) / 2
	bvh_nodes[id].left = buildBVH(l, mid)
	bvh_nodes[id].right = buildBVH(mid, r)
	return id

func updateFPS():
	$ColorRect/Label.text = \"FPS \" + str(Engine.get_frames_per_second())
	Engine.iterations_per_second
	pass
"

[sub_resource type="Shader" id=1]
code = "shader_type canvas_item;

uniform sampler2D triangles;
uniform sampler2D nodes;
uniform int triangles_count;
uniform int nodes_count;

// Object surface material definition
struct Material {
    vec3 emissive;
    vec3 baseColor;
    float subsurface;
    float metallic;
    float specular;
    float specularTint;
    float roughness;
    float anisotropic;
    float sheen;
    float sheenTint;
    float clearcoat;
    float clearcoatGloss;
    float IOR;
    float transmission;
};

ivec2 idx_to_coord(int idx) {
	return ivec2(idx & 2047, idx >> 11);
}

// Triangle definition
struct Triangle {
    vec3 p1, p2, p3;    // Vertex coordinates
    vec3 n1, n2, n3;    // Vertex normal
    Material material;  // texture of material
};

Triangle getTriangle(int idx) {
	int offset = idx * 12;
	Triangle t;
	t.p1 = texelFetch(triangles, idx_to_coord(offset), 0).xyz;
	t.p2 = texelFetch(triangles, idx_to_coord(offset + 1), 0).xyz;
	t.p3 = texelFetch(triangles, idx_to_coord(offset + 2), 0).xyz;
	t.n1 = texelFetch(triangles, idx_to_coord(offset + 3), 0).xyz;
	t.n2 = texelFetch(triangles, idx_to_coord(offset + 4), 0).xyz;
	t.n3 = texelFetch(triangles, idx_to_coord(offset + 5), 0).xyz;
	return t;
}

Material getMaterial(int idx) {
    Material m;
    int offset = idx * 12;
    vec3 param1 = texelFetch(triangles, idx_to_coord(offset + 8), 0).xyz;
    vec3 param2 = texelFetch(triangles, idx_to_coord(offset + 9), 0).xyz;
    vec3 param3 = texelFetch(triangles, idx_to_coord(offset + 10), 0).xyz;
    vec3 param4 = texelFetch(triangles, idx_to_coord(offset + 11), 0).xyz;
    
    m.emissive = texelFetch(triangles, idx_to_coord(offset + 6), 0).xyz;
    m.baseColor = texelFetch(triangles, idx_to_coord(offset + 7), 0).xyz;
    m.subsurface = param1.x;
    m.metallic = param1.y;
    m.specular = param1.z;
    m.specularTint = param2.x;
    m.roughness = param2.y;
    m.anisotropic = param2.z;
    m.sheen = param3.x;
    m.sheenTint = param3.y;
    m.clearcoat = param3.z;
    m.clearcoatGloss = param4.x;
    m.IOR = param4.y;
    m.transmission = param4.z;

    return m;
}

struct BVHNode {
	vec3 AA, BB;
	int left, right;
	int n, index;
};

BVHNode getBVHNode(int idx) {
	BVHNode node;
	int offset = idx * 3;
	node.AA = texelFetch(nodes, idx_to_coord(offset), 0).xyz;
	node.BB = texelFetch(nodes, idx_to_coord(offset + 1), 0).xyz;
	vec4 param = texelFetch(nodes, idx_to_coord(offset + 2), 0);
	node.left = int(param.x);
	node.right = int(param.y);
	node.n = int(param.z);
	node.index = int(param.w);
	return node;
}

struct Ray {
    vec3 orig;
    vec3 dir;
};

struct HitResult {
    bool isHit;             // Hit
    bool isInside;          // Whether to hit from inside
    float dist;             // Distance from intersection
    vec3 hitPoint;          // Light midpoint
    vec3 normal;            // Hit point normal
    vec3 viewDir;           // The direction of the light hitting the point
    Material material;      // Surface material of hit point
	int triangle_index;
	vec2 uv;
};

const float INF = 114514.0;

HitResult hitTriangle_(Triangle triangle, Ray ray) {
	HitResult res;
	res.dist = INF;
	res.isHit = false;
	res.isInside = false;
	// compute plane's normal
	vec3 v1v0 = triangle.p2 - triangle.p1;
	vec3 v2v0 = triangle.p3 - triangle.p1;
	vec3 rov0 = ray.orig - triangle.p1;
	// no need to normalize
	vec3 n = cross( v1v0, v2v0 );
	vec3 q = cross( rov0, ray.dir );
	float d = 1.0 / dot( ray.dir, n );
	float u = d*dot( -q, v2v0 );
	float v = d*dot(  q, v1v0 );
	float t = d*dot( -n, rov0 );
	//if( u<0.0 || v<0.0 || (u+v)>1.0 ) t = -1.0;
	if (u >= 0.0 && v >= 0.0 && (u + v) <= 1.0) {
		res.isHit = true;
		res.dist = t;
		res.uv = vec2(u, v);
	}
	return res;
}

// Intersection of light and triangle 
HitResult hitTriangle(Triangle triangle, Ray ray) {
    HitResult res;
    res.dist = INF;
    res.isHit = false;
    res.isInside = false;

    vec3 p1 = triangle.p1;
    vec3 p2 = triangle.p2;
    vec3 p3 = triangle.p3;

    vec3 S = ray.orig;    // Ray starting point
    vec3 d = ray.dir;     // Ray direction
    vec3 N = normalize(cross(p2-p1, p3-p1));    // Normal vector

    // Hit from behind the triangle (inside the model)
    if (dot(N, d) > 0.0f) {
        N = -N;   
        res.isInside = true;
    }

    // If the line of sight is parallel to the triangle
    if (abs(dot(N, d)) < 0.00001f) return res;

    // distance
    float t = (dot(N, p1) - dot(S, N)) / dot(d, N);
    if (t < 0.0005f) return res;    // If the triangle is on the back of the light

    // Intersection calculation
    vec3 P = S + d * t;

    // Determine whether the intersection is in the triangle
    vec3 c1 = cross(p2 - p1, P - p1);
    vec3 c2 = cross(p3 - p2, P - p2);
    vec3 c3 = cross(p1 - p3, P - p3);
    bool r1 = (dot(c1, N) > 0.0 && dot(c2, N) > 0.0 && dot(c3, N) > 0.0);
    bool r2 = (dot(c1, N) < 0.0 && dot(c2, N) < 0.0 && dot(c3, N) < 0.0);

    // Hit, encapsulate the returned result
    if (r1 || r2) {
        res.isHit = true;
        res.hitPoint = P;
        res.dist = t;
        res.normal = N;
        res.viewDir = d;
        // Interpolate vertex normals according to the intersection position
        float alpha = (-(P.x-p2.x)*(p3.y-p2.y) + (P.y-p2.y)*(p3.x-p2.x)) / (-(p1.x-p2.x-0.00005)*(p3.y-p2.y+0.00005) + (p1.y-p2.y+0.00005)*(p3.x-p2.x+0.00005));
        float beta  = (-(P.x-p3.x)*(p1.y-p3.y) + (P.y-p3.y)*(p1.x-p3.x)) / (-(p2.x-p3.x-0.00005)*(p1.y-p3.y+0.00005) + (p2.y-p3.y+0.00005)*(p1.x-p3.x+0.00005));
        float gama  = 1.0 - alpha - beta;
        vec3 Nsmooth = alpha * triangle.n1 + beta * triangle.n2 + gama * triangle.n3;
        res.normal = (res.isInside) ? (-Nsmooth) : (Nsmooth);
    }

    return res;
}

// Brutally traverse the array subscript range [l, r] to find the nearest intersection
HitResult hitArray(Ray ray, int l, int r) {
	HitResult res;
	res.isHit = false;
	res.dist = INF;
	for (int i = l; i < r; ++i) {
		Triangle triangle = getTriangle(i);
		HitResult res_i = hitTriangle_(triangle, ray);
		if (res_i.isHit && res_i.dist < res.dist) {
			res = res_i;
			//res.material = getMaterial(i);
			res.triangle_index = i;
		}
	}
	//if (res.isHit) {
	//	res.material = getMaterial(res.triangle_index);
	//}
	return res;
}

float hitAABB(Ray r, vec3 AA, vec3 BB) {
    vec3 invdir = 1.0 / r.dir;

    vec3 f = (BB - r.orig) * invdir;
    vec3 n = (AA - r.orig) * invdir;

    vec3 tmax = max(f, n);
    vec3 tmin = min(f, n);

    float t1 = min(tmax.x, min(tmax.y, tmax.z));
    float t0 = max(tmin.x, max(tmin.y, tmin.z));

    return (t1 >= t0) ? ((t0 > 0.0) ? (t0) : (t1)) : (-1.0);
}

HitResult hitBVH(Ray ray) {
	HitResult res;
	res.isHit = false;
	res.dist = INF;
	int stack[30];
    int sp = 0;
    stack[sp++] = 0;
	while (sp > 0) {
        BVHNode node = getBVHNode(stack[--sp]);
		if (node.n > 0) {
			HitResult r = hitArray(ray, node.index, node.index + node.n);
			if (r.isHit && r.dist < res.dist) {
				res = r;
			}
		} else {
			float d1 = INF;
			float d2 = INF;
			if (node.left > 0) {
				BVHNode leftNode = getBVHNode(node.left);
				d1 = hitAABB(ray, leftNode.AA, leftNode.BB);
			}
			if (node.right > 0) {
				BVHNode rightNode = getBVHNode(node.right);
				d2 = hitAABB(ray, rightNode.AA, rightNode.BB);
			}
			if (d1 > 0.0 && d2 > 0.0) {
				if (d1 < d2) {
					stack[sp++] = node.right;
					stack[sp++] = node.left;
				} else {
					stack[sp++] = node.left;
					stack[sp++] = node.right;
				}
			} else if (d1 > 0.0) {
				stack[sp++] = node.left;
			} else if (d2 > 0.0) {   // Hit right only
				stack[sp++] = node.right;
			}
		}
	}

	if (res.isHit) {
		res.material = getMaterial(res.triangle_index);
	}
	return res;
}

void fragment() {
	vec2 SIZE = 1.0 / SCREEN_PIXEL_SIZE;
	ivec2 COORD = ivec2(vec2(UV.x, 1.0 - UV.y) * SIZE);

	float aspect_ratio = SIZE.x / SIZE.y;

//	float viewport_height = 2.0;
//	float viewport_width = aspect_ratio * viewport_height;
//	float focal_length = 1.0;
//
//	vec3 origin = vec3(0, 2, 8);
//	vec3 horizontal = vec3(viewport_width, 2, 8);
//	vec3 vertical = vec3(0, viewport_height + 2.0, 8);
//	vec3 lower_left_corner = origin - horizontal / 2.0 - vertical / 2.0 - vec3(0, 0, focal_length);
//
//	float u = UV.x;
//	float v = 1.0 - UV.y;
//	Ray ray = Ray(origin, normalize( lower_left_corner + u * horizontal + v * vertical - origin ));

	Ray ray;
	ray.orig = vec3(0, 3, 7);
	vec3 dir = vec3(vec2(UV.x * aspect_ratio, 1.0 - UV.y) * 2.0 - vec2(aspect_ratio, 1) + vec2(0, 3), 5) - ray.orig;
	ray.dir = normalize(dir);

	//HitResult res = hitArray(ray, 0, triangles_count);
	HitResult res = hitBVH(ray);
	COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	if (res.isHit) {
	//	COLOR = vec4(res.material.baseColor, 1.0);
		COLOR = vec4(res.uv.x, res.uv.y, 1.0 - res.uv.x - res.uv.y, 1.0);
	}
//	BVHNode node = getBVHNode(6);
//	BVHNode left = getBVHNode(node.left);
//	BVHNode right = getBVHNode(node.right);
//
//	float r1 = hitAABB(ray, left.AA, left.BB);  
//	float r2 = hitAABB(ray, right.AA, right.BB);  
//
//	if(r1 > 0.0) COLOR.rgb = vec3(1, 0, 0);
//	if(r2 > 0.0) COLOR.rgb = vec3(0, 1, 0);
//	if(r1 > 0.0 && r2 > 0.0) COLOR.rgb = vec3(1, 1, 0);
}"

[sub_resource type="ShaderMaterial" id=2]
shader = SubResource( 1 )
shader_param/triangles_count = null
shader_param/nodes_count = null

[sub_resource type="CubeMesh" id=4]

[sub_resource type="CubeMesh" id=5]

[sub_resource type="SphereMesh" id=6]

[node name="Root" type="Spatial"]
script = SubResource( 3 )

[node name="ColorRect" type="ColorRect" parent="."]
material = SubResource( 2 )
anchor_right = 1.0
anchor_bottom = 1.0

[node name="Label" type="Label" parent="ColorRect"]
margin_right = 40.0
margin_bottom = 14.0

[node name="MeshInstance" type="MeshInstance" parent="." groups=["T"]]
transform = Transform( 5.05765, 0, 0, 0, 0.185778, 0, 0, 0, 5.5827, 0, 0, 0 )
mesh = SubResource( 4 )

[node name="MeshInstance2" type="MeshInstance" parent="." groups=["T"]]
transform = Transform( 0.861077, 0.31848, 0.396379, -0.289299, 0.94793, -0.133173, -0.418152, 0, 0.908377, -1.31653, 2.6594, -2.31899 )
mesh = SubResource( 5 )

[node name="MeshInstance3" type="MeshInstance" parent="." groups=["T"]]
transform = Transform( 1, 0, 0, 0, 1, 0, 0, 0, 1, 1.83212, 2.05665, -1.0931 )
mesh = SubResource( 6 )

[node name="BVHBuilder" type="Spatial" parent="."]
script = ExtResource( 1 )
 [gd_resource type="Environment" load_steps=2 format=2]

[sub_resource type="ProceduralSky" id=1]

[resource]
background_mode = 2
background_sky = SubResource( 1 )
             [gd_resource type="NativeScript" load_steps=2 format=2]

[ext_resource path="res://gdexample.tres" type="GDNativeLibrary" id=1]

[resource]

resource_name = "gdexample"
class_name = "BVHBuilder"
library = ExtResource( 1 )   [gd_resource type="GDNativeLibrary" format=2]

[resource]
entry/OSX.64 = "res://bin/osx/libgdexample.dylib"
entry/HTML5.wasm32 = "res://bin/web/libgdexample.wasm"
dependency/OSX.64 = []
dependency/HTML5.wasm32 = []
         GDST@   @            ?  WEBPRIFF?  WEBPVP8L?  /?????m????????_"?0@??^?"?v??s?}? ?W??<f??Yn#I??????wO???M`ҋ???N??m:?
??{-?4b7DԧQ??A ?B?P??*B??v??
Q?-????^R?D???!(????T?B?*?*???%E["??M?\͆B?@?U$R?l)???{?B???@%P????g*Ųs?TP??a??dD
?6?9?UR?s????1ʲ?X?!?Ha?ߛ?$??N????i?a΁}c Rm??1??Q?c???fdB?5??????J˚>>???s1??}????>????Y????TEDױ???s???\?T???4D????]ׯ?(aD??Ѓ!?a'\?G(??$+c$?|'?>????/B??c?v??_oH???9(l?fH??????8??vV?m?^?|?m۶m?????q???k2?='???:_>??????????á????-wӷU?x?˹?fa???????????ӭ?M???SƷ7??????|??v??v???m?d???ŝ,??L??Y??ݛ?X?\֣? ???{?#3????
?6??????t`?
??t?4O??ǎ%????u[B??????O̲H??o߾??$???f???? ?H??\??? ?kߡ}?~$?f???N\??[?=?'??Nr:a???si?????(9Lΰ????=????q-??W??LL%ɩ	??V????R)?=jM????d`?ԙHT?c???'ʦI??DD?R??C׶?&????|t Sw?|WV&?^??bt5WW,v?Ş?qf???+???Jf?t?s?-BG?t?"&?Ɗ????׵?Ջ?KL?2)gD?? ???? NEƋ?R;k?.{L?$?y???{'??`??ٟ??i??{z?5??i???????c???Z^?
h?+U?mC??b??J??uE?c?????h??}{??????i?'?9r??????ߨ򅿿??hR?Mt?Rb???C?DI??iZ?6i"?DN?3???J?zڷ#oL?????Q ?W??D@!'??;??? D*?K?J?%"?0?????pZԉO?A??b%?l?#??$A?W?A?*^i?$?%a??rvU5A?ɺ??'a<??&?DQ??r6ƈZC_B)?N?N(?????(z??y?&H?ض^??1Z4*,RQjԫ׶c????yq??4?????R?????0?6f2Il9j??ZK?4???է?0؍è?ӈ?Uq?3?=[vQ???d$???±eϘA?????R?^??=%:?G?v??)?ǖ/??RcO???z .?ߺ??S&Q????o,X?`?????|??s?<3Z??lns'???vw????Y??>V????G?nuk:??5?U.?v??|????W???Z???4?@U3U???????|?r??;?
         [remap]

importer="texture"
type="StreamTexture"
path="res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://icon.png"
dest_files=[ "res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
              ?PNG

   IHDR   @   @   ?iq?   sRGB ???  ?IDATx???ytTU????ի%???@ȞY1JZ ?iA?i?[P??e??c;?.`Ow+4?>?(}z?EF?Dm?:?h??IHHB?BR!{%?Zߛ???	U?T?
???:??]~???????-?	Ì?{q*?h$e-
?)??'?d?b(??.?B?6???J?ĩ=;???Cv?j??E~Z??+??CQ?AA??????;?.?	?^P	???ARkUjQ?b?,#;?8?6??P~,? ?0?h%*QzE? ?"??T??
?=1p:lX?Pd?Y???(:g?????kZx ??A???띊3G?Di? !?6?????A҆ @?$JkD?$??/?nYE??< Q???<]V?5O!???>2<??f??8?I??8??f:a?|+?/?l9?DEp?-?t]9)C?o??M~?k??tw?r??????w??|r?Ξ?	?S?)^? ??c?eg$?vE17ϟ?(?|???Ѧ*????
????^???uD?̴D????h?????R??O?bv?Y????j^?SN֝
??????PP??????????Y>????&?P??.3+?$??ݷ??????{n?????_5c?99?fbסF&?k?mv???bN?T???F???A?9?
(.?'*"??[??c?{ԛmNު8???3?~V?? az
?沵?f?sD??&+[???ke3o>r????????T?]????* ???f?~nX?Ȉ???w+?G???F?,U?? D?Դ0赍?!?B?q?c?(
ܱ??f?yT?:??1?? +????C|??-?T??D?M??\|?K?j??<yJ, ?????n??1.FZ?d$I0݀8]??Jn_? ???j~?????ցV??????????1@M?)`F?BM????^x?>
?????`??I?˿??wΛ	????W[?????v??E?????u??~??{R?(????3?????????y????C??!??nHe??T??Z?????K?P`ǁF´?nH啝???=>id,?>?GW-糓F??????m<P8?{o[D????w?Q??=N}?!+?????-?<{[?????????w?u?L??????4?????Uc?s??F?륟??c?g?u?s??N??lu???}ן($D??ת8m?Q?V	l?;??(??ڌ???k?
s\??JDIͦOzp??مh????T???IDI???W?Iǧ?X???g??O??a??\:???>????g???%|????i)	?v??]u.?^??:Gk??i)	>??T@k{'	=???????@a?$zZ?;}?󩀒??T?6?Xq&1aWO?,&L?cřT?4P???g[?
p?2??~;? ??Ҭ?29?xri? ?????)??_??@s[??^?ܴhnɝ4&'
??NanZ4??^Js[ǘ??2???x?Oܷ?$??3?$r?????Q??1@?????~??Y?Qܑ?Hjl(}?v?4vSr?iT?1???f???????(????A?ᥕ?$? X,?3'?0s????×ƺk~2~'?[?ё?&F?8{2O?y?n?-`^/FPB??.?N?AO]]?? ?n]β[?SR?kN%;>?k??5??????]8??????=p????Ցh??????`}?
?J?8-??ʺ????? ?fl˫[8??E9q?2&??????p??<??r?8x? [^݂??2?X??z?V+7N????V@j?A????hl??/+/'5?3??;9
?(?Ef'Gyҍ???̣?h4RSS? ??????????j?Z??jI??x??dE-y?a?X?/?????:??? +k?? ?"˖/???+`??],[????UVV4u??P ?˻?AA`??)*ZB\\??9lܸ?]{N??礑]6?Hnnqqq-a??Qxy?7?`=8A?Sm&?Q??????u?0hsPz????yJt?[?>?/ޫ?il?????.??ǳ???9??
_
??<s???wT?S??????;F????-{k?????T?Z^???z?!t?۰؝^?^*???؝c
???;??7]h^
??PA??+@??gA*+?K??ˌ?)S?1??(Ե??ǯ??h????õ?M?`??p?cC?T")?z?j?w??V??@??D??N?^M\?????m?zY??C?Ҙ?I????N?Ϭ??{??9?)????o???C???h?????ʆ.??׏(?ҫ???@?Tf%yZt???wg?4s?]f?q뗣?ǆi?l?⵲3t??I???O??v;Z?g???l??l??kAJѩU^wj?(????????{???)?9?T???KrE?V!?D???aw???x[?I??tZ?0Y ?%E?͹???n?G?P?"5FӨ??M?K?!>R?????$?.x????h=gϝ?K&@-F??=}?=??????5???s ?CFwa???8??u?_????D#???x:R!5&??_?]????*?O??;?)Ȉ?@?g?????ou?Q?v???J?G?6?P???????7??-???	պ^#?C??S??[]3??1???IY??.Ȉ!6\K??:???9?Ev??S]?l;???/? ??5?p?X??f?1?;5??S?ye??Ƅ???,Da?>?? O.?AJL(???pL??C5ij޿hBƾ???ڎ?)s??9$D?p?????I??e?,ə?+;??t??v?p?-??&????	V???x???yuo-G&8->??xt?t??????Rv??Y?4ZnT?4P]?HA?4?a?T?ǅ1`u\?,???hZ????S??????o翿???{?릨ZRq???Y??fat?[????[z9??4?U?V??Anb$Kg??????]??????8?M0(WeU?H??\n_??¹?C??F?F?}????8d?N??.??]???u?,%Z?F-???E?'????q?L?\??????=H?W'?L{?BP0Z???Y?̞???DE??I?N7???c??S???7?Xm?/`?	?+`????X_???KI??^??F\?aD??????~?+M????ㅤ??	SY??/?.?`???:?9Q?c ?38K?j?0Y?D?8????W;ܲ?pTt??6P,? Nǵ??Æ?:(???&?N?/ X??i%???_P	?n?F?.^?G?E???鬫>????"@v?2???A~?aԹ_[P, n????N??????_rƢ??    IEND?B`?       ECFG	      application/config/name         Lux    application/run/main_scene         res://Root.tscn    application/config/icon         res://icon.png     display/window/dpi/allow_hidpi            display/window/vsync/use_vsync             display/window/stretch/shrink         @+   gui/common/drop_mouse_on_gui_input_disabled         )   physics/common/enable_pause_aware_picking         )   rendering/environment/default_environment          res://default_env.tres                