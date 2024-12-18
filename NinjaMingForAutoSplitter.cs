using System;
using System.Runtime.InteropServices;

namespace NJM.Extern {

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

        public LevelDescription(int levelID) {
            chapter = 0;
            majorLevel = 0;
            subLevel = 0;
            this.levelID = levelID;
        }

        public LevelDescription(ushort chapter, byte majorLevel, byte subLevel) {
            levelID = 0;
            this.chapter = chapter;
            this.majorLevel = majorLevel;
            this.subLevel = subLevel;
        }

        public int ToInt() {
            return levelID;
        }

    }

    public static class NinjaMingForAutoSplitter {

        public static double gameTime;

        // update when changed
        public static int scrollCount;

        /* struct LevelDescription currentLevelID:

           Little Endian
           8bit     | 8bit       | 16bit
           subLevel | majorLevel | chapter

           eg: 1-2-0, means chapter 1, major level 2, sub level 0
           0        | 2          | 1
           Binary: 0000 0000 | 0000 0010 | 0000 0000 0000 0001
        */
        public static LevelDescription currentLevelID;

        // 0: Not Running, 1: Running, 2: End
        public static int state;

    }

}