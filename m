Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 27 Sep 2013 09:37:53 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20130927083753.GA3268@dztty>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
 <1380140085-29712-5-git-send-email-tixxdz@opendz.org>
 <CA+55aFwhb8rFbd8xT0==+r_QV-m8ANm+0sFEqUfk9Qg4rYpm-w@mail.gmail.com>
 <20130926030254.GF13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926030254.GF13318@ZenIV.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH 04/12] seq_file: Make seq_file able to access the file's
 opener cred
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, tixxdz@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 26, 2013 at 04:02:54AM +0100, Al Viro wrote:
> On Wed, Sep 25, 2013 at 05:22:51PM -0700, Linus Torvalds wrote:
> > On Wed, Sep 25, 2013 at 1:14 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > >
> > > Therefor add the f_cred field to the seq_file struct and a helper
> > > seq_f_cred() to return it.
> > 
> > I hate how you've split up this patch from the next one that actually
> > _initializes_ the new field.
> > 
> > The two patches should have been one.
> > 
> > I think the patch should also remove the 'user_ns' member, since it's
> > now available as f_cred->user_ns.
> > 
> > I also suspect that it would be better to just make the the new
> > seq_file member point to the 'struct file' instead. Sure, it's an
> > extra level of indirection, but the lifetime of f_cred is not as clear
> > otherwise. You don't increment the reference count, which is correct
> > *only* because 'seq_file' has the same lifetime as 'struct file', and
> > thus the reference count from struct file for the f_cred is
> > sufficient.
> 
> That's better than f_cred (or user_ns, for that matter), but... I'm
> afraid that it'll get abused very soon.  And I don't understand the
> argument about the lifetime rules - what makes struct file ones
> different from struct cred ones in that respect?  Except that in this
> case it's really obvious that we can't grab a reference, that is...

Ok, I'll not argue on f_cred or user_ns as fields for seq_file struct


Al there are other solutions:

1) Use the 'struct file' as pointed by Linus, but instead make
the seq_file->private member point to it.
These ONE nodes that share the same code call:
   proc_single_open()
     -> single_open(filp, proc_single_show, inode);
       -> seq_open()
       -> seq_file->private = inode;

So instead of 'inode' we can pass the 'struct file' to single_open(),
and get the 'inode' and 'file->f_cred' later at any point.

If we go for this, then later other files like /proc/*/{maps,smaps}
that use the 'struct proc_maps_private' should also embed a pointer
to the 'struct file' in that struct. These files use seq files and their
seq_file->private point to this 'struct proc_maps_private'.

So:
Sensitive ONE files can use this solution.
Sensitive INF files need to be converted to REG files and have their own
file operations, like it's done in
[PATCH 11/12] procfs: improve permission checks on /proc/*/syscall

Other REG files will receive the 'struct file' as an arugment, and for
files that use seq files, we should find a way to embed a pointer to
the 'struct file'.


2) Like (1) but instead of using the 'struct file' we pass the adress of
&file->f_inode. We can have 'struct file' using container_of and we also
have the inode. But it will just add more extra level of indirections.
I'm not sure of this one! I don't like it, what about other
/proc/<pid>/* files ? Is this consistent ?


3) Make the sensitive files like /proc/*/{stack,stat} have their own
file_operations. These are ONE nodes that share the same code with the
other ONE files.

I've already done this for /proc/*/syscall that shares code with other
INF files:
[PATCH 11/12] procfs: improve permission checks on /proc/*/syscall

That was the only way I found to have appropriate permission checks and
to not break other files. The /proc/<pid>/auxv will also need its own
file_operations.


We can also argue that sharing code is good or not as good as we think.
Example there is extra unused code for the /proc/*/stack
proc_pid_stack() handler. This function never use its 'pid and ns'
arguments, so why bother to retrieve them!


If we go for this (3) there will be:
* More extra code but optimized for the corresponding file.
* We should not touch seq_file struct.
* These files will still continue to use seq files.
* We'll embed a pointer to the 'struct file' inside
  'struct proc_maps_private', so we can protect /proc/<pid>/{maps,smaps}
  files later. They use seq files, the check will be implemented in
  their m_start() handler.


Personally I'll go for (3) since we'll do the same for some INF files.


Al, what do you think ?



-- 
Djalal Harouni
http://opendz.org
