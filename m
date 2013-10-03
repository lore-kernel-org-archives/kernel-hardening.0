Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 3 Oct 2013 08:12:44 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20131003061244.GC25345@gmail.com>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
 <524B7999.60806@amacapital.net>
 <20131002143759.GA2966@dztty>
 <CALCETrUcg4o5QeGMP1rRAzJSfjwS=qD3DsDWV3=fPJQOA3xkKw@mail.gmail.com>
 <CAGXu5j+APTTSKh_xvgpzV3wNYseQxafbKqQ3NyvUe50aGOOBGg@mail.gmail.com>
 <20131002182206.GB2485@dztty>
 <CAGXu5jL3iReSCfRRXGaKp4dikh5f3BR55NbVEXHrTscTSDgeZA@mail.gmail.com>
 <20131002184844.GB3393@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002184844.GB3393@dztty>
Subject: [kernel-hardening] Re: [PATCH v2 0/9] procfs: protect /proc/<pid>/* files with
 file->f_cred
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Djalal Harouni <tixxdz@opendz.org> wrote:

> > Regardless, glibc uses /proc/self/maps, which would be fine here, right?
>
> I did not touch /proc/self/maps and others, but I'm planning to fix them 
> if this solution is accepted.
> 
> I'll do the same thing as in /proc/*/stat for maps, let it be 0444, and 
> try to delay the check to ->read(). So during ->read() perform 
> ptrace_may_access() on currenct's cred and process_allow_access() on 
> file's opener cred. This should work.

Aren't read() time checks fundamentally unrobust? We generally don't do 
locking on read()s, so such checks - in the general case - are pretty 
racy.

Now procfs might be special, as by its nature of a pseudofilesystem it's 
far more atomic than other filesystems, but still IMHO it's a lot more 
robust security design wise to revoke access to objects you should not 
have a reference to when a security boundary is crossed, than letting 
stuff leak through and sprinking all the potential cases that may leak 
information with permission checks ...

It's also probably faster: security boundary crossings are relatively rare 
slowpaths, while read()s are much more common...

So please first get consensus on this fundamental design question before 
spreading your solution to more areas.

Thanks,

	Ingo
