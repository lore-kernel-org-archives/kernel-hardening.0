MIME-Version: 1.0
In-Reply-To: <CAG48ez08bmRSQ7qSdtB-O2riyDw70uiUQyjMhAQTHPHDjSTJfQ@mail.gmail.com>
References: <1506435273-8428-1-git-send-email-s.mesoraca16@gmail.com>
 <1506435273-8428-3-git-send-email-s.mesoraca16@gmail.com> <CAG48ez08bmRSQ7qSdtB-O2riyDw70uiUQyjMhAQTHPHDjSTJfQ@mail.gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 26 Sep 2017 17:13:20 +0200
Message-ID: <CAJHCu1KF23kUvC806QmBZ=3y-Mr8XftPoLJKcv1Yr4+Ld4EZSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC v2 2/2] Protected O_CREAT open in sticky directory
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

2017-09-26 16:40 GMT+02:00 Jann Horn <jannh@google.com>:
> On Tue, Sep 26, 2017 at 4:14 PM, Salvatore Mesoraca
> <s.mesoraca16@gmail.com> wrote:
>> Disallows O_CREAT open missing the O_EXCL flag, in world or
>> group writable directories, even if the file doesn't exist yet.
>> With few exceptions (e.g. shared lock files based on flock())
>> if a program tries to open a file with the O_CREAT flag and
>> without the O_EXCL, it probably has a bug.
>> This feature allows to detect and potentially block programs that
>> act this way and can be used to find vulnerabilities (like those
>> prevented by patch #1) and to do policy enforcement.
> [...]
>> +static int may_create_no_excl(struct dentry * const dir,
>> +                             const unsigned char * const name,
>> +                             struct inode * const inode)
>> +{
>> +       umode_t mode = dir->d_inode->i_mode;
>> +
>> +       if (likely(!(mode & S_ISVTX)))
>> +               return 0;
>> +       if (inode && (uid_eq(inode->i_uid, dir->d_inode->i_uid) ||
>> +                     uid_eq(current_fsuid(), inode->i_uid)))
>> +               return 0;
>
> Why is there an exception for inode->i_uid==dir->d_inode->i_uid? Is this
> kind of behavior more likely to be correct when the directory owner is
> doing it?

That exception is there because we can't really prevent the directory
owner from playing nasty tricks with other users files, so there is no
point in trying to stop him.
Nevertheless, if we intend this feature just as a way to detect possible
vulnerabilities, it may be useful to remove that exception.
I'll do it in the next revision.

>> +       if ((sysctl_protected_sticky_child_create && likely(mode & 0002)) ||
>> +           (sysctl_protected_sticky_child_create >= 2 && mode & 0020)) {
>> +               pr_notice_ratelimited("unsafe O_CREAT open (missing O_EXCL) of '%s' in a sticky directory by UID %d, EUID %d, process %s:%d.\n",
>> +                                     name,
>> +                                     from_kuid(&init_user_ns, current_uid()),
>> +                                     from_kuid(&init_user_ns, current_euid()),
>> +                                     current->comm, current->pid);
>
> As far as I can tell, uid_t is unsigned, so the first two "%d"
> format string elements are technically wrong:
>   extern uid_t from_kuid(struct user_namespace *to, kuid_t uid);
>   typedef __kernel_uid32_t uid_t;
>   typedef unsigned int __kernel_uid32_t;

You are right. I'll fix it in the next version.

Thank you very much for taking the time to look at my email.

Salvatore
