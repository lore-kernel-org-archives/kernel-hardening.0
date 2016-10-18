Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKad-W6dCU17dJD0SwubmjQ0=pR0zAUU2oR5NakWzoj-A@mail.gmail.com>
References: <1476016472.2329.38.camel@cvidal.org> <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
 <1476040182.2329.72.camel@cvidal.org> <20161009193731.GD14666@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41BDCAF6@IRSMSX102.ger.corp.intel.com>
 <1476115319.2329.108.camel@cvidal.org> <CAGXu5jLvBMWHw_Y8ntmKB3GFqWfmT_E1neUiVQLJAsErLxFLWw@mail.gmail.com>
 <CAAseMr6oLtJEakAH-0ZC7dNrxqq4F56roNR-j2OuNN-+Jq1kuQ@mail.gmail.com>
 <CAGXu5j+PLo0AHDWiG9pWhzS9fFgsJYNvbn96G=2tQq==9GPpaw@mail.gmail.com>
 <CAAseMr4zGyww6vgjkuqHB-kK7qQFBvDU8ZJkXqugoLEOxP0svw@mail.gmail.com>
 <CAGXu5jJf21U1zG5qO=imXSLBsMJBZRbc96xw0CSTPMm+C85yrg@mail.gmail.com>
 <CAAseMr49vEgQHuBq-pT0bHvRzwL9dUeceqwr87pVBk9ZjuoAig@mail.gmail.com> <CAGXu5jKad-W6dCU17dJD0SwubmjQ0=pR0zAUU2oR5NakWzoj-A@mail.gmail.com>
From: Gengjia Chen <chengjia4574@gmail.com>
Date: Tue, 18 Oct 2016 19:52:22 +0800
Message-ID: <CAAseMr4o9tGKHoC39b=gZTqYAKqFNPVsnW7wZCS2wFJJ7Wn2uw@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a11401c505852b2053f22531a
Subject: Re: [kernel-hardening] self introduction
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Juerg Haefliger <juerg.haefliger@hpe.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a11401c505852b2053f22531a
Content-Type: text/plain; charset=UTF-8

>
>
>
> >2016-10-18 4:15 GMT+08:00 Kees Cook <keescook@chromium.org>:
> >On Mon, Oct 17, 2016 at 4:57 AM, Gengjia Chen <chengjia4574@gmail.com>
> wrote:
> >>>>> In your research have you seen a common kind of bug that results in
> >>>>> the vulnerabilities you find?
> >>>>
> >>>> No,
> >>>> Most of those issues are caused by the lack of checking of  user input
> >>>> length
> >>>> in copy_xx_user functions or afterwards in memcpy functions,
> >>>> however, looking into the details,
> >>>> they vary among different functions in different files.
> >>>
> >>>Cool, I hope the recent hardened usercopy stuff will improve that
> >>>situation, though there is plenty left to do.
> >>>
> >>>>> Is there anything that would have
> >>>>> significantly made exploitation more difficult in the things you
> >>>>> worked on?
> >>>>
> >>>> Yes!
> >>>>
> >>>> I mostly exploit buffer overflow vulns by overwrite function pointers
> >>>> (such
> >>>> as
> >>>> pointers in file_operations) of a global object or a heap object
> >>>> to redirect execution (and if PXN is enable, we simply use rop
> gadgets).
> >>>> Therefore mitigation solutions of Function_pointer_overwrite  would
> >>>> make such kind of exploitation much more diffcult.
> >>>> But I don't know if you have let all the pointers "const".
> >>>
> >>>Creating a mechanism like PaX's pax_open_kernel()/pax_close_kernel()
> >>>combined with the constify plugin would vastly improve the function
> >>>tables that could be const in the kernel. Perhaps that's something you
> >>>could look at: porting the pax_open_kernel()/pax_close_kernel()
> >>>infrastructure on ARM to upstream?
> >>>
> >>
> >> I found that pax_open_kernel()/pax_close_kernel() infrastructure
> >> had been ported on ARM in patch
> >> grsecurity-3.1-4.7.8-201610161720.patch, as follow:
> >>
> >> file: arch/arm/include/asm/pgtable.h
> >>
> >> #ifdef CONFIG_PAX_KERNEXEC
> >> static inline unsigned long pax_open_kernel(void) {
> >> #ifdef CONFIG_ARM_LPAE
> >>         /* TODO */
> >> #else
> >>         preempt_disable();
> >>         BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_KERNEXEC));
> >>         modify_domain(DOMAIN_KERNEL, DOMAIN_KERNEXEC);
> >> #endif
> >>         return 0;
> >> }
> >>
> >> static inline unsigned long pax_close_kernel(void) {
> >> #ifdef CONFIG_ARM_LPAE
> >>         /* TODO */
> >> #else
> >>         BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_MANAGER));
> >>         /* DOMAIN_MANAGER = "client" under KERNEXEC */
> >>         modify_domain(DOMAIN_KERNEL, DOMAIN_MANAGER);
> >>         preempt_enable_no_resched();
> >> #endif
> >>         return 0;
> >> }
> >> #else
> >> static inline unsigned long pax_open_kernel(void) { return 0; }
> >> static inline unsigned long pax_close_kernel(void) { return 0; }
> >> #endif
> >>
> >> Is there anything else I can do to help about this (mitigation
> solutions of
> >> Function_pointer_overwrite )?
> >
> >The ARM open/close depends on their use of Domains. For upstream,
> >you'd have to examine how Domains are being used (which seems
> >different to me).
>
> So, I will try to start to port pax_open_kernel/pax_close_kernel
> arm-specific features to upstream, and keep you in touch.
>
> >The other work is building the in-kernel
> >infrastructure to support write-rarely memory (likely a new section,
> >like ro_after_init, etc).
> >
>
> It seems that the constify plugin still not been ported to the lastest
> code (v4.9-rc1),
> If I understand, you means that a new section should be added
> to the upstream , and cooperate with the future constify plugin (the
> plugin automatically put those objects to that section ) ?
>

>
> >>>> Becsides, ret2dir is a common way to exploit  UAF vulns
> >>>> so  I think solutions like XPFO is a way  to make
> >>>> those kind of exploitation more diffcult.
> >>>
> >>>That's also good to hear. XPFO is making some progress; I'm looking
> >>>forward to it's next patch version (though IIUC, we'll need
> >>>arch-specific support for it on ARM -- the current patches are x86
> >>>only).
> >>
> >> I think I can also start with porting XPFO on ARM if you need.
> >
> >Sure, I'd be very curious to see this! Hopefully Juerg has some ideas
> >for helping there (he's been working on the x86 XPFO).
> >
> >>>> Right now KALSR is still disable in most android devices,
> >>>> so it is easy to get kernel symbol address,
> >>>> however if KALSR is enable, it may make exploitation more diffcult.
> >>>
> >>>Eliminating the various address exposures for KASLR is going to be a
> >>>long process, I suspect. If you find any that look easily fixable,
> >>>let's get them in. :)
> >>>
> >>>>> Are you interested mostly in ARM-specific things?
> >>>>
> >>>> I am famillar with ARM-specific things mostly, but I can also accept
> >>>> x86/x64
> >>>> tasks.
> >>>>
> >>>>> Are you interested in kernel-assisted userspace defenses too?
> >>>>
> >>>> What dose that mean ?  something like seccomp ?
> >>>
> >>>Sure, though I meant things like the brute-force detection, or W^X
> >>>memory enforcement for mmap/mprotect, etc. The defenses that the
> >>>kernel provides, but are for userspace hardening rather than kernel
> >>>hardening.
> >>
> >> Right now, I am rather more interested in kernel hardening,
> >> however, if there are people in charge of all areas, I can also
> >> get involve in userspace hardening
> >
> >Yeah, it's fine to stick with kernel; no worries. :) Thanks!
> >
> >-Kees
> >
> >
> >--
> >Kees Cook
> >Nexus Security
>

--001a11401c505852b2053f22531a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left=
-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;paddi=
ng-left:1ex"><div class=3D"gmail-HOEnZb"><div class=3D"gmail-h5"><div class=
=3D"gmail-h5"><br></div><div class=3D"gmail-h5"><br></div><div class=3D"gma=
il-h5">&gt;2016-10-18 4:15 GMT+08:00 Kees Cook &lt;<a href=3D"mailto:keesco=
ok@chromium.org">keescook@chromium.org</a>&gt;:</div><div class=3D"gmail-h5=
">&gt;On Mon, Oct 17, 2016 at 4:57 AM, Gengjia Chen &lt;<a href=3D"mailto:c=
hengjia4574@gmail.com">chengjia4574@gmail.com</a>&gt; wrote:</div><div clas=
s=3D"gmail-h5">&gt;&gt;&gt;&gt;&gt; In your research have you seen a common=
 kind of bug that results in</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt;&=
gt; the vulnerabilities you find?</div><div class=3D"gmail-h5">&gt;&gt;&gt;=
&gt;</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt; No,</div><div class=3D"g=
mail-h5">&gt;&gt;&gt;&gt; Most of those issues are caused by the lack of ch=
ecking of =C2=A0user input</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt; le=
ngth</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt; in copy_xx_user function=
s or afterwards in memcpy functions,</div><div class=3D"gmail-h5">&gt;&gt;&=
gt;&gt; however, looking into the details,</div><div class=3D"gmail-h5">&gt=
;&gt;&gt;&gt; they vary among different functions in different files.</div>=
<div class=3D"gmail-h5">&gt;&gt;&gt;</div><div class=3D"gmail-h5">&gt;&gt;&=
gt;Cool, I hope the recent hardened usercopy stuff will improve that</div><=
div class=3D"gmail-h5">&gt;&gt;&gt;situation, though there is plenty left t=
o do.</div><div class=3D"gmail-h5">&gt;&gt;&gt;</div><div class=3D"gmail-h5=
">&gt;&gt;&gt;&gt;&gt; Is there anything that would have</div><div class=3D=
"gmail-h5">&gt;&gt;&gt;&gt;&gt; significantly made exploitation more diffic=
ult in the things you</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt;&gt; wor=
ked on?</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt;</div><div class=3D"gm=
ail-h5">&gt;&gt;&gt;&gt; Yes!</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt;=
</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt; I mostly exploit buffer over=
flow vulns by overwrite function pointers</div><div class=3D"gmail-h5">&gt;=
&gt;&gt;&gt; (such</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt; as</div><d=
iv class=3D"gmail-h5">&gt;&gt;&gt;&gt; pointers in file_operations) of a gl=
obal object or a heap object</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt; =
to redirect execution (and if PXN is enable, we simply use rop gadgets).</d=
iv><div class=3D"gmail-h5">&gt;&gt;&gt;&gt; Therefore mitigation solutions =
of Function_pointer_overwrite =C2=A0would</div><div class=3D"gmail-h5">&gt;=
&gt;&gt;&gt; make such kind of exploitation much more diffcult.</div><div c=
lass=3D"gmail-h5">&gt;&gt;&gt;&gt; But I don&#39;t know if you have let all=
 the pointers &quot;const&quot;.</div><div class=3D"gmail-h5">&gt;&gt;&gt;<=
/div><div class=3D"gmail-h5">&gt;&gt;&gt;Creating a mechanism like PaX&#39;=
s pax_open_kernel()/pax_close_kernel()</div><div class=3D"gmail-h5">&gt;&gt=
;&gt;combined with the constify plugin would vastly improve the function</d=
iv><div class=3D"gmail-h5">&gt;&gt;&gt;tables that could be const in the ke=
rnel. Perhaps that&#39;s something you</div><div class=3D"gmail-h5">&gt;&gt=
;&gt;could look at: porting the pax_open_kernel()/pax_close_kernel()</div><=
div class=3D"gmail-h5">&gt;&gt;&gt;infrastructure on ARM to upstream?</div>=
<div class=3D"gmail-h5">&gt;&gt;&gt;</div><div class=3D"gmail-h5">&gt;&gt;<=
/div><div class=3D"gmail-h5">&gt;&gt; I found that pax_open_kernel()/pax_cl=
ose_kernel() infrastructure</div><div class=3D"gmail-h5">&gt;&gt; had been =
ported on ARM in patch</div><div class=3D"gmail-h5">&gt;&gt; grsecurity-3.1=
-4.7.8-201610161720.patch, as follow:</div><div class=3D"gmail-h5">&gt;&gt;=
</div><div class=3D"gmail-h5">&gt;&gt; file: arch/arm/include/asm/pgtable.h=
</div><div class=3D"gmail-h5">&gt;&gt;</div><div class=3D"gmail-h5">&gt;&gt=
; #ifdef CONFIG_PAX_KERNEXEC</div><div class=3D"gmail-h5">&gt;&gt; static i=
nline unsigned long pax_open_kernel(void) {</div><div class=3D"gmail-h5">&g=
t;&gt; #ifdef CONFIG_ARM_LPAE</div><div class=3D"gmail-h5">&gt;&gt; =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 /* TODO */</div><div class=3D"gmail-h5">&gt;&gt; #else=
</div><div class=3D"gmail-h5">&gt;&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 preempt_=
disable();</div><div class=3D"gmail-h5">&gt;&gt; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_KERNEXEC));</div><div class=3D=
"gmail-h5">&gt;&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 modify_domain(DOMAIN_KERNEL=
, DOMAIN_KERNEXEC);</div><div class=3D"gmail-h5">&gt;&gt; #endif</div><div =
class=3D"gmail-h5">&gt;&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;</div><div=
 class=3D"gmail-h5">&gt;&gt; }</div><div class=3D"gmail-h5">&gt;&gt;</div><=
div class=3D"gmail-h5">&gt;&gt; static inline unsigned long pax_close_kerne=
l(void) {</div><div class=3D"gmail-h5">&gt;&gt; #ifdef CONFIG_ARM_LPAE</div=
><div class=3D"gmail-h5">&gt;&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* TODO */</d=
iv><div class=3D"gmail-h5">&gt;&gt; #else</div><div class=3D"gmail-h5">&gt;=
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_M=
ANAGER));</div><div class=3D"gmail-h5">&gt;&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 /* DOMAIN_MANAGER =3D &quot;client&quot; under KERNEXEC */</div><div class=
=3D"gmail-h5">&gt;&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 modify_domain(DOMAIN_KER=
NEL, DOMAIN_MANAGER);</div><div class=3D"gmail-h5">&gt;&gt; =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 preempt_enable_no_resched();</div><div class=3D"gmail-h5">&gt=
;&gt; #endif</div><div class=3D"gmail-h5">&gt;&gt; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return 0;</div><div class=3D"gmail-h5">&gt;&gt; }</div><div class=3D"gm=
ail-h5">&gt;&gt; #else</div><div class=3D"gmail-h5">&gt;&gt; static inline =
unsigned long pax_open_kernel(void) { return 0; }</div><div class=3D"gmail-=
h5">&gt;&gt; static inline unsigned long pax_close_kernel(void) { return 0;=
 }</div><div class=3D"gmail-h5">&gt;&gt; #endif</div><div class=3D"gmail-h5=
">&gt;&gt;</div><div class=3D"gmail-h5">&gt;&gt; Is there anything else I c=
an do to help about this (mitigation solutions of</div><div class=3D"gmail-=
h5">&gt;&gt; Function_pointer_overwrite )?</div><div class=3D"gmail-h5">&gt=
;</div><div class=3D"gmail-h5">&gt;The ARM open/close depends on their use =
of Domains. For upstream,</div><div class=3D"gmail-h5">&gt;you&#39;d have t=
o examine how Domains are being used (which seems</div><div class=3D"gmail-=
h5">&gt;different to me).=C2=A0</div><div class=3D"gmail-h5"><br></div><div=
 class=3D"gmail-h5">So, I will try to start to port pax_open_kernel/pax_clo=
se_kernel=C2=A0</div><div class=3D"gmail-h5">arm-specific features to upstr=
eam, and keep you in touch.=C2=A0</div><div class=3D"gmail-h5"><br></div><d=
iv class=3D"gmail-h5">&gt;The other work is building the in-kernel</div><di=
v class=3D"gmail-h5">&gt;infrastructure to support write-rarely memory (lik=
ely a new section,</div><div class=3D"gmail-h5">&gt;like ro_after_init, etc=
).</div><div class=3D"gmail-h5">&gt;</div><div class=3D"gmail-h5"><br></div=
><div class=3D"gmail-h5">It seems that the constify plugin still not been p=
orted to the lastest code (v4.9-rc1),</div><div class=3D"gmail-h5">If I und=
erstand, you means that a new section should be added=C2=A0</div><div class=
=3D"gmail-h5">to the upstream , and cooperate with the future constify plug=
in (the plugin automatically put those objects to that section ) ?</div></d=
iv></div></blockquote><blockquote class=3D"gmail_quote" style=3D"margin:0px=
 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);bor=
der-left-style:solid;padding-left:1ex"><div class=3D"gmail-HOEnZb"><div cla=
ss=3D"gmail-h5"><div class=3D"gmail-h5"><br></div><div class=3D"gmail-h5"><=
br></div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt; Becsides, ret2dir is a co=
mmon way to exploit =C2=A0UAF vulns</div><div class=3D"gmail-h5">&gt;&gt;&g=
t;&gt; so =C2=A0I think solutions like XPFO is a way =C2=A0to make</div><di=
v class=3D"gmail-h5">&gt;&gt;&gt;&gt; those kind of exploitation more diffc=
ult.</div><div class=3D"gmail-h5">&gt;&gt;&gt;</div><div class=3D"gmail-h5"=
>&gt;&gt;&gt;That&#39;s also good to hear. XPFO is making some progress; I&=
#39;m looking</div><div class=3D"gmail-h5">&gt;&gt;&gt;forward to it&#39;s =
next patch version (though IIUC, we&#39;ll need</div><div class=3D"gmail-h5=
">&gt;&gt;&gt;arch-specific support for it on ARM -- the current patches ar=
e x86</div><div class=3D"gmail-h5">&gt;&gt;&gt;only).</div><div class=3D"gm=
ail-h5">&gt;&gt;</div><div class=3D"gmail-h5">&gt;&gt; I think I can also s=
tart with porting XPFO on ARM if you need.</div><div class=3D"gmail-h5">&gt=
;</div><div class=3D"gmail-h5">&gt;Sure, I&#39;d be very curious to see thi=
s! Hopefully Juerg has some ideas</div><div class=3D"gmail-h5">&gt;for help=
ing there (he&#39;s been working on the x86 XPFO).</div><div class=3D"gmail=
-h5">&gt;</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt; Right now KALSR is =
still disable in most android devices,</div><div class=3D"gmail-h5">&gt;&gt=
;&gt;&gt; so it is easy to get kernel symbol address,</div><div class=3D"gm=
ail-h5">&gt;&gt;&gt;&gt; however if KALSR is enable, it may make exploitati=
on more diffcult.</div><div class=3D"gmail-h5">&gt;&gt;&gt;</div><div class=
=3D"gmail-h5">&gt;&gt;&gt;Eliminating the various address exposures for KAS=
LR is going to be a</div><div class=3D"gmail-h5">&gt;&gt;&gt;long process, =
I suspect. If you find any that look easily fixable,</div><div class=3D"gma=
il-h5">&gt;&gt;&gt;let&#39;s get them in. :)</div><div class=3D"gmail-h5">&=
gt;&gt;&gt;</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt;&gt; Are you inter=
ested mostly in ARM-specific things?</div><div class=3D"gmail-h5">&gt;&gt;&=
gt;&gt;</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt; I am famillar with AR=
M-specific things mostly, but I can also accept</div><div class=3D"gmail-h5=
">&gt;&gt;&gt;&gt; x86/x64</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt; ta=
sks.</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt;</div><div class=3D"gmail=
-h5">&gt;&gt;&gt;&gt;&gt; Are you interested in kernel-assisted userspace d=
efenses too?</div><div class=3D"gmail-h5">&gt;&gt;&gt;&gt;</div><div class=
=3D"gmail-h5">&gt;&gt;&gt;&gt; What dose that mean ? =C2=A0something like s=
eccomp ?</div><div class=3D"gmail-h5">&gt;&gt;&gt;</div><div class=3D"gmail=
-h5">&gt;&gt;&gt;Sure, though I meant things like the brute-force detection=
, or W^X</div><div class=3D"gmail-h5">&gt;&gt;&gt;memory enforcement for mm=
ap/mprotect, etc. The defenses that the</div><div class=3D"gmail-h5">&gt;&g=
t;&gt;kernel provides, but are for userspace hardening rather than kernel</=
div><div class=3D"gmail-h5">&gt;&gt;&gt;hardening.</div><div class=3D"gmail=
-h5">&gt;&gt;</div><div class=3D"gmail-h5">&gt;&gt; Right now, I am rather =
more interested in kernel hardening,</div><div class=3D"gmail-h5">&gt;&gt; =
however, if there are people in charge of all areas, I can also</div><div c=
lass=3D"gmail-h5">&gt;&gt; get involve in userspace hardening</div><div cla=
ss=3D"gmail-h5">&gt;</div><div class=3D"gmail-h5">&gt;Yeah, it&#39;s fine t=
o stick with kernel; no worries. :) Thanks!</div><div class=3D"gmail-h5">&g=
t;</div><div class=3D"gmail-h5">&gt;-Kees</div><div class=3D"gmail-h5">&gt;=
</div><div class=3D"gmail-h5">&gt;</div><div class=3D"gmail-h5">&gt;--</div=
><div class=3D"gmail-h5">&gt;Kees Cook</div><div class=3D"gmail-h5">&gt;Nex=
us Security</div>
</div></div></blockquote></div><br></div></div>

--001a11401c505852b2053f22531a--
