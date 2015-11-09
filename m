Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 9 Nov 2015 19:39:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <20151109163910.GU18797@mwanda>
References: <1447018493-20631-1-git-send-email-Julia.Lawall@lip6.fr>
 <20151108221624.GP18797@mwanda>
 <alpine.DEB.2.10.1511082220500.2583@hadrien>
 <20151109054253.GQ18797@mwanda>
 <20151109134942.GB8264@mwanda>
 <alpine.DEB.2.10.1511091449560.3103@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1511091449560.3103@hadrien>
Subject: Re: [kernel-hardening] Re: [PATCH] video: constify geode ops
 structures
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 09, 2015 at 02:50:47PM +0000, Julia Lawall wrote:
> 
> 
> On Mon, 9 Nov 2015, Dan Carpenter wrote:
> 
> > Actually, it looks like Emese Revfy is going to merge the GCC plugin
> > constify stuff sooner rather than later so maybe adding all these consts
> > isn't going to be needed.
> 
> Is there any advantage of const over the plugin?  The consts are easy to
> add.

Less syntax.  It's a whitelist instead of blacklist so we don't miss
anything.

> 
> Does the plugin help for structures that have non-function fields?

Yeah.  You can mark a struct as __do_const in the .h file and it will
make them all const automatically.

regards,
dan carpenter
