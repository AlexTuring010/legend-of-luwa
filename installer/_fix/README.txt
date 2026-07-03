Legend of LuWa - Lag Fix (cnc-ddraw)
====================================

Fixes the choppy / stuttering animation when running the old (2002)
"Legend of LuWa" on modern Windows (10 / 11). The game renders through
DirectDraw, which modern Windows emulates slowly through the desktop
compositor. cnc-ddraw replaces DirectDraw with a real hardware renderer
(OpenGL / Direct3D) plus vsync, which makes movement smooth again.

This works on any Windows version, 32-bit or 64-bit.


HOW TO INSTALL
--------------
1. Make sure the game is already installed (you need Luwa.exe).
   Default location: C:\Program Files\LegendOfLuwa\

2. Copy these items into that SAME folder, right next to Luwa.exe:
      - ddraw.dll
      - ddraw.ini
      - Shaders            (folder)
      - cnc-ddraw config.exe   (optional - settings GUI)

   If the game is in C:\Program Files\, Windows will show an admin
   prompt when you paste - click "Continue" / "Yes".

3. Launch the game normally. That's it - the animation should be smooth.


NOTES
-----
- Windows Defender / antivirus may flag ddraw.dll as a false positive.
  This is normal and expected for game graphics wrappers (they hook into
  the graphics API). It is safe. You can verify the source yourself:
  https://github.com/FunkyFr3sh/cnc-ddraw

- This ddraw.ini is pre-tuned: vsync=true, singlecpu=true, maintas=true,
  renderer=auto.

- To change settings later, run "cnc-ddraw config.exe" in the game folder.

- If you get a BLACK SCREEN or wrong colors, open ddraw.ini in Notepad
  and change:   renderer=auto   ->   renderer=opengl
  (or try       renderer=direct3d9).

- To uninstall completely, just delete these files from the game folder:
  ddraw.dll, ddraw.ini, Shaders, cnc-ddraw config.exe.
  That returns the game to exactly how it was.


cnc-ddraw is by FunkyFr3sh (open source). 
