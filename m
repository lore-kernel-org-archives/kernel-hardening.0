Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Sun, 08 Nov 2015 14:13:28 +0100
MIME-Version: 1.0
Message-ID: <563F4A78.21151.23C6852D@pageexec.freemail.hu>
In-reply-to: <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>, <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6 Nov 2015 at 15:30, Kees Cook wrote:

> >        * gcc intentional overflow: gcc computes some expressions by overflow
> >           when it optimizes. Sadly it is doing this in the front end where
> >           there is no plugin support. Most of these false positives I handle
> >           from the plugin or sometimes I patch the kernel source code.
> >           There are some unsolved issues.
> 
> Has there been any discussion with gcc folks about this problem?

i seem to recall that there's an effort (gcc branch?) where some work
is being done to move the frontend canonicalization (the prime cause
for most if not all intentional overflows) into a proper GIMPLE pass
which would make life easier for the size overflow plugin. however i
have no idea where that work stands.

as a general note, some gcc (and eventually clang/llvm) folks could
perhaps be involved in kernel/plugin related discussions. this would
not only help heal some of the rift that developed over the years
between these communities but would ideally develop into a mode of
cooperation where features that kernel developers desire from the
compiler (e.g., a kernel specific optimization mode between -Os and
-O2 that comes up every now and then) could be prototyped and tested
as a plugin in the kernel and then submitted to gcc when they're
found good/mature enough. since gcc is developed at a much slower
pace than the kernel (1 release per year vs. 5 of linux), this would
certainly help put features faster into the hands of users (and support
even those using older gcc versions as well) while ensuring longer
term reliable support from the compiler. just some food for thought ;).

> >     You can read more about the plugin:
> >     https://forums.grsecurity.net/viewtopic.php?f=7&t=3043
> >     This is a complex plugin and it has false positives but it also found
> >     a lot of bugs (overflows, underflows and trunctions) and
> >     thanks to the data flow duplication it has a small performance impact only.
> >     I know that I will have to adapt it to be suitable for vanilla.
> 
> That's a great write-up! I would call other people's attention to the
> portion where you point out it blocks real-world cases of flaws:
> CVE-2013-0914 CVE-2013-0913 CVE-2013-2141

note that there're many cases where integer related problems just got
fixed without anyone (ourselves included) trying to figure out the exact
consequences.

finding these integer handling bugs is not just about security but general
correctness as well. e.g., 646200a041203f440fb6fcf9cacd9efeda9de74c started
out as a runtime alert from the overflow plugin and then turned out to be
something entirely different.

> >  * constify: This plugin constifies all structure types which contain only
> >     function pointers or are explicitly marked for constification.
> >     If some code wants to modify a read-only object it will cause
> >     a compile error.
> >     There are two gcc attributes:
> >        * no_const: if we don't want constification
> >        * do_const: if we want to constify a structure type which has a
> >           non-function pointer field
> 
> I assume some level of no_const marking could go away when KERNEXEC or
> at least a similar "temporary writing" ability lands in upstream?

the no_const attribute exists because PaX does automatic ops structure
constification and there're some ops types that cannot be made read-only
this way for one reason or another:

  - some/all objects of the ops type are dynamically allocated on the
    kernel heap as part of a larger object and cannot be easily made
    read-only, it would require sometimes non-trivial source changes.

  - some static objects of the ops type are written to at runtime,
    typically once during initialization. handling this case is
    somewhat messy in the current plugin, it's either done via forcibly
    overriding the constness of the object or by using the no_const
    attribute and placing the object into a section that will be part
    of read-only kernel data after init (in either case open/close
    calls are needed). i have plans to move to the latter approach
    exclusively but that requires rewriting the core of the plugin
    to not rely on existing gcc infrastructure to detect const violations.

> >  * latent_entropy: This plugin generates some entropy from program state
> >     throughout the uptime of the kernel. It has small performance loss.
> >     The plugin uses an attribute which can be
> >     on a function (to extract entropy beyond init functions) or on a
> >     variable (to initialize it with a random number generated at compile time)
> 
> How large is the entropy extracted during early init? I bet a lot of
> architectures would rejoice to have this available. (CCing Ted for
> thoughts.)

that's a good question nobody can answer unfortunately. thing is, this
kind of instrumentation essentially builds a PRNG whose internal structure
reflects the control flow of instrumented kernel functions, i.e., it's not
something anyone can describe and analyze because of its size and dynamic
nature (think loops with variable number of rounds, interrupts, etc).

what one can do is measure the number of states the PRNG can end up in say
right after boot and see how wide and uniform the distribution of states
is. at the time i developed this plugin i ran a few tests on an allnoconfig
amd64 kernel under qemu/kvm and even that environment produced a few bits
of entropy (i.e., more than one state). however this kind of testing can
scale only so far, e.g., to establish that say 30 bits of entropy can be
generated this way by the time init is called, one would have to boot the
kernel billions of times already...

> Perhaps the constify plugin would be a good first target? Can you
> speak to any known bugs it stopped? Having some mention of the threat
> it mitigates would be helpful.

(function) pointer constification is one of two strategies to protect
control flow (the other is code pointer target verification) in a similar
way that constifying code is a strategy to protect executable from
modifications.

since, unlike code, not all function pointers can be made const by design,
this constification effort basically amounts to attack surface reduction
only, albeit a cheap and effective one i think. also it's not just about
security (mitigating exploits, rootkits, etc) per se but also a sort of
enforcement mechanism for kernel policy that exists for some of these ops
types already and forces bad actors (khm, AV, khm) to be overt when they're
circumventing it in their products.

as for the effectiveness of this attack surface reduction method, on a
4.3 allyes-minus-some-debugging-options amd64 kernel the number of static
writable function pointers goes from 62k down to 28k in PaX (the ratio
would be somewhat worse on vanilla since PaX does more forced constification
that require source changes as well). on my own test machine's kernel the
ratio is even better, more than 75% of these function pointers get constified.

> (Do I remember correctly that it constified security_operations, which
> was a common target in exploits?) 

the plugin did not only constify security_operations objects but we also
put the security_ops pointer itself into read-only memory as well (that is,
until 4.2 where the new LSM stacking code made this approach infeasible
without extensive source changes).

cheers,
 PaX Team
