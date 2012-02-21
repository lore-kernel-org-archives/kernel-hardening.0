Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120221151057.a36bf2b2.akpm@linux-foundation.org>
References: <20120221215800.GA26721@www.outflux.net>
	<20120221151057.a36bf2b2.akpm@linux-foundation.org>
Date: Tue, 21 Feb 2012 15:22:57 -0800
Message-ID: <CAGXu5j+xzLQVHqT4oEXxVi8r2j5OUG3LLZLkMM=JscNzjLmkOQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2] fs: hardlink creation restrictions
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 21, 2012 at 3:10 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 21 Feb 2012 13:58:00 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> On systems that have user-writable directories on the same partition
>> as system files, a long-standing class of security issues is the
>> hardlink-based time-of-check-time-of-use race, most commonly seen in
>> world-writable directories like /tmp. The common method of exploitation
>> of this flaw is to cross privilege boundaries when following a given
>> hardlink (i.e. a root process follows a hardlink created by another
>> user). Additionally, an issue exists where users can "pin" a potentially
>> vulnerable setuid/setgid file so that an administrator will not actually
>> upgrade a system fully.
>>
>> The solution is to permit hardlinks to only be created when the user is
>> already the existing file's owner, or if they already have read/write
>> access to the existing file.
>>
>> Many Linux users are surprised when they learn they can link to files
>> they have no access to, so this change appears to follow the doctrine
>> of "least surprise". Additionally, this change does not violate POSIX,
>> which states "the implementation may require that the calling process
>> has permission to access the existing file"[1].
>>
>> This change is known to break some implementations of the "at" daemon,
>> though the version used by Fedora and Ubuntu has been fixed[2] for
>> a while. Otherwise, the change has been undisruptive while in use in
>> Ubuntu for the last 1.5 years.
>>
>> This patch is based on the patch in Openwall and grsecurity. =A0I have
>> added a sysctl to enable the protected behavior, documentation, and an
>> audit notification.
>>
>> [1] http://pubs.opengroup.org/onlinepubs/9699919799/functions/linkat.htm=
l
>> [2] http://anonscm.debian.org/gitweb/?p=3Dcollab-maint/at.git;a=3Dcommit=
diff;h=3Df4114656c3a6c6f6070e315ffdf940a49eda3279
>>
>
> Looks OKish to me.

Thanks!

>> --- a/Documentation/sysctl/fs.txt
>> +++ b/Documentation/sysctl/fs.txt
>> @@ -32,7 +32,8 @@ Currently, these files are in /proc/sys/fs:
>> =A0- nr_open
>> =A0- overflowuid
>> =A0- overflowgid
>> -- protected_sticky_symlinks
>> +- protected_hardlinks
>> +- protected_symlinks
>
> It's silly to add protected_sticky_symlinks and to then rename it in
> the very next patch. =A0I have reworked my copy of the earlier
> fs-symlink-restrictions-on-sticky-directories.patch so that it adds
> "protected_symlinks". =A0I then reworked this patch
> (fs-hardlink-creation-restrictions.patch) to add protected_hardlinks.
> Nice and simple.

Okay, sounds good. Thanks for the clean-ups!

>>
>> ...
>>
>> +static inline void
>> +audit_log_link_denied(const char *operation, struct path *link)
>> +{
>> + =A0 =A0 struct audit_buffer *ab;
>> +
>> + =A0 =A0 ab =3D audit_log_start(current->audit_context, GFP_KERNEL, AUD=
IT_AVC);
>> + =A0 =A0 audit_log_format(ab, "op=3D%s action=3Ddenied", operation);
>> + =A0 =A0 audit_log_format(ab, " pid=3D%d comm=3D", current->pid);
>> + =A0 =A0 audit_log_untrustedstring(ab, current->comm);
>> + =A0 =A0 audit_log_d_path(ab, " path=3D", link);
>> + =A0 =A0 audit_log_format(ab, " dev=3D");
>> + =A0 =A0 audit_log_untrustedstring(ab, link->dentry->d_inode->i_sb->s_i=
d);
>> + =A0 =A0 audit_log_format(ab, " ino=3D%lu", link->dentry->d_inode->i_in=
o);
>> + =A0 =A0 audit_log_end(ab);
>> +}
>
> This is far too large to inline. =A0It has two callsites and gcc is
> probably smart anough to uninline it for us. =A0I queued a patch to
> remove the `inline'.

Okay, seems fine to me.

>> =A0/**
>> =A0 * may_follow_link - Check symlink following for unsafe situations
>> - * @dentry: The inode/dentry of the symlink
>> - * @nameidata: The path data of the symlink
>> + * @link: The path of the symlink
>> =A0 *
>> - * In the case of the protected_sticky_symlinks sysctl being enabled,
>> + * In the case of the sysctl_protected_symlinks sysctl being enabled,
>> =A0 * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink i=
s
>> =A0 * in a sticky world-writable directory. This is to protect privilege=
d
>> =A0 * processes from failing races against path names that may change ou=
t
>> @@ -643,19 +660,20 @@ int sysctl_protected_sticky_symlinks __read_mostly=
 =3D
>> =A0 *
>> =A0 * Returns 0 if following the symlink is allowed, -ve on error.
>> =A0 */
>> -static inline int
>> -may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
>> +static inline int may_follow_link(struct path *link)
>> =A0{
>> =A0 =A0 =A0 int error =3D 0;
>> =A0 =A0 =A0 const struct inode *parent;
>> =A0 =A0 =A0 const struct inode *inode;
>> =A0 =A0 =A0 const struct cred *cred;
>> + =A0 =A0 struct dentry *dentry;
>>
>> - =A0 =A0 if (!sysctl_protected_sticky_symlinks)
>> + =A0 =A0 if (!sysctl_protected_symlinks)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>
> This is also too large to inline. =A0It doesn't matter a lot - it's not a
> hot path. =A0I removed this `inline' as well. =A0gcc will probably inline
> it anyway.
>
> If we were really concerned about speed here, we might decide to inline
> the test of sysctl_protected_symlinks and to uninline the remainder of
> the function.
>
>
>> =A0 =A0 =A0 /* Allowed if owner and follower match. */
>> =A0 =A0 =A0 cred =3D current_cred();
>> + =A0 =A0 dentry =3D link->dentry;
>> =A0 =A0 =A0 inode =3D dentry->d_inode;
>> =A0 =A0 =A0 if (cred->fsuid =3D=3D inode->i_uid)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>
>> ...
>>
>> +static inline int may_linkat(struct path *link)
>> +{
>> + =A0 =A0 int error =3D 0;
>> + =A0 =A0 const struct cred *cred;
>> + =A0 =A0 struct inode *inode;
>> + =A0 =A0 int mode;
>> +
>> + =A0 =A0 if (!sysctl_protected_hardlinks)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 cred =3D current_cred();
>> + =A0 =A0 inode =3D link->dentry->d_inode;
>> + =A0 =A0 mode =3D inode->i_mode;
>> +
>> + =A0 =A0 if (cred->fsuid !=3D inode->i_uid &&
>> + =A0 =A0 =A0 =A0 (!S_ISREG(mode) || (mode & S_ISUID) ||
>> + =A0 =A0 =A0 =A0 =A0((mode & (S_ISGID | S_IXGRP)) =3D=3D (S_ISGID | S_I=
XGRP)) ||
>> + =A0 =A0 =A0 =A0 =A0(inode_permission(inode, MAY_READ | MAY_WRITE))) &&
>> + =A0 =A0 =A0 =A0 !capable(CAP_FOWNER))
>> + =A0 =A0 =A0 =A0 =A0 =A0 error =3D -EPERM;
>
> omigod. =A0Geeze man, whose side are you on?

Heh. Yeah, this was not my favorite if statement.

> I suggest something like this:
>
> --- a/fs/namei.c~fs-hardlink-creation-restrictions-fix-fix
> +++ a/fs/namei.c
> @@ -692,6 +692,23 @@ static inline int may_follow_link(struct
> =A0 =A0 =A0 =A0return error;
> =A0}
>
> +static bool foobar(struct inode *inode, umode_t mode)
> +{
> + =A0 =A0 =A0 /* nice comment */
> + =A0 =A0 =A0 if (!S_ISREG(mode))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> + =A0 =A0 =A0 /* nice comment */
> + =A0 =A0 =A0 if (mode & S_ISUID)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> + =A0 =A0 =A0 /* nice comment */
> + =A0 =A0 =A0 if ((mode & (S_ISGID | S_IXGRP)) =3D=3D (S_ISGID | S_IXGRP)=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> + =A0 =A0 =A0 /* nice comment */
> + =A0 =A0 =A0 if (inode_permission(inode, MAY_READ | MAY_WRITE))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> + =A0 =A0 =A0 return false;
> +}
> +
> =A0/**
> =A0* may_linkat - Check permissions for creating a hardlink
> =A0* @link: the source to hardlink from
> @@ -722,11 +739,8 @@ static int may_linkat(struct path *link)
> =A0 =A0 =A0 =A0inode =3D link->dentry->d_inode;
> =A0 =A0 =A0 =A0mode =3D inode->i_mode;
>
> - =A0 =A0 =A0 if (cred->fsuid !=3D inode->i_uid &&
> - =A0 =A0 =A0 =A0 =A0 (!S_ISREG(mode) || (mode & S_ISUID) ||
> - =A0 =A0 =A0 =A0 =A0 =A0((mode & (S_ISGID | S_IXGRP)) =3D=3D (S_ISGID | =
S_IXGRP)) ||
> - =A0 =A0 =A0 =A0 =A0 =A0(inode_permission(inode, MAY_READ | MAY_WRITE)))=
 &&
> - =A0 =A0 =A0 =A0 =A0 !capable(CAP_FOWNER))
> + =A0 =A0 =A0 if (cred->fsuid !=3D inode->i_uid && foobar(inode, mode) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !capable(CAP_FOWNER))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D -EPERM;
>
> =A0 =A0 =A0 =A0if (error)
>
> Please take a look at that, pick a replacement for foobar, fill in the
> nice comments which explain our reasoning, retest it and send it back
> at me?

Sounds good -- I'll get it written and tested shortly.

> Also please take a look at local variable "mode" and decide if there
> was a good reason for it being `int' instead of mode_t?

Ah, sorry. That was an oversight on my part -- I'd ported these before
mode_t existed. I'll fix that too.

Thanks!

-Kees

--=20
Kees Cook
ChromeOS Security
