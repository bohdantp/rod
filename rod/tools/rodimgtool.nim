import cligen
import imgtool
import times
import os

proc rodimgtool(compressToPVR: bool = false, originalResPath: string = ".",
        resPath: string = ".", outPrefix: string = ".", nocompress: bool = false,
        downsampleRatio: float = 1.0,
        compositions: seq[string]): int =
    var tool = newImgTool()
    tool.originalResPath = originalResPath
    tool.resPath = resPath

    tool.compositionPaths = @[]
    for c in compositions:
        for i in walkFiles(c):
            tool.compositionPaths.add(i)
    tool.outPrefix = outPrefix
    tool.compressOutput = not nocompress
    tool.compressToPVR = compressToPVR
    tool.downsampleRatio = downsampleRatio
    let startTime = epochTime()
    tool.run()
    echo "Done. Time: ", epochTime() - startTime

dispatch(rodimgtool)
