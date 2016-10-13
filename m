Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAAseMr4zGyww6vgjkuqHB-kK7qQFBvDU8ZJkXqugoLEOxP0svw@mail.gmail.com>
References: <1476016472.2329.38.camel@cvidal.org> <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
 <1476040182.2329.72.camel@cvidal.org> <20161009193731.GD14666@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41BDCAF6@IRSMSX102.ger.corp.intel.com>
 <1476115319.2329.108.camel@cvidal.org> <CAGXu5jLvBMWHw_Y8ntmKB3GFqWfmT_E1neUiVQLJAsErLxFLWw@mail.gmail.com>
 <CAAseMr6oLtJEakAH-0ZC7dNrxqq4F56roNR-j2OuNN-+Jq1kuQ@mail.gmail.com>
 <CAGXu5j+PLo0AHDWiG9pWhzS9fFgsJYNvbn96G=2tQq==9GPpaw@mail.gmail.com> <CAAseMr4zGyww6vgjkuqHB-kK7qQFBvDU8ZJkXqugoLEOxP0svw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 13 Oct 2016 11:50:26 -0700
Message-ID: <CAGXu5jJf21U1zG5qO=imXSLBsMJBZRbc96xw0CSTPMm+C85yrg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] self introduction
To: Gengjia Chen <chengjia4574@gmail.com>, Juerg Haefliger <juerg.haefliger@hpe.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 13, 2016 at 4:14 AM, Gengjia Chen <chengjia4574@gmail.com> wrote:
>> In your research have you seen a common kind of bug that results in
>> the vulnerabilities you find?
>
> No,
> Most of those issues are caused by the lack of checking of  user input
> length
> in copy_xx_user functions or afterwards in memcpy functions,
> however, looking into the details,
> they vary among different functions in different files.

Cool, I hope the recent hardened usercopy stuff will improve that
situation, though there is plenty left to do.

>> Is there anything that would have
>> significantly made exploitation more difficult in the things you
>> worked on?
>
> Yes!
>
> I mostly exploit buffer overflow vulns by overwrite function pointers (such
> as
> pointers in file_operations) of a global object or a heap object
> to redirect execution (and if PXN is enable, we simply use rop gadgets).
> Therefore mitigation solutions of Function_pointer_overwrite  would
> make such kind of exploitation much more diffcult.
> But I don't know if you have let all the pointers "const".

Creating a mechanism like PaX's pax_open_kernel()/pax_close_kernel()
combined with the constify plugin would vastly improve the function
tables that could be const in the kernel. Perhaps that's something you
could look at: porting the pax_open_kernel()/pax_close_kernel()
infrastructure on ARM to upstream?

> Becsides, ret2dir is a common way to exploit  UAF vulns
> so  I think solutions like XPFO is a way  to make
> those kind of exploitation more diffcult.

That's also good to hear. XPFO is making some progress; I'm looking
forward to it's next patch version (though IIUC, we'll need
arch-specific support for it on ARM -- the current patches are x86
only).

> Right now KALSR is still disable in most android devices,
> so it is easy to get kernel symbol address,
> however if KALSR is enable, it may make exploitation more diffcult.

Eliminating the various address exposures for KASLR is going to be a
long process, I suspect. If you find any that look easily fixable,
let's get them in. :)

>> Are you interested mostly in ARM-specific things?
>
> I am famillar with ARM-specific things mostly, but I can also accept x86/x64
> tasks.
>
>> Are you interested in kernel-assisted userspace defenses too?
>
> What dose that mean ?  something like seccomp ?

Sure, though I meant things like the brute-force detection, or W^X
memory enforcement for mmap/mprotect, etc. The defenses that the
kernel provides, but are for userspace hardening rather than kernel
hardening.

-Kees

-- 
Kees Cook
Nexus Security
