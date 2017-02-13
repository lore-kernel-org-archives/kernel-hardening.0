Date: Tue, 14 Feb 2017 09:23:45 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
In-Reply-To: <CAGXu5jK6Y3i+zoHhF1PyehmxURTVdmEcMPio0HGu=+sTiOz8Mg@mail.gmail.com>
Message-ID: <alpine.LRH.2.20.1702140921150.19475@namei.org>
References: <alpine.LRH.2.20.1702131631490.8914@namei.org> <201702131933.GAF69296.FHQOOJSLOFVtFM@I-love.SAKURA.ne.jp> <CAGXu5jK6Y3i+zoHhF1PyehmxURTVdmEcMPio0HGu=+sTiOz8Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC PATCH 1/4] security: mark LSM hooks
 as __ro_after_init
To: Kees Cook <keescook@chromium.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 13 Feb 2017, Kees Cook wrote:

> On Mon, Feb 13, 2017 at 2:33 AM, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > James Morris wrote:
> >> As the regsitration of LSMs is performed during init and then does
> >> not change, we can mark all of the regsitration hooks as __ro_after_init.
> >>
> >> Signed-off-by: James Morris <james.l.morris@oracle.com>
> >
> > This patch makes LKM based LSMs (e.g. AKARI) impossible.
> > I'm not happy with this patch.
> 
> LKM based LSMs don't exist yet, and when they do, we may also have the
> "write rarely" infrastructure done, which LKM based LSMs can use to
> update the structures.

I think it would be a backwards step security-wise to allow dynamically 
loadable security modules.  The security risks of security code in the 
kernel should be aggressively minimized.


-- 
James Morris
<jmorris@namei.org>
