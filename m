Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 4 Oct 2013 10:05:38 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20131004090538.GB2157@dztty>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
 <524B7999.60806@amacapital.net>
 <20131002143759.GA2966@dztty>
 <CALCETrUcg4o5QeGMP1rRAzJSfjwS=qD3DsDWV3=fPJQOA3xkKw@mail.gmail.com>
 <CAGXu5j+APTTSKh_xvgpzV3wNYseQxafbKqQ3NyvUe50aGOOBGg@mail.gmail.com>
 <20131002182206.GB2485@dztty>
 <CAGXu5jL3iReSCfRRXGaKp4dikh5f3BR55NbVEXHrTscTSDgeZA@mail.gmail.com>
 <20131002184844.GB3393@dztty>
 <20131003061244.GC25345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003061244.GC25345@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 0/9] procfs: protect /proc/<pid>/* files with
 file->f_cred
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 03, 2013 at 08:12:44AM +0200, Ingo Molnar wrote:
> So please first get consensus on this fundamental design question before 
> spreading your solution to more areas.
Check file_ns_capable() added in commit 935d8aabd4331 by Linus
Add file_ns_capable() helper function for open-time capability checking

commit 6708075f104c3c9b0 by Eric,
userns: Don't let unprivileged users trick privileged users into setting
the id_map

So they add file_ns_capable() to inspect file->f_cred during ->write()

The difference between the function I've added proc_allow_access() and
file_ns_capable() is that proc_allow_access() will check if it's
absolutely the same user, otherwise fallback to security_capable() which
is the heart of file_ns_capable()

So it's already been done and proposed! this is an easy solution to
detect if current's cred have changed.


> Thanks,
> 
> 	Ingo

-- 
Djalal Harouni
http://opendz.org
