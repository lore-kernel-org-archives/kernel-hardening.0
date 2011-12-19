Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Dec 2011 11:41:36 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20111219194136.GG12321@outflux.net>
References: <1324017197-3292-1-git-send-email-keescook@chromium.org>
 <1324017197-3292-3-git-send-email-keescook@chromium.org>
 <alpine.LRH.2.00.1112191130530.22702@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1112191130530.22702@tundra.namei.org>
Subject: Re: [kernel-hardening] [PATCH 2/2] security: Yama LSM
To: James Morris <jmorris@namei.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi James,

On Mon, Dec 19, 2011 at 11:33:10AM +1100, James Morris wrote:
> On Thu, 15 Dec 2011, Kees Cook wrote:
> > +#ifdef CONFIG_SECURITY_YAMA
> > +	ns->ptrace_scope = parent_pid_ns->ptrace_scope;
> > +#endif
> > +
> 
> I'd like to see this implemented as an LSM hook, something like 
> security_ptrace_set_scope().

I must be dense, but I fail to understand the purpose of this. The "ptrace
scope" implemented by Yama is a sysctl, not an system interface. I don't
understand why (or where) other LSMs would want to catch changing this.
Can you explain what you're looking for in more detail?

-Kees

-- 
Kees Cook
