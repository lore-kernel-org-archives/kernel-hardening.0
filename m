MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170608211817.GA31010@openwall.com>
References: <20170608211817.GA31010@openwall.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 20 Jun 2017 14:02:40 -0700
Message-ID: <CAGXu5j+eCZdXHfnvDMAgwizKzZvgELHmVJn3q-L5k7Wodr-YGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: hard link restrictions
To: Solar Designer <solar@openwall.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 8, 2017 at 2:18 PM, Solar Designer <solar@openwall.com> wrote:
> Kees, all -
>
> My renewed interest in hard link restrictions was in context of crontab
> vs. crond privsep:
>
> http://www.openwall.com/lists/oss-security/2017/06/08/3
>
> Under that threat model (mostly overlooked/neglected so far?), any
> hard link to another user's (or root's) file is risky.  Even a file the
> linking user could readily read and write.  For crond specifically, this
> is not the case because it will refuse to process files with extra write
> permissions.  But for other services not yet hardened like this, e.g.
> mode 666 files hard-linked into their queue, etc. directories could be
> usable for attacks.
>
> Another subtle scenario where a hard link to another user's writable
> file could help the attacker is preserving one's ability to bypass disk
> quota via that file, even after the original owner would have deleted
> their original link to the file.  Similarly, it'd allow for keeping the
> other user's disk quota consumption even until after that user would
> have deleted their original link and wanted the quota usage reclaimed.
>
> Because those hard link restrictions were so non-standard back
> when they were new, we applied them only to files the user could not
> readily read and write, plus to SUIDs/SGIDs for the "pinning" concern.
> We tried to minimize breakage of programs relying on being able to hard
> link to arbitrary files.
>
> Maybe now is the time to introduce a stricter mode, perhaps enabled with
> "fs.protected_hardlinks = 2", where any hard links to other users' files
> would be disallowed, except when the invoking process has CAP_FOWNER?

I wouldn't be opposed to this idea. I always found hardlink behavior
to be surprising.

> In code, this would be skipping the "|| safe_hardlink_source(inode)" in:
>
>         /* Source inode owner (or CAP_FOWNER) can hardlink all they like,
>          * otherwise, it must be a safe source.
>          */
>         if (inode_owner_or_capable(inode) || safe_hardlink_source(inode))
>                 return 0;

Yup, agreed. Pardon the gmail-induced whitespace damage:

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 35e17f748ca7..aea564ee5f00 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -198,6 +198,9 @@ When set to "0", hardlink creation behavior is unrestricted.
 When set to "1" hardlinks cannot be created by users if they do not
 already own the source file, or do not have read/write access to it.

+When set to "2" hardlinks cannot be created by users if they do not
+already own the source file.
+
 This protection is based on the restrictions in Openwall and grsecurity.

 ==============================================================
diff --git a/fs/namei.c b/fs/namei.c
index 6571a5f5112e..0c52c0f8eebd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1005,10 +1005,12 @@ static int may_linkat(struct path *link)

        inode = link->dentry->d_inode;

-       /* Source inode owner (or CAP_FOWNER) can hardlink all they like,
-        * otherwise, it must be a safe source.
-        */
-       if (inode_owner_or_capable(inode) || safe_hardlink_source(inode))
+       /* Source inode owner (or CAP_FOWNER) can hardlink all they like. */
+       if (inode_owner_or_capable(inode))
+               return 0;
+
+       /* Otherwise, mode 1 allows a reasonable source. */
+       if (sysctl_protected_hardlinks < 2 && safe_hardlink_source(inode))
                return 0;

        audit_log_link_denied("linkat", link);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4dfba1a76cc3..827ec97a0898 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1778,7 +1778,7 @@ static struct ctl_table fs_table[] = {
                .mode           = 0600,
                .proc_handler   = proc_dointvec_minmax,
                .extra1         = &zero,
-               .extra2         = &one,
+               .extra2         = &two,
        },
        {
                .procname       = "suid_dumpable",


> While we're at it, doesn't the above code unnecessarily set PF_SUPERPRIV
> (which is then reported via BSD process accounting) when the CAP_FOWNER
> check inside inode_owner_or_capable() is reached and passed, but
> safe_hardlink_source() later returns false?

Erm, yeah, good point.

> In fact, inode_owner_or_capable() itself might also be problematic in
> this respect in that it'd set PF_SUPERPRIV even if kuid_has_mapping()
> later fails:
>
>         if (ns_capable(ns, CAP_FOWNER) && kuid_has_mapping(ns, inode->i_uid))
>                 return true;

I thought there was an alternative capable() check that didn't set
PF_SUPERPRIV... Ah, "has_*" prefix doesn't set them, but we should fix
these others since they may actually be using a capability.

> Or has the kernel gave up on being careful not to set PF_SUPERPRIV
> unnecessarily?  Sometimes it's a conflicting goal to minimizing the
> attack surface and improving performance in case of request flood DoS
> attacks, where it's best to stop processing the request sooner ("you
> would not be capable anyway") than later (after expensive other checks).

Right, I think it's not well audited. I'd expect anything with an
expensive check to use has_* first and then DTRT with PF_SUPERPRIV,
but that doesn't look to be the case in may_linkat() nor
inode_owner_or_capable().

-Kees

-- 
Kees Cook
Pixel Security
