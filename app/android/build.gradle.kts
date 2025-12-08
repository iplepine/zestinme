allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Workaround for Isar namespace issue with AGP 8+
subprojects {
    if (project.name == "isar_flutter_libs") {
        afterEvaluate {
            project.extensions.configure<com.android.build.gradle.LibraryExtension> {
                namespace = "dev.isar.isar_flutter_libs"
            }
        }
    }
}

// Force compileSdk 36 for all Android subprojects to prevent lStar resource errors
subprojects {
    afterEvaluate {
        if (plugins.hasPlugin("com.android.application") ||
            plugins.hasPlugin("com.android.library")) {

            extensions.findByName("android")?.let { ext ->
                (ext as com.android.build.gradle.BaseExtension).apply {
                    compileSdkVersion(36)
                    buildToolsVersion = "36.0.0"
                }
            }
        }
    }
}
