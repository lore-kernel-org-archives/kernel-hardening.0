Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120808121938.GA9995@albatros>
References: <1343262548-21743-1-git-send-email-keescook@chromium.org>
	<1343262548-21743-2-git-send-email-keescook@chromium.org>
	<20120808121938.GA9995@albatros>
Date: Sat, 11 Aug 2012 23:34:20 -0700
Message-ID: <CAGXu5j+AUmNFLYmm-097JD-LgxKaYXxTmpnCdsdsqA+jLztXZQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: [kernel-hardening] [PATCH 1/2] fs: add link restrictions
To: Vasily Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 8, 2012 at 5:19 AM, Vasily Kulikov <segoon@openwall.com> wrote:
> Hi Kees,
>
> On Wed, Jul 25, 2012 at 17:29 -0700, Kees Cook wrote:
>> +/**
>> + * safe_hardlink_source - Check for safe hardlink conditions
>> + * @inode: the source inode to hardlink from
>> + *
>> + * Return false if at least one of the following conditions:
>> + *    - inode is not a regular file
>> + *    - inode is setuid
>> + *    - inode is setgid and group-exec
>> + *    - access failure for read and write
>> + *
>> + * Otherwise returns true.
>> + */
>> +static bool safe_hardlink_source(struct inode *inode)
>> +{
>> +     umode_t mode = inode->i_mode;
>> +
>> +     /* Special files should not get pinned to the filesystem. */
>> +     if (!S_ISREG(mode))
>> +             return false;
>> +
>> +     /* Setuid files should not get pinned to the filesystem. */
>> +     if (mode & S_ISUID)
>> +             return false;
>
> We don't want to make hardlinks of SUID files, but we still allow to create
> hardlinks to SUID'ish cap'ed files.  Probably check whether the inode is
> setcap'ed?

Excellent idea. It doesn't look like there is anything "simple" to do
this already. It'd be close to get_file_caps() but without the bprm.
Maybe just get_vfs_caps_from_disk() and a walk of the caps? What would
you recommend?

> Probably we can enhance this further and allow LSMs to define whether this
> particular file is special in LSM's point of view (IOW, it can be able to move
> a process to another security domain which is served by LSM).

Yeah. Perhaps implementing the needed check above with a new security
check and have commoncaps do the vfs fetch with LSMs able to override?

-Kees

-- 
Kees Cook
Chrome OS Security
