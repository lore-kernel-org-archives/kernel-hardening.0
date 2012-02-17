Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120217152432.112fdace.akpm@linux-foundation.org>
References: <20120107185548.GA30748@outflux.net>
	<20120217152432.112fdace.akpm@linux-foundation.org>
Date: Fri, 17 Feb 2012 15:36:09 -0800
Message-ID: <CAGXu5jJ629rrEuQX1MSiqM2SvhCSmZYuNZdOA4zBr5GZHtFcuw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2012.2] fs: symlink restrictions on sticky directories
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 17, 2012 at 3:24 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 7 Jan 2012 10:55:48 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> A long-standing class of security issues is the symlink-based
>> time-of-check-time-of-use race, most commonly seen in world-writable
>> directories like /tmp. The common method of exploitation of this flaw
>> is to cross privilege boundaries when following a given symlink (i.e. a
>> root process follows a symlink belonging to another user). For a likely
>> incomplete list of hundreds of examples across the years, please see:
>> http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=3D/tmp
>>
>> The solution is to permit symlinks to only be followed when outside
>> a sticky world-writable directory, or when the uid of the symlink and
>> follower match, or when the directory owner matches the symlink's owner.
>>
>> Some pointers to the history of earlier discussion that I could find:
>>
>> =A01996 Aug, Zygo Blaxell
>> =A0 http://marc.info/?l=3Dbugtraq&m=3D87602167419830&w=3D2
>> =A01996 Oct, Andrew Tridgell
>> =A0 http://lkml.indiana.edu/hypermail/linux/kernel/9610.2/0086.html
>> =A01997 Dec, Albert D Cahalan
>> =A0 http://lkml.org/lkml/1997/12/16/4
>> =A02005 Feb, Lorenzo Hern__ndez Garc__a-Hierro
>> =A0 http://lkml.indiana.edu/hypermail/linux/kernel/0502.0/1896.html
>> =A02010 May, Kees Cook
>> =A0 https://lkml.org/lkml/2010/5/30/144
>>
>> Past objections and rebuttals could be summarized as:
>>
>> =A0- Violates POSIX.
>> =A0 =A0- POSIX didn't consider this situation and it's not useful to fol=
low
>> =A0 =A0 =A0a broken specification at the cost of security.
>> =A0- Might break unknown applications that use this feature.
>> =A0 =A0- Applications that break because of the change are easy to spot =
and
>> =A0 =A0 =A0fix. Applications that are vulnerable to symlink ToCToU by no=
t having
>> =A0 =A0 =A0the change aren't. Additionally, no applications have yet bee=
n found
>> =A0 =A0 =A0that rely on this behavior.
>> =A0- Applications should just use mkstemp() or O_CREATE|O_EXCL.
>> =A0 =A0- True, but applications are not perfect, and new software is wri=
tten
>> =A0 =A0 =A0all the time that makes these mistakes; blocking this flaw at=
 the
>> =A0 =A0 =A0kernel is a single solution to the entire class of vulnerabil=
ity.
>> =A0- This should live in the core VFS.
>> =A0 =A0- This should live in an LSM. (https://lkml.org/lkml/2010/5/31/13=
5)
>> =A0- This should live in an LSM.
>> =A0 =A0- This should live in the core VFS. (https://lkml.org/lkml/2010/8=
/2/188)
>>
>> This patch is based on the patch in Openwall and grsecurity, along with
>> suggestions from Al Viro. I have added a sysctl to enable the protected
>> behavior, documentation, and an audit notification.
>
> Looks reasonable to me.
>
> It's a viropatch. =A0I shall merge it into 3.4-rc1 if nothing happens to
> prevent that.

Thanks!

>> +config PROTECTED_STICKY_SYMLINKS
>> + =A0 =A0 bool "Evaluate vulnerable symlink conditions"
>> + =A0 =A0 default y
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
>> + =A0 =A0 =A0 Enabling this adds the logic to examine these dangerous sy=
mlink
>> + =A0 =A0 =A0 conditions. Whether or not the dangerous symlink situation=
s are
>> + =A0 =A0 =A0 allowed is controlled by PROTECTED_STICKY_SYMLINKS_ENABLED=
.
>> +
>> +config PROTECTED_STICKY_SYMLINKS_ENABLED
>> + =A0 =A0 depends on PROTECTED_STICKY_SYMLINKS
>> + =A0 =A0 bool "Disallow symlink following in sticky world-writable dirs=
"
>> + =A0 =A0 default y
>> + =A0 =A0 help
>> + =A0 =A0 =A0 Solve ToCToU symlink race vulnerablities by permitting sym=
links
>> + =A0 =A0 =A0 to be followed only when outside a sticky world-writable d=
irectory,
>> + =A0 =A0 =A0 or when the uid of the symlink and follower match, or when=
 the
>> + =A0 =A0 =A0 directory and symlink owners match.
>> +
>> + =A0 =A0 =A0 When PROC_SYSCTL is enabled, this setting can also be cont=
rolled
>> + =A0 =A0 =A0 via /proc/sys/kernel/protected_sticky_symlinks.
>
> I think I disagree with this. =A0If the person compiling the kernel
> includes the feature in his kernel via the time-honoured process of
> "wtf is that thing? =A0Yeah, whatev", it gets turned on by default. =A0Th=
is
> could easily result in weird failures which would take a *long* time
> for an unsuspecting person to debug.
>
> Would it not be kinder to our users to start this out as
> turned-off-at-runtime unless the kernel configurer has deliberately
> gone in and enabled it?

There was a fair bit of back-and-forth discussion about it.
Originally, I had it disabled, but, IIRC, Ingo urged me to have it be
the default. I can sent a patch to disable it if you want.

>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -109,6 +109,9 @@ extern int sysctl_nr_trim_pages;
>> =A0#ifdef CONFIG_BLOCK
>> =A0extern int blk_iopoll_enabled;
>> =A0#endif
>> +#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
>> +extern int sysctl_protected_sticky_symlinks;
>> +#endif
>>
>
> Grumble. =A0Yes, it's a site of much badness. =A0Let's not worsen things.
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: fs-symlink-restrictions-on-sticky-directories-fix
>
> move sysctl_protected_sticky_symlinks declaration into .h
>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> --- a/kernel/sysctl.c~fs-symlink-restrictions-on-sticky-directories-fix
> +++ a/kernel/sysctl.c
> @@ -109,9 +109,6 @@ extern int sysctl_nr_trim_pages;
> =A0#ifdef CONFIG_BLOCK
> =A0extern int blk_iopoll_enabled;
> =A0#endif
> -#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
> -extern int sysctl_protected_sticky_symlinks;
> -#endif
>
> =A0/* Constants used for minimum and =A0maximum */
> =A0#ifdef CONFIG_LOCKUP_DETECTOR
> --- a/include/linux/fs.h~fs-symlink-restrictions-on-sticky-directories-fi=
x
> +++ a/include/linux/fs.h
> @@ -422,6 +422,7 @@ extern unsigned long get_max_files(void)
> =A0extern int sysctl_nr_open;
> =A0extern struct inodes_stat_t inodes_stat;
> =A0extern int leases_enable, lease_break_time;
> +extern int sysctl_protected_sticky_symlinks;
>
> =A0struct buffer_head;
> =A0typedef int (get_block_t)(struct inode *inode, sector_t iblock,

Ah, sure. That works for me. Thanks!

-Kees

--=20
Kees Cook
ChromeOS Security
