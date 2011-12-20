Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 20 Dec 2011 09:35:41 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111220053541.GB2537@albatros>
References: <1324017197-3292-1-git-send-email-keescook@chromium.org>
 <1324017197-3292-3-git-send-email-keescook@chromium.org>
 <alpine.LRH.2.00.1112191130530.22702@tundra.namei.org>
 <20111219194136.GG12321@outflux.net>
 <alpine.LRH.2.00.1112200751260.30800@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1112200751260.30800@tundra.namei.org>
Subject: Re: [kernel-hardening] [PATCH 2/2] security: Yama LSM
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Tue, Dec 20, 2011 at 07:52 +1100, James Morris wrote:
> On Mon, 19 Dec 2011, Kees Cook wrote:
> > On Mon, Dec 19, 2011 at 11:33:10AM +1100, James Morris wrote:
> > > On Thu, 15 Dec 2011, Kees Cook wrote:
> > > > +#ifdef CONFIG_SECURITY_YAMA
> > > > +	ns->ptrace_scope = parent_pid_ns->ptrace_scope;
> > > > +#endif
> > > > +
> > > 
> > > I'd like to see this implemented as an LSM hook, something like 
> > > security_ptrace_set_scope().
> > 
> > I must be dense, but I fail to understand the purpose of this. The "ptrace
> > scope" implemented by Yama is a sysctl, not an system interface. I don't
> > understand why (or where) other LSMs would want to catch changing this.
> > Can you explain what you're looking for in more detail?
> > 
> 
> We should not see YAMA-specific code in the core kernel.  However you do 
> it, the above should happen in LSM.

Probably this should be security_pid_namespace_create() instead of
security_ptrace_set_scope()?  (Or even use create an analog of
register_pernet_subsys() for pid_ns.)

Then have ->ptrace_scope and similar things as per-LSM private variables
like in task_struct->cred->security.  ns->security should be dynamically
allocated.

Thanks,

-- 
Vasiliy
