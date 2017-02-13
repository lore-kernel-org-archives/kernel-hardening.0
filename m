From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LRH.2.20.1702131632340.8914@namei.org>
In-Reply-To: <alpine.LRH.2.20.1702131632340.8914@namei.org>
Message-Id: <201702132029.HJD35443.HFQFVOJOFLtOMS@I-love.SAKURA.ne.jp>
Date: Mon, 13 Feb 2017 20:29:24 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [RFC PATCH 2/4] security: mark nf ops in SELinux and Smack as __ro_after_init
To: jmorris@namei.org, linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

James Morris wrote:
> Both SELinux and Smack register Netfilter operations during init,
> which then don't change.  Mark these ops as __ro_after_init.
> 
> Signed-off-by: James Morris <james.l.morris@oracle.com>

This patch breaks CONFIG_SECURITY_SELINUX_DISABLE=y + SELINUX=disabled in /etc/selinux/config case,
doesn't it? Although I heard that SELinux is planning to remove CONFIG_SECURITY_SELINUX_DISABLE,
CONFIG_SECURITY_SELINUX_DISABLE is valid as of current linux-security.git#next .
