From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LRH.2.20.1702150016220.32759@namei.org>
	<201702142324.IFB95862.MOSJLOVFQFtFHO@I-love.SAKURA.ne.jp>
	<alpine.LRH.2.20.1702150952360.6813@namei.org>
	<201702152342.GBH04183.FOFJFHQOLMOtVS@I-love.SAKURA.ne.jp>
	<a5022e72-287b-e0d1-aa54-888eb569ac1f@schaufler-ca.com>
In-Reply-To: <a5022e72-287b-e0d1-aa54-888eb569ac1f@schaufler-ca.com>
Message-Id: <201702162000.EAC43726.FOSVQtJFHMFOLO@I-love.SAKURA.ne.jp>
Date: Thu, 16 Feb 2017 20:00:31 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [RFC v2 PATCH 1/2] security: introduce CONFIG_SECURITY_WRITABLE_HOOKS
To: casey@schaufler-ca.com, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Casey Schaufler wrote:
> I can't say that I'm buying the value of the additional
> complexity here. Sure, you're protecting part of the data
> all the time, but you're exposing part all the time, too.

Will you explain it in detail? As far as I know, __ro_after_init
annotation makes the kernel to call set_memory_ro() after __init
functions are completed, by gathering such variables into a section
so that set_memory_ro() can change page flags for a memory region
where it is PAGE_ALIGNED and the size is multiple of PAGE_SIZE bytes.

This "struct lsm_entry" is for gathering only LSM related variables which
would have been marked as __ro_after_init if CONFIG_SECURITY_WRITABLE_HOOKS=n
into a list of memory regions where they are PAGE_ALIGNED and the size is
multiple of PAGE_SIZE bytes, so that the kernel can call set_memory_ro() on
these memory regions even if CONFIG_SECURITY_SELINUX_DISABLE=y or allowing
LKM based LSMs.

> For now I think that the solution James proposes makes the
> most sense. In the hypothetical loadable modules case I
> don't see real value in hardening bits of the data while
> explicitly making the most important parts dynamic.

Best solution for environments where it is known to enforce only one specific
LSM module and no user choices and no LKM based LSMs (including antivirus or
alike) is to directly embed that LSM module into security/security.c .

CONFIG_SECURITY_WRITABLE_HOOKS=n depends on CONFIG_SECURITY_SELINUX_DISABLE=n
but many of distributor's kernels enable multiple LSM modules including
CONFIG_SECURITY_SELINUX_DISABLE=y. Also, people are using antivirus software
on distributor's kernels. At least one antivirus software (which allows
anonymous download of LKM source code) is using LSM hooks since Linux 2.6.32
instead of rewriting syscall tables. We are already allowing multiple concurrent
LSM modules (up to one fully armored module which uses "struct cred"->security
field or exclusive hooks like security_xfrm_state_pol_flow_match(), plus
unlimited number of lightweight modules which do not use "struct cred"->security
nor exclusive hooks) as long as they are built into the kernel. There is no
reason to keep LKM based LSM modules from antivirus software or alike away.
For such kernels, this "struct lsm_entry" allows calling set_memory_ro() on LSM
related variables which would have been marked as __ro_after_init if
CONFIG_SECURITY_WRITABLE_HOOKS=n.

If you are not happy with using kmalloc() for copying "struct security_hook_list"
in each LSM module, can we agree with padding "struct security_hook_list" in each
LSM module PAGE_ALIGNED and the size being multiple of PAGE_SIZE bytes?
