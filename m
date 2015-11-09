Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 9 Nov 2015 18:12:23 +0000 (GMT)
From: Julia Lawall <julia.lawall@lip6.fr>
In-Reply-To: <20151109133026.GA8264@mwanda>
Message-ID: <alpine.DEB.2.10.1511091812030.3745@hadrien>
References: <1447018493-20631-1-git-send-email-Julia.Lawall@lip6.fr> <20151108221624.GP18797@mwanda> <alpine.DEB.2.10.1511082220500.2583@hadrien> <20151109054253.GQ18797@mwanda> <alpine.DEB.2.10.1511090634180.2593@hadrien> <20151109133026.GA8264@mwanda>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [PATCH] video: constify geode ops
 structures
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kernel-hardening@lists.openwall.com, Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>



On Mon, 9 Nov 2015, Dan Carpenter wrote:

> Yeah, that's tricky and I don't have an answer but marking things as
> const is a worth while in itself because it makes static some analysis
> easier.

I'm not clear on how to proceed here...

julia
