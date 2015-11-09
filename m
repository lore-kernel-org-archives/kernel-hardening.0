Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 9 Nov 2015 14:50:47 +0000 (GMT)
From: Julia Lawall <julia.lawall@lip6.fr>
In-Reply-To: <20151109134942.GB8264@mwanda>
Message-ID: <alpine.DEB.2.10.1511091449560.3103@hadrien>
References: <1447018493-20631-1-git-send-email-Julia.Lawall@lip6.fr> <20151108221624.GP18797@mwanda> <alpine.DEB.2.10.1511082220500.2583@hadrien> <20151109054253.GQ18797@mwanda> <20151109134942.GB8264@mwanda>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [PATCH] video: constify geode ops
 structures
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On Mon, 9 Nov 2015, Dan Carpenter wrote:

> Actually, it looks like Emese Revfy is going to merge the GCC plugin
> constify stuff sooner rather than later so maybe adding all these consts
> isn't going to be needed.

Is there any advantage of const over the plugin?  The consts are easy to
add.

Does the plugin help for structures that have non-function fields?

julia

>
> regards,
> dan carpenter
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
