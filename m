Sender: Hans Liljestrand <ishkamiel@gmail.com>
Date: Wed, 26 Jul 2017 12:15:20 +0300
From: Hans Liljestrand <liljestrandh@gmail.com>
Message-ID: <20170726091520.hqhyx2rxda3ir5su@ishxps>
References: <20170724133824.27223-1-LiljestrandH@gmail.com>
 <20170724133824.27223-4-LiljestrandH@gmail.com>
 <CAGXu5jKLFoF584WMYG2CEaON-RSV6TjEzVJtvbuT1ahs0ER6cw@mail.gmail.com>
 <20170725075217.bfwp7slacegqcv7g@ishxps>
 <CAGXu5jKNnGvgWQKTDj7bjYN3vkppweTe8mZhY9PgDtakUTn5Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5jKNnGvgWQKTDj7bjYN3vkppweTe8mZhY9PgDtakUTn5Xw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC PATCH 3/5] x86: add mpxk-wrappers
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 25, 2017 at 11:22:02AM -0700, Kees Cook wrote:
>On Tue, Jul 25, 2017 at 12:52 AM, Hans Liljestrand
><liljestrandh@gmail.com> wrote:
>> Do you mean the FORTIFY_SOURCE thing (could not find anything directly on
>> CONFIG_FORTIFY). Based on a quick look FORTIFY_SOURCE is localized, and
>> essentially just provides the equivalent os our "wrappers", but I could be
>> wildly off?
>
>Yup, I mean this:
>
>https://git.kernel.org/linus/6974f0c4555e285ab217cee58b6e874f776ff409

Okay, thanks!

>
>> MPXK on the other hand also checks other pointer dereferences and propagates
>> pointer bounds into non-wrapper functions. The wrappers themselves also do
>> not load any bounds, instead the calling function passes in the pointer
>> bounds via the bound registers (although the caller might, depending on the
>> situation have loaded the bounds based on the kmalloc allocation).
>
>What are the code patterns that MPXK protects? It sounds like I'm not
>quite seeing what MPXK provides beyond the CONFIG_FORTIFY_SOURCE
>checks (both need to know the bounds already...)

>From what I can tell FORTIFY needs to know the during compile time and is only 
applied on specific function. This is not the case with MPXK, which works more 
like KASAN in that it enforces runtime bounds for any pointer access.

As a concrete example of the runtime instrumentation:

noinline void try_write(char *ptr, int i)
{
	ptr[i] = '\0';
}

becomes (where the bnd0 is set by the caller along with function args):

0000000000000000 <try_write>:
   0:	e8 00 00 00 00       	callq  5 <try_write+0x5>
   5:	4c 8d 54 24 08       	lea    0x8(%rsp),%r10
   a:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
   e:	48 63 f6             	movslq %esi,%rsi
  11:	48 01 f7             	add    %rsi,%rdi
  14:	41 ff 72 f8          	pushq  -0x8(%r10)
  18:	55                   	push   %rbp
  19:	48 89 e5             	mov    %rsp,%rbp
  1c:	41 52                	push   %r10
  1e:	48 83 ec 08          	sub    $0x8,%rsp
  22:	f3 0f 1a 07          	bndcl  (%rdi),%bnd0	# <- bound checks
  26:	f2 0f 1a 07          	bndcu  (%rdi),%bnd0	# <- bound checks
  2a:	c6 07 00             	movb   $0x0,(%rdi)
  2d:	48 83 c4 08          	add    $0x8,%rsp
  31:	41 5a                	pop    %r10
  33:	5d                   	pop    %rbp
  34:	49 8d 62 f8          	lea    -0x8(%r10),%rsp
  38:	f2 c3                	bnd retq 
  3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

This applies to any MPXK compiled function and pointer dereference, not only 
wrappers. The caller of course needs to know (at runtime) the bounds, which 
were set by the instrumentation either compile-time or runtime, potentially in 
the kmalloc wrapper (based on the size argument and returned via the bnd0 
register). The memcpy & friends are wrapped so the checks can be done 
explicitly before letting the functions do their thing. The wrappers serve, 
IIUC, a similar purpose to the KASAN's direct modifications to the same 
functions.

KASAN uses shadow memory to keep track of valid memory regions and then checks 
pointer dereferences against that. MPXK by contrast tracks the bounds along 
in-memory (either on stack or in .data section) or in MPX hardware bound 
registers (using regular MPX GCC instrumentation). This is not possible when 
pointers are stashed away in a shared array for example, so in those cases the 
bounds are stored elsewhere. Vanilla MPX uses a separate data structure for 
this, whereas MPXK attempts to determine bounds based on the kmalloc 
allocation area without explicit bound stores, shadow memory or fat-pointers.

The main difference to KASAN/vanilla-MPX is that MPXK does not use any extra 
memory and we therefore hope MPXK will be more feasible to actually use 
runtime.  In support of that idea MPXK is also designed to be modular, i.e.  
you can just apply it on specific parts of the code (hence also wrappers 
instead of KASAN-like direct changes to memcpy, etc implementations).

>
>> Can you recommend any "standard" way of doing measurements, either coverage
>> or performance, for this kind of protections?
>
>I say, for build coverage (possibly via some compile-time warning),
>how many, e.g., memcpy()s are protected (i.e. bounds are known). And
>then similarly, during runtime (possibly via kprobe) how many
>memcpy()s are protected?

Yes, this sounds good. Although it would not cover non-wrapped pointer 
dereferences.  None the less, this should give us an estimate of how much our 
bound load limitations actually affects MPXK coverage. When considering only 
these functions I think our worst case should be similar to what 
CONFIG_FORTIFY already does.

Thanks for the suggestion!

>
>For performance, it's trickier, and needs a meaningful workload. I've
>used hackbench and kernel build times...

The meaningful workload thing is further complicated because we haven't 
envisioned this for kernel-wide deployment. But I guess we will have to do 
something like this to get comparable numbers. I will have to take a look at 
hackbench.

Thanks,
-hans

>
>-Kees
>
>-- 
>Kees Cook
>Pixel Security
