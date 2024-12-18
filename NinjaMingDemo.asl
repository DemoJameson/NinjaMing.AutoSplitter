state("NinjaMing")
{
}

startup
{
    vars.Log = (Action<object>)(output => print("[Ninja Ming Demo] " + output));

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.AlertGameTime();
    vars.LevelDescriptionStruct = vars.Helper.Define(
        @"
        using System;
        using System.Runtime.InteropServices;

        [StructLayout(LayoutKind.Explicit)]
        public struct LevelDescription {
            [FieldOffset(0)]
            public int levelID;

            [FieldOffset(0)]
            public ushort chapter;

            [FieldOffset(2)]
            public byte majorLevel;

            [FieldOffset(3)]
            public byte subLevel;

            public override String ToString()
            {
                return chapter + ""-"" + majorLevel + ""-"" + subLevel;
            }
        }
        "
    );
}

init
{
    vars.Helper.Game = game;
    var hash = vars.Helper.GetMD5Hash("GameAssembly.dll");
    if (hash == "9B08BD1ED5ED514F2CD69C042A7FC191")
    {
        version = "legacy";
        vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
        {
            vars.Helper["gameTime"] = vars.Helper.Make<float>("GameAssembly.dll", 0x01C3EF88, 0xB8, 0x0, 0x20, 0xB8, 0x60, 0x18, 0x2C);
            vars.Helper["levelID"] = vars.Helper.Make<int>("GameAssembly.dll", 0x01C3EF88, 0xB8, 0x0, 0x20, 0xB8, 0x50);
            vars.Helper["chapter"] = vars.Helper.Make<ushort>("GameAssembly.dll", 0x01C3EF88, 0xB8, 0x0, 0x20, 0xB8, 0x50);
            return true;
        });
    }
    else
    {
        version = "modern";
        vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
        {
            var njmAS = mono["NJM.Kernel", "NinjaMingForAutoSplitter"];
            vars.Helper["gameTime"] = njmAS.Make<double>("gameTime");
            vars.Helper["state"] = njmAS.Make<int>("state");
            vars.currentLevelIDAddr = njmAS.Static + njmAS["currentLevelID"];
            return true;
        });
    }

    vars.Log("version=" + version);
}

start
{
    return old.state != 1 && current.state == 1;
}

update
{
    if (version == "modern")
    {
        var currentLevel = vars.Helper.ReadCustom(vars.LevelDescriptionStruct, vars.currentLevelIDAddr);
        current.levelID = currentLevel.levelID;
        current.chapter = currentLevel.chapter;
    }
    else
    {
        current.state = current.chapter == 1 ? 1 : 0;
    }
}

split
{
    return current.levelID != old.levelID;
}

gameTime
{
    return TimeSpan.FromSeconds(current.gameTime);
}

reset
{
    return old.state != 0 && current.state == 0;
}

isLoading
{
    return true;
}