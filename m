Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: David Windsor <dwindsor@gmail.com>
Date: Sat, 22 Oct 2016 18:13:29 -0400
Message-ID: <CAEXv5_jjqZkLEsPY_B6++pf8EeVY=2YkvRJc+rGvEFSaXdRX=A@mail.gmail.com>
Content-Type: multipart/alternative; boundary=94eb2c11657efacf12053f7b7714
Subject: [kernel-hardening] HARDENED_ATOMIC benchmarks
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

--94eb2c11657efacf12053f7b7714
Content-Type: text/plain; charset=UTF-8

Hi,

The following are the results of benchmarking HARDENED_ATOMIC.  The
benchmarks performed were dbench and a timed Linux kernel compile using the
Phoronix test suite [1] on a Linux VirtualBox guest.

dbench was chosen specifically to gauge the performance penalty involved in
heavy usage of struct file->f_count, as this is one of the hottest users of
atomic_t/atomic_long_t.

A small performance degradation was noticeable with HARDENED_ATOMIC
enabled.  The numbers are such that I'm unsure if this was due to the
feature itself or to random line noise.  What follows is a summary of the
benchmark results, then the results themselves.

[1] http://www.phoronix-test-suite.com/

HARDENED_ATOMIC Benchmarking Summary
===================================

dbench
======
CONFIG_HARDENED_ATOMIC not set: 109.79 MB/s
CONFIG_HARDENED_ATOMIC set: 106.75 MB/s
2.8% slowdown


Timed Linux kernel compile
=====================
CONFIG_HARDENED_ATOMIC not set: 504.12 seconds
CONFIG_HARDENED_ATOMIC set: 504.81 seconds
0.01% slowdown




HARDENED_ATOMIC Benchmark Results
===============================

dbench
======
HARDENED_ATOMIC disabled:
dbenchDbench 4.0:
    pts/dbench-1.0.0 [Client Count: 12]
    Test 1 of 1
    Estimated Trial Run Count:    3
    Estimated Time To Completion: 1 Hour, 25 Minutes
        Started Run 1 @ 08:48:01
        Started Run 2 @ 09:00:04
        Started Run 3 @ 09:12:07  [Std. Dev: 1.39%]

    Test Results:
        109.613
        108.351
        111.393

    Average: 109.79 MB/s


HARDENED_ATOMIC enabled:
Dbench 4.0:
    pts/dbench-1.0.0 [Client Count: 12]
    Test 1 of 1
    Estimated Trial Run Count:    3
    Estimated Time To Completion: 1 Hour, 28 Minutes
        Started Run 1 @ 06:48:33
        Started Run 2 @ 07:00:37
        Started Run 3 @ 07:12:40  [Std. Dev: 12.66%]
        Started Run 4 @ 07:24:43  [Std. Dev: 10.94%]
        Started Run 5 @ 07:36:46  [Std. Dev: 9.98%]
        Started Run 6 @ 07:48:50  [Std. Dev: 9.30%]

    Test Results:
        87.0504
        106.451
        111.377
        110.239
        112.226
        113.152

    Average: 106.75 MB/s


Timed Linux Kernel Compile
======================
HARDENED_ATOMIC disabled:
Timed Linux Kernel Compilation 4.3:
    pts/build-linux-kernel-1.6.0
    Test 4 of 4
    Estimated Trial Run Count:    3
    Estimated Time To Completion: 55 Minutes
    Estimated Trial Run Count:    3
    Estimated Time To Completion: 55 Minutes
        Running Pre-Test Script @ 02:39:33
        Started Run 1 @ 02:40:06
        Running Interim Test Script @ 02:48:39
        Started Run 2 @ 02:48:45
        Running Interim Test Script @ 02:57:07
        Started Run 3 @ 02:57:14  [Std. Dev: 0.84%]
        Running Post-Test Script @ 03:05:35

    Test Results:
        509.00912308693
        501.88456201553
        501.46281981468

    Average: 504.12 Seconds


HARDENED_ATOMIC enabled:
Timed Linux Kernel Compilation 4.3:
    pts/build-linux-kernel-1.6.0
    Test 4 of 4
    Estimated Trial Run Count:    3
    Estimated Time To Completion: 45 Minutes
        Running Pre-Test Script @ 05:26:55
        Started Run 1 @ 05:27:30
        Running Interim Test Script @ 05:36:01
        Started Run 2 @ 05:36:08
        Running Interim Test Script @ 05:44:32
        Started Run 3 @ 05:44:38  [Std. Dev: 0.36%]
        Running Post-Test Script @ 05:53:02

    Test Results:
        506.84527802467
        504.29637002945
        503.30119299889

    Average: 504.81 Seconds

--94eb2c11657efacf12053f7b7714
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>The following are the results of benchmarking H=
ARDENED_ATOMIC.=C2=A0 The benchmarks performed were dbench and a timed Linu=
x kernel compile using the Phoronix test suite [1] on a Linux VirtualBox gu=
est. <br><br>dbench was chosen specifically to gauge the performance penalt=
y involved in heavy usage of struct file-&gt;f_count, as this is one of the=
 hottest users of atomic_t/atomic_long_t.=C2=A0 <br><br>A small performance=
 degradation was noticeable with HARDENED_ATOMIC enabled.=C2=A0 The numbers=
 are such that I&#39;m unsure if this was due to the feature itself or to r=
andom line noise.=C2=A0 What follows is a summary of the benchmark results,=
 then the results themselves.<br><br>[1] <a href=3D"http://www.phoronix-tes=
t-suite.com/">http://www.phoronix-test-suite.com/</a><br><br>HARDENED_ATOMI=
C Benchmarking Summary<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br><br>dbench<br>=
=3D=3D=3D=3D=3D=3D<br>CONFIG_HARDENED_ATOMIC not set: 109.79 MB/s<br>CONFIG=
_HARDENED_ATOMIC set: 106.75 MB/s<br>2.8% slowdown<br><br><br>Timed Linux k=
ernel compile<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D<br>CONFIG_HARDENED_ATOMIC not set: 504.12 seconds<br>CONFIG_HARDENED=
_ATOMIC set: 504.81 seconds<br>0.01% slowdown<br><br><br><br><br>HARDENED_A=
TOMIC Benchmark Results<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br><br>dbench<br>=3D=3D=3D=3D=
=3D=3D<br>HARDENED_ATOMIC disabled:<br>dbenchDbench 4.0:<br>=C2=A0 =C2=A0 p=
ts/dbench-1.0.0 [Client Count: 12]<br>=C2=A0 =C2=A0 Test 1 of 1<br>=C2=A0 =
=C2=A0 Estimated Trial Run Count: =C2=A0 =C2=A03<br>=C2=A0 =C2=A0 Estimated=
 Time To Completion: 1 Hour, 25 Minutes<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Star=
ted Run 1 @ 08:48:01<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Started Run 2 @ 09:00:0=
4<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Started Run 3 @ 09:12:07 =C2=A0[Std. Dev: =
1.39%]<br><br>=C2=A0 =C2=A0 Test Results:<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 10=
9.613<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 108.351<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 111.393<br><br>=C2=A0 =C2=A0 Average: 109.79 MB/s<br><br><br>HARDENED_ATOM=
IC enabled:<br>Dbench 4.0:<br>=C2=A0 =C2=A0 pts/dbench-1.0.0 [Client Count:=
 12]<br>=C2=A0 =C2=A0 Test 1 of 1<br>=C2=A0 =C2=A0 Estimated Trial Run Coun=
t: =C2=A0 =C2=A03<br>=C2=A0 =C2=A0 Estimated Time To Completion: 1 Hour, 28=
 Minutes<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Started Run 1 @ 06:48:33<br>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 Started Run 2 @ 07:00:37<br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 Started Run 3 @ 07:12:40 =C2=A0[Std. Dev: 12.66%]<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Started Run 4 @ 07:24:43 =C2=A0[Std. Dev: 10.94%]<br>=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 Started Run 5 @ 07:36:46 =C2=A0[Std. Dev: 9.98%]<br>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 Started Run 6 @ 07:48:50 =C2=A0[Std. Dev: 9.30%]<b=
r><br>=C2=A0 =C2=A0 Test Results:<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 87.0504<br=
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 106.451<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 111.377=
<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 110.239<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 112.=
226<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 113.152<br><br>=C2=A0 =C2=A0 Average: 10=
6.75 MB/s<br><br><br>Timed Linux Kernel Compile<br>=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>HARDENED_ATOMIC disabled:<br>=
Timed Linux Kernel Compilation 4.3:<br>=C2=A0 =C2=A0 pts/build-linux-kernel=
-1.6.0<br>=C2=A0 =C2=A0 Test 4 of 4<br>=C2=A0 =C2=A0 Estimated Trial Run Co=
unt: =C2=A0 =C2=A03<br>=C2=A0 =C2=A0 Estimated Time To Completion: 55 Minut=
es<br>=C2=A0 =C2=A0 Estimated Trial Run Count: =C2=A0 =C2=A03<br>=C2=A0 =C2=
=A0 Estimated Time To Completion: 55 Minutes<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 Running Pre-Test Script @ 02:39:33<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Started =
Run 1 @ 02:40:06<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Running Interim Test Script=
 @ 02:48:39<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Started Run 2 @ 02:48:45<br>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 Running Interim Test Script @ 02:57:07<br>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 Started Run 3 @ 02:57:14 =C2=A0[Std. Dev: 0.84%]<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Running Post-Test Script @ 03:05:35<br><br>=C2=
=A0 =C2=A0 Test Results:<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 509.00912308693<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 501.88456201553<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
501.46281981468<br><br>=C2=A0 =C2=A0 Average: 504.12 Seconds<br><br><br>HAR=
DENED_ATOMIC enabled:<br>Timed Linux Kernel Compilation 4.3:<br>=C2=A0 =C2=
=A0 pts/build-linux-kernel-1.6.0<br>=C2=A0 =C2=A0 Test 4 of 4<br>=C2=A0 =C2=
=A0 Estimated Trial Run Count: =C2=A0 =C2=A03<br>=C2=A0 =C2=A0 Estimated Ti=
me To Completion: 45 Minutes<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Running Pre-Tes=
t Script @ 05:26:55<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Started Run 1 @ 05:27:30=
<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Running Interim Test Script @ 05:36:01<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Started Run 2 @ 05:36:08<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Running Interim Test Script @ 05:44:32<br>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 Started Run 3 @ 05:44:38 =C2=A0[Std. Dev: 0.36%]<br>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 Running Post-Test Script @ 05:53:02<br><br>=C2=A0 =C2=A0 Test=
 Results:<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 506.84527802467<br>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 504.29637002945<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 503.3011929988=
9<br><br>=C2=A0 =C2=A0 Average: 504.81 Seconds<br></div>

--94eb2c11657efacf12053f7b7714--
