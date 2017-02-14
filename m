Date: Tue, 14 Feb 2017 23:59:34 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
In-Reply-To: <201702142150.BEF81226.tOOFQVFJOHFMSL@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.2.20.1702142357560.29914@namei.org>
References: <201702131933.GAF69296.FHQOOJSLOFVtFM@I-love.SAKURA.ne.jp> <CAGXu5jK6Y3i+zoHhF1PyehmxURTVdmEcMPio0HGu=+sTiOz8Mg@mail.gmail.com> <alpine.LRH.2.20.1702140921150.19475@namei.org> <201702141937.IAD69742.SVtHOQFLJOFFMO@I-love.SAKURA.ne.jp>
 <alpine.LRH.2.20.1702142142480.20182@namei.org> <201702142150.BEF81226.tOOFQVFJOHFMSL@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC PATCH 1/4] security: mark LSM hooks
 as __ro_after_init
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 14 Feb 2017, Tetsuo Handa wrote:

> James Morris wrote:
> > > Disallowing dynamically loadable security modules is as silly idea as
> > > getting rid of LSM framework ( https://lwn.net/Articles/138042/ 
> > > http://lkml.kernel.org/r/alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org )
> > > unless we accept whatever out-of-tree LSM modules and maintain them as in-tree
> > > modules and enable them in distributor's kernels. But such things won't happen.
> > > If we legally allow LKM based LSMs, we don't need to make security/ directory
> > > look like /dev/random .
> > 
> > Dynamically loadable LSMs are legally allowed, we just don't cater to them 
> > in mainline.
> > 
> I'm saying that this patch will make dynamically loadable LSMs illegal, for
> not allowing updating struct list_head prevents dynamically loadable LSMs from
> registering.

The next patch set will include an option to allow writable hooks (for 
SELinux runtime disable).


-- 
James Morris
<jmorris@namei.org>
