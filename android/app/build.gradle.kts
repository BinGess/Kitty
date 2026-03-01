import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load key.properties for release signing (optional)
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}
fun prop(name: String): String? = keystoreProperties.getProperty(name)?.trim()?.takeIf { it.isNotEmpty() }

val useReleaseSigning = keystorePropertiesFile.exists() &&
    prop("storePassword") != null &&
    prop("keyAlias") != null &&
    prop("storeFile") != null &&
    rootProject.file(prop("storeFile")!!).exists()

android {
    namespace = "com.meowtalk.meow_talk"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    signingConfigs {
        if (useReleaseSigning) {
            create("release") {
                keyAlias = prop("keyAlias")
                keyPassword = prop("keyPassword") ?: prop("storePassword")
                storeFile = prop("storeFile")?.let { rootProject.file(it) }
                storePassword = prop("storePassword")
            }
        }
    }

    defaultConfig {
        applicationId = "com.meowtalk.meow_talk"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = if (useReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
