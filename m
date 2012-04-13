Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: amluto@gmail.com
In-Reply-To: <alpine.LRH.2.02.1204131414580.22039@tundra.namei.org>
References: <1334267284-19166-1-git-send-email-wad@chromium.org> <alpine.LRH.2.02.1204131414580.22039@tundra.namei.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 12 Apr 2012 21:25:27 -0700
Message-ID: <CAObL_7ER32AesD6bHk591ss0hTFmp0bjVOKV9oEdhiFwCEVOBA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v18 01/15] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve
 from granting privs
To: James Morris <jmorris@namei.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, "David S. Miller" <davem@davemloft.net>, hpa@zytor.com, mingo@redhat.com, Oleg Nesterov <oleg@redhat.com>, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, Eric Paris <eparis@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Stephen Smalley <sds@tycho.nsa.gov>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 12, 2012 at 9:16 PM, James Morris <jmorris@namei.org> wrote:
> On Thu, 12 Apr 2012, Will Drewry wrote:
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index d85b793..0b06685 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -2016,6 +2016,13 @@ static int selinux_bprm_set_creds(struct linux_bi=
nprm *bprm)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_tsec->sid =3D old_tsec->exec_sid;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Reset exec SID on execve. */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_tsec->exec_sid =3D 0;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* Minimize confusion: if no_new_privs and a=
 transition is
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* explicitly requested, then fail the exec.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EPERM;
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Check for a default transition on this pr=
ogram. */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D security_transition_sid(old_tsec->sid=
, isec->sid,
>> @@ -2029,7 +2036,8 @@ static int selinux_bprm_set_creds(struct linux_bin=
prm *bprm)
>> =A0 =A0 =A0 ad.selinux_audit_data =3D &sad;
>> =A0 =A0 =A0 ad.u.path =3D bprm->file->f_path;
>>
>> - =A0 =A0 if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
>> + =A0 =A0 if ((bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) ||
>> + =A0 =A0 =A0 =A0 (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_tsec->sid =3D old_tsec->sid;
>>
>> =A0 =A0 =A0 if (new_tsec->sid =3D=3D old_tsec->sid) {
>> --
>
> What about dynamic transitions in SELinux ?
>

What's a dynamic transition?

--Andy
