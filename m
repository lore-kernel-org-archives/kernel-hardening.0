Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 29 Mar 2016 13:53:22 -0700
From: Andi Kleen <ak@linux.intel.com>
Message-ID: <20160329205322.GB9083@tassilo.jf.intel.com>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
 <1459281207-24377-4-git-send-email-sbauer@eng.utah.edu>
 <20160329195906.GA9083@tassilo.jf.intel.com>
 <56FAE98B.8040008@eng.utah.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56FAE98B.8040008@eng.utah.edu>
Subject: [kernel-hardening] Re: [PATCH v4 3/4] Sysctl: SROP Mitigation: Add Sysctl argument to
 disable SROP.
To: Scotty Bauer <sbauer@eng.utah.edu>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, x86@kernel.org, luto@amacapital.net, mingo@redhat.com, tglx@linutronix.de, wmealing@redhat.com, torvalds@linux-foundation.org, Abhiram Balasubramanian <abhiram@cs.utah.edu>, Scott Bauer <sbauer@plzdonthack.me>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 29, 2016 at 02:46:03PM -0600, Scotty Bauer wrote:
> 
> 
> 
> On 03/29/2016 01:59 PM, Andi Kleen wrote:
> > On Tue, Mar 29, 2016 at 01:53:26PM -0600, Scott Bauer wrote:
> >> This patch adds a sysctl argument to disable SROP protection.
> > 
> > Sysctl needs to be documented in Documentation/sysctl/
> > 
> > Also negated sysctl is weird, normally they are positive (enable-xxx)
> > 
> 
> Sure, I can change it. This may be a dumb question: I want SROP to be enabled by default, and thus the new
> enable-xxx will be initialized to 1, that's fine, right?

Yes that's fine.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
