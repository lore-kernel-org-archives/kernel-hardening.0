MIME-Version: 1.0
In-Reply-To: <CAG48ez3PHp_H4SEru8ommgVgedVx2xP2PP86f_BSkE-uiVeFnw@mail.gmail.com>
References: <1531935483-30784-1-git-send-email-s.mesoraca16@gmail.com> <CAG48ez3PHp_H4SEru8ommgVgedVx2xP2PP86f_BSkE-uiVeFnw@mail.gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Thu, 19 Jul 2018 12:35:55 +0200
Message-ID: <CAJHCu1KfDp=L8fUTHDagBzC4ezBWWVknRstoscqLT1xw=DVPNQ@mail.gmail.com>
Subject: Re: [RFC] kconfig: add hardened defconfig helpers
Content-Type: text/plain; charset="UTF-8"
To: Jann Horn <jannh@google.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

2018-07-18 22:09 GMT+02:00 Jann Horn <jannh@google.com>:
> On Wed, Jul 18, 2018 at 7:39 PM Salvatore Mesoraca
> <s.mesoraca16@gmail.com> wrote:
>>
>> Adds 4 new defconfig helpers (hardenedlowconfig,
>> hardenedmediumconfig, hardenedhighconfig,
>> hardenedextremeconfig) to enable various hardening
>> features.
>> The list of config options to enable is based on
>> KSPP's Recommended Settings[1] and on
>> kconfig-hardened-check[2], with some modifications.
>> These options are divided into 4 levels (low, medium,
>> high, extreme) based on their negative side effects, not
>> on their usefulness.
>> 'Low' level collects all those protections that have
>> (almost) no negative side effects.
>> 'Extreme' level collects those protections that may have
>> some many negative side effects that most people
>> wouldn't want to enable them.
>> Every feature in each level is briefly documented in
>> Documentation/security/hardenedconfig.rst, this file
>> also contain a better explanation of what every level
>> means.
>> To prevent this file from drifting from what the various
>> defconfigs actually do, it is used to dynamically
>> generate the config fragments.
>>
>> [1] http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings
>> [2] https://github.com/a13xp0p0v/kconfig-hardened-check
>>
>> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> [...]
>> +CONFIG_BPF_JIT=n
>> +~~~~~~~~~~~~~~~~
>> +
>> +**Negative side effects level:** High
>> +**- Protection type:** Attack surface reduction
>> +
>> +Berkeley Packet Filter filtering capabilities are normally handled
>> +by an interpreter. This option allows kernel to generate a native
>> +code when filter is loaded in memory. This should speedup
>> +packet sniffing (libpcap/tcpdump).
>
> Not just packet sniffing; also seccomp filters and other things.
> To get some concrete numbers on how important the BPF JIT is for
> seccomp performance, I ran the following test on a workstation that
> also has KPTI enabled (so syscalls are already not as fast as they
> used to be):
>
snip
> So with the JIT enabled, the filter increases syscall overhead by
> about 4%; but without the JIT, it increases syscall overhead by about
> **39%**! This is a microbenchmark, yes, but still. So please don't
> claim that the BPF JIT only matters for packet sniffing.

Thank you very much for noticing this and for the extensive explanation!
I'll specify the BPF JIT implications for seccomp in the next version.
Honestly, I just copy/pasted that description from the Kconfig help text,
maybe that should be updated too.

>> +Note, admin should enable this feature changing:
>> +/proc/sys/net/core/bpf_jit_enable
>> +/proc/sys/net/core/bpf_jit_harden   (optional)
>> +/proc/sys/net/core/bpf_jit_kallsyms (optional)
> [...]
>> +CONFIG_THREAD_INFO_IN_TASK=y
>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> +
>> +**Negative side effects level:** Low
>> +**- Protection type:** Self-protection
>> +
>> +Move thread_info off the stack into task_struct.
>
> As far as I understand, this config option can't be set by the user -
> it depends on what the architecture-specific code is designed to do.

You are absolutely right, this can be dropped.

Thank you again,

Salvatore
