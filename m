Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEXv5_jjqZkLEsPY_B6++pf8EeVY=2YkvRJc+rGvEFSaXdRX=A@mail.gmail.com>
References: <CAEXv5_jjqZkLEsPY_B6++pf8EeVY=2YkvRJc+rGvEFSaXdRX=A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Oct 2016 13:53:01 -0700
Message-ID: <CAGXu5j+bH3sGMxW0Giav4hsHtNGkmV9Z0DdTKAh5M9L1Bj+nHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: HARDENED_ATOMIC benchmarks
To: David Windsor <dwindsor@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Oct 22, 2016 at 3:13 PM, David Windsor <dwindsor@gmail.com> wrote:
> Hi,
>
> The following are the results of benchmarking HARDENED_ATOMIC.  The
> benchmarks performed were dbench and a timed Linux kernel compile using the
> Phoronix test suite [1] on a Linux VirtualBox guest.
>
> dbench was chosen specifically to gauge the performance penalty involved in
> heavy usage of struct file->f_count, as this is one of the hottest users of
> atomic_t/atomic_long_t.
>
> A small performance degradation was noticeable with HARDENED_ATOMIC enabled.
> The numbers are such that I'm unsure if this was due to the feature itself
> or to random line noise.  What follows is a summary of the benchmark
> results, then the results themselves.
>
> [1] http://www.phoronix-test-suite.com/
>
> HARDENED_ATOMIC Benchmarking Summary
> ===================================
>
> dbench
> ======
> CONFIG_HARDENED_ATOMIC not set: 109.79 MB/s
> CONFIG_HARDENED_ATOMIC set: 106.75 MB/s
> 2.8% slowdown
>
> Timed Linux kernel compile
> =====================
> CONFIG_HARDENED_ATOMIC not set: 504.12 seconds
> CONFIG_HARDENED_ATOMIC set: 504.81 seconds
> 0.01% slowdown
>
>
>
>
> HARDENED_ATOMIC Benchmark Results
> ===============================
>
> dbench
> ======
> HARDENED_ATOMIC disabled:
> dbenchDbench 4.0:
>     pts/dbench-1.0.0 [Client Count: 12]
>     Test 1 of 1
>     Estimated Trial Run Count:    3
>     Estimated Time To Completion: 1 Hour, 25 Minutes
>         Started Run 1 @ 08:48:01
>         Started Run 2 @ 09:00:04
>         Started Run 3 @ 09:12:07  [Std. Dev: 1.39%]
>
>     Test Results:
>         109.613
>         108.351
>         111.393
>
>     Average: 109.79 MB/s
>
>
> HARDENED_ATOMIC enabled:
> Dbench 4.0:
>     pts/dbench-1.0.0 [Client Count: 12]
>     Test 1 of 1
>     Estimated Trial Run Count:    3
>     Estimated Time To Completion: 1 Hour, 28 Minutes
>         Started Run 1 @ 06:48:33
>         Started Run 2 @ 07:00:37
>         Started Run 3 @ 07:12:40  [Std. Dev: 12.66%]
>         Started Run 4 @ 07:24:43  [Std. Dev: 10.94%]
>         Started Run 5 @ 07:36:46  [Std. Dev: 9.98%]
>         Started Run 6 @ 07:48:50  [Std. Dev: 9.30%]
>
>     Test Results:
>         87.0504
>         106.451
>         111.377
>         110.239
>         112.226
>         113.152
>
>     Average: 106.75 MB/s

Variation here is as large as the measured difference, so yeah, this
looks like it's mostly in the noise.

> Timed Linux Kernel Compile
> ======================
> HARDENED_ATOMIC disabled:
> Timed Linux Kernel Compilation 4.3:
>     pts/build-linux-kernel-1.6.0
>     Test 4 of 4
>     Estimated Trial Run Count:    3
>     Estimated Time To Completion: 55 Minutes
>     Estimated Trial Run Count:    3
>     Estimated Time To Completion: 55 Minutes
>         Running Pre-Test Script @ 02:39:33
>         Started Run 1 @ 02:40:06
>         Running Interim Test Script @ 02:48:39
>         Started Run 2 @ 02:48:45
>         Running Interim Test Script @ 02:57:07
>         Started Run 3 @ 02:57:14  [Std. Dev: 0.84%]
>         Running Post-Test Script @ 03:05:35
>
>     Test Results:
>         509.00912308693
>         501.88456201553
>         501.46281981468
>
>     Average: 504.12 Seconds
>
>
> HARDENED_ATOMIC enabled:
> Timed Linux Kernel Compilation 4.3:
>     pts/build-linux-kernel-1.6.0
>     Test 4 of 4
>     Estimated Trial Run Count:    3
>     Estimated Time To Completion: 45 Minutes
>         Running Pre-Test Script @ 05:26:55
>         Started Run 1 @ 05:27:30
>         Running Interim Test Script @ 05:36:01
>         Started Run 2 @ 05:36:08
>         Running Interim Test Script @ 05:44:32
>         Started Run 3 @ 05:44:38  [Std. Dev: 0.36%]
>         Running Post-Test Script @ 05:53:02
>
>     Test Results:
>         506.84527802467
>         504.29637002945
>         503.30119299889
>
>     Average: 504.81 Seconds

These have much smaller std deviations.

Thanks for the testing! The cover letter can likely get updated to
include the overview: no meaningfully measurable performance
difference. :)

-Kees

-- 
Kees Cook
Nexus Security
