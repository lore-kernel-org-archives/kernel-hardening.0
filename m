Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87hasfinik.fsf@xmission.com>
References: <1343262548-21743-1-git-send-email-keescook@chromium.org>
	<1343262548-21743-2-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.02.1208031425530.25196@tundra.namei.org>
	<CAGXu5jKFm3uxwF3hhhzkUJcxJ0zOH89_bAgQGLCEf=g3CpXuHw@mail.gmail.com>
	<87hasfinik.fsf@xmission.com>
Date: Mon, 6 Aug 2012 16:57:54 -0700
Message-ID: <CAGXu5jKfcOzDnX0a+et9z7OcrbxTXhR7149p=9AUmPViPVoBPw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: multipart/alternative; boundary=14dae9340af37080f004c6a1a53b
Subject: Re: [kernel-hardening] [PATCH 1/2] fs: add link restrictions
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>, Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>
List-ID: <kernel-hardening.lists.openwall.com>

--14dae9340af37080f004c6a1a53b
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Aug 6, 2012 at 4:55 PM, Eric W. Biederman <ebiederm@xmission.com>wrote:

> Kees Cook <keescook@chromium.org> writes:
>
> > On Thu, Aug 2, 2012 at 9:26 PM, James Morris <jmorris@namei.org> wrote:
> >> On Wed, 25 Jul 2012, Kees Cook wrote:
> >>
> >>> This adds symlink and hardlink restrictions to the Linux VFS.
> >>
> >> Is Al happy with this now?
> >
> > Looks like it; thanks for checking. It's in mainline now:
> >
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=800179c9b8a1e796e441674776d11cd4c05d61d7
>
> So there was one trivial little issue with your patch.  You were
> directly comparing kuids instead of using uid_eq.  This only practically
> matters when user namespaces are enabled which is currently impossible
> in 3.6-rc1 :(
>
> I have added the following fixup patch to my for-next branch of
> user-namespace.git
>
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Fri, 3 Aug 2012 09:38:08 -0700
> Subject: [PATCH] userns:  Fix link restrictions to use uid_eq
>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>

Ah-ha! Thanks for fixing this.

Acked-by: Kees Cook <keescook@chromium.org>


-- 
Kees Cook
Chrome OS Security

--14dae9340af37080f004c6a1a53b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Mon, Aug 6, 2012 at 4:55 PM, Eric W. Biederma=
n <span dir=3D"ltr">&lt;<a href=3D"mailto:ebiederm@xmission.com" target=3D"=
_blank">ebiederm@xmission.com</a>&gt;</span> wrote:<br><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex">
<div class=3D"HOEnZb"><div class=3D"h5">Kees Cook &lt;<a href=3D"mailto:kee=
scook@chromium.org">keescook@chromium.org</a>&gt; writes:<br>
<br>
&gt; On Thu, Aug 2, 2012 at 9:26 PM, James Morris &lt;<a href=3D"mailto:jmo=
rris@namei.org">jmorris@namei.org</a>&gt; wrote:<br>
&gt;&gt; On Wed, 25 Jul 2012, Kees Cook wrote:<br>
&gt;&gt;<br>
&gt;&gt;&gt; This adds symlink and hardlink restrictions to the Linux VFS.<=
br>
&gt;&gt;<br>
&gt;&gt; Is Al happy with this now?<br>
&gt;<br>
&gt; Looks like it; thanks for checking. It&#39;s in mainline now:<br>
&gt; <a href=3D"http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.=
git;a=3Dcommitdiff;h=3D800179c9b8a1e796e441674776d11cd4c05d61d7" target=3D"=
_blank">http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3D=
commitdiff;h=3D800179c9b8a1e796e441674776d11cd4c05d61d7</a><br>

<br>
</div></div>So there was one trivial little issue with your patch. =A0You w=
ere<br>
directly comparing kuids instead of using uid_eq. =A0This only practically<=
br>
matters when user namespaces are enabled which is currently impossible<br>
in 3.6-rc1 :(<br>
<br>
I have added the following fixup patch to my for-next branch of<br>
user-namespace.git<br>
<br>
From: &quot;Eric W. Biederman&quot; &lt;<a href=3D"mailto:ebiederm@xmission=
.com">ebiederm@xmission.com</a>&gt;<br>
Date: Fri, 3 Aug 2012 09:38:08 -0700<br>
Subject: [PATCH] userns: =A0Fix link restrictions to use uid_eq<br>
<br>
Signed-off-by: &quot;Eric W. Biederman&quot; &lt;<a href=3D"mailto:ebiederm=
@xmission.com">ebiederm@xmission.com</a>&gt;<br></blockquote><div><br></div=
><div>Ah-ha! Thanks for fixing this.</div><div><br></div><div>Acked-by: Kee=
s Cook &lt;<a href=3D"mailto:keescook@chromium.org">keescook@chromium.org</=
a>&gt;</div>
<div><br></div></div><div><br></div>-- <br>Kees Cook<br>Chrome OS Security<=
br>

--14dae9340af37080f004c6a1a53b--
