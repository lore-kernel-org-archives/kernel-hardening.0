Date: Wed, 7 Jun 2017 14:06:06 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170607120606.GA15236@openwall.com>
References: <20170606215534.GA13126@openwall.com> <CAGXu5j+tMVT2uQMP74KsYfvN-uFtQmjin-mON9gAs-qAMUq52Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+tMVT2uQMP74KsYfvN-uFtQmjin-mON9gAs-qAMUq52Q@mail.gmail.com>
Subject: Re: [kernel-hardening] symlink/hardlink/FIFO restrictions
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 09:10:43PM -0700, Kees Cook wrote:
> On Tue, Jun 6, 2017 at 2:55 PM, Solar Designer <solar@openwall.com> wrote:
> > The hardlink restrictions differ between -ow vs. grsecurity and upstream.
> > In -ow, I had the check in vfs_link().  In grsecurity (oldest I checked
> > now is grsecurity-2.1.11-2.4.35-200708071800), it's in sys_link() and
> > later in sys_linkat(), which is also called by sys_link().  Upstream
> > also has it right in the linkat() syscall function.  Maybe there were
> > good reasons not to do it in vfs_link(), but I am unaware of those.
> > We need to know what currently happens and what we'd like to happen for
> > other callers to vfs_link(), such as kernel nfsd and CRIU - do we want
> > the restrictions to apply there?  Maybe for some of those other callers,
> > but not for all?  Do the same checks work correctly when called from
> > those other contexts or do we need revised checks there?
> 
> Hm, yeah, I don't remember sys_linkat() vs vfs_link() coming up during
> review, but it's been a while. The nfsd thing is interesting... would
> it be right to refuse a client's linkat based on the server's link
> restriction sysctl? Hmm.

Probably it would, because otherwise we have a bypass in case the
server's filesystem is or will be later also mounted elsewhere.

> > As to the FIFO restrictions, those don't appear to have been merged
> > upstream yet.
> 
> Do the FIFO restrictions exist in -ow too?

Yes, and they pre-date grsecurity too.

> I wonder what enabling that protection might break...

I was adding notes on what broke to the -ow patch FAQ, but it lists
nothing for the FIFOs.  So apparently nothing of note broke, maybe
because the restrictions were limited to what was required (e.g., didn't
apply to FIFOs opened without O_CREAT).

+Restricted FIFOs in /tmp
+CONFIG_HARDEN_FIFO
+  In addition to restricting links, you might also want to restrict
+  writes into untrusted FIFOs (named pipes), to make data spoofing
+  attacks harder. Enabling this option disallows writing into FIFOs
+  not owned by the user in +t directories, unless the owner is the
+  same as that of the directory or the FIFO is opened without the
+  O_CREAT flag.

@@ -1084,6 +1126,32 @@ do_last:
        /*
         * It already exists.
         */
+
+#ifdef CONFIG_HARDEN_FIFO
+       /*
+        * Don't write to FIFOs that we don't own in +t directories,
+        * unless the FIFO is owned by the owner of the directory.
+        *
+        * Do this check early while we hold the directory.
+        */
+       inode = dentry->d_inode;
+       if (S_ISFIFO(inode->i_mode) && !(flag & O_EXCL) &&
+           (dir->d_inode->i_mode & S_ISVTX) &&
+           inode->i_uid != dir->d_inode->i_uid &&
+           current->fsuid != inode->i_uid) {
+               up(&dir->d_inode->i_sem);
+               if (!permission(inode, acc_mode))
+               security_alert("denied writing FIFO of %d.%d "
+                       "by UID %d, EUID %d, process %s:%d",
+                       "writes into a FIFO denied",
+                       inode->i_uid, inode->i_gid,
+                       current->uid, current->euid,
+                       current->comm, current->pid);
+               error = -EACCES;
+               goto exit_dput;
+       }
+#endif

The intent was to detect unintentional writes to FIFOs, where the
program expected to create a regular file with this very same call.

An argument against restricting this is that similar attacks are also
possible via attacker-created regular files, especially now that we have
inotify, although FIFOs made the attacks particularly simple and
reliable (no need to win a race).

Alexander
