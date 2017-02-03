Date: Fri, 3 Feb 2017 12:02:55 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
In-Reply-To: <1486055094-4532-3-git-send-email-djalal@gmail.com>
Message-ID: <alpine.LRH.2.20.1702031159120.3285@namei.org>
References: <1486055094-4532-1-git-send-email-djalal@gmail.com> <1486055094-4532-3-git-send-email-djalal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC/PATCH 2/3] security: Add the Timgad module
To: Djalal Harouni <tixxdz@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Lafcadio Wluiki <wluikil@gmail.com>, Dongsu Park <dongsu@endocode.com>, Andy Lutomirski <luto@kernel.org>, James Morris <james.l.morris@oracle.com>, serge@hallyn.com, Al Viro <viro@zeniv.linux.org.uk>, Daniel Mack <daniel@zonque.org>, Jann Horn <jann@thejh.net>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2 Feb 2017, Djalal Harouni wrote:

> *) The per-process prctl() settings are:
>     prctl(PR_TIMGAD_OPTS, PR_TIGMAD_SET_MOD_RESTRICT, value, 0, 0)
> 
>     Where value means:
> 
> 0 - Classic module load and unload permissions, nothing changes.
> 
> 1 - The current process must have CAP_SYS_MODULE to be able to load and
>     unload modules. CAP_NET_ADMIN should allow the current process to
>     load and unload only netdev aliased modules, not implemented
> 
> 2 - Current process can not loaded nor unloaded modules.
> 
> *) sysctl interface supports the followin values:
> 
> 0 - Classic module load and unload permissions, nothing changes.
> 
> 1 - Only privileged processes with CAP_SYS_MODULE should be able to load and
>     unload modules.
> 
>     To be added: processes with CAP_NET_ADMIN should be able to
>     load and unload only netdev aliased modules, this is currently not
>     supported. Other checks for real root without CAP_SYS_MODULE ? ...
> 
>     (This should be improved)
> 
> 2 - Modules can not be loaded nor unloaded. Once set, this sysctl value
>     cannot be changed.

How is this different to just using CAP_SYS_MODULE?

-- 
James Morris
<jmorris@namei.org>
