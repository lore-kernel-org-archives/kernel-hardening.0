Date: Tue, 14 Feb 2017 23:34:12 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
In-Reply-To: <alpine.LRH.2.20.1702142142480.20182@namei.org>
Message-ID: <alpine.LRH.2.20.1702142324540.29914@namei.org>
References: <alpine.LRH.2.20.1702131631490.8914@namei.org> <201702131933.GAF69296.FHQOOJSLOFVtFM@I-love.SAKURA.ne.jp> <CAGXu5jK6Y3i+zoHhF1PyehmxURTVdmEcMPio0HGu=+sTiOz8Mg@mail.gmail.com> <alpine.LRH.2.20.1702140921150.19475@namei.org>
 <201702141937.IAD69742.SVtHOQFLJOFFMO@I-love.SAKURA.ne.jp> <alpine.LRH.2.20.1702142142480.20182@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC PATCH 1/4] security: mark LSM hooks
 as __ro_after_init
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 14 Feb 2017, James Morris wrote:

> As mentioned above, we are trying to harden the LSM framework against 
> being an attack vector.  We are not trying to harden it against an already 
> compromised kernel.

I should clarify here -- by already compromised, I mean specifically in 
terms of the attacker being able to bypass/change RO kernel pages.

-- 
James Morris
<jmorris@namei.org>
