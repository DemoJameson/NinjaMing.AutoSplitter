state("NinjaMing")
{
    short chapter: "GameAssembly.dll", 0x01C3EF88, 0xB8, 0x0, 0x20, 0xB8, 0x50;
    int level    : "GameAssembly.dll", 0x01C3EF88, 0xB8, 0x0, 0x20, 0xB8, 0x50; // short chapter + byte level + byte sublevel
    float time   : "GameAssembly.dll", 0x01C3EF88, 0xB8, 0x0, 0x20, 0xB8, 0x60, 0x18, 0x2C;
}

startup
{
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var mbox = MessageBox.Show(
            "NinjaMing uses in-game time.\nWould you like to switch to it?",
            "LiveSplit | NinjaMing",
            MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

start
{
    return old.chapter == 0 && current.level == 1;
}

split
{
    return current.level != old.level && current.chapter != 0;
}

gameTime
{
    
    return TimeSpan.FromSeconds(current.time);
}

reset
{
    return old.chapter != 0 && current.chapter == 0;
}

isLoading
{
    return true;
}