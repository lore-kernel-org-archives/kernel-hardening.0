Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 10 Mar 2016 10:43:39 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160310094339.GA5105@gmail.com>
References: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
 <20160309083204.GA30365@gmail.com>
 <56E09E8B.1010909@eng.utah.edu>
 <20160309152212.07a9b83b@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160309152212.07a9b83b@lwn.net>
Subject: [kernel-hardening] Re: [PATCH v3 1/3] SROP Mitigation: Architecture independent code
 for signal cookies
To: Jonathan Corbet <corbet@lwn.net>
Cc: Scotty Bauer <sbauer@eng.utah.edu>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, x86@kernel.org, wmealing@redhat.com, ak@linux.intel.com, luto@amacapital.net, Abhiram Balasubramanian <abhiram@cs.utah.edu>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Jonathan Corbet <corbet@lwn.net> wrote:

> On Wed, 9 Mar 2016 15:07:07 -0700
> Scotty Bauer <sbauer@eng.utah.edu> wrote:
> 
> > On 03/09/2016 01:32 AM, Ingo Molnar wrote:
> > > 
> > > Could you please add a high level description in Documentation
> > > that explains the attack and the way how this mitigation code
> > > prevents that kind of attack?
> > > 
> > > Also, the first changelogs should contain more high level
> > > description as well. For example, what does the 'verification'
> > > of the signal cookie mean, and how does it prevent an SROP
> > > attempt?
> > > 
> > > All of these patches seem to assume that people reading this code
> > > know what SROP is and how we defend against it - that is not so.
> > 
> > I'm going to submit v4 to fix some nits where I'll include the explanation
> > and a change log, I apologize for not doing that here. In the meantime if
> > you don't mind visiting a link I included a brief explanation on previous
> > versions of the patch set.
> > 
> > https://lkml.org/lkml/2016/2/6/166
> 
> The curious might also find background information in my article about this
> patch set:
> 
>       https://lwn.net/Articles/676803/

Scott, mind including a prominent link to the (excellent!) LWN.net article in the 
changelog/documentation as well?

Thanks,

	Ingo
