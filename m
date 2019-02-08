Date: Fri, 8 Feb 2019 14:05:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Message-ID: <20190208130544.GI32511@hirez.programming.kicks-ass.net>
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: kernel-hardening@lists.openwall.com, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, keescook@chromium.org, tytso@mit.edu
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 08, 2019 at 02:15:49PM +0200, Elena Reshetova wrote:
> 1) hackbench -s 4096 -l 2000 -g 15 -f 25 -P
>     base:           Time: 12.243
>     random_offset:  Time: 13.411

>     base:
>      8.46%  time     [kernel.kallsyms]  [k] crc32c_pcl_intel_update
>      4.77%  time     [kernel.kallsyms]  [k] ext4_mark_iloc_dirty
>      4.14%  time     [kernel.kallsyms]  [k] fsnotify
> 
>     random_offset:
>      8.35%  time     [kernel.kallsyms]  [k] crc32c_pcl_intel_update
>      5.61%  time     [kernel.kallsyms]  [k] get_random_u64
>      4.88%  time     [kernel.kallsyms]  [k] ext4_mark_iloc_dirty

*ouch*

>   Notable differences from RANDKSTACK:

>   - random bits are taken from get_random_long() instead of
>     rdtsc() for a better randomness. This however has a big
>     performance impact (see above the numbers) and additionally
>     if we happen to hit a point when a generator needs to be
>     reseeded, we might have an issue. Alternatives can be to
>     make this feature dependent on CONFIG_RANDOM_TRUST_CPU,
>     which can solve some issues, but I doubt that all of them.
>     Of course rdtsc() can be a fallback if there is no way to
>     make calls for a proper randomness from the trampoline stack.

http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html

That would seem to suggest that the low bits of rdtsc would in fact be a
fairly good source of random.

Still, doing this on sysexit seems painful at best, syscall performance
matters (and hopefully we'll get rid of meltdown 'soon').

Why can't we change the stack offset periodically from an interrupt or
so, and then have every later entry use that.
