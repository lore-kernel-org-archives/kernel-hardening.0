MIME-Version: 1.0
In-Reply-To: <CAGXu5jLRn3_gCb4F5EyUXSk=JOW-yzftST3z2XA3Kner21d=bw@mail.gmail.com>
References: <1505465028-15256-1-git-send-email-s.mesoraca16@gmail.com> <CAGXu5jLRn3_gCb4F5EyUXSk=JOW-yzftST3z2XA3Kner21d=bw@mail.gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 19 Sep 2017 17:51:00 +0200
Message-ID: <CAJHCu1LFTtRuC1-bGLtQxD=GdAZX8CtFkM=COEM2Ce=1aN5x7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC] Restrict writes into untrusted FIFOs and regular files
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Solar Designer <solar@openwall.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

2017-09-18 23:00 GMT+02:00 Kees Cook <keescook@chromium.org>:
> On Fri, Sep 15, 2017 at 1:43 AM, Salvatore Mesoraca
> <s.mesoraca16@gmail.com> wrote:
>> Disallows writing into FIFOs or regular files not owned by the user
>> in world writable sticky directories, unless the owner is the same as
>> that of the directory or the file is opened without the O_CREAT flag.
>
> Thanks for working on this!
Thank you for taking the time to review it!

>> The purpose is to make data spoofing attacks harder.
>
> Do you have any examples of attacks (CVEs, blog posts, etc) that you
> could link to in this commit?
I'll try to find some examples of CVEs partially fixed by the symlinks/hardlinks
restriction that could be still exploited via FIFOs or regular files.

>> This protection can be turned on and off separately for FIFOs and regular
>> files via sysctl, just like the symlinks/hardlinks protection.
>> This patch is based on Openwall's "HARDEN_FIFO" feature by Solar
>> Designer <solar at openwall.com>.
>
> The email address obfuscation can be dropped here, it's already listed
> in the "Suggested-by". :)
Oops :)

>> Suggested-by: Solar Designer <solar@openwall.com>
>> Suggested-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
>> ---
>>  Documentation/sysctl/fs.txt | 34 ++++++++++++++++++++++++++++++++++
>>  fs/namei.c                  | 23 +++++++++++++++++++++++
>>  include/linux/fs.h          |  2 ++
>>  kernel/sysctl.c             | 18 ++++++++++++++++++
>>  4 files changed, 77 insertions(+)
>>
>> diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
>> index 35e17f7..18e16b7 100644
>> --- a/Documentation/sysctl/fs.txt
>> +++ b/Documentation/sysctl/fs.txt
>> @@ -36,6 +36,8 @@ Currently, these files are in /proc/sys/fs:
>>  - pipe-user-pages-soft
>>  - protected_hardlinks
>>  - protected_symlinks
>> +- protected_fifos
>> +- protected_regular_files
>
> bike shed: I think "_files" is redundant, since we're already in proc/sys/fs/
>
> Also, here and later, keep this list alphabetized (fifos, hardlinks,
> regular_files, symlinks).
OK, I'll fix this.

>>  - suid_dumpable
>>  - super-max
>>  - super-nr
>> @@ -222,6 +224,38 @@ This protection is based on the restrictions in Openwall and grsecurity.
>>
>>  ==============================================================
>>
>> +protected_fifos:
>> +
>> +The intent of this protection is to avoid unintentional writes to
>> +an attacker-controlled FIFO, where program expected to create a regular
>> +file.
>
> Typo: "a program" or "programs", instead of "program".
Oops 2 :)

>> +
>> +When set to "0", FIFOs writing is unrestricted.
>> +
>> +When set to "1" don't allow O_CREAT open on FIFOs that we don't own
>> +in world writable sticky directories, unless they are owned by the
>> +owner of the directory.
>> +
>> +This protection is based on the restrictions in Openwall.
>> +
>> +==============================================================
>> +
>> +protected_regular_files:
>> +
>> +This protection is similar to protected_fifos, but it
>> +avoids writes to an attacker-controlled regular file, where program
>> +expected to create one.
>> +
>> +When set to "0", regular files writing is unrestricted.
>> +
>> +When set to "1" don't allow O_CREAT open on regular files that we
>> +don't own in world writable sticky directories, unless they are
>> +owned by the owner of the directory.
>> +
>> +This protection is based on the restrictions in Openwall.
>> +
>> +==============================================================
>> +
>>  suid_dumpable:
>>
>>  This value can be used to query and set the core dump mode for setuid
>> diff --git a/fs/namei.c b/fs/namei.c
>> index c75ea03..5459dbc 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -3225,6 +3225,9 @@ static int lookup_open(struct nameidata *nd, struct path *path,
>>         return error;
>>  }
>>
>> +int sysctl_protected_fifos __read_mostly;
>> +int sysctl_protected_regular_files __read_mostly;
>> +
>>  /*
>>   * Handle the last step of open()
>>   */
>> @@ -3354,6 +3357,26 @@ static int do_last(struct nameidata *nd,
>>
>>         seq = 0;        /* out of RCU mode, so the value doesn't matter */
>>         inode = d_backing_inode(path.dentry);
>> +       /*
>> +        * When this protection is turned on via sysctl:
>> +        * don't allow "O_CREAT" open on FIFOs or regular files that we
>> +        * don't own in world writable sticky directories, unless they
>> +        * are owned by the owner of the directory.
>> +        */
>> +       if (((sysctl_protected_fifos && S_ISFIFO(inode->i_mode)) ||
>> +            (sysctl_protected_regular_files && S_ISREG(inode->i_mode))) &&
>> +           (dir->d_inode->i_mode & (S_ISVTX|S_IWOTH) == (S_ISVTX|S_IWOTH)) &&
>> +           !uid_eq(inode->i_uid, dir->d_inode->i_uid) &&
>> +           !uid_eq(current_fsuid(), inode->i_uid)) {
>> +               pr_notice_ratelimited("denied writing in file of %d.%d in a sticky directory by UID %d, EUID %d, process %s:%d.",
>> +                               from_kuid(&init_user_ns, inode->i_uid),
>> +                               from_kgid(&init_user_ns, inode->i_gid),
>> +                               from_kuid(&init_user_ns, current_uid()),
>> +                               from_kuid(&init_user_ns, current_euid()),
>> +                               current->comm, current->pid);
>> +               path_to_nameidata(&path, nd);
>> +               return -EACCES;
>> +       }
>
> I think instead of putting this inline in do_last(), you can make a
> helper function (e.g. may_creat()), as done for the hardlink and
> symlink restrictions. Also, I think you'll need to do this check later
> and merge with with the existing O_CREAT flag sanity check:
>
>         if (open_flag & O_CREAT) {
>                 error = -EISDIR;
>                 if (d_is_dir(nd->path.dentry))
>                     goto out;
>                 error = may_creat(dir, inode);
>                 if (unlikely(error))
>                     goto out;
>         }
>
OK, I'll do this in the next revision.

>>  finish_lookup:
>>         error = step_into(nd, &path, 0, inode, seq);
>>         if (unlikely(error))
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 339e737..591ae87 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -71,6 +71,8 @@
>>  extern int leases_enable, lease_break_time;
>>  extern int sysctl_protected_symlinks;
>>  extern int sysctl_protected_hardlinks;
>> +extern int sysctl_protected_fifos;
>> +extern int sysctl_protected_regular_files;
>>
>>  typedef __kernel_rwf_t rwf_t;
>>
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index 6648fbb..b18d500 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -1807,6 +1807,24 @@ static int sysrq_sysctl_handler(struct ctl_table *table, int write,
>>                 .extra2         = &one,
>>         },
>>         {
>> +               .procname       = "protected_fifos",
>> +               .data           = &sysctl_protected_fifos,
>> +               .maxlen         = sizeof(int),
>> +               .mode           = 0600,
>> +               .proc_handler   = proc_dointvec_minmax,
>> +               .extra1         = &zero,
>> +               .extra2         = &one,
>> +       },
>> +       {
>> +               .procname       = "protected_regular_files",
>> +               .data           = &sysctl_protected_regular_files,
>> +               .maxlen         = sizeof(int),
>> +               .mode           = 0600,
>> +               .proc_handler   = proc_dointvec_minmax,
>> +               .extra1         = &zero,
>> +               .extra2         = &one,
>> +       },
>> +       {
>>                 .procname       = "suid_dumpable",
>>                 .data           = &suid_dumpable,
>>                 .maxlen         = sizeof(int),
>> --
>> 1.9.1
>>
>
> Otherwise, yeah, looks good! :)
Great, thank you!

Salvatore
