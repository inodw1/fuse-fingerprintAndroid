using Uno.Threading;
using Uno;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;
using Android;
using Uno.Permissions;


using Fuse;
using Fuse.Scripting;

[extern(Android) ForeignInclude(Language.Java,     
                        "android.content.Intent", 
                        "android.content.Context", 
                        "android.os.Bundle",
                        "android.content.SharedPreferences",
                        "android.os.Handler",
                        "android.hardware.fingerprint.FingerprintManager",
                        "java.lang.Object"
                         )]

[UXGlobalModule]
public class fingerAndroid : NativeModule{
    static readonly fingerAndroid _instance;
    static string getPermission;
    
    public fingerAndroid(){
        if (_instance != null) return;
    	_instance = this;
    	Resource.SetGlobalKey(_instance, "fingerAndroid");
        AddMember(new NativeFunction("fingerPrintAuth",(NativeCallback)fingerPrint));
    }

    object fingerPrint(Context c, object[] args){
        var permissionPromise = Permissions.Request(Permissions.Android.USE_FINGERPRINT);
        permissionPromise.Then(OnPermitted, OnRejected);
        return getPermission;
        //fingerPrintImpl();
        //return null;
    }

    void OnPermitted(PlatformPermission permission)
     {
          debug_log "Access to the fingerprint Scanner!";
          getPermission = fingerPrintImpl();
     }

     void OnRejected(Exception e)
     {
         debug_log "Blast: " + e.Message;
     }

    [Foreign(Language.Java)]
    public static extern(Android) string fingerPrintImpl()
    @{
    android.util.Log.d("Inside the fingerPrintImpl", "Started!");
    return null;
    //My Code will goes here
    @}

    static extern(!Android) string fingerPrintImpl(){
        debug_log("Notifications not supported on this platform.");
        return null;
    }

}