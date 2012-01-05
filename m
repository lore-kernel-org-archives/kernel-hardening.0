Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120105091704.GB3249@elte.hu>
References: <20120104201800.GA2587@www.outflux.net>
	<20120105091704.GB3249@elte.hu>
Date: Thu, 5 Jan 2012 11:36:11 -0800
Message-ID: <CAGXu5jJ=D1pKCZ8=1-WGkm0witNEH9Ux01+1BJyZKC_DAX00aA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 5, 2012 at 1:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
> * Kees Cook <keescook@chromium.org> wrote:
>
>> @@ -1495,6 +1496,15 @@ static struct ctl_table fs_table[] =3D {
>> =A0#endif
>> =A0#endif
>> =A0 =A0 =A0 {
>> + =A0 =A0 =A0 =A0 =A0 =A0 .procname =A0 =A0 =A0 =3D "protected_sticky_sy=
mlinks",
>> + =A0 =A0 =A0 =A0 =A0 =A0 .data =A0 =A0 =A0 =A0 =A0 =3D &protected_stick=
y_symlinks,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .maxlen =A0 =A0 =A0 =A0 =3D sizeof(int),
>> + =A0 =A0 =A0 =A0 =A0 =A0 .mode =A0 =A0 =A0 =A0 =A0 =3D 0644,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .proc_handler =A0 =3D proc_dointvec_minmax,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .extra1 =A0 =A0 =A0 =A0 =3D &zero,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .extra2 =A0 =A0 =A0 =A0 =3D &one,
>> + =A0 =A0 },
>
> Small detail:
>
> Might make sense to change the .mode to 0600, to make it harder
> for unprivileged attack code to guess whether this protection
> (and the resulting audit warning to the administrator) is
> enabled on a system or not.

Sure, I have no problem with that. In addition to this change, what's
the best next step for this patch?

Thanks,

-Kees

--=20
Kees Cook
ChromeOS Security
