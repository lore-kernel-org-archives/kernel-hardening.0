Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20111207073051.GB16942@elte.hu>
References: <20111206235815.GA21764@www.outflux.net>
	<20111207073051.GB16942@elte.hu>
Date: Wed, 7 Dec 2011 10:23:28 -0800
Message-ID: <CAGXu5j+Es+12b=0j28a149nVahJUFktMbft3Bx0CBLJ7J2ZJUA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2011.1] fs: symlink restrictions on sticky directories
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Dan Rosenberg <drosenberg@vsecurity.com>, kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 6, 2011 at 11:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
> * Kees Cook <keescook@chromium.org> wrote:
>
>> Past objections and rebuttals could be summarized as:
>> ...
>> =A0- Might break unknown applications that use this feature.
>> =A0 =A0- Applications that break because of the change are easy to spot =
and
>> =A0 =A0 =A0fix. Applications that are vulnerable to symlink ToCToU by no=
t having
>> =A0 =A0 =A0the change aren't. Additionally, no applications have yet bee=
n found
>> =A0 =A0 =A0that rely on this behavior.
>
> Are there *known* applications that break?

Not that I've seen and none have been mentioned in any of the previous
discussions I've been able to find. (From above: "Additionally, no
applications have yet been found that rely on this behavior.")

>> =A0- This should live in the core VFS.
>> =A0 =A0- This should live in an LSM. (https://lkml.org/lkml/2010/5/31/13=
5)
>> =A0- This should live in an LSM.
>> =A0 =A0- This should live in the core VFS. (https://lkml.org/lkml/2010/8=
/2/188)
>
> Ugh - and people continue to get exploited from a preventable,
> fixable and already fixed VFS design flaw.

Right.

>> +config PROTECTED_STICKY_SYMLINKS
>> + =A0 =A0 bool "Protect symlink following in sticky world-writable direc=
tories"
>> + =A0 =A0 help
>> + =A0 =A0 =A0 A long-standing class of security issues is the symlink-ba=
sed
>> + =A0 =A0 =A0 time-of-check-time-of-use race, most commonly seen in
>> + =A0 =A0 =A0 world-writable directories like /tmp. The common method of
>> + =A0 =A0 =A0 exploitation of this flaw is to cross privilege boundaries
>> + =A0 =A0 =A0 when following a given symlink (i.e. a root process follow=
s
>> + =A0 =A0 =A0 a malicious symlink belonging to another user).
>> +
>> + =A0 =A0 =A0 Enabling this solves the problem by permitting symlinks to=
 only
>> + =A0 =A0 =A0 be followed when outside a sticky world-writable directory=
,
>> + =A0 =A0 =A0 or when the uid of the symlink and follower match, or when
>> + =A0 =A0 =A0 the directory and symlink owners match.
>
> Unless there are known apps that regress, shouldnt this be
> default y? Even if we were forced to not actually release such a
> final kernel, doing it in -rc1 would flush weird apps out of the
> woodwork.

I would totally agree. I was trying to be conservative here, but would
much rather this default to "y".

>> +int protected_sticky_symlinks =3D
>
> __read_mostly, most emphatically.

Ah yes. I will fix this.

>> +static inline int
>> +may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
>> +{
>> + =A0 =A0 int error =3D 0;
>> + =A0 =A0 const struct inode *parent;
>> + =A0 =A0 const struct inode *inode;
>> + =A0 =A0 const struct cred *cred;
>> +
>> + =A0 =A0 if (!protected_sticky_symlinks)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 /* Allowed if owner and follower match. */
>> + =A0 =A0 cred =3D current_cred();
>> + =A0 =A0 inode =3D dentry->d_inode;
>> + =A0 =A0 if (cred->fsuid =3D=3D inode->i_uid)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 /* Check parent directory mode and owner. */
>> + =A0 =A0 spin_lock(&dentry->d_lock);
>> + =A0 =A0 parent =3D dentry->d_parent->d_inode;
>> + =A0 =A0 if ((parent->i_mode & (S_ISVTX|S_IWOTH)) =3D=3D (S_ISVTX|S_IWO=
TH) &&
>> + =A0 =A0 =A0 =A0 parent->i_uid !=3D inode->i_uid) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 error =3D -EACCES;
>> + =A0 =A0 }
>> + =A0 =A0 spin_unlock(&dentry->d_lock);
>
> Taking the global /tmp and /lib, /usr/lib dentry spinlocks here
> every time we follow a symlink is a bit sad: there are a lot of
> high-profile symlinks in a Linux installation in those places,
> followed by non-owners.
>
> Nor is it really a realistic race that happens often: neither
> /tmp nor the library directories are being renamed or their
> permissions changed all that often for this parent lock taking
> to matter in practice.
>
> Couldnt we somehow export this information outside the dentry
> lock, allowing safe lockless access to it?

I'm open to whatever is needed, though I think this change would be
outside the scope of this patch's intent.

>> + =A0 =A0 if (error) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 char name[sizeof(current->comm)];
>> + =A0 =A0 =A0 =A0 =A0 =A0 printk_ratelimited(KERN_NOTICE "non-matching-u=
id symlink "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "following attempted in sticky=
 world-writable "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "directory by %s (fsuid %d)\n"=
,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_task_comm(name, current), =
cred->fsuid);
>
> I don't think the get_task_comm() extra layer is really
> necessary here - this is called in the *current* task's context
> - and it's not like that tasks are changing their own names all
> that often while they are busy executing VFS code, right? The
> race with some other task writing to /proc/PID/comm is
> uninteresting.

I would rather not have any kind of race here. It's only during the
failure condition, so we don't need speed.

> The more important piece of forensic information to log would be
> the file name that got attempted and perhaps the directory name
> as well. If there's an unknown hole in an unknown privileged app
> then this warning alone does not give the admin any clues where
> to look - the name of the expoiting task is probably obfuscated
> anyway, it's the identity of the attack vector that matters -
> and that name can generally not be controlled and obfuscated by
> the attacker.

Agreed. I will work on extracting this information and presenting it sanely=
.

> If those issues are resolved:
>
> =A0Reviewed-by: Ingo Molnar <mingo@elte.hu>

Thanks for looking it over!

-Kees

--=20
Kees Cook
ChromeOS Security
