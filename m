Sender: Tejun Heo <htejun@gmail.com>
Date: Wed, 10 May 2017 13:52:38 -0400
From: Tejun Heo <tj@kernel.org>
Message-ID: <20170510175238.GH32165@htj.duckdns.org>
References: <20170510173637.25116-1-danielmicay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170510173637.25116-1-danielmicay@gmail.com>
Subject: [kernel-hardening] Re: [PATCH] mark most percpu globals as __ro_after_init
To: Daniel Micay <danielmicay@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hello, Daniel.

On Wed, May 10, 2017 at 01:36:37PM -0400, Daniel Micay wrote:
> Moving pcpu_base_addr to this section comes from PaX where it's part of
> KERNEXEC. This extends it to the rest of the globals only written by the
> init code.

How did you test the patch?

> -static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
> +static struct list_head *pcpu_slot __ro_after_init; /* chunk list slots */

At least this one isn't read only.

Thanks.

-- 
tejun
