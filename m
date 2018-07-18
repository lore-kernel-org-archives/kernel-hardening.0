MIME-Version: 1.0
References: <1531935483-30784-1-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1531935483-30784-1-git-send-email-s.mesoraca16@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 18 Jul 2018 22:09:57 +0200
Message-ID: <CAG48ez3PHp_H4SEru8ommgVgedVx2xP2PP86f_BSkE-uiVeFnw@mail.gmail.com>
Subject: Re: [RFC] kconfig: add hardened defconfig helpers
Content-Type: text/plain; charset="UTF-8"
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 18, 2018 at 7:39 PM Salvatore Mesoraca
<s.mesoraca16@gmail.com> wrote:
>
> Adds 4 new defconfig helpers (hardenedlowconfig,
> hardenedmediumconfig, hardenedhighconfig,
> hardenedextremeconfig) to enable various hardening
> features.
> The list of config options to enable is based on
> KSPP's Recommended Settings[1] and on
> kconfig-hardened-check[2], with some modifications.
> These options are divided into 4 levels (low, medium,
> high, extreme) based on their negative side effects, not
> on their usefulness.
> 'Low' level collects all those protections that have
> (almost) no negative side effects.
> 'Extreme' level collects those protections that may have
> some many negative side effects that most people
> wouldn't want to enable them.
> Every feature in each level is briefly documented in
> Documentation/security/hardenedconfig.rst, this file
> also contain a better explanation of what every level
> means.
> To prevent this file from drifting from what the various
> defconfigs actually do, it is used to dynamically
> generate the config fragments.
>
> [1] http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings
> [2] https://github.com/a13xp0p0v/kconfig-hardened-check
>
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
[...]
> +CONFIG_BPF_JIT=n
> +~~~~~~~~~~~~~~~~
> +
> +**Negative side effects level:** High
> +**- Protection type:** Attack surface reduction
> +
> +Berkeley Packet Filter filtering capabilities are normally handled
> +by an interpreter. This option allows kernel to generate a native
> +code when filter is loaded in memory. This should speedup
> +packet sniffing (libpcap/tcpdump).

Not just packet sniffing; also seccomp filters and other things.
To get some concrete numbers on how important the BPF JIT is for
seccomp performance, I ran the following test on a workstation that
also has KPTI enabled (so syscalls are already not as fast as they
used to be):

==========================================
# cat syscall_overhead.c
#define _GNU_SOURCE
#include <string.h>
#include <seccomp.h>
#include <err.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <sched.h>

/* just a bunch of random syscalls for benchmarking.
 * this list isn't supposed to make sense. */
int blacklist[] = {
  SCMP_SYS(acct), /* 163 */
  SCMP_SYS(add_key), /* 248 */
  SCMP_SYS(chroot), /* 161 */
  SCMP_SYS(fanotify_init), /* 300 */
  SCMP_SYS(fanotify_mark), /* 301 */
  SCMP_SYS(finit_module), /* 313 */
  SCMP_SYS(fdatasync), /* 75 */
  SCMP_SYS(fsync), /* 74 */
  SCMP_SYS(flistxattr), /* 196 */
  SCMP_SYS(getsockopt), /* 55 */
  SCMP_SYS(socket), /* 41 */
  SCMP_SYS(getpeername) /* 52 */
};

/* NOTE: libseccomp - or at least the version of it that I have on my machine -
 * generates relatively inefficient filter code - an allowed syscall has to
 * be compared with every blacklist entry separately (time linear in the size of
 * the filter list), instead of the more sensible algorithms Chrome and Android
 * are using (with time logarithmic in the size of the filter list):
 *
 * # ./seccomp_dump 22876 every_insn
 * ===== filter 0 (18 instructions) =====
 * 0000 ld arch
 * 0001 if arch != 0xc000003e: [true +15, false +0]
 * 0011   ret KILL
 * 0002 ld nr
 * 0003 if nr >= 0x40000000: [true +13, false +0]
 * 0011   ret KILL
 * 0004 if nr == 0x00000029: [true +12, false +0]
 * 0011   ret KILL
 * 0005 if nr == 0x00000034: [true +11, false +0]
 * 0011   ret KILL
 * 0006 if nr == 0x00000037: [true +10, false +0]
 * 0011   ret KILL
 * 0007 if nr == 0x0000004a: [true +9, false +0]
 * 0011   ret KILL
 * 0008 if nr == 0x0000004b: [true +8, false +0]
 * 0011   ret KILL
 * 0009 if nr == 0x000000a1: [true +7, false +0]
 * 0011   ret KILL
 * 000a if nr == 0x000000a3: [true +6, false +0]
 * 0011   ret KILL
 * 000b if nr == 0x000000c4: [true +5, false +0]
 * 0011   ret KILL
 * 000c if nr == 0x000000f8: [true +4, false +0]
 * 0011   ret KILL
 * 000d if nr == 0x0000012c: [true +3, false +0]
 * 0011   ret KILL
 * 000e if nr == 0x0000012d: [true +2, false +0]
 * 0011   ret KILL
 * 000f if nr == 0x00000139: [true +1, false +0]
 * 0011   ret KILL
 *
 * This makes the seccomp overhead more measurable than it would have to be for
 * a blacklist of this size.
 *
 * It looks like this issue was already reported as
 * https://github.com/seccomp/libseccomp/issues/116 , but hasn't been fixed yet.
 * */
void seccomp_on(void) {
  scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_ALLOW);
  if (!ctx) err(1, "seccomp_init");
  for (int i = 0; i < sizeof(blacklist)/sizeof(blacklist[0]); i++) {
    if (seccomp_rule_add(ctx, SCMP_ACT_KILL, blacklist[i], 0))
      err(1, "seccomp_rule_add");
  }
  if (seccomp_load(ctx))
    err(1, "seccomp_load");
}

int main(int argc, char **argv) {
  if (argc == 2 && strcmp(argv[1], "filtered") == 0) {
    seccomp_on();
  }

  // get realtime prio to hopefully remove some jitter
  struct sched_param param = { .sched_priority = 50 };
  if (sched_setscheduler(0, SCHED_FIFO, &param))
    err(1, "sched_setscheduler");

  for (int i=0; i<5000000; i++) {
    syscall(__NR_gettid);
  }
  _exit(0);
}
# gcc -o syscall_overhead syscall_overhead.c -lseccomp
# for i in {0..10}; do echo 0 > /proc/sys/net/core/bpf_jit_enable;
/usr/bin/time --format='unfiltered: %e' ./syscall_overhead unfiltered;
/usr/bin/time --format='filtered (no JIT): %e' ./syscall_overhead
filtered; echo 1 > /proc/sys/net/core/bpf_jit_enable; /usr/bin/time
--format='filtered (with JIT): %e' ./syscall_overhead filtered; done
unfiltered: 3.00
filtered (no JIT): 4.23
filtered (with JIT): 3.19
unfiltered: 3.09
filtered (no JIT): 4.21
filtered (with JIT): 3.17
unfiltered: 2.95
filtered (no JIT): 4.19
filtered (with JIT): 3.23
unfiltered: 3.04
filtered (no JIT): 4.19
filtered (with JIT): 3.25
unfiltered: 3.04
filtered (no JIT): 4.35
filtered (with JIT): 3.17
unfiltered: 3.03
filtered (no JIT): 4.29
filtered (with JIT): 3.09
unfiltered: 3.04
filtered (no JIT): 4.21
filtered (with JIT): 3.11
unfiltered: 2.97
filtered (no JIT): 4.28
filtered (with JIT): 3.27
unfiltered: 3.07
filtered (no JIT): 4.20
filtered (with JIT): 3.22
unfiltered: 3.04
filtered (no JIT): 4.33
filtered (with JIT): 3.15
unfiltered: 2.88
filtered (no JIT): 4.37
filtered (with JIT): 3.09
#
==========================================

So with the JIT enabled, the filter increases syscall overhead by
about 4%; but without the JIT, it increases syscall overhead by about
**39%**! This is a microbenchmark, yes, but still. So please don't
claim that the BPF JIT only matters for packet sniffing.

> +Note, admin should enable this feature changing:
> +/proc/sys/net/core/bpf_jit_enable
> +/proc/sys/net/core/bpf_jit_harden   (optional)
> +/proc/sys/net/core/bpf_jit_kallsyms (optional)
[...]
> +CONFIG_THREAD_INFO_IN_TASK=y
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +**Negative side effects level:** Low
> +**- Protection type:** Self-protection
> +
> +Move thread_info off the stack into task_struct.

As far as I understand, this config option can't be set by the user -
it depends on what the architecture-specific code is designed to do.
