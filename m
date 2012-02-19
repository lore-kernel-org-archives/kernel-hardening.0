Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120219124916.GB25900@elte.hu>
References: <20120218193857.GA30985@www.outflux.net>
	<20120219124916.GB25900@elte.hu>
Date: Sun, 19 Feb 2012 09:45:12 -0800
Message-ID: <CAGXu5jL-NZP9At16q-b6biszMAWQQ4HLzW3cHDQUf0m7PGwGbQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] fs: hardlink creation restrictions
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 19, 2012 at 4:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> This is the other half of link restrictions, now that symlink
>> restriction has landed in -mm.
>
> Nice features!

Thanks!

>> @@ -300,9 +302,29 @@ config PROTECTED_STICKY_SYMLINKS_ENABLED
>> =A0 =A0 =A0 =A0 via /proc/sys/kernel/protected_sticky_symlinks.
>>
>> =A0config PROTECTED_STICKY_SYMLINKS_ENABLED_SYSCTL
>> - =A0 =A0 depends on PROTECTED_STICKY_SYMLINKS
>> + =A0 =A0 depends on PROTECTED_LINKS
>> =A0 =A0 =A0 int
>> =A0 =A0 =A0 default "1" if PROTECTED_STICKY_SYMLINKS_ENABLED
>> =A0 =A0 =A0 default "0"
>>
>> +config PROTECTED_NONACCESS_HARDLINKS_ENABLED
>> + =A0 =A0 depends on PROTECTED_LINKS
>> + =A0 =A0 bool "Disallow hardlink creation to non-accessible files"
>> + =A0 =A0 default y
>> + =A0 =A0 help
>> + =A0 =A0 =A0 Solve ToCToU hardlink race vulnerabilities by permitting h=
ardlinks
>> + =A0 =A0 =A0 to be created only when to a regular file that is owned by=
 the user,
>> + =A0 =A0 =A0 or is readable and writable by the user. Also blocks users=
 from
>> + =A0 =A0 =A0 "pinning" vulnerable setuid/setgid programs from being upg=
raded by
>> + =A0 =A0 =A0 the administrator.
>> +
>> + =A0 =A0 =A0 When PROC_SYSCTL is enabled, this setting can also be cont=
rolled
>> + =A0 =A0 =A0 via /proc/sys/kernel/protected_nonaccess_hardlinks.
>
> I'd add a:
>
> =A0 =A0 =A0 =A0See Documentation/sysctl/fs.txt for details.
>
> line as well.

Good call.

>> +config PROTECTED_NONACCESS_HARDLINKS_ENABLED_SYSCTL
>> + =A0 =A0 depends on PROTECTED_LINKS
>> + =A0 =A0 int
>> + =A0 =A0 default "1" if PROTECTED_NONACCESS_HARDLINKS_ENABLED
>> + =A0 =A0 default "0"
>
> Naming nit: how about dropping the _NONACCESS/_nonaccess names
> complete and turn it into protected_hardlinks? The longer
> variant is not any better descriptive, and needlessly longer.
>
> The PROTECTED_SYMLINKS/PROTECTED_HARDLINKS naming is thus also
> nicely symmetric.

Yeah, this really does look much better. I had opted for extreme
verbosity, but I would agree: it's not really called for here.

>> +#ifdef CONFIG_AUDIT
>> + =A0 =A0 if (error) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct audit_buffer *ab;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 ab =3D audit_log_start(current->audit_context,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP=
_KERNEL, AUDIT_AVC);
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_format(ab, "op=3Dlinkat action=3Dden=
ied");
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_format(ab, " pid=3D%d comm=3D", curr=
ent->pid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_untrustedstring(ab, current->comm);
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_d_path(ab, " path=3D", old_path);
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_format(ab, " dev=3D");
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_untrustedstring(ab, inode->i_sb->s_i=
d);
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_format(ab, " ino=3D%lu", inode->i_in=
o);
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_end(ab);
>> + =A0 =A0 }
>> +#endif
>
> Small detail: don't these audit methods map to nothing on
> !CONFIG_AUDIT, allowing the #ifdef to be dropped? (if not then
> it should really be so.)

Ah-ha; a more careful look at audit.h agrees. :) I'll adjust this as well.

> Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks for the review,

-Kees

--=20
Kees Cook
ChromeOS Security
