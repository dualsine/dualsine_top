window.onload = () ->
	window.addEventListener 'scroll', window.onScroll, false

	if !Detector.webgl
		alert('no webgl!')
		return false

	manager = new THREE.LoadingManager()
	manager.onProgress = ( item, loaded, total ) ->
		console.log (loaded / total * 100)

	window.container = document.getElementById( 'slide1' )
	window.menu = document.getElementById( 'menu' )

	window.camera = new THREE.PerspectiveCamera( 45, window.innerWidth / (window.innerHeight+10), 0.25, 20 )
	window.camera.position.set( 0, 0, 12.7 )

	#path = 'env/'
	#format = '.jpg'
	#envMap = new THREE.CubeTextureLoader().load( [
	#					path + 'posx' + format, path + 'negx' + format,
	#					path + 'posy' + format, path + 'negy' + format,
	#					path + 'posz' + format, path + 'negz' + format
	#				] )

	window.scene = new THREE.Scene()
	window.scene.background = new THREE.Color( 0xffffff )

	light = new THREE.HemisphereLight( 0xbbbbff, 0x444422 )
	light.position.set( 0, 1, 0 )
	window.scene.add( light )

	window.point_light = new THREE.PointLight( 0xbbbbff, 4, 10 )
	window.point_light.position.set( -3, 0, 10 )
	window.scene.add( window.point_light )

	loader = new THREE.GLTFLoader()
	loader.setDRACOLoader( new THREE.DRACOLoader() );
	window.shapes = []
	loader.load 'models/untitled.gltf', ( gltf ) ->
		gltf.scene.traverse ( child ) ->
			if child.isMesh
				#child.material.envMap = envMap
				window.shapes.push(child)
				#child.geometry.applyMatrix( new THREE.Matrix4().makeTranslation( -5.5, -5.5, 0 ) )
				if window.innerWidth/window.innerHeight > 2
					child.position.x = -5
				else
					child.position.x = -4
				child.position.y = 0.7
				child.position.z = 0.2
		scene.add( gltf.scene )
	, (xhr) ->
		console.log( ( xhr.loaded / xhr.total * 100 ) + '% loaded' );
	, () ->
		console.log('error')

	window.renderer = new THREE.WebGLRenderer( { antialias: true, alpha: true } )
	window.renderer.setPixelRatio( window.devicePixelRatio )
	window.renderer.setSize( window.innerWidth, window.innerHeight+10 )
	window.renderer.gammaOutput = true
	window.container.appendChild( window.renderer.domElement )
	window.addEventListener( 'resize', window.onWindowResize, false )

	window.mouse = {
		y: 0,
		x: 0
	}
	window.container.addEventListener( 'mousemove', window.mouseMove, false )

	window.light_direction = 'down';
	window.animate()

window.onScroll = () ->
	if document.body.offsetTop > 10
		document.getElementById('down-arrow').classList.add('hidden')
	else
		document.getElementById('down-arrow').classList.remove('hidden')

window.mouseMove = (event) ->
	cursor_position_y = (event.clientY-window.container.offsetTop-document.body.offsetTop-(window.container.clientHeight/2));
	if cursor_position_y < 0
		normal_cursor_position_y = Math.abs(cursor_position_y)
	else
		normal_cursor_position_y = cursor_position_y * -1
	window.mouse.y = normal_cursor_position_y / 100

	cursor_position_x = (event.clientX-(window.container.clientWidth/2)) + window.innerWidth / 6
	normal_cursor_position_x = cursor_position_x
	window.mouse.x = normal_cursor_position_x / 90

window.onWindowResize = () ->
	#camera.aspect = window.innerWidth / window.innerHeight;
	#camera.updateProjectionMatrix();
	#renderer.setSize( window.innerWidth, window.innerHeight );
window.animate = () ->
	requestAnimationFrame( window.animate )
	for shape in window.shapes
		shape.rotation.z += 0.003
	window.renderer.render( window.scene, window.camera )
