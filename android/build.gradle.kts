allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Fix for old plugins (e.g. isar_flutter_libs) that don't declare a namespace.
// Must handle both already-evaluated and not-yet-evaluated projects because
// evaluationDependsOn(":app") above causes :app to evaluate early.
subprojects {
    val fixNamespace: () -> Unit = {
        if (plugins.hasPlugin("com.android.library")) {
            val android = extensions.getByType(com.android.build.gradle.LibraryExtension::class.java)
            if (android.namespace.isNullOrEmpty()) {
                val manifest = file("${project.projectDir}/src/main/AndroidManifest.xml")
                if (manifest.exists()) {
                    val pkg = javax.xml.parsers.DocumentBuilderFactory.newInstance()
                        .newDocumentBuilder()
                        .parse(manifest)
                        .documentElement
                        .getAttribute("package")
                    if (pkg.isNotEmpty()) {
                        android.namespace = pkg
                    }
                }
            }
        }
    }

    if (project.state.executed) {
        fixNamespace()
    } else {
        afterEvaluate { fixNamespace() }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
