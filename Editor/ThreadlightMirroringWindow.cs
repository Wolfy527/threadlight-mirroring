namespace Threadlight.MirroringBuilder.Editor {
using Threadlight.Mirroring.Editor;
using UnityEditor;
public sealed class ThreadlightMirroringWindow : EditorWindow {
    public void CreateGUI() { Open(); Close(); }
    [MenuItem("Tools/ThreadLight/Mirroring")]
    public static void Open() => LiveMirroringSetupWindow.Open();
}
}
