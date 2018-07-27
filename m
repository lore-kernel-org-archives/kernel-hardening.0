MIME-Version: 1.0
In-Reply-To: <20180727143141.4b53d554@gandalf.local.home>
References: <20180725202238.165314-1-salyzyn@android.com> <20180725210717.3b807191@vmware.local.home>
 <11437c3e-5131-7190-c496-7b51eb7fcc2a@android.com> <20180726153153.GA8327@kroah.com>
 <CAKwvOdk9s+=kUwcPGQzZNxR7eOGAiiasAyWhZxgKom4_6h+oxA@mail.gmail.com>
 <20180726181558.25a5c3b8@gandalf.local.home> <753E9YR1QhdsPhsFoYuXCwfUzfyntDrc_A93hMUkktMi7lbh3KUZMcbfqKVWUfi15zYhuiDFant-ROa4QNV5shx74ff4hGngq2BOJDv-hq4=@protonmail.ch>
 <CAG48ez1U=5nTOrnOqwMuXhdER-7XxJUYLcyYNuczwasQLQ0gXA@mail.gmail.com>
 <20180727094730.3a448629@gandalf.local.home> <CAKwvOdmg4DSSwy9YBccYWzc+6ZU2yKSSFmfnj72wqbYDJU0gzw@mail.gmail.com>
 <20180727143141.4b53d554@gandalf.local.home>
From: Mark Salyzyn <salyzyn@google.com>
Date: Fri, 27 Jul 2018 11:41:05 -0700
Message-ID: <CAMx4XWv3OazvURuN1XU2+5C5tNDzPuTniMn_T=XTA4P8_uwS_A@mail.gmail.com>
Subject: Re: [PATCH] tracing: do not leak kernel addresses
Content-Type: multipart/alternative; boundary="0000000000005830330571ff7440"
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, Golden_Miller83@protonmail.ch, greg@kroah.com, Kees Cook <keescook@google.com>, Mark Salyzyn <salyzyn@android.com>, LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com, Android Kernel Team <kernel-team@android.com>, stable@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--0000000000005830330571ff7440
Content-Type: text/plain; charset="UTF-8"

Any system can chose to change the permissions of a sysfs node, default,
DAC (and MAC) is just layers of multi-level security (or lack thereof). As
well intentioned as a default DAC is in the kernel, leaking kernel
addresses is still an attack surface that we want to close tightly.

For instance on Android:

     chmod 0755 /sys/kernel/debug/tracing

is in the common init.rc file ...

If DAC has been adjusted at runtime to permit access to the node, I would
think that if the caller does not have all the credentials/capabilities, we
do want the addresses to be abstracted by the kernel.

-- Mark

On Fri, Jul 27, 2018 at 11:31 AM, Steven Rostedt <rostedt@goodmis.org>
wrote:

> On Fri, 27 Jul 2018 11:13:51 -0700
> Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> > I found the internal bug report (reported Jan '17, you'll have to
> > forgive me if my memory of the issue is hazy, or if the fix used at
> > the time wasn't perfect), which was reported against the Nexus 6.
> > >From the report, it was possible to `cat
> > /sys/kernel/debug/tracing/printk_formats` without being root, which I
> > can't do on my workstations much more modern kernel (Nexus 6 was
> > 3.10).  So I guess the question is what governs access to files below
> > /sys/kernel/debug, and why was it missing from those kernels?  I
> > assume some check was added, but either not backported to 3.10 stable
> > (or more likely not pulled in to Nexus 6's kernel through stable;
> > Android is now in a much better place for that kind of issue).
>
> As of commit 82aceae4f0d4 ("debugfs: more tightly restrict default
> mount mode") /sys/kernel/debug has been default mounted as 0700 (root
> only). But that was introduced in 3.7. Not sure why your 3.10 kernel
> didn't have that. Perhaps there's another commit that fixed
> permissions not being inherited?
>
> -- Steve
>
> --
> You received this message because you are subscribed to the Google Groups
> "kernel-team" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to kernel-team+unsubscribe@android.com.
>
>

--0000000000005830330571ff7440
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Any system can chose to change the permissions of a sysfs =
node, default, DAC (and MAC) is just layers of multi-level security (or lac=
k thereof). As well intentioned as a default DAC is in the kernel, leaking =
kernel addresses is still an attack surface that we want to close tightly.<=
div><br></div><div>For instance on Android:</div><div><br></div><div>=C2=A0=
 =C2=A0 =C2=A0chmod 0755 /sys/kernel/debug/tracing</div><div><br></div><div=
>is in the common init.rc file ...</div><div><div><br></div><div>If DAC has=
 been adjusted at runtime to permit access to the node, I would think that =
if the caller does not have all the credentials/capabilities, we do want th=
e addresses to be abstracted by the kernel.</div></div><div><br></div><div>=
-- Mark</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote=
">On Fri, Jul 27, 2018 at 11:31 AM, Steven Rostedt <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:rostedt@goodmis.org" target=3D"_blank">rostedt@goodmis.org<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On=
 Fri, 27 Jul 2018 11:13:51 -0700<br>
Nick Desaulniers &lt;<a href=3D"mailto:ndesaulniers@google.com">ndesaulnier=
s@google.com</a>&gt; wrote:<br>
<br>
&gt; I found the internal bug report (reported Jan &#39;17, you&#39;ll have=
 to<br>
&gt; forgive me if my memory of the issue is hazy, or if the fix used at<br=
>
&gt; the time wasn&#39;t perfect), which was reported against the Nexus 6.<=
br>
&gt; &gt;From the report, it was possible to `cat=C2=A0 <br>
&gt; /sys/kernel/debug/tracing/<wbr>printk_formats` without being root, whi=
ch I<br>
&gt; can&#39;t do on my workstations much more modern kernel (Nexus 6 was<b=
r>
&gt; 3.10).=C2=A0 So I guess the question is what governs access to files b=
elow<br>
&gt; /sys/kernel/debug, and why was it missing from those kernels?=C2=A0 I<=
br>
&gt; assume some check was added, but either not backported to 3.10 stable<=
br>
&gt; (or more likely not pulled in to Nexus 6&#39;s kernel through stable;<=
br>
&gt; Android is now in a much better place for that kind of issue).<br>
<br>
</span>As of commit 82aceae4f0d4 (&quot;debugfs: more tightly restrict defa=
ult<br>
mount mode&quot;) /sys/kernel/debug has been default mounted as 0700 (root<=
br>
only). But that was introduced in 3.7. Not sure why your 3.10 kernel<br>
didn&#39;t have that. Perhaps there&#39;s another commit that fixed<br>
permissions not being inherited?<br>
<br>
-- Steve<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
-- <br>
You received this message because you are subscribed to the Google Groups &=
quot;kernel-team&quot; group.<br>
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:kernel-team%2Bunsubscribe@android.com">kernel-tea=
m+unsubscribe@<wbr>android.com</a>.<br>
<br>
</div></div></blockquote></div><br></div>

--0000000000005830330571ff7440--
