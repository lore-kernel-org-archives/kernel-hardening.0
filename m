Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 3 Oct 2013 15:39:39 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20131003133939.GB28308@gmail.com>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
 <524B7999.60806@amacapital.net>
 <20131002143759.GA2966@dztty>
 <CALCETrUcg4o5QeGMP1rRAzJSfjwS=qD3DsDWV3=fPJQOA3xkKw@mail.gmail.com>
 <20131002181257.GA2485@dztty>
 <20131003062256.GD25345@gmail.com>
 <20131003125609.GB3619@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003125609.GB3619@dztty>
Subject: [kernel-hardening] Re: [PATCH v2 0/9] procfs: protect /proc/<pid>/* files with
 file->f_cred
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Djalal Harouni <tixxdz@opendz.org> wrote:

> On Thu, Oct 03, 2013 at 08:22:56AM +0200, Ingo Molnar wrote:
> > 
> > * Djalal Harouni <tixxdz@opendz.org> wrote:
> > 
> > >  * You can't do it for /proc/*/stat otherwise you will break userspace
> > >   "ps"..., ps must access /proc/1/stat etc... so the proposed solution
> > >   will work without any side effect.
> > 
> > The thing is, returning -EINVAL is not the only way to reject access to 
> > privileged information!
> 
> > In the /proc/1/stat case a compatibility quirk can solve the problem: 
> > create a special 'dummy' process inode for invalid accesses and give 
> > it to ps, with all fields present but zero.
>
> Hmm, we already return zero for the fields that must be protected. 
> Already done.
>
> Not all fields need to be zero ?  If so, yes it could be done as you 
> propose and avoid the 'if permitted' test each time... but we don't want 
> to do it

Indeed some fields need to be available, for utilities like 'top' to work.

Thanks,

	Ingo
