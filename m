Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 18 Jan 2017 10:48:58 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170118104857.GA3231@leverpostej>
References: <20170113220256.GA57663@beast>
 <587D1F55.2222.8A262A4@pageexec.freemail.hu>
 <20170117174831.GB367@leverpostej>
 <587E686E.29386.DA7FA27@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <587E686E.29386.DA7FA27@pageexec.freemail.hu>
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: PaX Team <pageexec@freemail.hu>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 17, 2017 at 07:54:38PM +0100, PaX Team wrote:
> On 17 Jan 2017 at 17:48, Mark Rutland wrote:
> > That being the case, (and given the relevant bug has now been fixed),
> > it's not clear to me what the value of this is today. i.e. given the
> > general case, is this preventing many leaks?
> 
> no idea, i stopped looking at the instrumentation log long ago, but everyone
> can enable the debug output (has a very specific comment on it ;) and look at
> the results. i keep this plugin around because it costs nothing to maintain
> it and the alternative (better) solution doesn't exist yet.

Fair enough; understood.

> > > i never went into that direction because i think the security goal can
> > > be achieved without the performance impact of forced initialization.
> > 
> > Was there a particular technique you had in mind?
> 
> sure, i mentioned it in my SSTIC'12 keynote (page 36):
> https://pax.grsecurity.net/docs/PaXTeam-SSTIC12-keynote-20-years-of-PaX.pdf

Thanks for the pointer.

I'm probably being very naive here, but IIUC the per-task usercopy stack
would require roughly the same analysis to identify relevant variables,
unless all local variables (regardless of initialisation) that fed into
a usercopy would be on the usercopy stack?

Regardless, I can see the benefit of cleanly separating that data from
the rest of the kernel data.

Thanks,
Mark.
