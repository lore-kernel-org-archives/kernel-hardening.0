MIME-Version: 1.0
In-Reply-To: <20170816151235.oamkdva6cwpc4cex@gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com> <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 16 Aug 2017 09:57:58 -0700
Message-ID: <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: x86: PIE support and option to extend KASLR randomization
To: Ingo Molnar <mingo@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org, kvm list <kvm@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-sparse@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 16, 2017 at 8:12 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
> > On Tue, Aug 15, 2017 at 12:56 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > >
> > > * Thomas Garnier <thgarnie@google.com> wrote:
> > >
> > >> > Do these changes get us closer to being able to build the kernel as truly
> > >> > position independent, i.e. to place it anywhere in the valid x86-64 address
> > >> > space? Or any other advantages?
> > >>
> > >> Yes, PIE allows us to put the kernel anywhere in memory. It will allow us to
> > >> have a full randomized address space where position and order of sections are
> > >> completely random. There is still some work to get there but being able to build
> > >> a PIE kernel is a significant step.
> > >
> > > So I _really_ dislike the whole PIE approach, because of the huge slowdown:
> > >
> > > +config RANDOMIZE_BASE_LARGE
> > > +       bool "Increase the randomization range of the kernel image"
> > > +       depends on X86_64 && RANDOMIZE_BASE
> > > +       select X86_PIE
> > > +       select X86_MODULE_PLTS if MODULES
> > > +       default n
> > > +       ---help---
> > > +         Build the kernel as a Position Independent Executable (PIE) and
> > > +         increase the available randomization range from 1GB to 3GB.
> > > +
> > > +         This option impacts performance on kernel CPU intensive workloads up
> > > +         to 10% due to PIE generated code. Impact on user-mode processes and
> > > +         typical usage would be significantly less (0.50% when you build the
> > > +         kernel).
> > > +
> > > +         The kernel and modules will generate slightly more assembly (1 to 2%
> > > +         increase on the .text sections). The vmlinux binary will be
> > > +         significantly smaller due to less relocations.
> > >
> > > To put 10% kernel overhead into perspective: enabling this option wipes out about
> > > 5-10 years worth of painstaking optimizations we've done to keep the kernel fast
> > > ... (!!)
> >
> > Note that 10% is the high-bound of a CPU intensive workload.
>
> Note that the 8-10% hackbench or even a 2%-4% range would be 'huge' in terms of
> modern kernel performance. In many cases we are literally applying cycle level
> optimizations that are barely measurable. A 0.1% speedup in linear execution speed
> is already a big success.
>
> > I am going to start doing performance testing on -mcmodel=large to see if it is
> > faster than -fPIE.
>
> Unfortunately mcmodel=large looks pretty heavy too AFAICS, at the machine
> instruction level.
>
> Function calls look like this:
>
>  -mcmodel=medium:
>
>    757:   e8 98 ff ff ff          callq  6f4 <test_code>
>
>  -mcmodel=large
>
>    77b:   48 b8 10 f7 df ff ff    movabs $0xffffffffffdff710,%rax
>    782:   ff ff ff
>    785:   48 8d 04 03             lea    (%rbx,%rax,1),%rax
>    789:   ff d0                   callq  *%rax
>
> And we'd do this for _EVERY_ function call in the kernel. That kind of crap is
> totally unacceptable.
>

I started looking into mcmodel=large and ran into multiple issues. In
the meantime, i thought I would
try difference configurations and compilers.

I did 10 hackbench runs accross 10 reboots with and without pie (same
commit) with gcc 4.9. I copied
the result below and based on the hackbench configuration we are
between -0.29% and 1.92% (average
across is 0.8%) which seems more aligned with what people discussed in
this thread.

I don't know how I got 10% maximum on hackbench, I am still
investigating. It could be the configuration
I used or my base compiler being too old.

> > > I think the fundamental flaw is the assumption that we need a PIE executable
> > > to have a freely relocatable kernel on 64-bit CPUs.
> > >
> > > Have you considered a kernel with -mcmodel=small (or medium) instead of -fpie
> > > -mcmodel=large? We can pick a random 2GB window in the (non-kernel) canonical
> > > x86-64 address space to randomize the location of kernel text. The location of
> > > modules can be further randomized within that 2GB window.
> >
> > -model=small/medium assume you are on the low 32-bit. It generates instructions
> > where the virtual addresses have the high 32-bit to be zero.
>
> How are these assumptions hardcoded by GCC? Most of the instructions should be
> relocatable straight away, as most call/jump/branch instructions are RIP-relative.

I think PIE is capable to use relative instructions well.
mcmodel=large assumes symbols can be anywhere.

>
> I.e. is there no GCC code generation mode where code can be placed anywhere in the
> canonical address space, yet call and jump distance is within 31 bits so that the
> generated code is fast?

I think that's basically PIE. With PIE, you have the assumption
everything is close, the main issue is any assembly referencing
absolute addresses.

>
> Thanks,
>
>         Ingo

process-pipe-1600 ------
         baseline_samecommit     pie  % diff
0                     16.985  16.999   0.082
1                     17.065  17.071   0.033
2                     17.188  17.130  -0.342
3                     17.148  17.107  -0.240
4                     17.217  17.170  -0.275
5                     17.216  17.145  -0.415
6                     17.161  17.109  -0.304
7                     17.202  17.122  -0.465
8                     17.169  17.173   0.024
9                     17.217  17.178  -0.227
average               17.157  17.120  -0.213
median                17.169  17.122  -0.271
min                   16.985  16.999   0.082
max                   17.217  17.178  -0.228

[14 rows x 3 columns]
threads-pipe-1600 ------
         baseline_samecommit     pie  % diff
0                     17.914  18.041   0.707
1                     18.337  18.352   0.083
2                     18.233  18.457   1.225
3                     18.334  18.402   0.366
4                     18.381  18.369  -0.066
5                     18.370  18.408   0.207
6                     18.337  18.400   0.345
7                     18.368  18.372   0.020
8                     18.328  18.588   1.421
9                     18.369  18.344  -0.138
average               18.297  18.373   0.415
median                18.337  18.373   0.200
min                   17.914  18.041   0.707
max                   18.381  18.588   1.126

[14 rows x 3 columns]
threads-pipe-50 ------
         baseline_samecommit     pie  % diff
0                     23.491  22.794  -2.965
1                     23.219  23.542   1.387
2                     22.886  23.638   3.286
3                     23.233  23.778   2.343
4                     23.228  23.703   2.046
5                     23.000  23.376   1.636
6                     23.589  23.335  -1.079
7                     23.043  23.543   2.169
8                     23.117  23.350   1.007
9                     23.059  23.420   1.564
average               23.187  23.448   1.127
median                23.187  23.448   1.127
min                   22.886  22.794  -0.399
max                   23.589  23.778   0.800

[14 rows x 3 columns]
process-socket-50 ------
         baseline_samecommit     pie  % diff
0                     20.333  20.430   0.479
1                     20.198  20.371   0.856
2                     20.494  20.737   1.185
3                     20.445  21.264   4.008
4                     20.530  20.911   1.854
5                     20.281  20.487   1.015
6                     20.311  20.871   2.757
7                     20.472  20.890   2.044
8                     20.568  20.422  -0.710
9                     20.415  20.647   1.134
average               20.405  20.703   1.462
median                20.415  20.703   1.410
min                   20.198  20.371   0.856
max                   20.568  21.264   3.385

[14 rows x 3 columns]
process-pipe-50 ------
         baseline_samecommit     pie  % diff
0                     20.131  20.643   2.541
1                     20.184  20.658   2.349
2                     20.359  20.907   2.693
3                     20.365  21.284   4.514
4                     20.506  20.578   0.352
5                     20.393  20.599   1.010
6                     20.245  20.515   1.331
7                     20.627  20.964   1.636
8                     20.519  20.862   1.670
9                     20.505  20.741   1.150
average               20.383  20.775   1.922
median                20.383  20.741   1.753
min                   20.131  20.515   1.907
max                   20.627  21.284   3.186

[14 rows x 3 columns]
threads-socket-50 ------
         baseline_samecommit     pie  % diff
0                     23.197  23.728   2.286
1                     23.304  23.585   1.205
2                     23.098  23.379   1.217
3                     23.028  23.787   3.295
4                     23.242  23.122  -0.517
5                     23.036  23.512   2.068
6                     23.139  23.258   0.512
7                     22.801  23.458   2.881
8                     23.319  23.276  -0.187
9                     22.989  23.577   2.557
average               23.115  23.468   1.526
median                23.115  23.468   1.526
min                   22.801  23.122   1.407
max                   23.319  23.787   2.006

[14 rows x 3 columns]
process-socket-1600 ------
         baseline_samecommit     pie  % diff
0                     17.214  17.168  -0.262
1                     17.172  17.195   0.135
2                     17.278  17.137  -0.817
3                     17.173  17.102  -0.414
4                     17.211  17.153  -0.335
5                     17.220  17.160  -0.345
6                     17.224  17.161  -0.365
7                     17.224  17.224  -0.004
8                     17.176  17.135  -0.236
9                     17.242  17.188  -0.311
average               17.213  17.162  -0.296
median                17.214  17.161  -0.306
min                   17.172  17.102  -0.405
max                   17.278  17.224  -0.315

[14 rows x 3 columns]
threads-socket-1600 ------
         baseline_samecommit     pie  % diff
0                     18.395  18.389  -0.031
1                     18.459  18.404  -0.296
2                     18.427  18.445   0.096
3                     18.449  18.421  -0.150
4                     18.416  18.411  -0.026
5                     18.409  18.443   0.185
6                     18.325  18.308  -0.092
7                     18.491  18.317  -0.940
8                     18.496  18.375  -0.656
9                     18.436  18.385  -0.279
average               18.430  18.390  -0.219
median                18.430  18.390  -0.219
min                   18.325  18.308  -0.092
max                   18.496  18.445  -0.278

[14 rows x 3 columns]
Total stats ======
         baseline_samecommit     pie  % diff
average               19.773  19.930   0.791
median                19.773  19.930   0.791
min                   16.985  16.999   0.082
max                   23.589  23.787   0.839

[4 rows x 3 columns]

-- 
Thomas
