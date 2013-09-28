Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 28 Sep 2013 15:57:26 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20130928145725.GB2199@dztty>
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
For that reference count lifetime rule. Sorry I was trying to compare it
with other implemented solutions. /proc/pid/environ will increment the
mm->mm_count inside __mem_open(), thus mm_struct will stay in until
mem_release(). That's it.

In the proposed solution and as noted by Linus, the reference count
from 'struct file' is sufficient for f_cred.

Last, I'm happy with /proc/pid/environ as it is, will not touch it
unless there is a request for it, but this proposed file->f_cred
solution is better:
* Not *all* these /proc/<pid>/* files are interested in acquiring a
  reference to the task's mm and increment its counters.
* It can be adapted to all the /proc/<pid>/* files, we already have the
  file->f_cred
* It allow to pass file descriptors if original opener had enough
  permission. It's explained in [Patch 0/12]
* It allow referencing the correct mm of the currently running
  target task at read(),write()...

  Where other solutions will just block/restrict this behaviour.

Thanks

-- 
Djalal Harouni
http://opendz.org
