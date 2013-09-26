Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 26 Sep 2013 04:02:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20130926030254.GF13318@ZenIV.linux.org.uk>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
 <1380140085-29712-5-git-send-email-tixxdz@opendz.org>
 <CA+55aFwhb8rFbd8xT0==+r_QV-m8ANm+0sFEqUfk9Qg4rYpm-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwhb8rFbd8xT0==+r_QV-m8ANm+0sFEqUfk9Qg4rYpm-w@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH 04/12] seq_file: Make seq_file able to access the file's
 opener cred
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Djalal Harouni <tixxdz@opendz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, tixxdz@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Sep 25, 2013 at 05:22:51PM -0700, Linus Torvalds wrote:
> On Wed, Sep 25, 2013 at 1:14 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >
> > Therefor add the f_cred field to the seq_file struct and a helper
> > seq_f_cred() to return it.
> 
> I hate how you've split up this patch from the next one that actually
> _initializes_ the new field.
> 
> The two patches should have been one.
> 
> I think the patch should also remove the 'user_ns' member, since it's
> now available as f_cred->user_ns.
> 
> I also suspect that it would be better to just make the the new
> seq_file member point to the 'struct file' instead. Sure, it's an
> extra level of indirection, but the lifetime of f_cred is not as clear
> otherwise. You don't increment the reference count, which is correct
> *only* because 'seq_file' has the same lifetime as 'struct file', and
> thus the reference count from struct file for the f_cred is
> sufficient.

That's better than f_cred (or user_ns, for that matter), but... I'm
afraid that it'll get abused very soon.  And I don't understand the
argument about the lifetime rules - what makes struct file ones
different from struct cred ones in that respect?  Except that in this
case it's really obvious that we can't grab a reference, that is...
