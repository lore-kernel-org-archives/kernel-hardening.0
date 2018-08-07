MIME-Version: 1.0
References: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
 <7529eedf-af56-2e94-261e-bc5c86abadaa@arm.com> <CAKv+Gu9X1CDpy+XvrmbSdjBjMb45eBW7JVsvsK_JQdUt2Dbvgw@mail.gmail.com>
 <b0c974a2-4e81-7855-7d4e-22834c5d8997@arm.com> <CAKv+Gu_ZzDbWwHVwOuoheXeN-ta_FjOT4Aj15=r56QZVTUK0FA@mail.gmail.com>
 <CAKv+Gu_wGk2Gdzd6WuOMZqz1tKHAWHL7pWm2Szyt0DZwPTCmOw@mail.gmail.com>
 <31443e6a-56b4-c4fb-82b1-b8eb5d7eebe1@arm.com> <CAGXu5jLj=KP038d-c+xzCx=Oogn1prH__oryQjNZZwNaAHaAAw@mail.gmail.com>
 <CAKv+Gu-9M0yO-rSXiREs11feEro0mJFcNN3Wkp_LSOGrKKd5dg@mail.gmail.com>
 <CAGXu5j+Tddmp_VgyvwTd+StEGtx=oGofeY+KpLD4OuPw+2=S2Q@mail.gmail.com> <CAKv+Gu-5ERHvqgXHR626QzKCZJPc0Cp5Ktv+gwucep5ZGvu9Vw@mail.gmail.com>
In-Reply-To: <CAKv+Gu-5ERHvqgXHR626QzKCZJPc0Cp5Ktv+gwucep5ZGvu9Vw@mail.gmail.com>
From: Mark Brand <markbrand@google.com>
Date: Mon, 6 Aug 2018 20:05:20 -0700
Message-ID: <CAN+XpFQCO1nr5tQ4oyPPaSfvnQSvwx-=JCtba2xJXrEN+6=LZg@mail.gmail.com>
Subject: Re: [RFC/PoC PATCH 0/3] arm64: basic ROP mitigation
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000d25b7c0572cfaaf2"
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Julien Thierry <julien.thierry@arm.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@fedoraproject.org>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

--000000000000d25b7c0572cfaaf2
Content-Type: multipart/alternative; boundary="000000000000cd50ff0572cfaa24"

--000000000000cd50ff0572cfaa24
Content-Type: text/plain; charset="UTF-8"

I think the phrasing of "limit kernel attack surface against ROP attacks"
is confusing and misleading. ROP does not describe a class of bugs,
vulnerabilities or attacks against the kernel - it's just one of many
code-reuse techniques that can be used by an attacker while exploiting a
vulnerability. But that's kind of off-topic!

I think what this thread is talking about is implementing extremely
coarse-grained reverse-edge control-flow-integrity, in that a return can
only return to the address following a legitimate call, but it can return
to any of those.

I suspect there's not much benefit to this, since (as far as I can see) the
assumption is that an attacker has the means to direct flow of execution as
far as taking complete control of the (el1) stack before executing any ROP
payload.

At that point, I think it's highly unlikely an attacker needs to chain
gadgets through return instructions at all - I suspect there are a few
places in the kernel where it is necessary to load the entire register
context from a register that is not the stack pointer, and it would likely
not be more than a minor inconvenience to an attacker to use these (and
chaining through branch register) instructions instead of chaining through
return instructions.

I'd have to take a closer look at an arm64 kernel image to be sure though -
I'll do that when I get a chance and update...

Regards,
Mark

On Mon, 6 Aug 2018 at 19:28, Ard Biesheuvel <ard.biesheuvel@linaro.org>
wrote:

> On 6 August 2018 at 21:50, Kees Cook <keescook@chromium.org> wrote:
> > On Mon, Aug 6, 2018 at 12:35 PM, Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> >> On 6 August 2018 at 20:49, Kees Cook <keescook@chromium.org> wrote:
> >>> On Mon, Aug 6, 2018 at 10:45 AM, Robin Murphy <robin.murphy@arm.com>
> wrote:
> >>>> I guess what I'm getting at is that if the protection mechanism is
> "always
> >>>> return with SP outside TTBR1", there seems little point in going
> through the
> >>>> motions if SP in TTBR0 could still be valid and allow an attack to
> succeed
> >>>> anyway; this is basically just me working through a justification for
> saying
> >>>> the proposed scheme needs "depends on ARM64_PAN ||
> ARM64_SW_TTBR0_PAN",
> >>>> making it that much uglier for v8.0 CPUs...
> >>>
> >>> I think anyone with v8.0 CPUs interested in this mitigation would also
> >>> very much want PAN emulation. If a "depends on" isn't desired, what
> >>> about "imply" in the Kconfig?
> >>>
> >>
> >> Yes, but actually, using bit #0 is maybe a better alternative in any
> >> case. You can never dereference SP with bit #0 set, regardless of
> >> whether the address points to user or kernel space, and my concern
> >> about reloading sp from x29 doesn't really make sense, given that x29
> >> is always assigned from sp right after pushing x29 and x30 in the
> >> function prologue, and sp only gets restored from x29 in the epilogue
> >> when there is a stack frame to begin with, in which case we add #1 to
> >> sp again before returning from the function.
> >
> > Fair enough! :)
> >
> >> The other code gets a lot cleaner as well.
> >>
> >> So for the return we'll have
> >>
> >>   ldp     x29, x30, [sp], #nn
> >>>>add     sp, sp, #0x1
> >>   ret
> >>
> >> and for the function call
> >>
> >>   bl      <foo>
> >>>>mov      x30, sp
> >>>>bic     sp, x30, #1
> >>
> >> The restore sequence in entry.s:96 (which has no spare registers) gets
> >> much simpler as well:
> >>
> >> --- a/arch/arm64/kernel/entry.S
> >> +++ b/arch/arm64/kernel/entry.S
> >> @@ -95,6 +95,15 @@ alternative_else_nop_endif
> >>          */
> >>         add     sp, sp, x0      // sp' = sp + x0
> >>         sub     x0, sp, x0      // x0' = sp' - x0 = (sp + x0) - x0 = sp
> >> +#ifdef CONFIG_ARM64_ROP_SHIELD
> >> +       tbnz    x0, #0, 1f
> >> +       .subsection     1
> >> +1:     sub     x0, x0, #1
> >> +       sub     sp, sp, #1
> >> +       b       2f
> >> +       .previous
> >> +2:
> >> +#endif
> >>         tbnz    x0, #THREAD_SHIFT, 0f
> >>         sub     x0, sp, x0      // x0'' = sp' - x0' = (sp + x0) - sp =
> x0
> >>         sub     sp, sp, x0      // sp'' = sp' - x0 = (sp + x0) - x0 = sp
> >
> > I get slightly concerned about "add" vs "clear bit", but I don't see a
> > real way to chain a lot of "add"s to get to avoid the unaligned
> > access. Is "or" less efficient than "add"?
> >
>
> Yes. The stack pointer is special on arm64, and can only be used with
> a limited set of ALU instructions. So orring #1 would involve 'mov
> <reg>, sp ; orr sp, <reg>, #1' like in the 'bic' case above, which
> requires a scratch register as well.
>

--000000000000cd50ff0572cfaa24
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><div dir=3D"auto">I think the phrasing of &quot;limit kernel attack su=
rface against ROP attacks&quot; is confusing and misleading. ROP does not d=
escribe a class of bugs, vulnerabilities or attacks against the kernel - it=
&#39;s just one of many code-reuse techniques that can be used by an attack=
er while exploiting a vulnerability. But that&#39;s kind of off-topic!</div=
><div dir=3D"auto"><br></div><div dir=3D"auto">I think what this thread is =
talking about is implementing extremely coarse-grained reverse-edge control=
-flow-integrity, in that a return can only return to the address following =
a legitimate call, but it can return to any of those.<br></div></div><div d=
ir=3D"auto"><br></div><div dir=3D"auto">I suspect there&#39;s not much bene=
fit to this, since (as far as I can see) the assumption is that an attacker=
 has the means to direct flow of execution as far as taking complete contro=
l of the (el1) stack before executing any ROP payload.=C2=A0</div><div dir=
=3D"auto"><br></div><div dir=3D"auto">At that point, I think it&#39;s highl=
y unlikely an attacker needs to chain gadgets through return instructions a=
t all - I suspect there are a few places in the kernel where it is necessar=
y to load the entire register context from a register that is not the stack=
 pointer, and it would likely not be more than a minor inconvenience to an =
attacker to use these (and chaining through branch register) instructions i=
nstead of chaining through return instructions.</div><div dir=3D"auto"><br>=
</div><div dir=3D"auto">I&#39;d have to take a closer look at an arm64 kern=
el image to be sure though - I&#39;ll do that when I get a chance and updat=
e...</div><div dir=3D"auto"><br></div><div dir=3D"auto">Regards,</div><div =
dir=3D"auto">Mark</div><div><br><div class=3D"gmail_quote"><div dir=3D"ltr"=
>On Mon, 6 Aug 2018 at 19:28, Ard Biesheuvel &lt;<a href=3D"mailto:ard.bies=
heuvel@linaro.org">ard.biesheuvel@linaro.org</a>&gt; wrote:<br></div><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">On 6 August 2018 at 21:50, Kees Cook &lt;<a href=
=3D"mailto:keescook@chromium.org" target=3D"_blank">keescook@chromium.org</=
a>&gt; wrote:<br>
&gt; On Mon, Aug 6, 2018 at 12:35 PM, Ard Biesheuvel<br>
&gt; &lt;<a href=3D"mailto:ard.biesheuvel@linaro.org" target=3D"_blank">ard=
.biesheuvel@linaro.org</a>&gt; wrote:<br>
&gt;&gt; On 6 August 2018 at 20:49, Kees Cook &lt;<a href=3D"mailto:keescoo=
k@chromium.org" target=3D"_blank">keescook@chromium.org</a>&gt; wrote:<br>
&gt;&gt;&gt; On Mon, Aug 6, 2018 at 10:45 AM, Robin Murphy &lt;<a href=3D"m=
ailto:robin.murphy@arm.com" target=3D"_blank">robin.murphy@arm.com</a>&gt; =
wrote:<br>
&gt;&gt;&gt;&gt; I guess what I&#39;m getting at is that if the protection =
mechanism is &quot;always<br>
&gt;&gt;&gt;&gt; return with SP outside TTBR1&quot;, there seems little poi=
nt in going through the<br>
&gt;&gt;&gt;&gt; motions if SP in TTBR0 could still be valid and allow an a=
ttack to succeed<br>
&gt;&gt;&gt;&gt; anyway; this is basically just me working through a justif=
ication for saying<br>
&gt;&gt;&gt;&gt; the proposed scheme needs &quot;depends on ARM64_PAN || AR=
M64_SW_TTBR0_PAN&quot;,<br>
&gt;&gt;&gt;&gt; making it that much uglier for v8.0 CPUs...<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I think anyone with v8.0 CPUs interested in this mitigation wo=
uld also<br>
&gt;&gt;&gt; very much want PAN emulation. If a &quot;depends on&quot; isn&=
#39;t desired, what<br>
&gt;&gt;&gt; about &quot;imply&quot; in the Kconfig?<br>
&gt;&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; Yes, but actually, using bit #0 is maybe a better alternative in a=
ny<br>
&gt;&gt; case. You can never dereference SP with bit #0 set, regardless of<=
br>
&gt;&gt; whether the address points to user or kernel space, and my concern=
<br>
&gt;&gt; about reloading sp from x29 doesn&#39;t really make sense, given t=
hat x29<br>
&gt;&gt; is always assigned from sp right after pushing x29 and x30 in the<=
br>
&gt;&gt; function prologue, and sp only gets restored from x29 in the epilo=
gue<br>
&gt;&gt; when there is a stack frame to begin with, in which case we add #1=
 to<br>
&gt;&gt; sp again before returning from the function.<br>
&gt;<br>
&gt; Fair enough! :)<br>
&gt;<br>
&gt;&gt; The other code gets a lot cleaner as well.<br>
&gt;&gt;<br>
&gt;&gt; So for the return we&#39;ll have<br>
&gt;&gt;<br>
&gt;&gt;=C2=A0 =C2=A0ldp=C2=A0 =C2=A0 =C2=A0x29, x30, [sp], #nn<br>
&gt;&gt;&gt;&gt;add=C2=A0 =C2=A0 =C2=A0sp, sp, #0x1<br>
&gt;&gt;=C2=A0 =C2=A0ret<br>
&gt;&gt;<br>
&gt;&gt; and for the function call<br>
&gt;&gt;<br>
&gt;&gt;=C2=A0 =C2=A0bl=C2=A0 =C2=A0 =C2=A0 &lt;foo&gt;<br>
&gt;&gt;&gt;&gt;mov=C2=A0 =C2=A0 =C2=A0 x30, sp<br>
&gt;&gt;&gt;&gt;bic=C2=A0 =C2=A0 =C2=A0sp, x30, #1<br>
&gt;&gt;<br>
&gt;&gt; The restore sequence in entry.s:96 (which has no spare registers) =
gets<br>
&gt;&gt; much simpler as well:<br>
&gt;&gt;<br>
&gt;&gt; --- a/arch/arm64/kernel/entry.S<br>
&gt;&gt; +++ b/arch/arm64/kernel/entry.S<br>
&gt;&gt; @@ -95,6 +95,15 @@ alternative_else_nop_endif<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0add=C2=A0 =C2=A0 =C2=A0sp, sp, x0=
=C2=A0 =C2=A0 =C2=A0 // sp&#39; =3D sp + x0<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sub=C2=A0 =C2=A0 =C2=A0x0, sp, x0=
=C2=A0 =C2=A0 =C2=A0 // x0&#39; =3D sp&#39; - x0 =3D (sp + x0) - x0 =3D sp<=
br>
&gt;&gt; +#ifdef CONFIG_ARM64_ROP_SHIELD<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0tbnz=C2=A0 =C2=A0 x0, #0, 1f<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0.subsection=C2=A0 =C2=A0 =C2=A01<br>
&gt;&gt; +1:=C2=A0 =C2=A0 =C2=A0sub=C2=A0 =C2=A0 =C2=A0x0, x0, #1<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0sub=C2=A0 =C2=A0 =C2=A0sp, sp, #1<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0b=C2=A0 =C2=A0 =C2=A0 =C2=A02f<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0.previous<br>
&gt;&gt; +2:<br>
&gt;&gt; +#endif<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tbnz=C2=A0 =C2=A0 x0, #THREAD_SHI=
FT, 0f<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sub=C2=A0 =C2=A0 =C2=A0x0, sp, x0=
=C2=A0 =C2=A0 =C2=A0 // x0&#39;&#39; =3D sp&#39; - x0&#39; =3D (sp + x0) - =
sp =3D x0<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sub=C2=A0 =C2=A0 =C2=A0sp, sp, x0=
=C2=A0 =C2=A0 =C2=A0 // sp&#39;&#39; =3D sp&#39; - x0 =3D (sp + x0) - x0 =
=3D sp<br>
&gt;<br>
&gt; I get slightly concerned about &quot;add&quot; vs &quot;clear bit&quot=
;, but I don&#39;t see a<br>
&gt; real way to chain a lot of &quot;add&quot;s to get to avoid the unalig=
ned<br>
&gt; access. Is &quot;or&quot; less efficient than &quot;add&quot;?<br>
&gt;<br>
<br>
Yes. The stack pointer is special on arm64, and can only be used with<br>
a limited set of ALU instructions. So orring #1 would involve &#39;mov<br>
&lt;reg&gt;, sp ; orr sp, &lt;reg&gt;, #1&#39; like in the &#39;bic&#39; ca=
se above, which<br>
requires a scratch register as well.<br>
</blockquote></div></div>

--000000000000cd50ff0572cfaa24--

--000000000000d25b7c0572cfaaf2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIS7QYJKoZIhvcNAQcCoIIS3jCCEtoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghBTMIIEXDCCA0SgAwIBAgIOSBtqDm4P/739RPqw/wcwDQYJKoZIhvcNAQELBQAwZDELMAkGA1UE
BhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExOjA4BgNVBAMTMUdsb2JhbFNpZ24gUGVy
c29uYWxTaWduIFBhcnRuZXJzIENBIC0gU0hBMjU2IC0gRzIwHhcNMTYwNjE1MDAwMDAwWhcNMjEw
NjE1MDAwMDAwWjBMMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEiMCAG
A1UEAxMZR2xvYmFsU2lnbiBIViBTL01JTUUgQ0EgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBALR23lKtjlZW/17kthzYcMHHKFgywfc4vLIjfq42NmMWbXkNUabIgS8KX4PnIFsTlD6F
GO2fqnsTygvYPFBSMX4OCFtJXoikP2CQlEvO7WooyE94tqmqD+w0YtyP2IB5j4KvOIeNv1Gbnnes
BIUWLFxs1ERvYDhmk+OrvW7Vd8ZfpRJj71Rb+QQsUpkyTySaqALXnyztTDp1L5d1bABJN/bJbEU3
Hf5FLrANmognIu+Npty6GrA6p3yKELzTsilOFmYNWg7L838NS2JbFOndl+ce89gM36CW7vyhszi6
6LqqzJL8MsmkP53GGhf11YMP9EkmawYouMDP/PwQYhIiUO0CAwEAAaOCASIwggEeMA4GA1UdDwEB
/wQEAwIBBjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwEgYDVR0TAQH/BAgwBgEB/wIB
ADAdBgNVHQ4EFgQUyzgSsMeZwHiSjLMhleb0JmLA4D8wHwYDVR0jBBgwFoAUJiSSix/TRK+xsBtt
r+500ox4AAMwSwYDVR0fBEQwQjBAoD6gPIY6aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9ncy9n
c3BlcnNvbmFsc2lnbnB0bnJzc2hhMmcyLmNybDBMBgNVHSAERTBDMEEGCSsGAQQBoDIBKDA0MDIG
CCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzANBgkqhkiG
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
QAYIKwYBBQUHMAKGNGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzaHZzbWlt
ZWNhMS5jcnQwHQYDVR0OBBYEFHBSBDmApw3Xi49XlWZD2iFby5ooMB8GA1UdIwQYMBaAFMs4ErDH
mcB4koyzIZXm9CZiwOA/MEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMDsGA1UdHwQ0MDIwMKAuoCyGKmh0
dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NodnNtaW1lY2ExLmNybDAOBgNVHQ8BAf8EBAMCBaAw
HQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMA0GCSqGSIb3DQEBCwUAA4IBAQCEWxDOz17X
hCYX+4CFh1LQ/77xHmLszAWtuLH4ALDk5P4Wf8vqCwwrlSx0LieV7aGCVklDAwhIa0MeWIa5Wsz+
laequtNQBc2UmnR6okDSnbUBC9MFU11ZQHp66esFXr3svRJUfCVDJ3GR5V3xRAjoJm60hnYK/ypz
rxH6JYeCbsbIxFrly2wF6vYsVXN3+fk351T4z40wrZnbaptm4RI2WsXSDfW7Gq28MyYHyXYra5Yu
kG0zqLbYqxHpnunzHMl/ucHXEr86qs7kyUVoFh3CMnDy497xbm59ihRV429OGCFYW3Qz5NY6SxIA
AT6/iI5s2Jr/GEwMCSFPJyDOeNiEMYICXjCCAloCAQEwXDBMMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEiMCAGA1UEAxMZR2xvYmFsU2lnbiBIViBTL01JTUUgQ0EgMQIM
I4UvjeJfrNd3XgIDMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCALJ4b8WiEndyLy
cFe8Kf5B5XffzalJoE7XHlR1kkFsCDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0xODA4MDcwMzA1MzNaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCG
SAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEB
BzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAK4HNIPPh/wanJMj/oVMl8xkAw3MQgu7O
0X1NZsHA2IwgLFoddwIVc/bv6lZycOSiS3/TOdEVJgZ7Wf8afTVOtM5DZnCXvsVZu19Lk3XMlPtO
LW8UOQJNKfr2l/X0Ij+XcohYOOlcI2bwdc7E/GWPIKAK5+gdV0+y5JVraoieFKTy8NzOpmGxq2B4
j4o8pnK7YNJxhVRN2ipw7lThLSN7i4wGsbkzw4EdL3axmneNohcrsK+szw7NfrcXMvA7cCozFLry
a0hxEx6xGjQwfCTd61yEC+mvourqhJu3gFl7OCFCOIY6wv55DTIi7HQVxhwCdd4ZKEV0X8WfX0Je
ubzG+A==
--000000000000d25b7c0572cfaaf2--
