Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Tue, 17 Jan 2017 19:54:38 +0100
MIME-Version: 1.0
Message-ID: <587E686E.29386.DA7FA27@pageexec.freemail.hu>
In-reply-to: <20170117174831.GB367@leverpostej>
References: <20170113220256.GA57663@beast>, <587D1F55.2222.8A262A4@pageexec.freemail.hu>, <20170117174831.GB367@leverpostej>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On 17 Jan 2017 at 17:48, Mark Rutland wrote:

> That being the case, (and given the relevant bug has now been fixed),
> it's not clear to me what the value of this is today. i.e. given the
> general case, is this preventing many leaks?

no idea, i stopped looking at the instrumentation log long ago, but everyone
can enable the debug output (has a very specific comment on it ;) and look at
the results. i keep this plugin around because it costs nothing to maintain
it and the alternative (better) solution doesn't exist yet.

> > i never went into that direction because i think the security goal can
> > be achieved without the performance impact of forced initialization.
> 
> Was there a particular technique you had in mind?

sure, i mentioned it in my SSTIC'12 keynote (page 36):
https://pax.grsecurity.net/docs/PaXTeam-SSTIC12-keynote-20-years-of-PaX.pdf
