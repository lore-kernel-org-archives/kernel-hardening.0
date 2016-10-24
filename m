Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+bH3sGMxW0Giav4hsHtNGkmV9Z0DdTKAh5M9L1Bj+nHw@mail.gmail.com>
References: <CAEXv5_jjqZkLEsPY_B6++pf8EeVY=2YkvRJc+rGvEFSaXdRX=A@mail.gmail.com>
 <CAGXu5j+bH3sGMxW0Giav4hsHtNGkmV9Z0DdTKAh5M9L1Bj+nHw@mail.gmail.com>
From: David Windsor <dwindsor@gmail.com>
Date: Mon, 24 Oct 2016 17:04:20 -0400
Message-ID: <CAEXv5_gjsCrY6dGq3tKfArXMvcn65R=Bw8q8Gvo2+qjc75MuSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: HARDENED_ATOMIC benchmarks
To: Kees Cook <keescook@chromium.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 24, 2016 at 4:53 PM, Kees Cook <keescook@chromium.org> wrote:
> On Sat, Oct 22, 2016 at 3:13 PM, David Windsor <dwindsor@gmail.com> wrote:
>> Hi,
>>
>> The following are the results of benchmarking HARDENED_ATOMIC.  The
>> benchmarks performed were dbench and a timed Linux kernel compile using the
>> Phoronix test suite [1] on a Linux VirtualBox guest.
>>
>> dbench was chosen specifically to gauge the performance penalty involved in
>> heavy usage of struct file->f_count, as this is one of the hottest users of
>> atomic_t/atomic_long_t.
>>
>> A small performance degradation was noticeable with HARDENED_ATOMIC enabled.
>> The numbers are such that I'm unsure if this was due to the feature itself
>> or to random line noise.  What follows is a summary of the benchmark
>> results, then the results themselves.
>>
>> [1] http://www.phoronix-test-suite.com/
>>
>> HARDENED_ATOMIC Benchmarking Summary
>> ===================================
>>
>> dbench
>> ======
>> CONFIG_HARDENED_ATOMIC not set: 109.79 MB/s
>> CONFIG_HARDENED_ATOMIC set: 106.75 MB/s
>> 2.8% slowdown
>>
>> Timed Linux kernel compile
>> =====================
>> CONFIG_HARDENED_ATOMIC not set: 504.12 seconds
>> CONFIG_HARDENED_ATOMIC set: 504.81 seconds
>> 0.01% slowdown
>>
>>
>>
>>
>> HARDENED_ATOMIC Benchmark Results
>> ===============================
>>
>> dbench
>> ======
>> HARDENED_ATOMIC disabled:
>> dbenchDbench 4.0:
>>     pts/dbench-1.0.0 [Client Count: 12]
>>     Test 1 of 1
>>     Estimated Trial Run Count:    3
>>     Estimated Time To Completion: 1 Hour, 25 Minutes
>>         Started Run 1 @ 08:48:01
>>         Started Run 2 @ 09:00:04
>>         Started Run 3 @ 09:12:07  [Std. Dev: 1.39%]
>>
>>     Test Results:
>>         109.613
>>         108.351
>>         111.393
>>
>>     Average: 109.79 MB/s
>>
>>
>> HARDENED_ATOMIC enabled:
>> Dbench 4.0:
>>     pts/dbench-1.0.0 [Client Count: 12]
>>     Test 1 of 1
>>     Estimated Trial Run Count:    3
>>     Estimated Time To Completion: 1 Hour, 28 Minutes
>>         Started Run 1 @ 06:48:33
>>         Started Run 2 @ 07:00:37
>>         Started Run 3 @ 07:12:40  [Std. Dev: 12.66%]
>>         Started Run 4 @ 07:24:43  [Std. Dev: 10.94%]
>>         Started Run 5 @ 07:36:46  [Std. Dev: 9.98%]
>>         Started Run 6 @ 07:48:50  [Std. Dev: 9.30%]
>>
>>     Test Results:
>>         87.0504
>>         106.451
>>         111.377
>>         110.239
>>         112.226
>>         113.152
>>
>>     Average: 106.75 MB/s
>
> Variation here is as large as the measured difference, so yeah, this
> looks like it's mostly in the noise.
>
>> Timed Linux Kernel Compile
>> ======================
>> HARDENED_ATOMIC disabled:
>> Timed Linux Kernel Compilation 4.3:
>>     pts/build-linux-kernel-1.6.0
>>     Test 4 of 4
>>     Estimated Trial Run Count:    3
>>     Estimated Time To Completion: 55 Minutes
>>     Estimated Trial Run Count:    3
>>     Estimated Time To Completion: 55 Minutes
>>         Running Pre-Test Script @ 02:39:33
>>         Started Run 1 @ 02:40:06
>>         Running Interim Test Script @ 02:48:39
>>         Started Run 2 @ 02:48:45
>>         Running Interim Test Script @ 02:57:07
>>         Started Run 3 @ 02:57:14  [Std. Dev: 0.84%]
>>         Running Post-Test Script @ 03:05:35
>>
>>     Test Results:
>>         509.00912308693
>>         501.88456201553
>>         501.46281981468
>>
>>     Average: 504.12 Seconds
>>
>>
>> HARDENED_ATOMIC enabled:
>> Timed Linux Kernel Compilation 4.3:
>>     pts/build-linux-kernel-1.6.0
>>     Test 4 of 4
>>     Estimated Trial Run Count:    3
>>     Estimated Time To Completion: 45 Minutes
>>         Running Pre-Test Script @ 05:26:55
>>         Started Run 1 @ 05:27:30
>>         Running Interim Test Script @ 05:36:01
>>         Started Run 2 @ 05:36:08
>>         Running Interim Test Script @ 05:44:32
>>         Started Run 3 @ 05:44:38  [Std. Dev: 0.36%]
>>         Running Post-Test Script @ 05:53:02
>>
>>     Test Results:
>>         506.84527802467
>>         504.29637002945
>>         503.30119299889
>>
>>     Average: 504.81 Seconds
>
> These have much smaller std deviations.
>
> Thanks for the testing! The cover letter can likely get updated to
> include the overview: no meaningfully measurable performance
> difference. :)
>

Ok, that sounds good.  Although, Jann Horn and I worked together to
come up with a better benchmark that directly targets the
file_get->atomic_add path, which is one of the hottest paths to be
impacted by HARDENED_ATOMIC.

I'm running those benchmarks now; they should be finished in a few hours.

Here is the code for the benchmark.  I'll post this code on my
personal site and link to it from the kernsec.org page we use to
document the feature, when I get around to writing documentation:

/*
 * atomicbench.c: test the effects of HARDENED_ATOMIC on thread creation
 * David Windsor <dave@progbits.org>
 *
 * Note: increase the NOFILE rlimit to 50000 before running this program.
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <sched.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>
#include <err.h>

#define STACK_SIZE 4096
#define NUM_CLONES 0x00010000
#define MAX_OPEN_FILES 50000
#define NUM_OPEN_FILES MAX_OPEN_FILES - 10000

int fd;

static int justexit(void *foo) {
    /* Decrement struct file->f_count NUM_OPEN_FILES times */
    _exit(0);
}

static void *cloner(void *foo) {
    int i, flags;
    pid_t pid;
    char *stack, *top;

    /* Everything but CLONE_FILES */
    flags = CLONE_VM|CLONE_FS|CLONE_IO|CLONE_SIGHAND|CLONE_SYSVSEM|SIGCHLD;

    for (i = 0; i < NUM_CLONES; i++) {
        stack = malloc(STACK_SIZE);
        if (!stack) {
            err(1, "malloc");
        }
        top = stack + STACK_SIZE;
        /* Increment struct file->f_count NUM_OPEN_FILES times */
        pid = clone(justexit, (void *)top, flags, NULL);
        if (pid == -1) {
            err(1, "clone");
        }
        if (waitpid(pid, NULL, 0) == -1) {
            err(1, "waitpid");
        }
    }

    return NULL;
}

int main()
{
    int i;
    pthread_t thread_a, thread_b;

    fd = open("/dev/null", O_RDWR);
    if (fd < 0) {
        err(1, "open");
    }

    /* Fill up fd table */
    for (i = 0; i < NUM_OPEN_FILES; i++) {
        if (dup(fd) < 0) {
            err(1, "dup");
        }
    }

    if (pthread_create(&thread_a, NULL, cloner, NULL)) {
        errx(1, "Error: pthread_create");
    }
    if (pthread_create(&thread_b, NULL, cloner, NULL)) {
        errx(1, "Error: pthread_create");
    }
    pthread_join(thread_a, NULL);
    pthread_join(thread_b, NULL);

    return 0;
}


> -Kees
>
> --
> Kees Cook
> Nexus Security
