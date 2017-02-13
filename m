Date: Mon, 13 Feb 2017 17:57:30 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170213175730.GA16636@leverpostej>
References: <alpine.LRH.2.20.1702131631490.8914@namei.org>
 <201702131933.GAF69296.FHQOOJSLOFVtFM@I-love.SAKURA.ne.jp>
 <CAGXu5jK6Y3i+zoHhF1PyehmxURTVdmEcMPio0HGu=+sTiOz8Mg@mail.gmail.com>
 <9a8a38e0-d502-d6fc-5ea6-77f45539eba6@redhat.com>
 <CAGXu5jKg=5XrAEeRWXAjV8GdLdL6zhiMChQDya0uzWrLiZ5Fsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKg=5XrAEeRWXAjV8GdLdL6zhiMChQDya0uzWrLiZ5Fsg@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 1/4] security: mark LSM hooks
 as __ro_after_init
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, James Morris <jmorris@namei.org>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Mon, Feb 13, 2017 at 09:34:32AM -0800, Kees Cook wrote:
> On Mon, Feb 13, 2017 at 8:26 AM, Laura Abbott <labbott@redhat.com> wrote:
> > On 02/13/2017 06:59 AM, Kees Cook wrote:
> >> On Mon, Feb 13, 2017 at 2:33 AM, Tetsuo Handa
> >> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> >>> James Morris wrote:
> >>>> As the regsitration of LSMs is performed during init and then does
> >>>> not change, we can mark all of the regsitration hooks as __ro_after_init.
> >>>>
> >>>> Signed-off-by: James Morris <james.l.morris@oracle.com>
> >>>
> >>> This patch makes LKM based LSMs (e.g. AKARI) impossible.
> >>> I'm not happy with this patch.
> >>
> >> LKM based LSMs don't exist yet, and when they do, we may also have the
> >> "write rarely" infrastructure done, which LKM based LSMs can use to
> >> update the structures.
> >
> > Is someone actually working on the write rarely patches? If a version
> > has been sent out, I don't recall seeing it.
> 
> Still mostly just discussion. I've been toying with the PaX-style of
> it on x86, and I think Mark Rutland had some ideas for arm64, but I
> don't know if he's actually written code.

While I had a rough idea [1] of what that could look like, I haven't
written any code.

Thanks,
Mark.

[1] http://www.openwall.com/lists/kernel-hardening/2016/11/18/3
