Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 19 Nov 2011 20:59:03 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20111119165903.GB2208@openwall.com>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org> <1319672956-17114-4-git-send-email-keescook@chromium.org> <20111119163058.GA3131@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111119163058.GA3131@albatros>
Subject: [kernel-hardening] Re: [PATCH 3/3] security: Yama: add ptrace relationship tracking interface
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 19, 2011 at 08:30:58PM +0400, Vasiliy Kulikov wrote:
> On Wed, Oct 26, 2011 at 16:49 -0700, Kees Cook wrote:
> > +	if (mode == PTRACE_MODE_ATTACH &&
> > +	    ptrace_scope &&
> > +	    !capable(CAP_SYS_PTRACE) &&
> > +	    !task_is_descendant(current, child) &&
> > +	    !ptracer_exception_found(current, child))
> > +		rc = -EPERM;
> 
> capable() is better to put after all other tests

Right, but...

> as a failed capable()
> might emit a false positive warning into logs or something.

...primarily for another reason: a successful capable() sets
PF_SUPERPRIV, whereas the permission might have been granted without
capable() as well.  The PF_SUPERPRIV flag is visible via BSD process
accounting.

Alexander
