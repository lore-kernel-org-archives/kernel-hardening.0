Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120218205626.GA26880@joi.lan>
References: <20120218193857.GA30985@www.outflux.net>
	<20120218205626.GA26880@joi.lan>
Date: Sat, 18 Feb 2012 17:36:36 -0800
Message-ID: <CAGXu5jJQVWS60m5W1-OvDCDixe=kVU2HxPP1C3zNCVgWcXzdDA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] fs: hardlink creation restrictions
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 18, 2012 at 12:56 PM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
> On Sat, Feb 18, 2012 at 11:38:57AM -0800, Kees Cook wrote:
>> @@ -3052,6 +3119,9 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __=
user *, oldname,
>> =A0 =A0 =A0 error =3D mnt_want_write(new_path.mnt);
>> =A0 =A0 =A0 if (error)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_dput;
>> + =A0 =A0 error =3D may_linkat(&old_path);
>> + =A0 =A0 if (error)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_dput;
>> =A0 =A0 =A0 error =3D security_path_link(old_path.dentry, &new_path, new=
_dentry);
>> =A0 =A0 =A0 if (error)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_drop_write;
>
> You should give up write access after check failure (i.e. goto out_drop_w=
rite).

Ah! Thanks, yes, good catch. I will move the check before mnt_want_write().

-Kees

--=20
Kees Cook
ChromeOS Security
