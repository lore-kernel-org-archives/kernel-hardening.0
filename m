Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJofXU-KsZ+1vxHHKHQFcVv5YSi1wtx3DR0sAZto-NvsQ@mail.gmail.com>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com>
 <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com>
 <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com> <CAGXu5jJofXU-KsZ+1vxHHKHQFcVv5YSi1wtx3DR0sAZto-NvsQ@mail.gmail.com>
From: Shubham Bansal <illusionist.neo@gmail.com>
Date: Tue, 12 Jul 2016 18:55:39 +0530
Message-ID: <CAHgaXdJ_kTp7u1tEr4VTLyw7nVyz_L5P7WcuO2=WLtpE_CdeKw@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a114040a87a457e053770343c
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Daniel Borkmann <daniel@iogearbox.net>
List-ID: <kernel-hardening.lists.openwall.com>

--001a114040a87a457e053770343c
Content-Type: text/plain; charset=UTF-8

Hi,

On Tue, Jul 12, 2016 at 12:22 AM, Kees Cook <keescook@chromium.org> wrote:

> On Sun, Jul 10, 2016 at 12:04 PM, Shubham Bansal
> <illusionist.neo@gmail.com> wrote:
> > Hi Kees,
> >
> > Sorry for the late reply. I am having some problems with arranging a lot
> of
> > mails from the list.
>
> No worries! Glad to have you interested in the discussions. :)
>
> >
> > On Wed, Jul 6, 2016 at 11:05 PM, Kees Cook <keescook@chromium.org>
> wrote:
> >> On Wed, Jul 6, 2016 at 10:40 AM, Shubham Bansal
> >> <illusionist.neo@gmail.com> wrote:
> >>> Hi guys,
> >>>
> >>> I want to start with linux kernel development and looking for some
> >>> project
> >>> where I can contribute. I was looking at
> >>> http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project which
> >>> asked
> >>> to introduce myself on the list if I am looking for some work (thats
> what
> >>> I
> >>> am doing :) ). It would be highly appreciated if any of you guys have
> >>> something where I can contribute.
> >>>
> >>> Best,
> >>> Shubham Bansal
> >>
> >> Welcome to the fun! :)
> >>
> >> What things are you generally interested in?
> >
> > Well, I don't have any preference as such. I am open to any work that is
> > related to security. I have just graduated from the college. I have
> > background in Crypto, Reverse engg. and exploit development. But if you
> need
> > a specific topic, I would say I want to add some features from
> grsecurity to
> > main linux kernel.
>
> That's ultimately where a lot of the work comes from: most of the
> interesting protections have an implementation in the grsecurity
> patch, but tends not to be in a form that is easily upstreamed.
>
Okay. I can try to add those protections to the main kernel.

>
> >> Do you have familiarity
> >> with a specific architecture (or do you want to _gain_ familiarity
> >> with a specific architecture)?
> >
> > I have a good familiarity with x86,x86-64 but I also know arm. Although,
> its
> > not a problem if there is a need, I will read about it.
>
> If you want to poke at tricky/hard arch-specific issues, I'd love to
> see ARMv8.1's PAN emulated on ARMv8.0. That one looks to be possible,
> but tricky to find all the right ways to handle it.
>
> If you're really feeling adventurous, I'd love to see the PaX's UDEREF
> feature on x86_64 implemented in upstream.
>
Okay. I can work on PaX's UDEREF feature now (if it's needed?) and keep on
reading about the ARMv8.0's PAN emulation. I will pick up the ARMv8.0's PAN
emulation later when I have enough knowledge about it.

>
> >> There's a small list of stuff that is related to the larger project
> >> pieces that I try to keep up to date, of varying difficulty:
> >>
> >>
> >>
> http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project#Specific_TODO_Items
> >
> > All of these sounds interesting to me. Although I didn't fully understand
> > some of the TODO items but few of these which I think I would like to
> work :
> >
> > Move kernel stack to vmap area
>
> This one is under way by Andy Lutomirski for x86, but it'd be great to
> see it done on arm and arm64 or other architectures.
>

> > Split thread_info off of kernel stack
>
> This is in progress for x86 too, but again, we need it for other
> architectures.
>
> > Convert remaining BPF JITs to eBPF JIT (with blinding)
>
> This would be nice for gaining BPF performance on the architectures
> that don't support the JIT currently.
>
I can work on this if its needed. I want to pick up the arm related
features later when I have enough knowledge about the arm.

>
> > Write lib/test_bpf.c tests for eBPF constant blinding
>
> And this is good for testing the eBPF JIT blinding -- right now it's
> kind of a manual check, and that makes me nervous since it's harder to
> notice regressions.
>
> (I've added Daniel Borkmann and Elena Reshetova to CC, since they
> could help direct you with the BPF work.)
>
> > But, I can work on other things also, whatever you think is appropriate.
> I
> > would prefer working on challenging project though.
>
> If you can solve the PAN emulation on ARMv8.0, that would be very
> valuable -- most newer phones and tablets are moving to arm64, and
> none are ARMv8.1, so they only have PXN and no PAN (where as 32-bit
> arm can do full PAN emulation with Domains right now, so there's this
> weird gap where we're actually going to regress in memory protections
> for a few years until everything is shipping with ARMv8.1 devices).
>
 I am not confident about my knowledge of arm as of now but if needed I can
pick it up.

>
> > Hoping for a quick reply. I want to start working as soon as possible.
>
> Hopefully this is quick enough. :)
>
> -Kees
>
> --
> Kees Cook
> Chrome OS & Brillo Security
>
So overall I have 3 options :

   - PaX's UDEREF feature - I want to work on this if its needed
   - PAN emulation on ARMv8.0 - My second preference would be this.
   - Convert remaining BPF JITs to eBPF JIT (with blinding) - Happy to do
   it if need
   - Move kernel stack to vmap area for arm - Want to keep it for later.

Let me know what you would suggest. I am still a beginner so don't know how
much work and knowledge they would need. I don't want to stuck in the
middle if the things get tough.


Best,

Shubham Bansal

--001a114040a87a457e053770343c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br><div><div class=3D"gmail_extra"><div class=3D"g=
mail_quote">On Tue, Jul 12, 2016 at 12:22 AM, Kees Cook <span dir=3D"ltr">&=
lt;<a href=3D"mailto:keescook@chromium.org" target=3D"_blank">keescook@chro=
mium.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex"><span class=3D"">On Sun, Jul 10, 2016 at 12:04 PM, Shubham Bansa=
l<br>
&lt;<a href=3D"mailto:illusionist.neo@gmail.com">illusionist.neo@gmail.com<=
/a>&gt; wrote:<br>
&gt; Hi Kees,<br>
&gt;<br>
&gt; Sorry for the late reply. I am having some problems with arranging a l=
ot of<br>
&gt; mails from the list.<br>
<br>
</span>No worries! Glad to have you interested in the discussions. :)<br>
<span class=3D""><br>
&gt;<br>
&gt; On Wed, Jul 6, 2016 at 11:05 PM, Kees Cook &lt;<a href=3D"mailto:keesc=
ook@chromium.org">keescook@chromium.org</a>&gt; wrote:<br>
&gt;&gt; On Wed, Jul 6, 2016 at 10:40 AM, Shubham Bansal<br>
&gt;&gt; &lt;<a href=3D"mailto:illusionist.neo@gmail.com">illusionist.neo@g=
mail.com</a>&gt; wrote:<br>
&gt;&gt;&gt; Hi guys,<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I want to start with linux kernel development and looking for =
some<br>
&gt;&gt;&gt; project<br>
&gt;&gt;&gt; where I can contribute. I was looking at<br>
&gt;&gt;&gt; <a href=3D"http://kernsec.org/wiki/index.php/Kernel_Self_Prote=
ction_Project" rel=3D"noreferrer" target=3D"_blank">http://kernsec.org/wiki=
/index.php/Kernel_Self_Protection_Project</a> which<br>
&gt;&gt;&gt; asked<br>
&gt;&gt;&gt; to introduce myself on the list if I am looking for some work =
(thats what<br>
&gt;&gt;&gt; I<br>
&gt;&gt;&gt; am doing :) ). It would be highly appreciated if any of you gu=
ys have<br>
&gt;&gt;&gt; something where I can contribute.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Best,<br>
&gt;&gt;&gt; Shubham Bansal<br>
&gt;&gt;<br>
&gt;&gt; Welcome to the fun! :)<br>
&gt;&gt;<br>
&gt;&gt; What things are you generally interested in?<br>
&gt;<br>
&gt; Well, I don&#39;t have any preference as such. I am open to any work t=
hat is<br>
&gt; related to security. I have just graduated from the college. I have<br=
>
&gt; background in Crypto, Reverse engg. and exploit development. But if yo=
u need<br>
&gt; a specific topic, I would say I want to add some features from grsecur=
ity to<br>
&gt; main linux kernel.<br>
<br>
</span>That&#39;s ultimately where a lot of the work comes from: most of th=
e<br>
interesting protections have an implementation in the grsecurity<br>
patch, but tends not to be in a form that is easily upstreamed.<br></blockq=
uote><div>Okay. I can try to add those protections to the main kernel.<br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left:1px solid rgb(204,204,204);padding-left:1ex">
<span class=3D""><br>
&gt;&gt; Do you have familiarity<br>
&gt;&gt; with a specific architecture (or do you want to _gain_ familiarity=
<br>
&gt;&gt; with a specific architecture)?<br>
&gt;<br>
&gt; I have a good familiarity with x86,x86-64 but I also know arm. Althoug=
h, its<br>
&gt; not a problem if there is a need, I will read about it.<br>
<br>
</span>If you want to poke at tricky/hard arch-specific issues, I&#39;d lov=
e to<br>
see ARMv8.1&#39;s PAN emulated on ARMv8.0. That one looks to be possible,<b=
r>
but tricky to find all the right ways to handle it.<br>
<br>
If you&#39;re really feeling adventurous, I&#39;d love to see the PaX&#39;s=
 UDEREF<br>
feature on x86_64 implemented in upstream.<br></blockquote><div>Okay. I can=
 work on PaX&#39;s UDEREF feature now (if it&#39;s needed?) and keep on rea=
ding about the ARMv8.0&#39;s PAN emulation. I will pick up the ARMv8.0&#39;=
s PAN emulation later when I have enough knowledge about it.<br></div><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:=
1px solid rgb(204,204,204);padding-left:1ex">
<span class=3D""><br>
&gt;&gt; There&#39;s a small list of stuff that is related to the larger pr=
oject<br>
&gt;&gt; pieces that I try to keep up to date, of varying difficulty:<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; <a href=3D"http://kernsec.org/wiki/index.php/Kernel_Self_Protectio=
n_Project#Specific_TODO_Items" rel=3D"noreferrer" target=3D"_blank">http://=
kernsec.org/wiki/index.php/Kernel_Self_Protection_Project#Specific_TODO_Ite=
ms</a><br>
&gt;<br>
&gt; All of these sounds interesting to me. Although I didn&#39;t fully und=
erstand<br>
&gt; some of the TODO items but few of these which I think I would like to =
work :<br>
&gt;<br>
&gt; Move kernel stack to vmap area<br>
<br>
</span>This one is under way by Andy Lutomirski for x86, but it&#39;d be gr=
eat to<br>
see it done on arm and arm64 or other architectures.<br></blockquote><block=
quote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1=
px solid rgb(204,204,204);padding-left:1ex">
<span class=3D""><br>
&gt; Split thread_info off of kernel stack<br>
<br>
</span>This is in progress for x86 too, but again, we need it for other arc=
hitectures.<br>
<span class=3D""><br>
&gt; Convert remaining BPF JITs to eBPF JIT (with blinding)<br>
<br>
</span>This would be nice for gaining BPF performance on the architectures<=
br>
that don&#39;t support the JIT currently.<br></blockquote><div>I can work o=
n this if its needed. I want to pick up the arm related features later when=
 I have enough knowledge about the arm. <br></div><blockquote class=3D"gmai=
l_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,20=
4,204);padding-left:1ex">
<span class=3D""><br>
&gt; Write lib/test_bpf.c tests for eBPF constant blinding<br>
<br>
</span>And this is good for testing the eBPF JIT blinding -- right now it&#=
39;s<br>
kind of a manual check, and that makes me nervous since it&#39;s harder to<=
br>
notice regressions.<br>
<br>
(I&#39;ve added Daniel Borkmann and Elena Reshetova to CC, since they<br>
could help direct you with the BPF work.)<br>
<span class=3D""><br>
&gt; But, I can work on other things also, whatever you think is appropriat=
e. I<br>
&gt; would prefer working on challenging project though.<br>
<br>
</span>If you can solve the PAN emulation on ARMv8.0, that would be very<br=
>
valuable -- most newer phones and tablets are moving to arm64, and<br>
none are ARMv8.1, so they only have PXN and no PAN (where as 32-bit<br>
arm can do full PAN emulation with Domains right now, so there&#39;s this<b=
r>
weird gap where we&#39;re actually going to regress in memory protections<b=
r>
for a few years until everything is shipping with ARMv8.1 devices).<br></bl=
ockquote><div>=C2=A0I am not confident about my knowledge of arm as of now =
but if needed I can pick it up.<br></div><blockquote class=3D"gmail_quote" =
style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);pa=
dding-left:1ex">
<span class=3D""><br>
&gt; Hoping for a quick reply. I want to start working as soon as possible.=
<br>
<br>
</span>Hopefully this is quick enough. :)<br>
<div class=3D""><div class=3D"h5"><br>
-Kees<br>
<br>
--<br>
Kees Cook<br>
Chrome OS &amp; Brillo Security<br></div></div></blockquote><div>So overall=
 I have 3 options :<br><ul><li>PaX&#39;s UDEREF feature - I want to work on=
 this if its needed<br></li><li>PAN emulation on ARMv8.0 - My second prefer=
ence would be this.<br></li><li><span class=3D"">Convert remaining BPF JITs=
 to eBPF JIT (with blinding)</span> - Happy to do it if need<br></li><li><s=
pan class=3D"">Move kernel stack to vmap area for arm - Want to keep it for=
 later.</span></li></ul><p>Let me know what you would suggest. I am still a=
 beginner so don&#39;t know how much work and knowledge they would need. I =
don&#39;t want to stuck in the middle if the things get tough.</p><p><br></=
p><p>Best,</p><p>Shubham Bansal<br></p></div></div></div></div></div>

--001a114040a87a457e053770343c--
