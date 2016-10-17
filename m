Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJf21U1zG5qO=imXSLBsMJBZRbc96xw0CSTPMm+C85yrg@mail.gmail.com>
References: <1476016472.2329.38.camel@cvidal.org> <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
 <1476040182.2329.72.camel@cvidal.org> <20161009193731.GD14666@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41BDCAF6@IRSMSX102.ger.corp.intel.com>
 <1476115319.2329.108.camel@cvidal.org> <CAGXu5jLvBMWHw_Y8ntmKB3GFqWfmT_E1neUiVQLJAsErLxFLWw@mail.gmail.com>
 <CAAseMr6oLtJEakAH-0ZC7dNrxqq4F56roNR-j2OuNN-+Jq1kuQ@mail.gmail.com>
 <CAGXu5j+PLo0AHDWiG9pWhzS9fFgsJYNvbn96G=2tQq==9GPpaw@mail.gmail.com>
 <CAAseMr4zGyww6vgjkuqHB-kK7qQFBvDU8ZJkXqugoLEOxP0svw@mail.gmail.com> <CAGXu5jJf21U1zG5qO=imXSLBsMJBZRbc96xw0CSTPMm+C85yrg@mail.gmail.com>
From: Gengjia Chen <chengjia4574@gmail.com>
Date: Mon, 17 Oct 2016 19:57:13 +0800
Message-ID: <CAAseMr49vEgQHuBq-pT0bHvRzwL9dUeceqwr87pVBk9ZjuoAig@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a1141091edd7ade053f0e46bb
Subject: Re: [kernel-hardening] self introduction
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a1141091edd7ade053f0e46bb
Content-Type: text/plain; charset=UTF-8

>>> In your research have you seen a common kind of bug that results in
>>> the vulnerabilities you find?
>>
>> No,
>> Most of those issues are caused by the lack of checking of  user input
>> length
>> in copy_xx_user functions or afterwards in memcpy functions,
>> however, looking into the details,
>> they vary among different functions in different files.
>
>Cool, I hope the recent hardened usercopy stuff will improve that
>situation, though there is plenty left to do.
>
>>> Is there anything that would have
>>> significantly made exploitation more difficult in the things you
>>> worked on?
>>
>> Yes!
>>
>> I mostly exploit buffer overflow vulns by overwrite function pointers
(such
>> as
>> pointers in file_operations) of a global object or a heap object
>> to redirect execution (and if PXN is enable, we simply use rop gadgets).
>> Therefore mitigation solutions of Function_pointer_overwrite  would
>> make such kind of exploitation much more diffcult.
>> But I don't know if you have let all the pointers "const".
>
>Creating a mechanism like PaX's pax_open_kernel()/pax_close_kernel()
>combined with the constify plugin would vastly improve the function
>tables that could be const in the kernel. Perhaps that's something you
>could look at: porting the pax_open_kernel()/pax_close_kernel()
>infrastructure on ARM to upstream?
>

I found that pax_open_kernel()/pax_close_kernel() infrastructure
had been ported on ARM in patch
grsecurity-3.1-4.7.8-201610161720.patch, as follow:

file: arch/arm/include/asm/pgtable.h

#ifdef CONFIG_PAX_KERNEXEC
static inline unsigned long pax_open_kernel(void) {
#ifdef CONFIG_ARM_LPAE
        /* TODO */
#else
        preempt_disable();
        BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_KERNEXEC));
        modify_domain(DOMAIN_KERNEL, DOMAIN_KERNEXEC);
#endif
        return 0;
}

static inline unsigned long pax_close_kernel(void) {
#ifdef CONFIG_ARM_LPAE
        /* TODO */
#else
        BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_MANAGER));
        /* DOMAIN_MANAGER = "client" under KERNEXEC */
        modify_domain(DOMAIN_KERNEL, DOMAIN_MANAGER);
        preempt_enable_no_resched();
#endif
        return 0;
}
#else
static inline unsigned long pax_open_kernel(void) { return 0; }
static inline unsigned long pax_close_kernel(void) { return 0; }
#endif

Is there anything else I can do to help about this (mitigation solutions of
Function_pointer_overwrite )?


>> Becsides, ret2dir is a common way to exploit  UAF vulns
>> so  I think solutions like XPFO is a way  to make
>> those kind of exploitation more diffcult.
>
>That's also good to hear. XPFO is making some progress; I'm looking
>forward to it's next patch version (though IIUC, we'll need
>arch-specific support for it on ARM -- the current patches are x86
>only).
>

I think I can also start with porting XPFO on ARM if you need.


>> Right now KALSR is still disable in most android devices,
>> so it is easy to get kernel symbol address,
>> however if KALSR is enable, it may make exploitation more diffcult.
>
>Eliminating the various address exposures for KASLR is going to be a
>long process, I suspect. If you find any that look easily fixable,
>let's get them in. :)
>
>>> Are you interested mostly in ARM-specific things?
>>
>> I am famillar with ARM-specific things mostly, but I can also accept
x86/x64
>> tasks.
>>
>>> Are you interested in kernel-assisted userspace defenses too?
>>
>> What dose that mean ?  something like seccomp ?
>
>Sure, though I meant things like the brute-force detection, or W^X
>memory enforcement for mmap/mprotect, etc. The defenses that the
>kernel provides, but are for userspace hardening rather than kernel
>hardening.

Right now, I am rather more interested in kernel hardening,
however, if there are people in charge of all areas, I can also
get involve in userspace hardening

2016-10-14 2:50 GMT+08:00 Kees Cook <keescook@chromium.org>:

> On Thu, Oct 13, 2016 at 4:14 AM, Gengjia Chen <chengjia4574@gmail.com>
> wrote:
> >> In your research have you seen a common kind of bug that results in
> >> the vulnerabilities you find?
> >
> > No,
> > Most of those issues are caused by the lack of checking of  user input
> > length
> > in copy_xx_user functions or afterwards in memcpy functions,
> > however, looking into the details,
> > they vary among different functions in different files.
>
> Cool, I hope the recent hardened usercopy stuff will improve that
> situation, though there is plenty left to do.
>
> >> Is there anything that would have
> >> significantly made exploitation more difficult in the things you
> >> worked on?
> >
> > Yes!
> >
> > I mostly exploit buffer overflow vulns by overwrite function pointers
> (such
> > as
> > pointers in file_operations) of a global object or a heap object
> > to redirect execution (and if PXN is enable, we simply use rop gadgets).
> > Therefore mitigation solutions of Function_pointer_overwrite  would
> > make such kind of exploitation much more diffcult.
> > But I don't know if you have let all the pointers "const".
>
> Creating a mechanism like PaX's pax_open_kernel()/pax_close_kernel()
> combined with the constify plugin would vastly improve the function
> tables that could be const in the kernel. Perhaps that's something you
> could look at: porting the pax_open_kernel()/pax_close_kernel()
> infrastructure on ARM to upstream?
>
> > Becsides, ret2dir is a common way to exploit  UAF vulns
> > so  I think solutions like XPFO is a way  to make
> > those kind of exploitation more diffcult.
>
> That's also good to hear. XPFO is making some progress; I'm looking
> forward to it's next patch version (though IIUC, we'll need
> arch-specific support for it on ARM -- the current patches are x86
> only).
>
> > Right now KALSR is still disable in most android devices,
> > so it is easy to get kernel symbol address,
> > however if KALSR is enable, it may make exploitation more diffcult.
>
> Eliminating the various address exposures for KASLR is going to be a
> long process, I suspect. If you find any that look easily fixable,
> let's get them in. :)
>
> >> Are you interested mostly in ARM-specific things?
> >
> > I am famillar with ARM-specific things mostly, but I can also accept
> x86/x64
> > tasks.
> >
> >> Are you interested in kernel-assisted userspace defenses too?
> >
> > What dose that mean ?  something like seccomp ?
>
> Sure, though I meant things like the brute-force detection, or W^X
> memory enforcement for mmap/mprotect, etc. The defenses that the
> kernel provides, but are for userspace hardening rather than kernel
> hardening.
>
> -Kees
>
> --
> Kees Cook
> Nexus Security
>

--001a1141091edd7ade053f0e46bb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>&gt;&gt;&gt; In your research have you seen a common =
kind of bug that results in</div><div>&gt;&gt;&gt; the vulnerabilities you =
find?</div><div>&gt;&gt;</div><div>&gt;&gt; No,</div><div>&gt;&gt; Most of =
those issues are caused by the lack of checking of =C2=A0user input</div><d=
iv>&gt;&gt; length</div><div>&gt;&gt; in copy_xx_user functions or afterwar=
ds in memcpy functions,</div><div>&gt;&gt; however, looking into the detail=
s,</div><div>&gt;&gt; they vary among different functions in different file=
s.</div><div>&gt;</div><div>&gt;Cool, I hope the recent hardened usercopy s=
tuff will improve that</div><div>&gt;situation, though there is plenty left=
 to do.</div><div>&gt;</div><div>&gt;&gt;&gt; Is there anything that would =
have</div><div>&gt;&gt;&gt; significantly made exploitation more difficult =
in the things you</div><div>&gt;&gt;&gt; worked on?</div><div>&gt;&gt;</div=
><div>&gt;&gt; Yes!</div><div>&gt;&gt;</div><div>&gt;&gt; I mostly exploit =
buffer overflow vulns by overwrite function pointers (such</div><div>&gt;&g=
t; as</div><div>&gt;&gt; pointers in file_operations) of a global object or=
 a heap object</div><div>&gt;&gt; to redirect execution (and if PXN is enab=
le, we simply use rop gadgets).</div><div>&gt;&gt; Therefore mitigation sol=
utions of Function_pointer_overwrite =C2=A0would</div><div>&gt;&gt; make su=
ch kind of exploitation much more diffcult.</div><div>&gt;&gt; But I don&#3=
9;t know if you have let all the pointers &quot;const&quot;.</div><div>&gt;=
</div><div>&gt;Creating a mechanism like PaX&#39;s pax_open_kernel()/pax_cl=
ose_kernel()</div><div>&gt;combined with the constify plugin would vastly i=
mprove the function</div><div>&gt;tables that could be const in the kernel.=
 Perhaps that&#39;s something you</div><div>&gt;could look at: porting the =
pax_open_kernel()/pax_close_kernel()</div><div>&gt;infrastructure on ARM to=
 upstream?</div><div>&gt;</div><div><br></div><div>I found that pax_open_ke=
rnel()/pax_close_kernel() infrastructure=C2=A0</div><div>had been ported on=
 ARM in patch=C2=A0</div><div>grsecurity-3.1-4.7.8-201610161720.patch, as f=
ollow:</div><div><br></div><div>file: arch/arm/include/asm/pgtable.h</div><=
div><br></div><div>#ifdef CONFIG_PAX_KERNEXEC</div><div>static inline unsig=
ned long pax_open_kernel(void) {</div><div>#ifdef CONFIG_ARM_LPAE</div><div=
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* TODO */</div><div>#else</div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 preempt_disable();</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_KERNEXEC));</div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 modify_domain(DOMAIN_KERNEL, DOMAIN_KERNEXEC);</div><d=
iv>#endif</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;</div><div>}</div>=
<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0</div><di=
v>static inline unsigned long pax_close_kernel(void) {</div><div>#ifdef CON=
FIG_ARM_LPAE</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* TODO */</div><div>#el=
se =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0</div><div>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_MANAGER));</div><div>=C2=A0=
 =C2=A0 =C2=A0 =C2=A0 /* DOMAIN_MANAGER =3D &quot;client&quot; under KERNEX=
EC */</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 modify_domain(DOMAIN_KERNEL, DO=
MAIN_MANAGER);</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 preempt_enable_no_resc=
hed();</div><div>#endif =C2=A0</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 return=
 0;</div><div>}</div><div>#else</div><div>static inline unsigned long pax_o=
pen_kernel(void) { return 0; }</div><div>static inline unsigned long pax_cl=
ose_kernel(void) { return 0; }</div><div>#endif</div><div><br></div><div>Is=
 there anything else I can do to help about this (mitigation solutions of F=
unction_pointer_overwrite )?</div><div><br></div><div><br></div><div>&gt;&g=
t; Becsides, ret2dir is a common way to exploit =C2=A0UAF vulns</div><div>&=
gt;&gt; so =C2=A0I think solutions like XPFO is a way =C2=A0to make</div><d=
iv>&gt;&gt; those kind of exploitation more diffcult.</div><div>&gt;</div><=
div>&gt;That&#39;s also good to hear. XPFO is making some progress; I&#39;m=
 looking</div><div>&gt;forward to it&#39;s next patch version (though IIUC,=
 we&#39;ll need</div><div>&gt;arch-specific support for it on ARM -- the cu=
rrent patches are x86</div><div>&gt;only).</div><div>&gt;</div><div><br></d=
iv><div>I think I can also start with porting XPFO on ARM if you need.</div=
><div><br></div><div><br></div><div>&gt;&gt; Right now KALSR is still disab=
le in most android devices,</div><div>&gt;&gt; so it is easy to get kernel =
symbol address,</div><div>&gt;&gt; however if KALSR is enable, it may make =
exploitation more diffcult.</div><div>&gt;</div><div>&gt;Eliminating the va=
rious address exposures for KASLR is going to be a</div><div>&gt;long proce=
ss, I suspect. If you find any that look easily fixable,</div><div>&gt;let&=
#39;s get them in. :)</div><div>&gt;</div><div>&gt;&gt;&gt; Are you interes=
ted mostly in ARM-specific things?</div><div>&gt;&gt;</div><div>&gt;&gt; I =
am famillar with ARM-specific things mostly, but I can also accept x86/x64<=
/div><div>&gt;&gt; tasks.</div><div>&gt;&gt;</div><div>&gt;&gt;&gt; Are you=
 interested in kernel-assisted userspace defenses too?</div><div>&gt;&gt;</=
div><div>&gt;&gt; What dose that mean ? =C2=A0something like seccomp ?</div=
><div>&gt;</div><div>&gt;Sure, though I meant things like the brute-force d=
etection, or W^X</div><div>&gt;memory enforcement for mmap/mprotect, etc. T=
he defenses that the</div><div>&gt;kernel provides, but are for userspace h=
ardening rather than kernel</div><div>&gt;hardening.</div><div><br></div><d=
iv>Right now, I am rather more interested in kernel hardening,=C2=A0</div><=
div>however, if there are people in charge of all areas, I can also=C2=A0</=
div><div>get involve in userspace hardening</div></div><div class=3D"gmail_=
extra"><br><div class=3D"gmail_quote">2016-10-14 2:50 GMT+08:00 Kees Cook <=
span dir=3D"ltr">&lt;<a href=3D"mailto:keescook@chromium.org" target=3D"_bl=
ank">keescook@chromium.org</a>&gt;</span>:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
"><span class=3D"">On Thu, Oct 13, 2016 at 4:14 AM, Gengjia Chen &lt;<a hre=
f=3D"mailto:chengjia4574@gmail.com">chengjia4574@gmail.com</a>&gt; wrote:<b=
r>
&gt;&gt; In your research have you seen a common kind of bug that results i=
n<br>
&gt;&gt; the vulnerabilities you find?<br>
&gt;<br>
&gt; No,<br>
&gt; Most of those issues are caused by the lack of checking of=C2=A0 user =
input<br>
&gt; length<br>
&gt; in copy_xx_user functions or afterwards in memcpy functions,<br>
&gt; however, looking into the details,<br>
&gt; they vary among different functions in different files.<br>
<br>
</span>Cool, I hope the recent hardened usercopy stuff will improve that<br=
>
situation, though there is plenty left to do.<br>
<span class=3D""><br>
&gt;&gt; Is there anything that would have<br>
&gt;&gt; significantly made exploitation more difficult in the things you<b=
r>
&gt;&gt; worked on?<br>
&gt;<br>
&gt; Yes!<br>
&gt;<br>
&gt; I mostly exploit buffer overflow vulns by overwrite function pointers =
(such<br>
&gt; as<br>
&gt; pointers in file_operations) of a global object or a heap object<br>
&gt; to redirect execution (and if PXN is enable, we simply use rop gadgets=
).<br>
&gt; Therefore mitigation solutions of Function_pointer_overwrite=C2=A0 wou=
ld<br>
&gt; make such kind of exploitation much more diffcult.<br>
&gt; But I don&#39;t know if you have let all the pointers &quot;const&quot=
;.<br>
<br>
</span>Creating a mechanism like PaX&#39;s pax_open_kernel()/pax_close_<wbr=
>kernel()<br>
combined with the constify plugin would vastly improve the function<br>
tables that could be const in the kernel. Perhaps that&#39;s something you<=
br>
could look at: porting the pax_open_kernel()/pax_close_<wbr>kernel()<br>
infrastructure on ARM to upstream?<br>
<span class=3D""><br>
&gt; Becsides, ret2dir is a common way to exploit=C2=A0 UAF vulns<br>
&gt; so=C2=A0 I think solutions like XPFO is a way=C2=A0 to make<br>
&gt; those kind of exploitation more diffcult.<br>
<br>
</span>That&#39;s also good to hear. XPFO is making some progress; I&#39;m =
looking<br>
forward to it&#39;s next patch version (though IIUC, we&#39;ll need<br>
arch-specific support for it on ARM -- the current patches are x86<br>
only).<br>
<span class=3D""><br>
&gt; Right now KALSR is still disable in most android devices,<br>
&gt; so it is easy to get kernel symbol address,<br>
&gt; however if KALSR is enable, it may make exploitation more diffcult.<br=
>
<br>
</span>Eliminating the various address exposures for KASLR is going to be a=
<br>
long process, I suspect. If you find any that look easily fixable,<br>
let&#39;s get them in. :)<br>
<span class=3D""><br>
&gt;&gt; Are you interested mostly in ARM-specific things?<br>
&gt;<br>
&gt; I am famillar with ARM-specific things mostly, but I can also accept x=
86/x64<br>
&gt; tasks.<br>
&gt;<br>
&gt;&gt; Are you interested in kernel-assisted userspace defenses too?<br>
&gt;<br>
&gt; What dose that mean ?=C2=A0 something like seccomp ?<br>
<br>
</span>Sure, though I meant things like the brute-force detection, or W^X<b=
r>
memory enforcement for mmap/mprotect, etc. The defenses that the<br>
kernel provides, but are for userspace hardening rather than kernel<br>
hardening.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
-Kees<br>
<br>
--<br>
Kees Cook<br>
Nexus Security<br>
</div></div></blockquote></div><br></div>

--001a1141091edd7ade053f0e46bb--
