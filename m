Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 9 Nov 2015 18:05:55 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20151109180555.28c45c3ccaf2042dd7fefec4@gmail.com>
In-Reply-To: <alpine.DEB.2.10.1511091449560.3103@hadrien>
References: <1447018493-20631-1-git-send-email-Julia.Lawall@lip6.fr>
	<20151108221624.GP18797@mwanda>
	<alpine.DEB.2.10.1511082220500.2583@hadrien>
	<20151109054253.GQ18797@mwanda>
	<20151109134942.GB8264@mwanda>
	<alpine.DEB.2.10.1511091449560.3103@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH] video: constify geode ops
 structures
To: kernel-hardening@lists.openwall.com
Cc: Julia Lawall <julia.lawall@lip6.fr>, Dan Carpenter <dan.carpenter@oracle.com>, Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 9 Nov 2015 14:50:47 +0000 (GMT)
Julia Lawall <julia.lawall@lip6.fr> wrote:
> > Actually, it looks like Emese Revfy is going to merge the GCC plugin
> > constify stuff sooner rather than later so maybe adding all these consts
> > isn't going to be needed.
> 
> Is there any advantage of const over the plugin?  The consts are easy to
> add.

Hi,

I think it's a very good advantage that the plugin constifies automatically
without regular maintenance (e.g., generate patches with coccinelle, 
send patches to the maintainers every new kernel version). ;)
But if it doesn't convince you, I did constification by hand (with a coccinelle
script) some years ago.
There are too many types that can be const and it took too long to prepare and
get the maintainers to accept the patches.
And it never ends as there are always new types that can be const.

> Does the plugin help for structures that have non-function fields?
Yes, it does. See __do_const here:
http://www.openwall.com/lists/kernel-hardening/2015/11/06/11
or more about the constify plugin:
https://pax.grsecurity.net/docs/PaXTeam-H2HC13-PaX-gcc-plugins.pdf

-- 
Emese
