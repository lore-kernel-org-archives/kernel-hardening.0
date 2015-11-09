Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1447093145.2701.45.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Mon, 09 Nov 2015 10:19:05 -0800
In-Reply-To: <alpine.DEB.2.10.1511091812030.3745@hadrien>
References: <1447018493-20631-1-git-send-email-Julia.Lawall@lip6.fr>
	 <20151108221624.GP18797@mwanda>
	 <alpine.DEB.2.10.1511082220500.2583@hadrien>
	 <20151109054253.GQ18797@mwanda>
	 <alpine.DEB.2.10.1511090634180.2593@hadrien> <20151109133026.GA8264@mwanda>
	 <alpine.DEB.2.10.1511091812030.3745@hadrien>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH] video: constify geode ops
 structures
To: Julia Lawall <julia.lawall@lip6.fr>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: kernel-hardening@lists.openwall.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 2015-11-09 at 18:12 +0000, Julia Lawall wrote:
> 
> On Mon, 9 Nov 2015, Dan Carpenter wrote:
> 
> > Yeah, that's tricky and I don't have an answer but marking things as
> > const is a worth while in itself because it makes static some analysis
> > easier.
> 
> I'm not clear on how to proceed here...

I think not relying on gcc plugins would be good and
would not be harmful even with a future plugin use.

So I think sending patches to add const is good.
