Date: Fri, 12 Jan 2018 11:51:09 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20180112175109.yoz4jaaipztdj34k@treble>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151571802258.27429.932636277047687877.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <151571802258.27429.932636277047687877.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH v2 07/19] x86: introduce __uaccess_begin_nospec and
 ASM_IFENCE
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 11, 2018 at 04:47:02PM -0800, Dan Williams wrote:
> For 'get_user' paths, do not allow the kernel to speculate on the value
> of a user controlled pointer. In addition to the 'stac' instruction for
> Supervisor Mode Access Protection, an 'ifence' causes the 'access_ok'
> result to resolve in the pipeline before the cpu might take any
> speculative action on the pointer value.

So I understand the need to "patch first and ask questions later".  I
also understand that usercopy is an obvious attack point for speculative
bugs.  However, I'm still hopelessly confused about what exactly this
patch (and the next one) are supposed to accomplish.

I can't figure out if:

a) I'm missing something completely obvious;
b) this is poorly described; or
c) it doesn't actually fix/protect/harden anything.

The commit log doesn't help me at all.  In fact, it confuses me more.
For example, this paragraph:

> Since this is a major kernel interface that deals with user controlled
> data, the '__uaccess_begin_nospec' mechanism will prevent speculative
> execution past an 'access_ok' permission check. While speculative
> execution past 'access_ok' is not enough to lead to a kernel memory
> leak, it is a necessary precondition.

That just sounds wrong.  What if the speculation starts *after* the
access_ok() check?  Then the barrier has no purpose.

Most access_ok/get_user/copy_from_user calls are like this:

  if (copy_from_user(...uptr..))  /* or access_ok() or get_user() */
  	return -EFAULT;

So in other words, the usercopy function is called *before* the branch.

But to halt speculation, the lfence needs to come *after* the branch.
So putting lfences *before* the branch doesn't solve anything.

So what am I missing?

-- 
Josh
