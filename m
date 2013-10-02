Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 2 Oct 2013 19:41:54 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20131002184154.GA3393@dztty>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
 <524B7999.60806@amacapital.net>
 <20131002143759.GA2966@dztty>
 <CALCETrUcg4o5QeGMP1rRAzJSfjwS=qD3DsDWV3=fPJQOA3xkKw@mail.gmail.com>
 <CAGXu5j+APTTSKh_xvgpzV3wNYseQxafbKqQ3NyvUe50aGOOBGg@mail.gmail.com>
 <CALCETrW05=Jk_nCakZgjwJjbdG-X-f=ssFntB3Xpe1ogxiTMFQ@mail.gmail.com>
 <20131002182643.GC2485@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002182643.GC2485@dztty>
Subject: [kernel-hardening] Re: [PATCH v2 0/9] procfs: protect /proc/<pid>/* files with
 file->f_cred
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 02, 2013 at 07:26:43PM +0100, Djalal Harouni wrote:
> On Wed, Oct 02, 2013 at 11:00:26AM -0700, Andy Lutomirski wrote:
> > On Wed, Oct 2, 2013 at 10:48 AM, Kees Cook <keescook@chromium.org> wrote:
> > > I think revoking the fd would be great. Does that mechanism exist?
> > 
> > There's this thing that never got merged.
> > 
> > http://thread.gmane.org/gmane.linux.kernel/1523331
> > 
> > But doing it more directly should be reasonably straightforward.  Either:
> > 
> > (a) when a process execs and privileges change, find all the old proc
> > inodes, mark them dead, and unlink them, or
> Will take a look at it.
> 
> > (b) add self_exec_id to all the proc file private_data entries (or
> > somewhere else).  Then just make sure that they're unchanged.  I think
> > the bug last time around was because the self_exec_id and struct pid
> > weren't being compared together.
> The bug was about self_exec_id not beeing unique. self_exec_id stuff
> must be unique during life time as it's done currently in grsecurity
> with exec_id.
I forget to mention that I've already proposed this (b) solution, but after
the discussion with Eric, I came to the conclusion that we could allow
the fd to be passed to the process if the original opener had enough
privileges. In either case we want to check the privileges, otherwise ps
and other tool will not report data if target tasks do execve.

-- 
Djalal Harouni
http://opendz.org
