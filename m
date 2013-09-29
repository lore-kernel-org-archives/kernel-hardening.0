Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 29 Sep 2013 11:37:46 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20130929103746.GB3459@dztty>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
 <1380140085-29712-7-git-send-email-tixxdz@opendz.org>
 <CAGXu5jJKH6WPSMnqALOEjqGb6ZoeyYzj5vemk=2z4KPZyg=ptw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJKH6WPSMnqALOEjqGb6ZoeyYzj5vemk=2z4KPZyg=ptw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 06/12] procfs: make /proc/*/stack 0400
To: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, tixxdz@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 26, 2013 at 03:43:24PM -0500, Kees Cook wrote:
> On Wed, Sep 25, 2013 at 3:14 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > The /proc/*/stack contains sensitive information and currently its mode
> > is 0444. Change this to 0400 so the VFS will be able to block
> > unprivileged processes to get file descriptors on arbitrary privileged
> > /proc/*/stack files.
> >
> > The /proc/*/stack is a /procfs ONE file that shares the same ->open()
> > file operation with other ONE files. Doing a ptrace_may_access() check
> > during open() might break userspace from accessing other ONE files
> > like /proc/*/stat and /proc/*/statm.
> >
> > Therfore make it 0400 for now, and improve its check during ->read()
> > in the next following patch.
> >
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> 
> While the rest of the series is being discussed, I think it would be
> nice to at least get this into the tree. Fixing this reduces which
> processes are exposed to ASLR leaks. The rest of the series closes the
> remaining holes.
Kees I guess it's ok to add your Acked-by for this one, for v2

-- 
Djalal Harouni
http://opendz.org
