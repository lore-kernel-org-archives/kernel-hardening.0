Date: Sat, 24 Jun 2017 16:43:44 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170624144343.GA29589@openwall.com>
References: <20170606215534.GA13126@openwall.com> <CAGXu5j+tMVT2uQMP74KsYfvN-uFtQmjin-mON9gAs-qAMUq52Q@mail.gmail.com> <20170607120606.GA15236@openwall.com> <CAGXu5jJ80=ujcXw_QUPy5bbq8vse=5eDviH4Px_ja6=XTuDuBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ80=ujcXw_QUPy5bbq8vse=5eDviH4Px_ja6=XTuDuBg@mail.gmail.com>
Subject: Re: [kernel-hardening] symlink/hardlink/FIFO restrictions
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 22, 2017 at 09:27:10PM -0700, Kees Cook wrote:
> On Wed, Jun 7, 2017 at 5:06 AM, Solar Designer <solar@openwall.com> wrote:
> > On Tue, Jun 06, 2017 at 09:10:43PM -0700, Kees Cook wrote:
> >> On Tue, Jun 6, 2017 at 2:55 PM, Solar Designer <solar@openwall.com> wrote:
> >> > As to the FIFO restrictions, those don't appear to have been merged
> >> > upstream yet.
> >>
> >> Do the FIFO restrictions exist in -ow too?
> >
> > Yes, and they pre-date grsecurity too.
> >
> >> I wonder what enabling that protection might break...
> >
> > I was adding notes on what broke to the -ow patch FAQ, but it lists
> > nothing for the FIFOs.  So apparently nothing of note broke, maybe
> > because the restrictions were limited to what was required (e.g., didn't
> > apply to FIFOs opened without O_CREAT).
> >
> > +Restricted FIFOs in /tmp
> > +CONFIG_HARDEN_FIFO
> > +  In addition to restricting links, you might also want to restrict
> > +  writes into untrusted FIFOs (named pipes), to make data spoofing
> > +  attacks harder. Enabling this option disallows writing into FIFOs
> > +  not owned by the user in +t directories, unless the owner is the
> > +  same as that of the directory or the FIFO is opened without the
> > +  O_CREAT flag.
> >
> > @@ -1084,6 +1126,32 @@ do_last:
> >         /*
> >          * It already exists.
> >          */
> > +
> > +#ifdef CONFIG_HARDEN_FIFO
> > +       /*
> > +        * Don't write to FIFOs that we don't own in +t directories,
> > +        * unless the FIFO is owned by the owner of the directory.
> > +        *
> > +        * Do this check early while we hold the directory.
> > +        */
> > +       inode = dentry->d_inode;
> > +       if (S_ISFIFO(inode->i_mode) && !(flag & O_EXCL) &&
> > +           (dir->d_inode->i_mode & S_ISVTX) &&
> > +           inode->i_uid != dir->d_inode->i_uid &&
> > +           current->fsuid != inode->i_uid) {
> > +               up(&dir->d_inode->i_sem);
> > +               if (!permission(inode, acc_mode))
> > +               security_alert("denied writing FIFO of %d.%d "
> > +                       "by UID %d, EUID %d, process %s:%d",
> > +                       "writes into a FIFO denied",
> > +                       inode->i_uid, inode->i_gid,
> > +                       current->uid, current->euid,
> > +                       current->comm, current->pid);
> > +               error = -EACCES;
> > +               goto exit_dput;
> > +       }
> > +#endif
> >
> > The intent was to detect unintentional writes to FIFOs, where the
> > program expected to create a regular file with this very same call.
> >
> > An argument against restricting this is that similar attacks are also
> > possible via attacker-created regular files, especially now that we have
> > inotify, although FIFOs made the attacks particularly simple and
> > reliable (no need to win a race).
> 
> [trying to get back to older emails...]
> 
> Looks reasonable. Do you want to put together a patch for this?

No, I'd prefer that someone else does.  If a new KSPP contributor does,
then we need to provide some mentoring and be especially careful with
patch review - perhaps you'd help with that.  I lack time and I'm not up
to date with latest kernels.

> It seems like it'd be a useful addition to complement the link
> restrictions.

Yes, although not as useful as it used to be, unless:

Maybe at this time we can also afford a restriction on regular files,
even if perhaps disabled by default?  Disallow O_CREAT without O_EXCL in
+t directories, even for regular files.  A separate knob from the FIFOs,
but sharing code with them (skip the S_ISFIFO() check).

The primary thing I expect this to break is people's manual misuse of
/tmp and the like.  Maybe those trying to get rid of this bad habit will
enable this policy enforcement.  Then these people's use of the systems
and their problem reports will also uncover some issues and hardening
opportunities(*) in programs.

(*) Not every +t directory is world-writable - some are group-writable,
where the issues aren't directly exposed.

Alexander
