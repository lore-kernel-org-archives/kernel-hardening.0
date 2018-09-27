MIME-Version: 1.0
References: <20180926203446.2004-1-casey.schaufler@intel.com> <20180926203446.2004-4-casey.schaufler@intel.com>
In-Reply-To: <20180926203446.2004-4-casey.schaufler@intel.com>
From: Stephen Smalley <stephen.smalley@gmail.com>
Date: Wed, 26 Sep 2018 21:53:47 -0400
Message-ID: <CAB9W1A0o+U+R3dXhjjskdy6VYL14ANRvq1HSjYw+PuOURmrSEQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] SELinux: Prepare for PTRACE_MODE_SCHED
Content-Type: multipart/alternative; boundary="000000000000d6d6de0576d09cc2"
To: "Schaufler, Casey" <casey.schaufler@intel.com>
Cc: kernel-hardening@lists.openwall.com, Linux Kernel <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

--000000000000d6d6de0576d09cc2
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 26, 2018, 4:35 PM Casey Schaufler <casey.schaufler@intel.com>
wrote:

> From: Casey Schaufler <casey@schaufler-ca.com>
>
> A ptrace access check with mode PTRACE_MODE_SCHED gets called
> from process switching code. This precludes the use of audit or avc,
> as the locking is incompatible. The only available check that
> can be made without using avc is a comparison of the secids.
> This is not very satisfactory as it will indicate possible
> vulnerabilies much too aggressively.
>

We already have a flag to disable audit. What locking conflict is presented
by the avc, which uses rcu?


> Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
> ---
>  security/selinux/hooks.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index ad9a9b8e9979..160239791007 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2267,6 +2267,8 @@ static int selinux_ptrace_access_check(struct
> task_struct *child,
>         u32 sid = current_sid();
>         u32 csid = task_sid(child);
>
> +       if (mode & PTRACE_MODE_SCHED)
> +               return sid == csid ? 0 : -EACCES;
>         if (mode & PTRACE_MODE_READ)
>                 return avc_has_perm(&selinux_state,
>                                     sid, csid, SECCLASS_FILE, FILE__READ,
> NULL);
> --
> 2.17.1
>
>

--000000000000d6d6de0576d09cc2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><div class=3D"gmail_quote"><div dir=3D"ltr">On Wed, =
Sep 26, 2018, 4:35 PM Casey Schaufler &lt;<a href=3D"mailto:casey.schaufler=
@intel.com">casey.schaufler@intel.com</a>&gt; wrote:<br></div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">From: Casey Schaufler &lt;<a href=3D"mailto:casey@schaufl=
er-ca.com" target=3D"_blank" rel=3D"noreferrer">casey@schaufler-ca.com</a>&=
gt;<br>
<br>
A ptrace access check with mode PTRACE_MODE_SCHED gets called<br>
from process switching code. This precludes the use of audit or avc,<br>
as the locking is incompatible. The only available check that<br>
can be made without using avc is a comparison of the secids.<br>
This is not very satisfactory as it will indicate possible<br>
vulnerabilies much too aggressively.<br></blockquote></div></div><div dir=
=3D"auto"><br></div><div dir=3D"auto">We already have a flag to disable aud=
it. What locking conflict is presented by the avc, which uses rcu?=C2=A0</d=
iv><div dir=3D"auto"><br></div><div dir=3D"auto"><div class=3D"gmail_quote"=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex">
<br>
Signed-off-by: Casey Schaufler &lt;<a href=3D"mailto:casey.schaufler@intel.=
com" target=3D"_blank" rel=3D"noreferrer">casey.schaufler@intel.com</a>&gt;=
<br>
---<br>
=C2=A0security/selinux/hooks.c | 2 ++<br>
=C2=A01 file changed, 2 insertions(+)<br>
<br>
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c<br>
index ad9a9b8e9979..160239791007 100644<br>
--- a/security/selinux/hooks.c<br>
+++ b/security/selinux/hooks.c<br>
@@ -2267,6 +2267,8 @@ static int selinux_ptrace_access_check(struct task_st=
ruct *child,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 u32 sid =3D current_sid();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 u32 csid =3D task_sid(child);<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (mode &amp; PTRACE_MODE_SCHED)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return sid =3D=3D c=
sid ? 0 : -EACCES;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mode &amp; PTRACE_MODE_READ)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return avc_has_perm=
(&amp;selinux_state,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sid, csid, SECCLASS_FI=
LE, FILE__READ, NULL);<br>
-- <br>
2.17.1<br>
<br>
</blockquote></div></div></div>

--000000000000d6d6de0576d09cc2--
