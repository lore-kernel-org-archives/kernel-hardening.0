MIME-Version: 1.0
References: <CABgxDo+x3r=8HFxyM89HAc_FdY6+kBpJR5RpAgpOYsu0xZtshQ@mail.gmail.com>
 <CABgxDoJ-ue6HKyBR_q8cmbOp8DFnZDVf7zbxv8_wmHh7uis_vw@mail.gmail.com>
 <CAOfkYf4OxG-vkCOoWvmGxyRg3UVFcGszkdStKSoXf5qqyF_RQA@mail.gmail.com>
 <CABgxDoLe3fXNLob3pnj7Nn2v54Htqr+cg5gRRQPxFK7HPX85=Q@mail.gmail.com>
 <201906072117.A1C045C@keescook> <CAOfkYf40dzGm5qhEqMDJOHEHr0Zbw9KDT93QAPfb_jHEqWNu0g@mail.gmail.com>
In-Reply-To: <CAOfkYf40dzGm5qhEqMDJOHEHr0Zbw9KDT93QAPfb_jHEqWNu0g@mail.gmail.com>
From: Romain Perier <romain.perier@gmail.com>
Date: Sat, 8 Jun 2019 10:16:57 +0200
Message-ID: <CABgxDo+=rhCmn2qaGGM06TgDnaBZKi-kUjwg9cSq=+1XQOvBxg@mail.gmail.com>
Subject: Re: Get involved
Content-Type: multipart/alternative; boundary="000000000000badc3e058acb926a"
To: Shyam Saini <mayhs11saini@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--000000000000badc3e058acb926a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for these details.

Yeah if this is okay for you , I will pick the task for NLA_STRING . I can
mark it as WIP on the Wiki.

Regards,
Romain

Le sam. 8 juin 2019 =C3=A0 08:02, Shyam Saini <mayhs11saini@gmail.com> a =
=C3=A9crit :

> Hi Kees,
>
> >
> > Hi! Sorry for the late reply: I've been travelling this week. :P
>
> > > Okay, np. I will select another one then :) (hehe that's the game ;) =
)
> > >
> > > @Kees: do you have something in mind (as a new task) ?
> > Shyam, you'd also started FIELD_SIZEOF refactoring, but never sent a v2
> > patch if I was following correctly? Is there one or the other of these
> > tasks you'd like help with?
> https://patchwork.kernel.org/patch/10900187/
>
> sorry for being too late.
>
> You assigned me 3 tasks
> 1) FIELD_SIZEOF
> 2) WARN on kfree() of ERR_PTR range
> 3) NLA_STRING
>
> I'll send patches for task 1 and 2 today or tomorrow.
>
> If Roman is taking NLA_STRING task, I'd pick some other once i send
> patches for 1 and 2.
>
>
> > Romain, what do you think about reviewing NLA code? I'd mentioned a
> > third task here:
> > https://www.openwall.com/lists/kernel-hardening/2019/04/17/8
> >
> > Quoting...
> >
> >
> > - audit and fix all misuse of NLA_STRING
> >
> > This is a following up on noticing the misuse of NLA_STRING (no NUL
> > terminator), getting used with regular string functions (that expect a
> > NUL termination):
> >
> https://lore.kernel.org/lkml/1519329289.2637.12.camel@sipsolutions.net/T/=
#u
> >
> > It'd be nice if someone could inspect all the NLA_STRING
> > representations and find if there are any other problems like this
> > (and see if there was a good way to systemically fix the problem).
> >
> >
> >
> > For yet another idea would be to get syzkaller[1] set up and enable
> > integer overflow detection (by adding
> "-fsanitize=3Dsigned-integer-overflow"
> > to KBUILD_CFLAGS) and start finding and fixes cases like this[2].
> >
> > Thanks and let me know what you think!
> >
> > -Kees
> >
> > [1] https://github.com/google/syzkaller/blob/master/docs/linux/setup.md
> > [2] https://lore.kernel.org/lkml/20180824215439.GA46785@beast/
> >
> >
> > --
> > Kees Cook
>

--000000000000badc3e058acb926a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><div dir=3D"auto">Hi,</div></div><div dir=3D"auto"><br></div><div dir=
=3D"auto">Thanks for these details.</div><div dir=3D"auto"><br></div><div d=
ir=3D"auto">Yeah if this is okay for you , I will pick the task for NLA_STR=
ING . I can mark it as WIP on the Wiki.</div><div dir=3D"auto"><br></div><d=
iv dir=3D"auto">Regards,</div><div dir=3D"auto">Romain</div><div><br><div c=
lass=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">Le=C2=A0sam. 8 j=
uin 2019 =C3=A0 08:02, Shyam Saini &lt;<a href=3D"mailto:mayhs11saini@gmail=
.com">mayhs11saini@gmail.com</a>&gt; a =C3=A9crit=C2=A0:<br></div><blockquo=
te class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc so=
lid;padding-left:1ex">Hi Kees,<br>
<br>
&gt;<br>
&gt; Hi! Sorry for the late reply: I&#39;ve been travelling this week. :P<b=
r>
<br>
&gt; &gt; Okay, np. I will select another one then :) (hehe that&#39;s the =
game ;) )<br>
&gt; &gt;<br>
&gt; &gt; @Kees: do you have something in mind (as a new task) ?<br>
&gt; Shyam, you&#39;d also started FIELD_SIZEOF refactoring, but never sent=
 a v2<br>
&gt; patch if I was following correctly? Is there one or the other of these=
<br>
&gt; tasks you&#39;d like help with?=C2=A0 <a href=3D"https://patchwork.ker=
nel.org/patch/10900187/" rel=3D"noreferrer" target=3D"_blank">https://patch=
work.kernel.org/patch/10900187/</a><br>
<br>
sorry for being too late.<br>
<br>
You assigned me 3 tasks<br>
1) FIELD_SIZEOF<br>
2) WARN on kfree() of ERR_PTR range<br>
3) NLA_STRING<br>
<br>
I&#39;ll send patches for task 1 and 2 today or tomorrow.<br>
<br>
If Roman is taking NLA_STRING task, I&#39;d pick some other once i send<br>
patches for 1 and 2.<br>
<br>
<br>
&gt; Romain, what do you think about reviewing NLA code? I&#39;d mentioned =
a<br>
&gt; third task here:<br>
&gt; <a href=3D"https://www.openwall.com/lists/kernel-hardening/2019/04/17/=
8" rel=3D"noreferrer" target=3D"_blank">https://www.openwall.com/lists/kern=
el-hardening/2019/04/17/8</a><br>
&gt;<br>
&gt; Quoting...<br>
&gt;<br>
&gt;<br>
&gt; - audit and fix all misuse of NLA_STRING<br>
&gt;<br>
&gt; This is a following up on noticing the misuse of NLA_STRING (no NUL<br=
>
&gt; terminator), getting used with regular string functions (that expect a=
<br>
&gt; NUL termination):<br>
&gt; <a href=3D"https://lore.kernel.org/lkml/1519329289.2637.12.camel@sipso=
lutions.net/T/#u" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.=
org/lkml/1519329289.2637.12.camel@sipsolutions.net/T/#u</a><br>
&gt;<br>
&gt; It&#39;d be nice if someone could inspect all the NLA_STRING<br>
&gt; representations and find if there are any other problems like this<br>
&gt; (and see if there was a good way to systemically fix the problem).<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; For yet another idea would be to get syzkaller[1] set up and enable<br=
>
&gt; integer overflow detection (by adding &quot;-fsanitize=3Dsigned-intege=
r-overflow&quot;<br>
&gt; to KBUILD_CFLAGS) and start finding and fixes cases like this[2].<br>
&gt;<br>
&gt; Thanks and let me know what you think!<br>
&gt;<br>
&gt; -Kees<br>
&gt;<br>
&gt; [1] <a href=3D"https://github.com/google/syzkaller/blob/master/docs/li=
nux/setup.md" rel=3D"noreferrer" target=3D"_blank">https://github.com/googl=
e/syzkaller/blob/master/docs/linux/setup.md</a><br>
&gt; [2] <a href=3D"https://lore.kernel.org/lkml/20180824215439.GA46785@bea=
st/" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/lkml/2018=
0824215439.GA46785@beast/</a><br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; Kees Cook<br>
</blockquote></div></div>

--000000000000badc3e058acb926a--
