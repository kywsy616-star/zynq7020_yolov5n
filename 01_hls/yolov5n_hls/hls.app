<project xmlns="com.autoesl.autopilot.project" name="yolov5n_hls" top="yolov5n_top">
    <includePaths/>
    <libraryPaths/>
    <Simulation>
        <SimFlow name="csim" csimMode="0" lastCsimMode="0"/>
    </Simulation>
    <files xmlns="">
        <file name="../../src/tb_r5_reference.cpp" sc="0" tb="1" cflags=" -Wno-unknown-pragmas" csimflags=" -Wno-unknown-pragmas" blackbox="false"/>
        <file name="../../src/tb_yolov5n_r6_4.cpp" sc="0" tb="1" cflags=" -Wno-unknown-pragmas" csimflags=" -Wno-unknown-pragmas" blackbox="false"/>
        <file name="src/axi64_native_io.h" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="src/yolov5n_hls.h" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="src/yolov5n_r6_5_schedule.h" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="src/yolov5n_top.cpp" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
    </files>
    <solutions xmlns="">
        <solution name="solution1" status="active"/>
    </solutions>
</project>

