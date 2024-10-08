package ai.binah.binah_flutter_sdk

abstract class NativeBridgeApi {

    companion object {
        const val createSession = "createSession";
        const val startSession = "startSession";
        const val stopSession = "stopSession";
        const val terminateSession = "terminateSession";
        const val getSessionState = "getSessionState";
        const val getNativeSdkVersion = "getNativeSdkVersion";

    }
}