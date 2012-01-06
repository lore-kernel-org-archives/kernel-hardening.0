Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120106012120.32c3f370.akpm@linux-foundation.org>
References: <20120104201800.GA2587@www.outflux.net>
	<20120105091704.GB3249@elte.hu>
	<CAGXu5jJ=D1pKCZ8=1-WGkm0witNEH9Ux01+1BJyZKC_DAX00aA@mail.gmail.com>
	<20120106073635.GC14188@elte.hu>
	<20120106012120.32c3f370.akpm@linux-foundation.org>
Date: Fri, 6 Jan 2012 10:44:26 -0800
Message-ID: <CAGXu5j+HX5bO-_uxna4gUZJG2dY-yxJ2dgwAvooGSWUzJr-LHQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 6, 2012 at 1:21 AM, Andrew Morton <akpm@linux-foundation.org> w=
rote:
> On Fri, 6 Jan 2012 08:36:35 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>> * Kees Cook <keescook@chromium.org> wrote:
>> > On Thu, Jan 5, 2012 at 1:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> > > * Kees Cook <keescook@chromium.org> wrote:
>> > >
>> > >> @@ -1495,6 +1496,15 @@ static struct ctl_table fs_table[] =3D {
>> > >> =A0#endif
>> > >> =A0#endif
>> > >> =A0 =A0 =A0 {
>> > >> + =A0 =A0 =A0 =A0 =A0 =A0 .procname =A0 =A0 =A0 =3D "protected_stic=
ky_symlinks",
>> > >> + =A0 =A0 =A0 =A0 =A0 =A0 .data =A0 =A0 =A0 =A0 =A0 =3D &protected_=
sticky_symlinks,
>> > >> + =A0 =A0 =A0 =A0 =A0 =A0 .maxlen =A0 =A0 =A0 =A0 =3D sizeof(int),
>> > >> + =A0 =A0 =A0 =A0 =A0 =A0 .mode =A0 =A0 =A0 =A0 =A0 =3D 0644,
>> > >> + =A0 =A0 =A0 =A0 =A0 =A0 .proc_handler =A0 =3D proc_dointvec_minma=
x,
>> > >> + =A0 =A0 =A0 =A0 =A0 =A0 .extra1 =A0 =A0 =A0 =A0 =3D &zero,
>> > >> + =A0 =A0 =A0 =A0 =A0 =A0 .extra2 =A0 =A0 =A0 =A0 =3D &one,
>> > >> + =A0 =A0 },
>> > >
>> > > Small detail:
>> > >
>> > > Might make sense to change the .mode to 0600, to make it
>> > > harder for unprivileged attack code to guess whether this
>> > > protection (and the resulting audit warning to the
>> > > administrator) is enabled on a system or not.
>> >
>> > Sure, I have no problem with that. In addition to this change,
>> > what's the best next step for this patch?
>>
>> Al and Linus's call I guess. Maybe ask Andrew whether he'd put
>> it into -mm?
>
> Sure, I can babysit it for Viro and get it a bit of testing meanwhile.

That would be wonderful. :)

> However, you've now made me go and look at it...
>
> On Wed, 4 Jan 2012 12:18:00 -0800 Kees Cook <keescook@chromium.org> wrote=
:
>> diff --git a/fs/namei.c b/fs/namei.c
>> index 5008f01..b826d2e 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -624,10 +624,80 @@ static inline void put_link(struct nameidata *nd, =
struct path *link, void *cooki
>> =A0 =A0 =A0 path_put(link);
>> =A0}
>>
>> +int protected_sticky_symlinks =A0read_mostly =3D
>
> A nice convention is to prefix these globals with sysctl_.
>
> =A0 =A0 =A0 =A0grep ".data.*&sysctl_" kernel/sysctl.c
>
> has examples.

Excellent point, thanks. I will fix this.

>> +/**
>> + * may_follow_link - Check symlink following for unsafe situations
>> + * @dentry: The inode/dentry of the symlink
>> + * @nameidata: The path data of the symlink
>> + *
>> + * In the case of the protected_sticky_symlinks sysctl being enabled,
>> + * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink is
>> + * in a sticky world-writable directory. This is to protect privileged
>> + * processes from failing races against path names that may change out
>> + * from under them by way of other users creating malicious symlinks.
>> + * It will permit symlinks to be followed only when outside a sticky
>> + * world-writable directory, or when the uid of the symlink and followe=
r
>> + * match, or when the directory owner matches the symlink's owner.
>> + *
>> + * Returns 0 if following the symlink is allowed, -ve on error.
>> + */
>> +static inline int
>> +may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
>
> Setting aside the issue that gcc will cheerily ignore the inline
> directive, is it prudent to inline this? =A0Doing so will pork up the
> follow_link() cache footprint. =A0Perhaps it should actually be noinline?

Well, I was trying to balance a few potential issues. One thing to try
to avoid was slowing down symlink resolution. The first step was only
doing this check in the sensitive path, as Al had pointed out to me.
Since the code is relatively small, it seemed reasonable to inline it
where it was needed. If anyone has a strong opinion about this, it's
trivial for it to be changed.

>> + =A0 =A0 =A0 =A0 =A0 =A0 ab =3D audit_log_start(current->audit_context,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP=
_KERNEL, AUDIT_AVC);
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_format(ab, "op=3Dfollow_link action=
=3Ddenied");
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_format(ab, " pid=3D%d comm=3D", curr=
ent->pid);
>
> The same pid can exist in multiple namespaces. =A0Now whatcha gonna do?

Well, that's a wider problem that just this code. This style of report
is used in several other places. I'm open to suggestions.

>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_untrustedstring(ab, current->comm);
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_d_path(ab, "path=3D", &nameidata->pa=
th);
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_format(ab, " name=3D");
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_untrustedstring(ab, dentry->d_name.n=
ame);
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_format(ab, " dev=3D%s ino=3D%lu",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_sb=
->s_id,
>
> Can s_id contain characters which audit_log_untrustedstring() would
> have escaped? =A0I suspect so.

Hunh. Interesting point. I will adjust this here and in the place I
originally saw it.

>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_in=
o);
>> + =A0 =A0 =A0 =A0 =A0 =A0 audit_log_end(ab);
>> + =A0 =A0 }
>> +#endif
>> + =A0 =A0 return error;
>> +}
>> +
>> =A0static =A0always_inline int
>> -follow_link(struct path *link, struct nameidata *nd, void **p)
>> +follow_link(struct path *link, struct nameidata *nd, void **p, bool sen=
sitive)
>> =A0{
>> - =A0 =A0 int error;
>> + =A0 =A0 int error =3D 0;
>> =A0 =A0 =A0 struct dentry *dentry =3D link->dentry;
>>
>> =A0 =A0 =A0 BUG_ON(nd->flags & LOOKUP_RCU);
>> @@ -646,7 +716,10 @@ follow_link(struct path *link, struct nameidata *nd=
, void **p)
>> =A0 =A0 =A0 touch_atime(link->mnt, dentry);
>> =A0 =A0 =A0 nd_set_link(nd, NULL);
>>
>> - =A0 =A0 error =3D security_inode_follow_link(link->dentry, nd);
>> + =A0 =A0 if (sensitive)
>> + =A0 =A0 =A0 =A0 =A0 =A0 error =3D may_follow_link(link->dentry, nd);
>> + =A0 =A0 if (!error)
>> + =A0 =A0 =A0 =A0 =A0 =A0 error =3D security_inode_follow_link(link->den=
try, nd);
>> =A0 =A0 =A0 if (error) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 *p =3D ERR_PTR(error); /* no ->put_link(), p=
lease */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_put(&nd->path);
>> @@ -1339,7 +1412,7 @@ static inline int nested_symlink(struct path *path=
, struct nameidata *nd)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct path link =3D *path;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 void *cookie;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 res =3D follow_link(&link, nd, &cookie);
>> + =A0 =A0 =A0 =A0 =A0 =A0 res =3D follow_link(&link, nd, &cookie, 0);
>
> follow_link() takes a bool, so this 0 should anally be "false".
> Multiple instances of this.

Ah yes, thanks. I will fix this.

Thanks for the review! I will post an update shortly.

-Kees

--=20
Kees Cook
ChromeOS Security
